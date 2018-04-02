local Layer = class("Layer", cc.Node, require("base.NodeEx"))

function Layer:ctor(size)
    Layer.super.ctor(self, size)
end

return Layer