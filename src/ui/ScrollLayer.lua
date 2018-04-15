local JumpNode = require("ui.Node.JumpNode")
local NoteNode = require("ui.Node.NoteNode")
local ScrollLayer = class("ScrollLayer", require("base.Layer"))

function ScrollLayer:ctor(size)
    ScrollLayer.super.ctor(self, size)
    -- self.v = cc.p(-10, 0)
    -- self.a = cc.p(1, 1)
    -- self.p = cc.p(0,0)
    -- self.bgEdge = 0
    -- self.objEdge = 0
    -- self.bgl = nil
    -- self.bgr = nil
    -- self.clickTimes = 0
    self.notes = {}
    self.delNotes = {}
    self.stopTime = 0.15
    self.touchPos = nil
end

function ScrollLayer:onEnter()
    --self:createBgs()
    self:createOxe()
    self:initNotes()
    --self:scheduleUpdate()
    self:addTouchListenerOneByOne()
end

function ScrollLayer:createOxe()
    self.oxe = JumpNode:create()
    self.oxe:addTo(self)
end

function ScrollLayer:createBgs()
    local ui = cc.Sprite:create("bg.jpg")
    local width = ui:getContentSize().width
    ui:setAnchorPoint(cc.p(0, 0))
    ui:setPosition(cc.p(0, 0))
    ui.edge = width
    ui.width = width
    self:addChild(ui)
    self.bgl = ui

    local ui = cc.Sprite:create("bg.jpg")
    ui:setAnchorPoint(cc.p(0, 0))
    ui:setPosition(cc.p(width, 0))
    ui.edge = width * 2
    ui.width = width
    self:addChild(ui)
    self.bgr = ui

    self.bgEdge = width * 2 - 10
end

function ScrollLayer:onTouchBegan(touch, event)
    if self.touchPos then
        return
    end
    self.touchPos = touch:getLocation()
    return true
end

function ScrollLayer:onTouchEnded(touch, event)
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

function ScrollLayer:onTouchCancelled( touch, event )
    self.touchPos = nil
end

function ScrollLayer:updateBgs()
    if self.bgEdge < -self.p.x + self.size.width then
        self.bgl:setPosition(cc.p(self.bgr.edge, 0))
        self.bgl.edge = self.bgr.edge + self.bgl.width
        self.bgl, self.bgr = self.bgr, self.bgl
        self.bgEdge = self.bgEdge + self.bgl.width
    end
end

function ScrollLayer:update(dt)
    -- if self.clickTimes <= 0 then
    --     self.p = cc.p(self.p.x + self.v.x * self.a.x, self.p.y + self.v.y * self.a.y)
    --     self.scrollLayer:setPosition(self.p)
    --     self:updateBgs()
    -- end
    -- self.oxe:setRotation( self.oxe:getRotation() + 5)
    -- if self.oxe:getRotation() >= 360 then
    --     self.oxe:setRotation( 0  )
    -- end
end

--初始化note
function ScrollLayer:initNotes()
    for i = 1,20 do
        local note = NoteNode:create()
        note:setPosition( cc.p( 200 + (i - 1) * note:getContentSize().width ,0) )
        note:addTo(self)
        table.insert( self.notes, note )
    end
end

function ScrollLayer:moveNote()
    for i,note in ipairs(self.notes) do
        note:move()
    end

    for i,note in ipairs(self.delNotes) do
        note:move()
    end


    table.insert(self.delNotes,self.notes[1])
    table.remove(self.notes,1)
end

function ScrollLayer:addNote()
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

    -- for i = #self.notes,1,-1 do
    --     if self.notes[i]:remove() then 
    --         table.remove(self.notes,i) newIdx = newIdx + 1 
    --     end
    -- end
   
end

function ScrollLayer:getTouchDir(sPos,ePos)
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



return ScrollLayer
