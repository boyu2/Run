local NoteNode = class( "NoteNode",function ()
    return ccui.ImageView:create()
end )

local width =  57 * 1.5
local height = GameConfig.INIT_POSY - 57/2

local rotation = {
    0,
    90,
    180,
    270
}

-- local D_UP = 1
-- local D_RIGHT = 2
-- local D_DOWN = 3
-- local D_LEFT = 4

--反转
local TURN_TYPE = 1

function NoteNode:ctor()
    self.moveAction = nil
    self:loadTexture( "white.png"  )
    self:setScale9Enabled(true)
    self:setAnchorPoint( cc.p(0.5,0) )
    self:setContentSize( cc.size(width,height))

    local rndTurn = math.random( 1,10 )
    local rndDir = math.random( 1,4 )
    local dir = rndDir
    local bgPng

    if rndTurn == TURN_TYPE then
        if dir == GameConfig.D_UP then
            dir = GameConfig.D_DOWN
        elseif dir == GameConfig.D_RIGHT then
            dir = GameConfig.D_LEFT
        elseif dir == GameConfig.D_DOWN then
            dir = GameConfig.D_UP
        elseif dir == GameConfig.D_LEFT then
            dir = GameConfig.D_RIGHT
        end
        bgPng = "rbg.png"
    else
        bgPng = "gbg.png"
    end

    local dirBg = cc.Sprite:create( bgPng )
    dirBg:setPosition( cc.p( width/2,height/2 ) )
    dirBg:addTo( self )
    dirBg:setCascadeOpacityEnabled(true)
    local jtSp = cc.Sprite:create( "jt.png" )
    jtSp:setRotation( rotation[rndDir] )
    jtSp:setPosition( cc.p( dirBg:getContentSize().width/2,dirBg:getContentSize().height/2 ) )
    jtSp:addTo( dirBg )
    
    self._dirImg = dirBg
    self._dir = dir
end

function NoteNode:move( )
    --设置成上一次的位置重新播放动画
    if self.moveAction and self.moveX then
        self:setPositionX(self.moveX)
        self:stopAction(self.moveAction)
        self.moveAction = nil
    end
   
    if self.moveAction == nil then
        local x = self:getPositionX() - width
        self.moveX = x
        self.moveAction = cc.Sequence:create(
            cc.MoveTo:create( 12/60,cc.p(x,0) ),
            cc.CallFunc:create( 
            function ()
                self.moveAction = nil
            end)
        )
        self:runAction( self.moveAction )
    end
end
--删除
function NoteNode:remove()
    --print("YYYY",self:getPositionX() ,  self:getPositionX() <=  width)
    local isRemove = self:getPositionX() <=  -width/2
    if isRemove then
        self:removeFromParent()
    end
    return isRemove
end

function NoteNode:isRight(dir)
    if dir == self._dir then
        self._dirImg:runAction( cc.FadeOut:create(0.2) )
        return true
    end
end



return NoteNode