local GLOBAL = GLOBAL or _G

local debuglog = false

local require = GLOBAL.require
local io = GLOBAL.io
local os = GLOBAL.os
local unpack = GLOBAL.unpack

local function tbl_pack(...)
  return { n = GLOBAL.select("#", ...), ... } 
end

local function lshift(x, by)
  return x * 2 ^ by
end

local function rshift(x, by)
  return math.floor(x / 2 ^ by)
end

function bitand(a, b)
    local result = 0
    local bitval = 1
    while a > 0 and b > 0 do
      if a % 2 == 1 and b % 2 == 1 then -- test the rightmost bits
          result = result + bitval      -- set the current bit
      end
      bitval = bitval * 2 -- shift left
      a = math.floor(a/2) -- shift right
      b = math.floor(b/2)
    end
    return result
end

function KleiHashFn(str)
	local packed_str = pack(str:byte(1,str:len()))
	local hash = 0
	
	for i, v in ipairs(packed_str) do
		hash = (v + lshift(hash, 6) + lshift(hash, 16) - hash)
		hash = bitand(hash, 0xFFFFFFFF)
	end
	
	-- print(hash)
	return hash
end

local function UIntToBytes(x)
  local bytes = {}

  for i=1,4 do
    table.insert(bytes, math.floor(rshift(x, 8*(i-1))%256))
  end

  return bytes
end

local function BytesToUInt(src)
  return ((src[1] or 0) + lshift(src[2] or 0, 8) + lshift(src[3] or 0, 16) + lshift(src[4] or 0, 24))
end

local function GetStringFromBytes(bytes)
  return string.char(unpack(bytes))
end

local function ResolveMglStr(str, encr)
  if str == nil or encr == nil then
    return nil
  end

  local out_str = {}

  local str_bytes = tbl_pack(str:byte(1,str:len()))

  for i, v in ipairs(str_bytes) do
    -- print("Convert " ..  string.char(v) .. " to " .. string.char(encr[v]))
    table.insert(out_str, encr[v])
  end

  return string.char(unpack(out_str))
end

print("ARCHERY MOD GET NAME: " .. tostring(modname) .. " => actual name is " .. tostring(GLOBAL.KnownModIndex:GetModActualName(modname) or "unavailable"))

local outname = "../mods/"

if GLOBAL.KnownModIndex:GetModActualName(modname) then
  outname = outname .. tostring(GLOBAL.KnownModIndex:GetModActualName(modname))
else
  outname = outname .. modname 
end

-- local outname = "."

outname = outname .. "/skin_ownership."

local function DrawValidChar()
  local forbidden = {}

  for i=1,43 do
    forbidden[i-1] = true
  end

  forbidden[44] = true
  forbidden[91] = true
  forbidden[92] = true
  forbidden[93] = true
  forbidden[96] = true
  forbidden[127] = true

  local draw = math.random(0, 255)

  while forbidden[draw] ~= nil do
    draw = math.random(0, 255)
  end

  return draw
end

local function MakeRandomCharTable()
  local char_tbl = {}
  local reverse_tbl = {}

  char_tbl[95] = DrawValidChar()
  reverse_tbl[char_tbl[95]] = 95

  char_tbl[45] = DrawValidChar()
  reverse_tbl[char_tbl[45]] = 45

  char_tbl[228] = DrawValidChar()
  reverse_tbl[char_tbl[228]] = 228

  for i=48,57 do
    local link_char = DrawValidChar()

    while reverse_tbl[link_char] ~= nil do
      link_char = DrawValidChar()
    end

    char_tbl[i] = link_char
    reverse_tbl[link_char] = i
  end

  for i=65,90 do
    local link_char = DrawValidChar()

    while reverse_tbl[link_char] ~= nil do
      link_char = DrawValidChar()
    end

    char_tbl[i] = link_char
    reverse_tbl[link_char] = i
  end

  for i=97,122 do
    local link_char = DrawValidChar()

    while reverse_tbl[link_char] ~= nil do
      link_char = DrawValidChar()
    end

    char_tbl[i] = link_char
    reverse_tbl[link_char] = i
  end

  -- for k, v in pairs(char_tbl) do
  -- print(tostring(k) .. " <-> " .. tostring(v))
  -- end

  return char_tbl, reverse_tbl
end

