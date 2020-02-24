utils = GLOBAL.require('lib/utils')
utils.InitEnvReferences(GLOBAL, env)
logger.info("current language:", config.lang)

local initScripts = {
    ["scripts/init/mine_auto_reset.lua"] = config.mine_auto_reset,
    ["scripts/init/trap_can_reset.lua"] = config.trap_can_reset,
    ["scripts/init/tent_tweak.lua"] = config.tent_uses or config.siesta_uses,
    ["scripts/init/companion_tweak.lua"] = config.companion_invincible,
}

for script, condition in pairs(initScripts) do
    if condition then
        logger.info("loading", script)
        local status, err = pcall(function()
            modimport(script)
        end)
        if not status then
            logger.error(script, err)
        end
    end
end
