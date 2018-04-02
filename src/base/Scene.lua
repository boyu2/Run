local Scene = class("Scene", cc.Scene, require("base.NodeEx"))

function Scene:ctor(name)
    Scene.super.ctor(self)
    self.stack = {}
end

function Scene:push(...)
    self:addChild(...)
    local args = {...}
    self.stack[#self.stack + 1] = args[1]
end

function Scene:replace(...)
    self.stack[#self.stack]:removeFromParent()
    self:addChild(...)
    local args = {...}
    self.stack[#self.stack] = args[1]
end

return Scene