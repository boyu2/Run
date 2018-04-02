local Log = {}

function Log.d(...)
    if DEBUG >= 4 then
        print("DEBUG", ...)
    end
end

function Log.i(...)
    if DEBUG >= 3 then
        print("INFO", ...)
    end
end

function Log.w(...)
    if DEBUG >= 2 then
        print("WARN", ...)
    end
end

function Log.e(...)
    if DEBUG >= 1 then
        print(debug.traceback( nil, nil, 2 ))
        print("ERROR", ...)
    end
end

return Log