
cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"
require "base.init"

local function main()
    local scene = require("ui.MainScene"):create()
    scene:push(require("ui.MainLayer"):create())
    Utils:replaceScene(scene)
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
