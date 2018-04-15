local Utils = require("base.Utils")
local NodeEx = class("NodeEx")

function NodeEx:ctor(size)

    self.touchListener = nil
    self.touchListeners = {}
    if size then
        self:setContentSize(size)
        self.size = size
    end

    local function onNodeEvent(event)
        if "enter" == event then
            self:__onEnter()
        elseif "exit" == event then
            self:__onExit()
        end
    end
    self:registerScriptHandler(onNodeEvent)
end

function NodeEx:__onEnter()
    Log.d(self.__cname, "onEnter")
    if self.onEnter then
        self:onEnter()
    end
end

function NodeEx:__onExit()
    Log.d(self.class.__cname, "onExit")
    if self.onExit then
        self:onExit()
    end
    self:removeTouchListener()
end

function NodeEx:schedule(func, time)
    return Utils:schedule(self, func, time)
end

function NodeEx:call(func, delay)
    Utils:call(self, func, delay)
end

function NodeEx:scheduleUpdate()
    self:scheduleUpdateWithPriorityLua(handler(self, self.update), 0)
end

function NodeEx:update(dt)
end

function NodeEx:unschedule(handler)
    Utils:unschedule(self, handler)
end

function NodeEx:removeTouchListener(listener)
    if listener then
        self:getEventDispatcher():removeEventListener(touchListener)
        self.touchListeners[listener] = nil
        return
    end

    if self.touchListener then
        self:getEventDispatcher():removeEventListener(self.touchListener)
    end
    self.touchListener = nil

    for touchListener in pairs(self.touchListeners) do
        self:getEventDispatcher():removeEventListener(touchListener)
    end
    self.touchListeners = {}
end

function NodeEx:addTouchListenerOneByOne(funcs, notSwallow)
    local listener
    if funcs then
        listener = cc.EventListenerTouchOneByOne:create()
        listener:setSwallowTouches(notSwallow or false)
        listener:registerScriptHandler(funcs.onTouchBegan or function() return true end, cc.Handler.EVENT_TOUCH_BEGAN)

        if self.onTouchMoved then
            listener:registerScriptHandler(funcs.onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
        end
        if self.onTouchEnded then
            listener:registerScriptHandler(funcs.onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
        end
        if self.onTouchCancelled then
            listener:registerScriptHandler(funcs.onTouchCancelled, cc.Handler.EVENT_TOUCH_CANCELLED)
        end

        self.touchListeners[listener] = true
    else

        if self.touchListener then
            Log.w("触摸事件重复设置")
            return self.touchListener
        end

        listener = cc.EventListenerTouchOneByOne:create()
        listener:setSwallowTouches(notSwallow or false)

        listener:registerScriptHandler(self.onTouchBegan and handler(self, self.onTouchBegan) or function() return true end, cc.Handler.EVENT_TOUCH_BEGAN)
        if self.onTouchMoved then
            listener:registerScriptHandler(handler(self, self.onTouchMoved), cc.Handler.EVENT_TOUCH_MOVED)
        end
        if self.onTouchEnded then
            listener:registerScriptHandler(handler(self, self.onTouchEnded), cc.Handler.EVENT_TOUCH_ENDED)
        end
        if self.onTouchCancelled then
            listener:registerScriptHandler(handler(self, self.onTouchCancelled), cc.Handler.EVENT_TOUCH_CANCELLED)
        end
        self.touchListener = listener
    end

    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)
    return listener
end

setmetatable(NodeEx, {__newindex = Utils.newindex})

return NodeEx