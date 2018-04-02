local MainLayer = class("MainLayer", require("base.Layer"))

function MainLayer:ctor()
    MainLayer.super.ctor(self)
end

function MainLayer:onEnter()
    self:call(function()
        Global.scene:replace(require('ui.GameLayer'):create())
    end)
    
end

function MainLayer:update(dt)
    
end

function MainLayer:onExit()
end

return MainLayer