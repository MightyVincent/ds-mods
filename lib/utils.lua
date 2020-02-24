utils = {}

local function copyIfNotExists(from, to)
    for k, v in pairs(from) do
        if not to[k] then
            to[k] = v
        end
    end
end

function utils.InitEnvReferences(GLOBAL, env)
    local function _log(...)
        print("[ " .. env.modname .. " ]", ...)
    end
    env.logger = {
        mode = 1,
        error = function(...)
            if env.logger.mode >= 0 then
                _log("[ERROR]", ...)
            end
        end,
        warn = function(...)
            if env.logger.mode >= 1 then
                _log("[WARN]", ...)
            end
        end,
        info = function(...)
            if env.logger.mode >= 2 then
                _log("[INFO]", ...)
            end
        end,
        debug = function(...)
            if env.logger.mode >= 3 then
                _log("[DEBUG]", ...)
            end
        end,
    }

    env.config = setmetatable({ lang = GLOBAL.TheNet:GetLanguageCode() }, {
        __index = function(table, key)
            local value = env.GetModConfigData(key)
            if value then
                rawset(table, key, value)
            end
            return value
        end
    })

    copyIfNotExists(GLOBAL, env)
    env.AddPrefabPostInit("world", function()
        copyIfNotExists(GLOBAL, env)
    end)
end

return utils
