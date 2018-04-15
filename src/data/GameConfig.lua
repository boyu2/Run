
local GameConfig = {}
setmetatable(GameConfig,{__index = _G})
setfenv(1,GameConfig)

INIT_POSX = 200
--初始化Y
INIT_POSY = display.size.height/2
--初始化坐标
INIT_POS = cc.p( INIT_POSX, INIT_POSY )
--方向上
D_UP = 1
--方向右
D_RIGHT = 2
--方向下
D_DOWN = 3
--方向左
D_LEFT = 4


return GameConfig