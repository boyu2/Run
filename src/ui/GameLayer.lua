local JumpNode = require("ui.Node.JumpNode")
local NoteNode = require("ui.Node.NoteNode")
local GameLayer = class("GameLayer", require("base.Layer"))

function GameLayer:ctor(size)
    GameLayer.super.ctor(self, size)
    self.notes = {}
    self.delNotes = {}
    self.stopTime = 0.15
    self.touchPos = nil
end

function GameLayer:onEnter()
    self:createOxe()
    self:initNotes()
    --self:scheduleUpdate()
    self:addTouchListenerOneByOne()
end

function GameLayer:createOxe()
    self.oxe = JumpNode:create()
    self.oxe:addTo(self)
end

function GameLayer:onTouchBegan(touch, event)
    if self.touchPos then
        return
    end
    self.touchPos = touch:getLocation()
    return true
end

function GameLayer:onTouchEnded(touch, event)
    local sPos = self.touchPos
    local ePos = touch:getLocation()
    local distance = cc.pGetDistance(sPos,ePos)
    --移动距离为20才算移动
    if distance >= 20 then
        local jumpNote = self.notes[2]
        local touchDir = self:getTouchDir(sPos,ePos)
        if jumpNote:isRight(touchDir) then
            self.oxe:jump()
            self:moveNote()
            self:addNote()
        end
    end

    self.touchPos = nil
end

function GameLayer:onTouchCancelled( touch, event )
    self.touchPos = nil
end

function GameLayer:updateBgs()
    if self.bgEdge < -self.p.x + self.size.width then
        self.bgl:setPosition(cc.p(self.bgr.edge, 0))
        self.bgl.edge = self.bgr.edge + self.bgl.width
        self.bgl, self.bgr = self.bgr, self.bgl
        self.bgEdge = self.bgEdge + self.bgl.width
    end
end

function GameLayer:update(dt)

end

--初始化note
function GameLayer:initNotes()
    for i = 1,20 do
        local note = NoteNode:create()
        note:setPosition( cc.p( 200 + (i - 1) * note:getContentSize().width ,0) )
        note:addTo(self)
        table.insert( self.notes, note )
        if i == 1 then
            note._dirImg:setVisible(false)
        end
    end
end

function GameLayer:moveNote()
    for i,note in ipairs(self.notes) do
        note:move()
    end

    for i,note in ipairs(self.delNotes) do
        note:move()
    end

    table.insert(self.delNotes,self.notes[1])
    table.remove(self.notes,1)
end

function GameLayer:addNote()
    local newIdx = 0

    for i = #self.delNotes,1,-1 do
        if self.delNotes[i]:remove() then
            table.remove(self.delNotes,i)
            newIdx = newIdx + 1
        end
    end

    for i = 1,newIdx do
        local note = NoteNode:create()
        local lastNote = self.notes[#self.notes]
        note:setPosition( cc.p( lastNote:getPositionX(),0 ) )
        note:addTo(self)
        table.insert( self.notes, note )
    end
   
end

function GameLayer:getTouchDir(sPos,ePos)
    local touchDir
    local vector = cc.p(ePos.x - sPos.x,ePos.y - sPos.y)
    local radian = cc.pGetAngle(cc.p(1,0),vector)
    local angle = 180 / math.pi * radian
    if angle >= 45 and angle < 135 then
        --print("上")
        touchDir = GameConfig.D_UP
    elseif angle >= -45 and angle < 45 then
        --print("右")
        touchDir = GameConfig.D_RIGHT
    elseif angle >= -135 and angle < -45 then
        --print("下")
        touchDir = GameConfig.D_DOWN
    elseif (angle >= 135 and angle <= 180) or (angle >-180 and angle < -135 )  then
        --print("左")
        touchDir = GameConfig.D_LEFT
    end
    return touchDir
end



return GameLayer