local function ReadSeed(input)
  buffer = input:read(1)

  local seed_length = buffer:byte(1)

  -- print("seed has " .. tostring(seed_length) .. " digits")

  buffer = input:read(seed_length)
  -- print("seed bytes table: " .. tostring(buffer))

  local seed_bytes = tbl_pack(buffer:byte(1, seed_length))
  -- print("seed bytes table: " .. tostring(seed_bytes))

  local seed = 0

  for i, v in ipairs(seed_bytes) do
    -- print("Unpacked digit: " .. v)
    seed = seed + v*(10^(seed_length-i))
  end

  -- print("read seed: " .. tostring(seed))

  return seed
end

curr_encr = {}
curr_rev = {}
local prev_seed = nil

local function GenerateRandomSeed(output)
  local seed = os.time()

  if prev_seed and seed == prev_seed then
    seed = seed+1
  end

  -- print("os time is " .. tostring(seed))

  local ndigits = 0

  while math.floor(seed/(10^ndigits)) > 0 do
    -- print(math.floor(seed/(10^ndigits)))
    ndigits = ndigits+1
  end

  -- print("os time has " .. tostring(ndigits) .. " digits")

  output:write(string.char(ndigits))

  local seed_cpy = seed

  for i=1,ndigits do
    local order = ndigits-i
    output:write(string.char(math.floor(seed_cpy/(10^order))))
    seed_cpy = seed_cpy - math.floor(seed_cpy/(10^order))*(10^order)
  end

  return seed
end

