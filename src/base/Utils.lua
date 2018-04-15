local Utils = {}

function Utils:schedule(node, func, time)
    local time = time or 1/60
    local action = 
        cc.RepeatForever:create(
        cc.Sequence:create(cc.DelayTime:create(time), 
        cc.CallFunc:create(func))
    )
    node:runAction(action)
    return action
end

function Utils:unschedule(node, handler)
    node:stopAction(handler)
end

function Utils:call(node, func, delay)
    if delay then
        return node:runAction(cc.Sequence:create(cc.DelayTime:create(delay), cc.CallFunc:create(func)))
    else
        return node:runAction(cc.CallFunc:create(func))
    end
end

function Utils:replaceScene(scene)
    cc.Director:getInstance():replaceScene(scene)
    Global.scene = scene
end

function Utils:assert(cond, msg)
    assert(cond, msg)
end


function Utils.newindex(table, key, value)
    if table["set" .. key] then
        table["set" .. key](table, value)
    else
        Log.e(false, "找不到对应的方法")
    end
end

return Utils