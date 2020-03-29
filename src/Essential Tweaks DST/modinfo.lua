name = "DST Essential Tweaks"
author = "Vincent Lee"
description = [[
This mod is mainly for my personal usage, aiming at integrating / modifying / fixing / optimizing some essential to me or abandoned mods.
]]
version = "1.0.0"
forumthread = ""

standalone = false
restart_required = false
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false
dst_compatible = true
api_version_dst = 10
--priority = 1
all_clients_require_mod = true
client_only_mod = false

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {
    name,
    author,
    "mine_auto_reset",
    "trap_can_reset"
}

local function divide(label)
    return { name = "", label = label, options = { { description = "", data = "" } }, default = "" }
end

local function options_range(first, last, m, n, step)
    local t = {}
    t[1] = first
    for i = m, n, step do
        t[#t + 1] = { description = "" .. i, data = i }
    end
    t[#t + 1] = last
    return t
end

local function table_union(...)
    local all = {}
    for _, t in ipairs(...) do
        for _, item in ipairs(t) do
            all[#all + 1] = item
        end
    end
end

configuration_options = {
    divide("Tweaks"),
    {
        name = "mine_auto_reset",
        label = "Mine Auto Reset",
        hover = [[Mines (Teeth Trap, Maxwell Teeth Trap, Bramble Trap) will auto reset after a short delay]],
        options = {
            { description = "Disabled", data = false, hover = "Vanilla" },
            { description = "Enabled (Default)", data = true },
        },
        default = true,
    },
    {
        name = "trap_can_reset",
        label = "Trap Can Reset",
        hover = [[Traps (Trap, Bird Trap) can be reset instead of picking up]],
        options = {
            { description = "Disabled", data = false, hover = "Vanilla" },
            { description = "Enabled (Default)", data = true },
        },
        default = true,
    },
    {
        name = "tent_uses",
        label = "Tent Uses",
        hover = [[Change tent's uses]],
        options = options_range(
                { description = "Vanilla", data = false },
                { description = "Infinite (Default)", data = 0 },
                10, 100, 10
        ),
        default = 0,
    },
    {
        name = "siesta_uses",
        label = "Siesta Lean-to Uses",
        hover = [[Change Siesta Lean-to's uses]],
        options = options_range(
                { description = "Vanilla", data = false },
                { description = "Infinite (Default)", data = 0 },
                10, 100, 10
        ),
        default = 0,
    },
    {
        name = "companion_invincible",
        label = "Invincible Companions",
        hover = [[Some companions having a player as leader won't take any damage or attract combat attention, meanwhile they can still be interact with like storing items]],
        options = {
            { description = "Disabled", data = false, hover = "Vanilla" },
            { description = "Enabled (Default)", data = true },
        },
        default = true,
    },

}
