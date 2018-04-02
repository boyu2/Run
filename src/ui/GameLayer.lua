local BaseLayer = require("base.Layer")
local ScrollLayer = require("ui.ScrollLayer")
local Music = require("data.Music")

local GameLayer = class("GameLayer", BaseLayer)

function GameLayer:ctor()
    GameLayer.super.ctor(self)
end

function GameLayer:createScoreUI(layer)
    local score = cc.Label:createWithTTF("00", "number.ttf", 30)
    score:setTextColor(cc.c4b(255, 255, 255, 255))
    score:setPosition(cc.p(display.width - 100, display.height - 100))
    layer:addChild(score)
    self.scoreUI = score
end

function GameLayer:createUILayer()
    local layer = BaseLayer:create(cc.size(display.width, display.height))
    self:createScoreUI(layer)
    self:addChild(layer)
    self.uiLayer = layer
end

function GameLayer:createScrollLayer()
    local layer = ScrollLayer:create(cc.size(display.width, display.height))
    self:addChild(layer)
    self.scrollLayer = layer
end

function GameLayer:onEnter()
    self:createUILayer()
    self:createScrollLayer()
end

function GameLayer:onExit()
end

return GameLayer