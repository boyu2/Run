local JumpNode = class("JumpNode", function ()
    return cc.Sprite:create("oxe.png")
end)

function JumpNode:ctor()
    --self:setScale(0.8)
    self.jumpAction = nil
    self:setAnchorPoint(cc.p(0.5,0.5))
    self:setPosition( GameConfig.INIT_POS )
end

function JumpNode:jump()
    if self.jumpAction then
        Utils:unschedule(self,self.jumpAction)
        self.jumpAction = nil
        self:setPositionY(GameConfig.INIT_POSY)
        self:setRotation(0)
    end
    local function jumpActionFun(  )
        self:setRotation( self:getRotation() + 30)
        if self:getRotation() <= 180 then
            self:setPositionY( self:getPositionY() + 7 )
        else
            self:setPositionY( self:getPositionY() - 7 )
        end
        if self:getRotation() >= 360 then
            if self.jumpAction then
                Utils:unschedule(self,self.jumpAction)
                self.jumpAction = nil
            end
            self:setRotation(0)
        end
    end
    self.jumpAction = Utils:schedule(self,jumpActionFun)
end


return JumpNode