local BaseLayer = require("base.Layer")
local ScrollLayer = class("ScrollLayer", BaseLayer)

function ScrollLayer:ctor(size)
    ScrollLayer.super.ctor(self, size)
    self.v = cc.p(-10, 0)
    self.a = cc.p(1, 1)
    self.p = cc.p(0,0)
    self.maxEdge = display.width + 10
    self.bgEdge = 0
    self.objEdge = 0
    self.bgl = nil
    self.bgr = nil
    self.clickTimes = 0
    self.stopTime = 0.15

    self.oxePos = cc.p(100, 300)
end

function ScrollLayer:onEnter()
    local layer = BaseLayer:create(cc.size(display.width, display.height))
    self:addChild(layer)
    self.scrollLayer = layer

    --self:createBgs()
    self:createOxe()
    --self:scheduleUpdate()
    self:addTouchListenerOneByOne()
end

function ScrollLayer:createOxe()
    local oxe = cc.Sprite:create("oxe.png")
    oxe:setScale(50/57)
    oxe:setAnchorPoint(cc.p(0,0))
    oxe:setPosition(self.oxePos)
    self:addChild(oxe)
    self.oxe = oxe
end

function ScrollLayer:createBgs()
    local ui = cc.Sprite:create("bg.jpg")
    local width = ui:getContentSize().width
    ui:setAnchorPoint(cc.p(0, 0))
    ui:setPosition(cc.p(0, 0))
    ui.edge = width
    ui.width = width
    self.scrollLayer:addChild(ui)
    self.bgl = ui

    local ui = cc.Sprite:create("bg.jpg")
    ui:setAnchorPoint(cc.p(0, 0))
    ui:setPosition(cc.p(width, 0))
    ui.edge = width * 2
    ui.width = width
    self.scrollLayer:addChild(ui)
    self.bgr = ui

    self.bgEdge = width * 2 - 10
end

function ScrollLayer:onTouchBegan(touch, event)
    local touchX = touch:getLocation().x
    if touchX <= display.size.width/2 then
        print("左边")
    else
        print("右边")
    end
end


-- function ScrollLayer:onTouchEnded(touch, event)
--     print("touch")
--     self.clickTimes = self.clickTimes + 1
    
--     local move = cc.MoveBy:create(self.stopTime/2, cc.p(0, -200))
--     self.oxe:runAction(cc.Sequence:create(move, move:reverse()))
--     self:call(function() self.clickTimes = self.clickTimes - 1 end, self.stopTime)
-- end

function ScrollLayer:updateBgs()
    if self.bgEdge < -self.p.x + self.size.width then
        self.bgl:setPosition(cc.p(self.bgr.edge, 0))
        self.bgl.edge = self.bgr.edge + self.bgl.width
        self.bgl, self.bgr = self.bgr, self.bgl
        self.bgEdge = self.bgEdge + self.bgl.width
    end
end

function ScrollLayer:update(dt)
    if self.clickTimes <= 0 then
        self.p = cc.p(self.p.x + self.v.x * self.a.x, self.p.y + self.v.y * self.a.y)
        self.scrollLayer:setPosition(self.p)
        self:updateBgs()
    end
end

return ScrollLayer