local function ReloadAndRegenerateOwnership(player, newulck, rvkulck)
  if GLOBAL.ThePlayer == nil or GLOBAL.ThePlayer ~= player then
    return
  end

  local ulck = { }
  player._amskns = {}

  local input = io.open(outname .. tostring(player.userid), "r")

  if input ~= nil then
    local buffer

    prev_seed = ReadSeed(input)
    math.randomseed(prev_seed)

    local ctbl, rtbl = MakeRandomCharTable()

    buffer = input:read(1)
    local kidl = buffer:byte(1)

    buffer = input:read(kidl)
    local kuid = GetStringFromBytes(tbl_pack(buffer:byte(1, kidl)))

    local rkuid = ResolveMglStr(kuid, rtbl)

    if rkuid == player.userid then
      buffer = input:read(4)
      local nskulck = BytesToUInt(tbl_pack(buffer:byte(1,4)))

      -- print("Number of skins unlocked: " .. tostring(nskulck))

      local nodupe = {}

      for i=1,nskulck do
        local snmk = {}

        buffer = input:read(1)
        while buffer ~= nil and buffer:byte(1) ~= ctbl[228] do
          table.insert(snmk, buffer:byte(1))
          buffer = input:read(1)
        end

        if debuglog then print("Read item: " .. string.char(unpack(snmk)) .. " = " .. tostring(ResolveMglStr(string.char(unpack(snmk)), rtbl))) end

        local mglskn = string.char(unpack(snmk))
        local toa = ResolveMglStr(mglskn, rtbl)

        if nodupe[toa] == nil then
          table.insert(ulck, toa)
          nodupe[toa] = true
        end
      end

      if newulck ~= nil and nodupe[ResolveMglStr(newulck, rtbl)] == nil then
        if debuglog then print("Adding item: " .. tostring(newulck) .. " = " .. tostring(ResolveMglStr(newulck, rtbl))) end
        table.insert(ulck, ResolveMglStr(newulck, rtbl))
      end

      if rvkulck ~= nil then
        for i, v in ipairs(ulck) do
          if v == rvkulck then
            if debuglog then print("Removing item: " .. tostring(rvkulck) .. " at position " .. tostring(i)) end
            table.remove(ulck, i)
          end
        end
      end

      player:DoTaskInTime(0, function(player)
          if player.HUD and player.HUD.controls.archery_item_notif and player.HUD.controls.archery_item_notif.pending then
            for i, v in ipairs(player.HUD.controls.archery_item_notif.pending) do
              player.HUD.controls.archery_item_notif.pending[i] = ResolveMglStr(v, rtbl)
            end
          end
        end)
    else
      if debuglog then print("Klei IDs read (" .. rkuid .. ") does not match the one of the requesting player: " .. player.userid) end
    end

    input:close()
  end

  input = nil

  local output = io.open(outname .. tostring(player.userid), "w")

  if output == nil then
    print("ERROR!!!! Unabled to open skin_ownership for writing")
  end

  math.randomseed(GenerateRandomSeed(output))
  local encr, k_ = MakeRandomCharTable()

  if player and player.userid then
    if debuglog then print("Retrieved Klei ID: " .. tostring(player.userid)) end
    output:write(string.char(player.userid:len()))
    output:write(ResolveMglStr(player.userid, encr))
  else
    print("ERROR!!!! Unabled to retrieve the userid")
  end

  local nskulck__ = GetStringFromBytes(UIntToBytes(#ulck))

  -- print("Size of unloccked table: " .. tostring(#ulck))
  -- print("Bytes transcript of that size: " .. nskulck__)

  output:write(GetStringFromBytes(UIntToBytes(#ulck)))

  for i, v in ipairs(ulck) do
    local mglskn = ResolveMglStr(v, encr)
    output:write(mglskn)
    -- print("Separator: " .. ResolveMglStr(string.char(228), encr))
    output:write(ResolveMglStr(string.char(228), encr))

    if debuglog then print("Wrote item: " .. tostring(mglskn) .. " = " .. tostring(ResolveMglStr(mglskn, k_))) end

    player._amskns[mglskn] = true
  end

  curr_encr = encr
  curr_rev = k_

  player:DoTaskInTime(0, function(player)
      if player.HUD and player.HUD.controls.archery_item_notif and player.HUD.controls.archery_item_notif.pending then
        for i, v in ipairs(player.HUD.controls.archery_item_notif.pending) do
          player.HUD.controls.archery_item_notif.pending[i] = ResolveMglStr(v, encr)
        end
      end
    end)

  output:close()
end

local function CheckValidOwner(player, toc)
  if not GLOBAL.ThePlayer or GLOBAL.ThePlayer ~= player then
    return false
  end

  -- print("Checking user unlocked for: " .. tostring(toc))
  local srch = ResolveMglStr(toc, curr_encr)
  -- print("Mangled search: " .. tostring(srch))

  -- local owdsks = io.open(outname, "r")

  -- if owdsks ~= nil then
  -- local ros = owdsks:read("*all")

  -- owdsks:close()

  -- if ros:find(srch) ~= nil then
  -- print("Found " .. tostring(srch))
  -- return true
  -- end
  -- else
  -- print("ERROR: Missing skin_ownership.am")
  -- end

  if debuglog then
    print("Searching for " .. toc .. " ( mangled: " .. srch .. " ) in " .. tostring(player.userid) .. " skins list")

    for k, v in pairs(player._amskns) do
      print("Mangled skin: " .. tostring(k) .. " = " .. ResolveMglStr(k, curr_rev))
    end
  end

  if player._amskns[srch] then
    return true
  end

  return false
end

local function ArcheryItemNotifPopup(player, data)
  if player and player.HUD and data.skin ~= nil then
    player.HUD.controls.archery_item_notif.numitems = player.HUD.controls.archery_item_notif.numitems+1

    if player.HUD.controls.archery_item_notif.pending == nil then
      player.HUD.controls.archery_item_notif.pending = {}
    end

    if debuglog then print("Adding the following skin to the list of pending ones: " .. tostring(data.skin)) end

    table.insert(player.HUD.controls.archery_item_notif.pending, data.skin)

    player.HUD.controls.archery_item_notif:OnToast(player.HUD.controls.archery_item_notif.numitems)

    if data.active then
      player.HUD.controls.archery_item_notif:EnableClick()
    else
      player.HUD.controls.archery_item_notif:DisableClick()
    end
  end
end

local function GrantSkin(player, tog)
  if debuglog then print("Grant skin for " .. tostring(player) .. " : " .. tostring(tog)) end
  if GLOBAL.ThePlayer and GLOBAL.ThePlayer == player and player.player_classified and player.HUD then
    if debuglog then print("Running on and for the player hosting") end
    ArcheryItemNotifPopup(player, { skin = tog, active = player.player_classified.hasgiftmachine:value() })
  elseif GLOBAL.TheWorld.ismastersim then
    if debuglog then print("Host processing request") end
    player.player_classified._am_notifynewskin:set(tog)
    inst:DoTaskInTime(1, function(inst) inst._am_notifynewskin:set_local("") end)
  end
end

local function RevokeSkin(player, tor)
  if player.player_classified then
    ReloadAndRegenerateOwnership(player, nil, tor)
  end
end

local function GetIsHostPlayer(player)
  return GLOBAL.TheWorld.ismastersim and GLOBAL.ThePlayer and GLOBAL.ThePlayer == player
end

local function GetIsMasterID()
  if GLOBAL.ThePlayer and
  (GLOBAL.ThePlayer.userid == "KU_-nnSA9gH" or 
    GLOBAL.ThePlayer.userid == "KU_99-jtQ9R" or
    GLOBAL.ThePlayer.userid == "KU_WdfuZ29G" or
    GLOBAL.ThePlayer.userid == "KU___1YflBU")
  then
    return true
  end

  return false
end

function GLOBAL.ARCHERYFUNCS.MasterGrantSkin(tog)
  if GetIsMasterID() then
    if debuglog then print("Received grant request from " .. tostring(GLOBAL.ThePlayer) .. " : " .. tostring(ResolveMglStr(tog, curr_encr))) end
    GrantSkin(GLOBAL.ThePlayer, ResolveMglStr(tog, curr_encr))
  else
    print("CHEATER!")
    return
  end
end

function GLOBAL.ARCHERYFUNCS.MasterRevokeSkin(tor)
  if GetIsMasterID() then
    if debuglog then print("Received revoke request from " .. tostring(GLOBAL.ThePlayer)) end
    RevokeSkin(GLOBAL.ThePlayer, tor)
  else
    print("CHEATER!")
    return
  end
end

function GLOBAL.ARCHERYFUNCS.MasterGrantAllSkins()
  if GetIsMasterID() then
    for k, v in pairs(GLOBAL.ARCHERYSKINS) do
      for _, skn in ipairs(v) do
        GLOBAL.ThePlayer:DoTaskInTime(2, function() GrantSkin(GLOBAL.ThePlayer, ResolveMglStr(skn.skin, curr_encr)) end)
      end
    end
  else
    print("CHEATER!")
    return
  end
end

function GLOBAL.ARCHERYFUNCS.MasterRevokeAllSkins()
  if GetIsMasterID() then
    for k, v in pairs(GLOBAL.ARCHERYSKINS) do
      for _, skn in ipairs(v) do
        RevokeSkin(GLOBAL.ThePlayer, skn.skin)
      end
    end
  else
    print("CHEATER!")
    return
  end
end

----------------------------------------------- Post Inits ------------------------------------------------------------------

local function CancelTrackDropTask(classified, task_netvar)
  if debuglog then print("Canceling task " .. tostring(task_netvar)) end

  if classified._am_tracktasks[task_netvar] then
	if classified._am_tracktasks[task_netvar].task ~= nil then
		if debuglog then print("Task is running. Stopping it now... ") end
		classified._am_tracktasks[task_netvar].task:Cancel()
		classified._am_tracktasks[task_netvar].task = nil
	end

	classified._am_tracktasks[task_netvar] = nil
  end
end

local function HandleTrackTaskCanceling(player, netvar, skin, event, callback, force)
  if debuglog then print("Handle Track Task Cancelling: " .. tostring(player) .. " / " .. tostring(netvar) .. " / " .. tostring(skin) .. " / " .. tostring(event) .. " / " .. tostring(callback) .. " / " .. tostring(force)) end
  player:DoTaskInTime(1, function(player)
      if GetIsHostPlayer(player) then
        if CheckValidOwner(player, skin) or force then
          CancelTrackDropTask(player.player_classified, netvar)
        end
      elseif not GLOBAL.TheWorld.ismastersim and GLOBAL.ThePlayer and GLOBAL.ThePlayer == player then
        if CheckValidOwner(player, skin) or force then
          player.player_classified:RemoveEventCallback(event, callback)
          SendModRPCToServer(MOD_RPC["Archery Mod"]["CancelTrackTask"], netvar)
          -- player.player_classified[netvar] = nil
        end
      end
    end)
end

local function SetupNewTrackTask(classified, netvar)
  if classified._am_tracktasks then
    classified._am_tracktasks[netvar] = {}

    local idx = 0

    for k, v in pairs(classified._am_tracktasks) do
      idx = idx+1
    end

    classified._am_tracktasks[netvar].taskid = idx
    classified._am_tracktasks[netvar].netvar = netvar

    if debuglog then print("Done setting up new classified task track # " .. idx .." => " .. tostring(netvar)) end

    return idx
  else
    print("ERROR!!! classified._am_tracktasks table not initialized!")
    return nil
  end
end

local function CheckForReplicated(classified)
  if classified and classified.entity and classified.entity:GetParent() then
    return true
  else
    return false
  end
end

local curr_env = GLOBAL.getfenv(1)
curr_env.GrantSkin = GrantSkin
curr_env.ResolveMglStr = ResolveMglStr
curr_env.CheckValidOwner = CheckValidOwner
curr_env.CancelTrackDropTask = CancelTrackDropTask
curr_env.SetupNewTrackTask = SetupNewTrackTask
curr_env.HandleTrackTaskCanceling = HandleTrackTaskCanceling
curr_env.os = GLOBAL.os
curr_env.io = GLOBAL.io
curr_env.unpack = GLOBAL.unpack
curr_env.GetIsHostPlayer = GetIsHostPlayer
curr_env.CheckForReplicated = CheckForReplicated

local ArcherySkinPopUp = require "screens/archeryskinpopup"

local condfns = {}
local onsavefns = {}
local onloadfns = {}

for base, skin_info in pairs(GLOBAL.ARCHERYSKINS) do
  for i, skin in ipairs(skin_info) do
    if debuglog then print("Loading the base functions for " .. tostring(skin.skin)) end
    local sknlua = GLOBAL.loadfile("skinsfn/" .. skin.skin .."fns.lua")

    if type(sknlua) == "string" then
      print("ERROR while loading skinsfn/" .. skin.skin .."fns.lua" .. tostring(sknlua))
    else	
      GLOBAL.setfenv(sknlua, curr_env)

      local condfn, onsavefn, onloadfn = sknlua()

      condfns[skin.skin] = condfn
      onsavefns[skin.skin] = onsavefn
      onloadfns[skin.skin] = onloadfn
    end
  end
end

AddPrefabPostInit("player_classified", function(inst)	
    inst._am_notifynewskin = GLOBAL.net_string(inst.GUID, "amskins.notifynewskin", "am_notifynewskin")
    inst._am_openskinscreen = GLOBAL.net_string(inst.GUID, "amskins.openskinscreen", "am_openskinscreen")

    if not GLOBAL.TheWorld.ismastersim then
      inst:ListenForEvent("am_notifynewskin", function()
          if debuglog then print("Received archery skin drop notification: " .. tostring(inst._am_notifynewskin:value())) end
          if inst._am_notifynewskin:value():len() > 0 then
            ArcheryItemNotifPopup(inst, { skin = inst._am_notifynewskin:value(), active = inst.hasgiftmachine:value() })
            inst._am_notifynewskin:set_local("")
          end
        end)

      inst:ListenForEvent("am_openskinscreen", function(inst)
          local skin = inst._am_openskinscreen:value()
          if skin:len() > 0 then
            if debuglog then print("Received archery open skin screen notification. Current skin: " .. tostring(skin)) end
            local player = inst.entity:GetParent()
            player.HUD.archeryskinscreen = ArcherySkinPopUp(player, skin)
            player.HUD:OpenScreenUnderPause(player.HUD.archeryskinscreen)
            inst._am_openskinscreen:set_local("")
          end
        end)
    else
      inst._am_tracktasks = {}
    end

    TryDoUntil(inst, function(inst) return inst.entity:GetParent() ~= nil and inst.entity:GetParent().userid ~= nil end, 0.1, 0, 5, function(inst)
      if GLOBAL.ThePlayer and GLOBAL.ThePlayer == inst.entity:GetParent() then
        ReloadAndRegenerateOwnership(inst.entity:GetParent())
      end
    end)

  for k, fn in pairs(condfns) do
    fn(inst)
  end
end)

AddPlayerPostInit(function(player)
    if GLOBAL.TheWorld.ismastersim then		
      for k, fn in pairs(onsavefns) do
        local origOnSave = player.OnSave

        player.OnSave = function(player, data)
          if origOnSave then origOnSave(player, data) end

          fn(player, data)
        end
      end

      for k, fn in pairs(onloadfns) do
        local origOnLoad = player.OnLoad

        player.OnLoad = function(player, data)
          if origOnLoad then origOnLoad(player, data) end

          fn(player, data)
        end
      end
    end
  end)

local GiftItemToast = require "widgets/giftitemtoast"

local function IsNearDanger(inst)
  local hounded = GLOBAL.TheWorld.components.hounded
  if hounded ~= nil and (hounded:GetWarning() or hounded:GetAttacking()) then
    return true
  end
  local burnable = inst.components.burnable
  if burnable ~= nil and (burnable:IsBurning() or burnable:IsSmoldering()) then
    return true
  end
  -- See entityreplica.lua (for _combat tag usage)
  if inst:HasTag("spiderwhisperer") then
    --Danger if:
    -- being targetted
    -- OR near monster or pig that is neither player nor spider
    -- ignore shadow monsters when not insane
    return GLOBAL.FindEntity(inst, 10,
      function(target)
        return (target.components.combat ~= nil and target.components.combat.target == inst)
        or ((target:HasTag("monster") or target:HasTag("pig")) and
          not (target:HasTag("player") or target:HasTag("spider")) and
          not (inst.components.sanity:IsSane() and target:HasTag("shadowcreature")))
      end,
      nil, nil, { "monster", "pig", "_combat" }) ~= nil
  end
  --Danger if:
  -- being targetted
  -- OR near monster that is not player
  -- ignore shadow monsters when not insane
  return GLOBAL.FindEntity(inst, 10,
    function(target)
      return (target.components.combat ~= nil and target.components.combat.target == inst)
      or (target:HasTag("monster") and
        not target:HasTag("player") and
        not (inst.components.sanity:IsSane() and target:HasTag("shadowcreature")))
    end,
    nil, nil, { "monster", "_combat" }) ~= nil
end

local function ForceStopHeavyLifting(inst)
  if inst.components.inventory:IsHeavyLifting() then
    inst.components.inventory:DropItem(
      inst.components.inventory:Unequip(EQUIPSLOTS.BODY),
      true,
      true
    )
  end
end

local function OpenArcherySkinCrate(player, skin)
  player.components.locomotor:Stop()
  player.components.locomotor:Clear()
  player:ClearBufferedAction()

  local failstr =
  (IsNearDanger(player) and "ANNOUNCE_NODANGERGIFT") or
  (player.components.rider:IsRiding() and "ANNOUNCE_NOMOUNTEDGIFT") or
  nil

  if failstr ~= nil then
    player.sg.statemem.isfailed = true
    player.sg:GoToState("idle")
    if player.components.talker ~= nil then
      player.components.talker:Say(GetString(player, failstr))
    end
    return
  end

  ForceStopHeavyLifting(player)

  if player.components.playercontroller ~= nil then
    player.components.playercontroller:RemotePausePrediction()
    player.components.playercontroller:EnableMapControls(false)
    player.components.playercontroller:Enable(false)
  end

  player.components.inventory:Hide()
  player:PushEvent("ms_closepopups")
  player:ShowActions(false)

--  player.AnimState:PlayAnimation("pickanddrop_archery_skincrate")

--  local temp_crate = nil

--  player:DoTaskInTime(0.2, function(player)
--      player.AnimState:OverrideSymbol("swap_object", "swap_skin_crate", "swap_skin_crate")
--    end)

--  player:DoTaskInTime(0.75, function(player)		
--      player.AnimState:ClearOverrideSymbol("swap_object")

--      temp_crate = GLOBAL.SpawnPrefab("am_skin_crate")
--      temp_crate.Transform:SetPosition(player.Transform:GetWorldPosition())
--    end)

--  player:DoTaskInTime(1, function(player)
--      player.AnimState:OverrideSymbol("swap_object", "swap_shovel", "swap_shovel")

--      player.AnimState:PlayAnimation("shovel_pre")
--      player.AnimState:PushAnimation("shovel_loop")
--      player.AnimState:PushAnimation("shovel_pst")
--    end)

--  player:DoTaskInTime(2.67, function(player)
--      player.AnimState:PlayAnimation("idle")
--      local hand_equipped = player.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)

--      if hand_equipped ~= nil then 
--        hand_equipped.components.equippable.onequipfn(hand_equipped, player)
--      else
--        player.AnimState:ClearOverrideSymbol("swap_object")
--      end

--      if temp_crate then temp_crate:Remove() end
--      temp_crate = nil

--      if GLOBAL.ThePlayer and GLOBAL.ThePlayer == player then
--        player.HUD.archeryskinscreen = ArcherySkinPopUp(player, skin)
--        player.HUD:OpenScreenUnderPause(player.HUD.archeryskinscreen)
--      else
--        player.player_classified._am_openskinscreen:set(skin)
--        player:DoTaskInTime(1, function(player) player.player_classified._am_openskinscreen:set_local("") end)
--      end
--    end)

  if GLOBAL.ThePlayer and GLOBAL.ThePlayer == player then
    player.HUD.archeryskinscreen = ArcherySkinPopUp(player, skin)
    player.HUD:OpenScreenUnderPause(player.HUD.archeryskinscreen)
  else
    player.player_classified._am_openskinscreen:set(skin)
    player:DoTaskInTime(1, function(player) player.player_classified._am_openskinscreen:set_local("") end)
  end
end

AddPlayerPostInit(function(inst)
    inst:DoTaskInTime(0, function(inst)
        if inst.HUD and inst.HUD.controls then
          if debuglog then print("Adding the skin drop notification popup") end
          inst.HUD.controls.archery_item_notif = inst.HUD.controls.topleft_root:AddChild(GiftItemToast(inst))
          inst.HUD.controls.archery_item_notif:SetPosition(175, 150, 0)

          inst.HUD.controls.archery_item_notif.tab_gift.animstate:SetBuild("new_archery_skin")
          inst.HUD.controls.archery_item_notif.tab_gift.animstate:SetBank("new_archery_skin")

          local gift_update_cb = inst.event_listeners.giftreceiverupdate[inst.HUD.controls.archery_item_notif.inst]

          if debuglog then print(gift_update_cb) end

          for i, fn in ipairs(gift_update_cb) do
            inst.HUD.controls.archery_item_notif.inst:RemoveEventCallback("giftreceiverupdate", fn, inst)
          end

          if inst.player_classified then
            inst.HUD.controls.archery_item_notif.inst:ListenForEvent("giftsdirty",  function(player)
                if inst.HUD.controls.archery_item_notif.numitems > 0 then
                  inst.HUD.controls.archery_item_notif:OnToast(inst.HUD.controls.archery_item_notif.numitems)
                  if inst.player_classified.hasgiftmachine:value() then
                    inst.HUD.controls.archery_item_notif:EnableClick()
                  else
                    inst.HUD.controls.archery_item_notif:DisableClick()
                  end
                end
              end, inst.player_classified)
          end

          local last_click_time = 0
          local TIMEOUT = 1

          inst.HUD.controls.archery_item_notif.DoOpenGift = function(self)
            if not self.owner:HasTag("busy") and GLOBAL.ThePlayer and self.owner == GLOBAL.ThePlayer then
              local time = GLOBAL.GetTime()
              if time - last_click_time > TIMEOUT then
                last_click_time = time

                local nwskn = inst.HUD.controls.archery_item_notif.pending[#inst.HUD.controls.archery_item_notif.pending]
                local unmgl_skn = ResolveMglStr(nwskn, curr_rev)
                if debuglog then print("Pending item = " .. tostring(unmgl_skn)) end

                if GetIsHostPlayer(self.owner) then
                  OpenArcherySkinCrate(self.owner, unmgl_skn)
                elseif not GLOBAL.TheWorld.ismastersim then
                  SendModRPCToServer(MOD_RPC["Archery Mod"]["DoOpenSkinBoxAnim"], unmgl_skn)
                end

                if inst.HUD and #inst.HUD.controls.archery_item_notif.pending > 0 then
                  inst.HUD.controls.archery_item_notif.pending[#inst.HUD.controls.archery_item_notif.pending] = nil
                  inst.HUD.controls.archery_item_notif.numitems = inst.HUD.controls.archery_item_notif.numitems-1
                  ReloadAndRegenerateOwnership(inst, nwskn)
                  inst.HUD.controls.archery_item_notif:UpdateElements()
                end
              end
            end
          end
        end
      end)
  end)

GLOBAL.package.loaded["widgets/giftitemtoast"] = nil

--------------------------------------------- Widgets/SCreens Post Inits -----------------------------------------------

local function GetItemHasSkin(item)
  return GLOBAL.ARCHERYSKINS[item]
end

AddClassPostConstruct("widgets/recipepopup", function(self, horizontal)
    local origGetSkinList = self.GetSkinsList

    self.GetSkinsList = function(self)
      -- print("Checking skins for " .. tostring(self.recipe) .. " ( " .. tostring(self.recipe and self.recipe.name or nil) .. " ) => has mod skin? " .. tostring(GetItemHasSkin(self.recipe.name) or "got nothing"))
      if self.recipe and GetItemHasSkin(self.recipe.name) then
        if GLOBAL.ThePlayer then GLOBAL.ThePlayer._itemcheckedhasmodskin = nil end
        -- print("Checking out if the bow has skins")
        self.skins_list = {}
        for _,item_type in pairs(GLOBAL.PREFAB_SKINS[self.recipe.name]) do
          if CheckValidOwner(GLOBAL.ThePlayer, item_type) then
            local data  = {}
            data.type = type
            data.item = item_type
            table.insert(self.skins_list, data)
          end
        end

        return self.skins_list
      else
        return origGetSkinList(self)
      end
    end

    local origGetSkinOptions = self.GetSkinOptions

    self.GetSkinOptions = function(self)
      if self.recipe and GetItemHasSkin(self.recipe.name) ~= nil then
        local skin_options = {}

        table.insert(skin_options,
          {
            text = STRINGS.UI.CRAFTING.DEFAULT,
            data = nil,
            colour = GLOBAL.DEFAULT_SKIN_COLOR,
            new_indicator = false,
            image = {"images/inventoryimages/" .. self.recipe.name .. ".xml", self.recipe.name .. ".tex", "default.tex"},
          })

        if self.skins_list and GLOBAL.TheNet:IsOnlineMode() then
          for which = 1, #self.skins_list do
            local image_name = self.skins_list[which].item

            local colour = GLOBAL.GetColorForItem(image_name)
            local text_name = GLOBAL.GetSkinName(image_name) or STRINGS.SKIN_NAMES["missing"]
            local new_indicator = true

            if image_name == "" then
              image_name = "default"
            else
              image_name = string.gsub(image_name, "_none", "")
            end

            -- print("SKIN NAME: " .. tostring(image_name))

            table.insert(skin_options,
              {
                text = text_name,
                data = nil,
                colour = colour,
                new_indicator = new_indicator,
                image = {"images/inventoryimages/" .. image_name .. ".xml", image_name..".tex" or "default.tex", "default.tex"},
              })
          end

        else
          self.spinner_empty = true
        end

        return skin_options
      else
        return origGetSkinOptions(self)
      end
    end
  end)

AddComponentPostInit("builder", function(self)
    local origMakeRecipeFromMenu = self.MakeRecipeFromMenu

    self.MakeRecipeFromMenu = function(self, recipe, skin)
      if recipe.name == "bow" then
        if recipe.placer == nil then
          if self:KnowsRecipe(recipe.name) then
            if self:IsBuildBuffered(recipe.name) or self:CanBuild(recipe.name) then
              self:MakeRecipe(recipe, nil, nil, skin)
            end
          elseif GLOBAL.CanPrototypeRecipe(recipe.level, self.accessible_tech_trees) and
          self:CanLearn(recipe.name) and
          self:CanBuild(recipe.name) then
            self:MakeRecipe(recipe, nil, nil, skin,
              function()
                self:ActivateCurrentResearchMachine()
                self:UnlockRecipe(recipe.name)
              end
            )
          end
        end
      else
        origMakeRecipeFromMenu(self,recipe,skin)
      end
    end

    self.inst:ListenForEvent("builditem", function(inst, data)
        if GetItemHasSkin(data.item.prefab) ~= nil and data.skin ~= nil then
          if debuglog then print("Applying mod skin: " .. tostring(data.skin)) end
          data.item.AnimState:SetSkin(data.skin, data.skin)
          data.item._skinname = data.skin
          data.item.components.inventoryitem:ChangeImageName(data.skin)
          data.item.components.inventoryitem.atlasname = "images/inventoryimages/" .. data.skin .. ".xml"
        end
      end)
  end)



AddModRPCHandler("Archery Mod", "CancelTrackTask", function(player, task_netvar, reset_var)
    if debuglog then print("Received cancel request for task " .. tostring(task_netvar)) end
    if player.player_classified and player.player_classified._am_tracktasks[task_netvar] ~= nil then
      CancelTrackDropTask(player.player_classified, task_netvar, reset_var)
    else
      if player.player_classified == nil then
        print("WARNING: Failed to cancel task => player_classified == nil")
      else
        print("WARNING: Required to cancel non existing task " .. tostring(task_netvar))
      end
    end
  end)

AddModRPCHandler("Archery Mod", "GiveBackPlayerControl", function(player)
    if player.components.playercontroller ~= nil then
      player.components.playercontroller:EnableMapControls(true)
      player.components.playercontroller:Enable(true)
    end
    player.components.inventory:Show()
    player:ShowActions(true)
  end)

AddModRPCHandler("Archery Mod", "DoOpenSkinBoxAnim", function(player, skin)
    OpenArcherySkinCrate(player, skin)
  end)