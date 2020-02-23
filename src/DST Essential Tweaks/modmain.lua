utils = GLOBAL.require('lib/utils')
utils.InitEnvReferences(GLOBAL, env)
log("current language:", config.lang)

local initScripts = {
    ["scripts/init/mine_auto_reset.lua"] = config.mine_auto_reset,
    ["scripts/init/trap_can_reset.lua"] = config.trap_can_reset,
    ["scripts/init/tent_uses.lua"] = config.tent_uses or config.siesta_uses,
}

for script, condition in pairs(initScripts) do
    if condition then
        log("loading", script)
        local status, err = pcall(function()
            modimport(script)
        end)
        if not status then
            log("Error:", script, err)
        end
    end
end
