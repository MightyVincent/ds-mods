utils = {}

local function copyIfNotExists(from, to)
    for k, v in pairs(from) do
        if not to[k] then
            to[k] = v
        end
    end
end

function utils.InitEnvReferences(GLOBAL, env)
    function env.log(...)
        print("["..env.modname.."]", ...)
    end

    env.config = setmetatable({ lang = GLOBAL.TheNet:GetLanguageCode() }, {
        __index = function(table, key)
            local value = env.GetModConfigData(key)
            rawset(table, key, value)
            return value
        end
    })

    copyIfNotExists(GLOBAL, env)
    env.AddPrefabPostInit("world", function()
        copyIfNotExists(GLOBAL, env)
    end)
end

return utils
