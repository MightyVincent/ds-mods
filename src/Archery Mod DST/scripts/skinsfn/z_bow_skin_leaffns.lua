local debuglog = false

local function HandleCancelTrackLeaf(classified, callback, force)
	HandleTrackTaskCanceling(classified.entity:GetParent(), "drop_leaf_bow_ticks", "z_bow_skin_leaf", "dropleafbowticksdirty", callback, force)
end

local function DoTrackTask(classified)
	local rdm = math.random()
	-- print("Try to drop the reward bow: " .. tostring(rdm) .. " + " .. tostring(classified.drop_reward_bow_attempt*0.1) .. " = " .. tostring(rdm + player.drop_reward_bow_attempt*0.1))
	if rdm + math.floor(classified.drop_leaf_bow_ticks:value()/1800) > 0.95 then
		if debuglog then print("DROP REWARD BOW = SUCCESS for " .. tostring(classified)) end
		if debuglog then print("Reward = z_bow_skin_leaf ( mangled = " .. ResolveMglStr("z_bow_skin_leaf", curr_encr) .. " )") end
		GrantSkin(classified.entity:GetParent(), ResolveMglStr("z_bow_skin_leaf", curr_encr))
		return true
	else
		if debuglog then print("DROP REWARD BOW = FAILED for " .. tostring(classified)) end
		return false
	end
end

local function OnDropLeafBowTickDirty(classified)
	if debuglog then print("Received event dirty from task drop_leaf_bow_ticks ( " .. tostring(classified.entity:GetParent()) .. " ) = " .. tostring(classified.drop_leaf_bow_ticks:value())) end
	
	if classified.drop_leaf_bow_ticks:value()%180 == 0 and classified.drop_leaf_bow_ticks:value() > 0 then
		if DoTrackTask(classified) then
			HandleCancelTrackLeaf(classified, OnDropLeafBowTickDirty)
		end
	end
end

local function SetupTrackTask(classified)
	if classified._am_tracktasks["drop_leaf_bow_ticks"] and classified._am_tracktasks["drop_leaf_bow_ticks"].task == nil then
		local rseed = os.time()
		if debuglog then print("Item ok to trigger test drop ( random seed is " .. tostring(rseed) .. " )") end
		math.randomseed(os.time())
		
		classified._am_tracktasks["drop_leaf_bow_ticks"].task = classified:DoPeriodicTask(10, function(classified)
			if debuglog then print("Increasing drop tick by 1 for z_bow_skin_leaf for " .. tostring(classified)) end
			classified.drop_leaf_bow_ticks:set(classified.drop_leaf_bow_ticks:value()+1)
			
			if GetIsHostPlayer(classified) and classified.drop_leaf_bow_ticks:value()%180 == 0 then
				if DoTrackTask(classified) then
					HandleCancelTrackLeaf(classified, OnDropLeafBowTickDirty)
				end
			end
		end)
				
		classified.drop_leaf_bow_ticks:set_local(0)
	end
end

local function MasterInitFn(player, data)
	if debuglog then print("Built an item => " .. tostring(data.item)) end
	if player.player_classified and player.player_classified.drop_leaf_bow_ticks and data and data.item.prefab == "bow" and data.item:HasTag("zupalexsrangedweapons") then			
		SetupTrackTask(player.player_classified)
	elseif player.player_classified and player.player_classified.drop_leaf_bow_ticks == nil then
		player.player_classified:RemoveEventCallback("builditem", MasterInitFn, player)
	end
end

local function condfn(classified)
	classified.drop_leaf_bow_ticks = GLOBAL.net_ushortint(classified.GUID, "am_drop_leaf_bow_ticks", "dropleafbowticksdirty")
	
	if not GLOBAL.TheWorld.ismastersim then
		classified:ListenForEvent("dropleafbowticksdirty", OnDropLeafBowTickDirty)
		TryDoUntil(classified, CheckForReplicated, 0.1, 0, 5, function(classified)
			HandleCancelTrackLeaf(classified, OnDropLeafBowTickDirty)
		end)
		
		return classified
	end
	
	SetupNewTrackTask(classified, "drop_leaf_bow_ticks")
	
	TryDoUntil(classified, CheckForReplicated, 0.1, 0, 5, function(classified)
			if debuglog then print("Install the progress track for z_bow_skin_leaf ( " .. tostring(classified.entity:GetParent()) .. " )") end
			
			classified:ListenForEvent("builditem", MasterInitFn, classified.entity:GetParent())
			HandleCancelTrackLeaf(classified, OnDropLeafBowTickDirty)
	end)
end

local function onsavefn(player, data)
	local classified = player and player.player_classified
	if classified and classified.drop_leaf_bow_ticks and classified.drop_leaf_bow_ticks:value() > 0 then	
		data.drop_leaf_bow_ticks = classified.drop_leaf_bow_ticks:value()
	elseif data.drop_leaf_bow_ticks ~= nil then
		data.drop_leaf_bow_ticks = nil
	end
end

local function onloadfn(player, data)
	if data and data.drop_leaf_bow_ticks then
		if debuglog then print("Restoring leaf bow ticks for " .. tostring(player) .. " => " .. tostring(data.drop_leaf_bow_ticks)) end
		player:DoTaskInTime(5, function(player) 
			local classified = player.player_classified
			if classified and classified._am_tracktasks["drop_leaf_bow_ticks"] and classified.drop_leaf_bow_ticks then
				if debuglog then print("Restarting the drop check task...") end
				SetupTrackTask(classified)
				classified.drop_leaf_bow_ticks:set_local(data.drop_leaf_bow_ticks)
			end
		end)
	end
end

return condfn, onsavefn, onloadfn