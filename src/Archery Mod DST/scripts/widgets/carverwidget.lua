require "class"
local InvSlot = require "widgets/invslot"
local Widget = require "widgets/widget"
local Text = require "widgets/text"
local UIAnim = require "widgets/uianim"
local ImageButton = require "widgets/imagebutton"
local ItemTile = require "widgets/itemtile"
local ContainerWidget = require "widgets/containerwidget"

-- require "forge_buttons_pos"

-- function SplitString(s, delimiter)
    -- local result = {}
    -- for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        -- table.insert(result, match)
    -- end
    -- return result
-- end

local ArrowCarverWidget = Class(Widget, function(self, owner)
    Widget._ctor(self, "CarverWidget")
    -- local scale = 0.6
    -- self:SetScale(scale,scale,scale)
    self.open = false
    self.owner = owner
	
    self:SetPosition(0, 0, 0)
    -- self.slotsperrow = 3
	
    self.inv = {}
	self.buttons = {}
   
    self.bganim = self:AddChild(UIAnim())
    self.bgimage = self:AddChild(Image())
    self.isopen = false
end)

-- local delay_anim = 0

-- local function ActivateForgeContainerSlots(self, _first, _last, desactivateOthers)
	-- if desactivateOthers == nil then
		-- desactivateOthers = true
	-- end

	-- if self.CwidgetRef then
		-- if desactivateOthers then
			-- for k, v in pairs(self.CwidgetRef.inv) do
				-- print("Found slot ", k, " : ", v)
				
				-- v.bgimage:SetTexture("images/buttons/item_slot_locked.xml", "item_slot_locked.tex")
				-- v:Disable()
			-- end
		-- end
		
		-- if _first >= 1 and _first <= _last then
			-- for n = _first, _last, 1 do
				-- self.CwidgetRef.inv[n].bgimage:SetTexture("images/buttons/item_slot_enabled.xml", "item_slot_enabled.tex")
				-- self.CwidgetRef.inv[n]:Enable()
			-- end
		-- end
	-- end
	
	-- local container = (self.forge.replica and self.forge.replica.container) or (self.forge.components and self.forge.components.container)
	
	-- if container then
		-- print("I can retrieve the widget associated to this container : ", container.inst.Cwidget)
	
		-- container.itemtestfn = function(cont, item, slot)
									-- if slot and cont.inst.Cwidget and cont.inst.Cwidget.inv[slot].enabled then
										-- if slot == 1 and item:HasTag("weapon") then
											-- return true
										-- elseif slot >= 2 and slot <= 7 then
											-- for k, v in ipairs(VALID_FORGE_MATERIALS) do
												-- if item.prefab == VALID_FORGE_MATERIALS[k] then
													-- return true
												-- end
											-- end
										-- elseif slot >= 8 and slot <= 10 then
											-- for k, v in ipairs(VALID_FORGE_SOCKET) do
												-- if item.prefab == VALID_FORGE_SOCKET[k] then
													-- return true
												-- end
											-- end
										-- else
											-- return false
										-- end
									-- else
										-- return false
									-- end
		-- end
	-- end
-- end

-- function ForgeWidget:ActivateForgeSlots(_first, _last, desactivateOthers)
	-- ActivateForgeContainerSlots(self, _first, _last, desactivateOthers)
-- end

-- function GiveBackItemsToDoer(self, doer, firstSlot, lastSlot)
	-- local container = self.forge.components and self.forge.components.container
	-- local inventory = doer.components and doer.components.inventory
	
	-- print("Attempting to give back extra item to ", inventory or "UNAVAILABLE", " from ", container or "UNAVAILABLE")
	
	-- if container and inventory then
		-- for n = firstSlot, lastSlot, 1 do
			-- local itemToRetrieve = container:GetItemInSlot(n)
			-- if itemToRetrieve then
				-- local item = container:RemoveItemBySlot(n)
				-- if item ~= nil then
					-- item.Transform:SetPosition(container.inst.Transform:GetWorldPosition())
					-- if item.components.inventoryitem ~= nil then
						-- item.components.inventoryitem:OnDropped(true)
					-- end
					-- item.prevcontainer = nil
					-- item.prevslot = nil
					-- container.inst:PushEvent("dropitem", { item = item })
					-- inventory:GiveItem(item)
				-- end		
			-- end
		-- end
	-- end
-- end

-- local function KillAllText(self)
	-- print("I kill all the texts now")
	-- if self.CwidgetRef then
		-- if self.CwidgetRef.ingrlist then
			-- for k, v in pairs(self.CwidgetRef.ingrlist) do
				-- self.CwidgetRef.ingrlist[k]:Kill()
				-- self.CwidgetRef.ingrlist[k] = nil
			-- end		
		-- end
		-- if self.CwidgetRef.ingrimg then
			-- for k, v in pairs(self.CwidgetRef.ingrimg) do
				-- self.CwidgetRef.ingrimg[k]:Kill()
				-- self.CwidgetRef.ingrimg[k] = nil
			-- end			
		-- end
	-- end
-- end

-- local function KillAllSideButtons(self, tabchange)
	-- KillAllText(self)

	-- if self.buttons["craft"] ~= nil then
		-- for k, v in pairs(self.buttons["craft"]) do
			-- if type(v) ~= "string" and type(v) ~= "number" then
				-- self.buttons["craft"][k]:Kill()
				-- self.buttons["craft"][k] = nil
			-- end
		-- end
		-- if tabchange then
			-- self.buttons["craft"].currentCategoryGroup = nil
			-- self.buttons["craft"].currentListGroup = nil
		-- end
	-- end

	-- if self.buttons["repair"] ~= nil then	
		-- for k, v in pairs(self.buttons["repair"]) do
			-- self.buttons["repair"][k]:Kill()
			-- self.buttons["repair"][k] = nil
		-- end
	-- end

	-- if self.buttons["upgrade"] ~= nil then	
		-- for k, v in pairs(self.buttons["upgrade"]) do
			-- if type(v) ~= "string" and type(v) ~= "number" then
				-- self.buttons["upgrade"][k]:Kill()
				-- self.buttons["upgrade"][k] = nil
			-- end
		-- end
		-- if tabchange then
			-- self.buttons["upgrade"].currentCategoryGroup = nil
			-- self.buttons["upgrade"].currentListGroup = nil
		-- end
	-- end
-- end

-- local function AddSpecialButtonToWidget(widget, forge, doer, groupname, name, atlas, atlas_button_name, posx, posy, posz, scalex, scaley, scalez, text, textsize, textcolorR, textcolorG, textcolorB, textalpha, onclickfn, HnCcommon, execRPC, helpmsg)
	-- print("Adding a button to the forge widget : ")
	-- print("Group Name = ", groupname)
	-- print("Button Name = ", name)

	-- if widget.buttons == nil then
		-- widget.buttons = {}
	-- end
	
	-- if widget.buttons[groupname] == nil then
		-- widget.buttons[groupname] = {}
	-- end

	-- widget.buttons[groupname][name] = widget:AddChild(ImageButton(atlas, atlas_button_name..".tex", atlas_button_name.."_over.tex", atlas_button_name.."_disabled.tex", nil, nil, {1,1}, {0,0}))
	-- -- widget.buttons[groupname][name] = widget:AddChild(ImageButton(atlas, atlas_button_name..".tex", atlas_button_name..".tex", atlas_button_name..".tex", nil, nil, {1,1}, {0,0}))
    -- widget.buttons[groupname][name]:SetPosition(posx, posy, posz)
    -- widget.buttons[groupname][name]:SetText(text)
	            
	-- widget.buttons[groupname][name].image:SetScale(scalex, scaley, scalez)
	-- widget.buttons[groupname][name].text:SetPosition(2,-2)
	            
	-- widget.buttons[groupname][name]:SetFont(BUTTONFONT)
	-- widget.buttons[groupname][name]:SetDisabledFont(BUTTONFONT)
	-- widget.buttons[groupname][name]:SetTextSize(textsize)
	-- widget.buttons[groupname][name].text:SetVAlign(ANCHOR_MIDDLE)
	-- widget.buttons[groupname][name].text:SetColour(textcolorR, textcolorG, textcolorB, textalpha)
	            
	-- if helpmsg then
		-- widget.buttons[groupname][name]:SetHoverText(helpmsg, {size = 45})
	-- end			
	
    -- widget.buttons[groupname][name]:SetOnClick(function()
								-- -- print("I clicked on the button")
								
								-- if widget.isBusy then return end
								
								-- if doer ~= nil then
									-- if doer:HasTag("busy") then
										-- --Ignore button click when doer is busy
										-- return
									-- elseif doer.components.playercontroller ~= nil then
										-- local iscontrolsenabled, ishudblocking = doer.components.playercontroller:IsEnabled()
										-- if not (iscontrolsenabled or ishudblocking) then
											-- --Ignore button click when controls are disabled
											-- --but not just because of the HUD blocking input
											-- return
										-- end
									-- end
								-- end
								
								-- local forgeWidget = doer.HUD and doer.HUD.controls and doer.HUD.controls.forge
								
								-- if TheWorld.ismastersim or HnCcommon then
									-- -- print("I call the ", name, " function on the HOST")
									-- onclickfn(forgeWidget, doer, groupname, name)
								-- end
								-- if not TheWorld.ismastersim and execRPC then
									-- print("CLIENT ", name, " request...")
									
									-- local catIndex = (forgeWidget.buttons["craft"] and forgeWidget.buttons["craft"].currentCategoryGroup) or 
														-- (forgeWidget.buttons["upgrade"] and forgeWidget.buttons["upgrade"].currentCategoryGroup) or
														-- nil
									
									-- local listIndex = (forgeWidget.buttons["craft"] and forgeWidget.buttons["craft"].currentListGroup) or 
														-- (forgeWidget.buttons["upgrade"] and forgeWidget.buttons["upgrade"].currentListGroup) or
														-- nil
									
									-- SendModRPCToServer(MOD_RPC["Blacksmith Mod"]["ClientCPInteractions"], 	forge, 
																											-- name == "close" and name or forgeWidget.currentMode, 
																											-- forgeWidget.buttons["general"] and forgeWidget.buttons["general"][name] and forgeWidget.buttons["general"][name].item or nil,
																											-- catIndex, listIndex
									-- )
								-- end
							-- end
	-- )
-- end

-- function ForgeWidget:AddSpecialButton(forge, doer, groupname, name, atlas, atlas_button_name, posx, posy, posz, scalex, scaley, scalez, text, textsize, textcolorR, textcolorG, textcolorB, textalpha, onclickfn, HnCcommon, execRPC, helpmsg)
	-- AddSpecialButtonToWidget(self, forge, doer, groupname, name, atlas, atlas_button_name, posx, posy, posz, scalex, scaley, scalez, text, textsize, textcolorR, textcolorG, textcolorB, textalpha, onclickfn, HnCcommon, execRPC, helpmsg)
-- end

-- function ForgeWidget:AddText(doer, name, posx, posy, posz, font, text, textsize, textcolorR, textcolorG, textcolorB, textalpha)
	-- if self.CwidgetRef then
		-- if self.CwidgetRef.ingrlist == nil then
			-- self.CwidgetRef.ingrlist = {}
		-- end
		
		-- self.CwidgetRef.ingrlist[name] = self.CwidgetRef:AddChild(Text(font, textsize, text, {textcolorR, textcolorG, textcolorB, textalpha}))
		-- self.CwidgetRef.ingrlist[name]:SetPosition(posx, posy, posz)
	-- end
-- end

-- function ForgeWidget:AddImage(doer, name, posx, posy, posz, atlas, tex, helpmsg)
	-- if self.CwidgetRef then
		-- if self.CwidgetRef.ingrimg == nil then
			-- self.CwidgetRef.ingrimg = {}
		-- end
		
		-- self.CwidgetRef.ingrimg[name] = self.CwidgetRef:AddChild(Image(atlas, tex))
		-- self.CwidgetRef.ingrimg[name]:SetPosition(posx, posy, posz)
		-- if helpmsg then
			-- self.CwidgetRef.ingrimg[name]:SetHoverText(helpmsg, {size = 45})
		-- end
	-- end
-- end

-- local function DisplayIngredientList(self, doer, groupname, name)
	-- if groupname == "repair" then
	
	-- elseif groupname == "upgrade" or groupname == "craft" then
		-- print("Displaying Ingredients")
		-- print("data = ")
		-- print("doer = ", doer, " / groupname = ", groupname, " / name = ", name)
	
		-- local container = (self.forge.components and self.forge.components.container) or (self.forge.replica and self.forge.replica.container)
	
		-- if self.currentMode == "upgrade" and container == nil then
			-- return
		-- end
	
		-- local selectedItemPattern = SplitString(name, '_')
		
		-- print("selecteditem = ", name)
		-- print("Category Group = ", self.buttons[groupname].currentCategoryGroup)	
		-- print("List Group = ", self.buttons[groupname].currentListGroup)
		
		-- local ITEMLIST = {}
		
		-- if groupname == "upgrade" then
			-- local upType = selectedItemPattern[1]
		
			-- upType = (upType == "common" and "common") or container:GetItemInSlot(1).prefab
		
			-- ITEMLIST = FORGE_ITEM_LIST.UPGRADE[upType]
			
			-- local matchingKey = GetKeyFromValue(ITEMLIST, name, "UPGRD")
			
			-- ITEMLIST = FORGE_ITEM_LIST.UPGRADE[upType][matchingKey]			
		-- else
			-- ITEMLIST = FORGE_ITEM_LIST.CRAFT[selectedItemPattern[1]][name]
		-- end
		
		-- local materialAmount = 0
		-- local socketAmount = 0
		
		-- local offy = 75 * (#ITEMLIST - (groupname == "upgrade" and 2 or 1))/2
		-- print("Required Items : ")
		-- for i, v in ipairs(ITEMLIST) do
			-- if i > 1 and not (groupname == "upgrade" and i == #ITEMLIST) then
				-- print(v[1], " x", v[2])
				-- local tempprefab = SpawnPrefab(v[1])
				
				-- for n, v2 in ipairs(VALID_FORGE_MATERIALS) do
					-- if tempprefab.prefab == v2 then
						-- materialAmount = materialAmount + 1
					-- end
				-- end
				
				-- for n, v2 in ipairs(VALID_FORGE_SOCKET) do
					-- if tempprefab.prefab == v2 then
						-- socketAmount = socketAmount + 1
					-- end
				-- end
				
				-- if tempprefab ~= nil then				
					-- local displayname = tempprefab:GetDisplayName()
					-- tempprefab:Remove()
					-- local itematlas = (softresolvefilepath("images/inventory/"..v[1]..".xml") ~= nil and resolvefilepath("images/inventory/"..v[1]..".xml")) or 
										-- (softresolvefilepath("images/required/"..v[1]..".xml") ~= nil and resolvefilepath("images/required/"..v[1]..".xml")) or
										-- (softresolvefilepath("images/inventoryimages/"..v[1]..".xml") ~= nil and resolvefilepath("images/inventoryimages/"..v[1]..".xml")) or
										-- resolvefilepath("images/inventoryimages.xml")
					-- self:AddImage(doer, v[1], -190, 0+offy, 0, itematlas,  v[1]..".tex", displayname)	
					-- self:AddText(doer, v[1], -130, 0+offy, 0, BUTTONFONT, "x"..v[2], 45, 0, 0, 0, 1)
					-- offy = offy - 75
				-- end
			-- end
		-- end
		
		-- GiveBackItemsToDoer(self, doer, 2+materialAmount, 11)
		
		-- local startingSlot = self.currentMode == "upgrade" and 1 or 2
		
		-- ActivateForgeContainerSlots(self, startingSlot, 1+materialAmount)
		-- ActivateForgeContainerSlots(self, 0 + (socketAmount > 0 and 8 or 0), 0 + (socketAmount > 0 and 8 or 0) + socketAmount, false)
	-- end
-- end

-- local function onclickTabItem(self, doer, groupname, name)
	-- self.isBusy = true
	
	-- print("I clicked on the item ", name, " from the group ", groupname, " (Operated Forge = ", self.forge, ")")
	
	-- KillAllText(self)
		
	-- self.buttons["general"]["forge"].item = name
		
	-- DisplayIngredientList(self, doer, groupname, name)
		
	-- if self.checkitemstask ~= nil then
		-- self.inst:RemoveEventCallback("itemlose", self.onitemlosefn, self.forge)	
		-- self.inst:RemoveEventCallback("itemget", self.onitemgetfn, self.forge)
	-- end
	
	-- self.checkitemstask = 1
	
	-- self.onitemlosefn = function(inst, data) self:OnItemLose(doer, groupname, name) end
    -- self.inst:ListenForEvent("itemlose", self.onitemlosefn, self.forge)

    -- self.onitemgetfn = function(inst, data) self:OnItemGet(doer, groupname, name) end
    -- self.inst:ListenForEvent("itemget", self.onitemgetfn, self.forge)
	
	-- if doer == ThePlayer then
		-- self:RefreshButton(doer, name)
	-- end
	
	-- self.isBusy = false
-- end

-- local function onclickScrollList(self, doer, groupname, name)
	-- self.isBusy = true
	
	-- local container = (self.forge.replica and self.forge.replica.container) or (self.forge.components and self.forge.replica.components)
	
	-- local currentCategory = self.buttons[groupname][name].currentCategory

	-- KillAllSideButtons(self, false)
	
	-- if self.checkitemstask ~= nil and self.currentMode == "craft" then
		-- self.inst:RemoveEventCallback("itemlose", self.onitemlosefn, self.forge)	
		-- self.inst:RemoveEventCallback("itemget", self.onitemgetfn, self.forge)
	-- end
	
	-- self.buttons["general"]["forge"]:Disable()

	-- if name == "gouplist" then
		-- self.buttons[groupname].currentListGroup = self.buttons[groupname].currentListGroup - 1 
	-- elseif name == "godownlist" then
		-- self.buttons[groupname].currentListGroup = self.buttons[groupname].currentListGroup + 1
	-- end

	-- print("onclickScrollList :")
	-- print("groupname = ", groupname, " / category group = ", self.buttons[groupname].currentCategoryGroup, " / current category = ", currentCategory or "UNAVAILABLE", " / list group = ", self.buttons[groupname].currentListGroup)
		
	-- local ITEMLIST = {}
	
	-- local SPECUPGRADELIST = {}
	-- local COMMONUPGRADELIST = {}
	
	-- local sortedKeysList = {}
	
	-- if self.currentMode == "upgrade" then
		-- local itemToUpgrade = container:GetItemInSlot(1)
		
		-- local itemCoatingCap = TableContainsKey(FORGE_WEAPONS_UPGRADE_CAPACITIES, itemToUpgrade.prefab) and FORGE_WEAPONS_UPGRADE_CAPACITIES[itemToUpgrade.prefab][1] or 1
		-- local itemSocketCap = TableContainsKey(FORGE_WEAPONS_UPGRADE_CAPACITIES, itemToUpgrade.prefab) and FORGE_WEAPONS_UPGRADE_CAPACITIES[itemToUpgrade.prefab][2] or 0
		
		-- for n = 1, #FORGE_ITEM_LIST.UPGRADE.common, 1 do
			-- if 	(SplitString(FORGE_ITEM_LIST.UPGRADE.common[n]["UPGRD"], '_')[2] == "sockets" and not itemInSlot:HasTag("upgraded_sockets_"..itemSocketCap)) or
				-- (SplitString(FORGE_ITEM_LIST.UPGRADE.common[n]["UPGRD"], '_')[2] == "coatings" and not itemInSlot:HasTag("upgraded_coatings_"..itemCoatingCap))
				-- then
					-- table.insert(COMMONUPGRADELIST, FORGE_ITEM_LIST.UPGRADE.common[n])
			-- end
		-- end
		
		-- SPECUPGRADELIST = TableContainsKey(FORGE_ITEM_LIST.UPGRADE, itemToUpgrade.prefab) and FORGE_ITEM_LIST.UPGRADE[itemToUpgrade.prefab] or {}
		
		-- local offy = 118
		
		-- if self.buttons[groupname].currentListGroup == 1 then
			-- local maxSpecSize = math.min(4, #SPECUPGRADELIST)
			
			-- for n = 1, maxSpecSize, 1 do										
				-- local buttonscalex = 0.65
				-- local buttonscaley = 0.65
				-- -- offy = offy + nbr_return_to_line*25
				-- self:AddSpecialButton(self.forge, doer, "upgrade", SPECUPGRADELIST[n].UPGRD, 
										-- "images/buttons/forgebuttons.xml", "listbutton",
										-- FORGE_BUTTONS.GOUPLIST.x, FORGE_BUTTONS.GOUPLIST.y-offy, FORGE_BUTTONS.GOUPLIST.z, buttonscalex, buttonscaley, 1, 
										-- SPECUPGRADELIST[n][1], 45, 0, 0, 0, 1, onclickTabItem, true)
				-- offy = offy + 118
			-- end
			
			-- local maxCommonSize = math.min((5 - maxSpecSize), #COMMONUPGRADELIST)
			
			-- for n = 1, maxCommonSize do										
				-- local buttonscalex = 0.65
				-- local buttonscaley = 0.65
				-- -- offy = offy + nbr_return_to_line*25
				-- self:AddSpecialButton(self.forge, doer, "upgrade", COMMONUPGRADELIST[n].UPGRD, 
										-- "images/buttons/forgebuttons.xml", "listbutton",
										-- FORGE_BUTTONS.GOUPLIST.x, FORGE_BUTTONS.GOUPLIST.y-offy, FORGE_BUTTONS.GOUPLIST.z, buttonscalex, buttonscaley, 1, 
										-- COMMONUPGRADELIST[n][1], 45, 0, 0, 0, 1, onclickTabItem, true)
				-- offy = offy + 118
			-- end		
		-- else					
			-- local firstSpecEntry = (#SPECUPGRADELIST > 4 + (self.buttons[groupname].currentListGroup - 2) * 5) and 1 + 4 + (self.buttons[groupname].currentListGroup - 2) * 5 or 0
			-- local lastSpecEntry = math.min(firstSpecEntry+4, #sortedKeysList)
			
			-- local firstCommonEntry = 	((firstSpecEntry > 0 and lastSpecEntry - firstSpecEntry < 5) and 1 + 1) or 
										-- ((firstSpecEntry == 0) and (self.buttons[groupname].currentListGroup - 1) * 5 - #SPECUPGRADELIST + 1) or 
										-- 0
			-- local lastCommonEntry = firstSpecEntry > 0 and math.min(firstCommonEntry + 5 - (lastSpecEntry - firstSpecEntry), #COMMONUPGRADELIST) or 
									-- math.min(firstCommonEntry + 5, #COMMONUPGRADELIST)
			
			-- print("firstSpecEntry = ", firstSpecEntry, " / lastSpecEntry = ", lastSpecEntry)
			-- print("firstCommonEntry = ", firstCommonEntry, " / lastCommonEntry = ", lastCommonEntry)
			
			-- if firstSpecEntry > 0 then
				-- for n = firstSpecEntry, lastSpecEntry, 1 do										
					-- local buttonscalex = 0.65
					-- local buttonscaley = 0.65
					-- -- offy = offy + nbr_return_to_line*25
					-- self:AddSpecialButton(self.forge, doer, "upgrade", SPECUPGRADELIST[n].UPGRD, 
											-- "images/buttons/forgebuttons.xml", "listbutton",
											-- FORGE_BUTTONS.GOUPLIST.x, FORGE_BUTTONS.GOUPLIST.y-offy, FORGE_BUTTONS.GOUPLIST.z, buttonscalex, buttonscaley, 1, 
											-- SPECUPGRADELIST[n][1], 45, 0, 0, 0, 1, onclickTabItem, true)
					-- offy = offy + 118
				-- end
			-- end
			
			-- if firstCommonEntry > 0 then
				-- for n = firstCommonEntry, lastCommonEntry, 1 do										
					-- local buttonscalex = 0.65
					-- local buttonscaley = 0.65
					-- -- offy = offy + nbr_return_to_line*25
					-- self:AddSpecialButton(self.forge, doer, "upgrade", COMMONUPGRADELIST[n].UPGRD, 
											-- "images/buttons/forgebuttons.xml", "listbutton",
											-- FORGE_BUTTONS.GOUPLIST.x, FORGE_BUTTONS.GOUPLIST.y-offy, FORGE_BUTTONS.GOUPLIST.z, buttonscalex, buttonscaley, 1, 
											-- COMMONUPGRADELIST[n][1], 45, 0, 0, 0, 1, onclickTabItem, true)
					-- offy = offy + 118
				-- end
			-- end
		-- end
	-- elseif self.currentMode == "craft" then
		-- -- local lastClickedEntryPattern = SplitString(self.buttons["general"]["forge"].item, '_')	
	
		-- ITEMLIST = FORGE_ITEM_LIST.CRAFT[currentCategory]
		
		-- sortedKeysList = GetSortedKeysList(ITEMLIST, { "name" })
	
		-- local firstEntryToDisplay = 1 + (self.buttons[groupname].currentListGroup - 1) * 5
		-- local lastEntryToDisplay = math.min(firstEntryToDisplay+4, #sortedKeysList)
		
		-- local offy = 118
		-- for n = firstEntryToDisplay, lastEntryToDisplay, 1 do
			-- local buttonscalex = 0.65
			-- local buttonscaley = 0.65

			-- self:AddSpecialButton(self.forge, doer, groupname, sortedKeysList[n], 
									-- "images/buttons/forgebuttons.xml", "listbutton",
									-- FORGE_BUTTONS.GOUPLIST.x, FORGE_BUTTONS.GOUPLIST.y-offy, FORGE_BUTTONS.GOUPLIST.z, buttonscalex, buttonscaley, 1, 
									-- ITEMLIST[sortedKeysList[n]][1], 45, 0, 0, 0, 1, onclickTabItem, true)
			-- offy = offy + 118
		-- end
	-- end
	
	-- local listButtScale = 0.7
	
	-- self:AddSpecialButton(self.forge, doer, groupname, "gouplist", 
							-- "images/buttons/forgebuttons.xml", "listup",
							-- FORGE_BUTTONS.GOUPLIST.x, FORGE_BUTTONS.GOUPLIST.y, FORGE_BUTTONS.GOUPLIST.z, listButtScale, listButtScale, listButtScale, 
							-- "", 45, 0, 0, 0, 1, onclickScrollList, true)		

	-- self:AddSpecialButton(self.forge, doer, groupname, "godownlist", 
							-- "images/buttons/forgebuttons.xml", "listdown",
							-- FORGE_BUTTONS.GODOWNLIST.x, FORGE_BUTTONS.GODOWNLIST.y, FORGE_BUTTONS.GODOWNLIST.z, listButtScale, listButtScale, listButtScale, 
							-- "", 45, 0, 0, 0, 1, onclickScrollList, true)		
	
	-- self.buttons[groupname]["gouplist"].currentCategory = currentCategory
	-- self.buttons[groupname]["godownlist"].currentCategory = currentCategory
	
	-- if self.buttons[groupname].currentListGroup == 1 then
		-- self.buttons[groupname]["gouplist"]:Disable()
	-- else
		-- self.buttons[groupname]["gouplist"]:Enable()
	-- end
	
	-- local maxGroup = self.currentMode == "craft" and math.ceil(#sortedKeysList/5) or math.ceil((#SPECUPGRADELIST + #COMMONUPGRADELIST)/5)
	
	-- if self.buttons[groupname].currentListGroup == maxGroup then
		-- self.buttons[groupname]["godownlist"]:Disable()	
	-- else
		-- self.buttons[groupname]["godownlist"]:Enable()
	-- end
	
	-- self.isBusy = false
-- end

-- local function DoRepairButtonCheckFunc(self, doer, groupname)
	-- print("I perform the check for the Repair Button")
	-- print("data = ")
	-- print("doer = ", doer, " / groupname = ", groupname)	
	-- local container = (self.forge.replica and self.forge.replica.container) or (self.forge.components and self.forge.replica.components)
	-- local iteminweapslot = container and container:GetItemInSlot(1)
	-- local iwsprefab = iteminweapslot and iteminweapslot.prefab

	-- if not container or (container and container:GetItemInSlot(1) == nil) then
		-- KillAllText(self)
	-- end
	
	-- if not container then
		-- return false
	-- end
	
	-- if container:GetItemInSlot(11) ~= nil then
		-- return false
	-- end
	
	-- if self.isBusy then
		-- return false
	-- end
	
	-- -- local REQ_ITEMS_LIST = FORGE_ITEM_LIST["REPAIR"][self.buttons[groupname].currentCategoryGroup][iteminweapslot.prefab]
	-- local REQ_ITEMS_LIST = AllRecipes[iwsprefab] and AllRecipes[iwsprefab].ingredients
	-- print("The list of All Know Recipes is : ", AllRecipes)
	
	-- if REQ_ITEMS_LIST == nil then
		-- print("weapon/armor missing or invalid (have ", iwsprefab or "NOTHING", "in the weapon/armor slot)")
		-- if iwsprefab ~= nil then
			-- if self.ingrlist and self.ingrlist[iwsprefab] then
				-- self.ingrlist[iwsprefab]:Kill()
				-- self.ingrlist[iwsprefab] = nil
			-- end
			-- self:AddText(doer, iwsprefab or "empty", -160, 50, 0, BUTTONFONT, "This item\ncannot be\nrepaired", 45, 0, 0, 0, 1) 
		-- end
		
		-- return false
	-- end
	
	-- local print_ingr_list = true
	-- if self.ingrlist and self.ingrlist[iwsprefab] then
		-- print_ingr_list = false
	-- end
	
	-- local nbr_repair_parts = math.ceil(#REQ_ITEMS_LIST/2)
	
	-- GiveBackItemsToDoer(self, doer, 2+nbr_repair_parts, 11)
	
	-- ActivateForgeContainerSlots(self, 1, 1+nbr_repair_parts)
	
	-- local found_repair_parts = 0
	-- local found_valid_repair_parts = 0
	
	-- local offy = 75 * (nbr_repair_parts+1)/2

	-- if print_ingr_list then
		-- KillAllText(self)
		
		-- local tempprefab = SpawnPrefab(iwsprefab)
		-- local displayname = tempprefab:GetDisplayName()
		-- tempprefab:Remove()
		-- self:AddImage(doer, iwsprefab, -160, 0+offy, 0, AllRecipes[iwsprefab].atlas, AllRecipes[iwsprefab].image, displayname)
		-- offy = offy - 75
	-- end

	-- self.repairReqList = {}
	
	-- for i1, v1 in ipairs(FORGE_ITEM_LIST["REPAIR"]) do
		-- for i2, v2 in ipairs(REQ_ITEMS_LIST) do
			-- print("Checking ", FORGE_ITEM_LIST["REPAIR"][i1], " against ", REQ_ITEMS_LIST[i2]["type"])
			-- if v1 == REQ_ITEMS_LIST[i2]["type"] then
				-- found_repair_parts = found_repair_parts + 1
				

				-- if print_ingr_list then
					-- local tempprefab = SpawnPrefab(REQ_ITEMS_LIST[i2]["type"])
					
					-- table.insert(self.repairReqList, {REQ_ITEMS_LIST[i2]["type"], math.ceil(REQ_ITEMS_LIST[i2]["amount"]/2)})
					
					-- local displayname = tempprefab:GetDisplayName()
					-- tempprefab:Remove()
					-- self:AddImage(doer, v2, -190, 0+offy, 0,  REQ_ITEMS_LIST[i2]["atlas"],  REQ_ITEMS_LIST[i2]["type"]..".tex",  displayname)
					-- self:AddText(doer, v2, -130, 0+offy, 0, BUTTONFONT, "x"..math.ceil(REQ_ITEMS_LIST[i2]["amount"]/2), 45, 0, 0, 0, 1) 
					-- offy = offy - 75
				-- end

				-- local hasitem, numfound = container:Has(REQ_ITEMS_LIST[i2]["type"], math.ceil(REQ_ITEMS_LIST[i2]["amount"]/2))
				-- if hasitem then
					-- print(REQ_ITEMS_LIST[i2]["type"], " is required (" , math.ceil(REQ_ITEMS_LIST[i2]["amount"]/2), ")and ", numfound, " were found in the forge container")
					-- found_valid_repair_parts = found_valid_repair_parts + 1
					-- print("")
				-- else
					-- print("item missing : ", REQ_ITEMS_LIST[i2]["type"], " (found ", numfound," need ", math.ceil(REQ_ITEMS_LIST[i2]["amount"]/2),")")
				-- end
				
				-- if nbr_repair_parts == found_repair_parts then
					-- return found_valid_repair_parts == nbr_repair_parts
				-- end
			-- end
		-- end
	-- end
	
	-- return false
-- end

-- local function DoUpgradeButtonCheckFunc(self, doer, groupname, name)
	-- print("I perform the check for the Upgrade Button")
	-- print("data = ")
	-- print("doer = ", doer, " / groupname = ", groupname, " / name = ", name)	
	-- local container = self.forge.replica and self.forge.replica.container
	-- local itemInSlot = container and container:GetItemInSlot(1)
	
	-- if not container then
		-- return false
	-- end
	
	-- if self.isBusy then
		-- return false
	-- end
	
	-- if itemInSlot == nil then
		-- self.isBusy = true
		
		-- GiveBackItemsToDoer(self, doer, 1, 11)
		
		-- KillAllSideButtons(self, true)
		
		-- delay_anim = 0
		
		-- if self.categoryListIsOpen then
			-- print("Category List was open... Closing it...")
			-- self.categoryListIsOpen = false
			-- self.bganim:GetAnimState():PlayAnimation("forge_close_list", false)
			-- delay_anim = delay_anim + self.bganim:GetAnimState():GetCurrentAnimationLength()
		-- end
		
		-- self.buttons["general"]["forge"]:Disable()
		
		-- ActivateForgeContainerSlots(self, 1, 1)
	
		-- self.bganim:GetAnimState():PushAnimation("forge_init", false)
		
		-- if self.checkitemstask ~= nil then
			-- self.inst:RemoveEventCallback("itemlose", self.onitemlosefn, self.forge)	
			-- self.inst:RemoveEventCallback("itemget", self.onitemgetfn, self.forge)
		-- end
	
		-- self.checkitemstask = 1
		
		-- self.onitemlosefn = function(inst, data) self:OnItemLose(doer, name) end
		-- self.inst:ListenForEvent("itemlose", self.onitemlosefn, self.forge)

		-- self.onitemgetfn = function(inst, data) self:OnItemGet(doer, name) end
		-- self.inst:ListenForEvent("itemget", self.onitemgetfn, self.forge)
		
		-- self.inst:DoTaskInTime(delay_anim, function() self.isBusy = false end)
		
		-- return false
	-- end
	
	-- if container:GetItemInSlot(11) ~= nil then
		-- return false
	-- end
	
	-- local itemCoatingCap = TableContainsKey(FORGE_WEAPONS_UPGRADE_CAPACITIES, itemInSlot.prefab) and FORGE_WEAPONS_UPGRADE_CAPACITIES[itemInSlot.prefab][1] or 1
	-- local itemSocketCap = TableContainsKey(FORGE_WEAPONS_UPGRADE_CAPACITIES, itemInSlot.prefab) and FORGE_WEAPONS_UPGRADE_CAPACITIES[itemInSlot.prefab][2] or 0
	
	-- if itemInSlot:HasTag("upgraded_sockets_"..itemSocketCap) and itemInSlot:HasTag("upgraded_coatings_"..itemCoatingCap) then
		-- self.isBusy = true
		
		-- GiveBackItemsToDoer(self, doer, 2, 11)
		
		-- KillAllSideButtons(self, true)
		
		-- delay_anim = 0
		
		-- if self.categoryListIsOpen then
			-- print("Category List was open... Closing it...")
			-- self.categoryListIsOpen = false
			-- self.bganim:GetAnimState():PlayAnimation("forge_close_list", false)
			-- delay_anim = delay_anim + self.bganim:GetAnimState():GetCurrentAnimationLength()
		-- end
		
		-- self.buttons["general"]["forge"]:Disable()
		
		-- ActivateForgeContainerSlots(self, 1, 1)
	
		-- self.bganim:GetAnimState():PushAnimation("forge_init", false)
		
		-- if self.checkitemstask ~= nil then
			-- self.inst:RemoveEventCallback("itemlose", self.onitemlosefn, self.forge)	
			-- self.inst:RemoveEventCallback("itemget", self.onitemgetfn, self.forge)
		-- end
	
		-- self.checkitemstask = 1
		
		-- self.onitemlosefn = function(inst, data) self:OnItemLose(doer, name) end
		-- self.inst:ListenForEvent("itemlose", self.onitemlosefn, self.forge)

		-- self.onitemgetfn = function(inst, data) self:OnItemGet(doer, name) end
		-- self.inst:ListenForEvent("itemget", self.onitemgetfn, self.forge)
		
		-- self.inst:DoTaskInTime(delay_anim, function() 
												-- self.isBusy = false 
											-- end
		-- )
		
		-- return false
	-- end
	
	-- if itemInSlot ~= nil and not self.categoryListIsOpen then
		-- -- if not TableContainsKey(FORGE_ITEM_LIST["UPGRADE"][1], itemInSlot.prefab) then
			-- -- return false
		-- -- end
	
		-- self.isBusy = true
		
		-- local COMMONUPGRADELIST = {}
		-- for n = 1, #FORGE_ITEM_LIST.UPGRADE.common, 1 do
			-- if 	(SplitString(FORGE_ITEM_LIST.UPGRADE.common[n]["UPGRD"], '_')[2] == "sockets" and not itemInSlot:HasTag("upgraded_sockets_"..itemSocketCap)) or
				-- (SplitString(FORGE_ITEM_LIST.UPGRADE.common[n]["UPGRD"], '_')[2] == "coatings" and not itemInSlot:HasTag("upgraded_coatings_"..itemCoatingCap))
				-- then
					-- table.insert(COMMONUPGRADELIST, FORGE_ITEM_LIST.UPGRADE.common[n])
			-- end
		-- end
	
		-- local SPECUPGRADELIST = TableContainsKey(FORGE_ITEM_LIST.UPGRADE, itemInSlot.prefab) and FORGE_ITEM_LIST.UPGRADE[itemInSlot.prefab] or {}
	
		-- self.buttons["upgrade"] = {}
	
		-- local delay_anim = 0
	
		-- self.bganim:GetAnimState():PlayAnimation("forge_open_list", false)
		
		-- delay_anim = delay_anim + self.bganim:GetAnimState():GetCurrentAnimationLength()
		
		-- self.categoryListIsOpen = true
		-- self.inst:DoTaskInTime(delay_anim, 
								-- function()
									-- local offy = 118
									
									-- local maxSpecSize = math.min(4, #SPECUPGRADELIST)
									
									-- for n = 1, maxSpecSize, 1 do										
										-- local buttonscalex = 0.65
										-- local buttonscaley = 0.65
										-- -- offy = offy + nbr_return_to_line*25
										-- self:AddSpecialButton(self.forge, doer, "upgrade", SPECUPGRADELIST[n].UPGRD, 
																-- "images/buttons/forgebuttons.xml", "listbutton",
																-- FORGE_BUTTONS.GOUPLIST.x, FORGE_BUTTONS.GOUPLIST.y-offy, FORGE_BUTTONS.GOUPLIST.z, buttonscalex, buttonscaley, 1, 
																-- SPECUPGRADELIST[n][1], 45, 0, 0, 0, 1, onclickTabItem, true)
										-- offy = offy + 118
									-- end
									
									-- local maxCommonSize = math.min((5 - maxSpecSize), #COMMONUPGRADELIST)
									
									-- for n = 1, maxCommonSize do										
										-- local buttonscalex = 0.65
										-- local buttonscaley = 0.65
										-- -- offy = offy + nbr_return_to_line*25
										-- self:AddSpecialButton(self.forge, doer, "upgrade", COMMONUPGRADELIST[n].UPGRD, 
																-- "images/buttons/forgebuttons.xml", "listbutton",
																-- FORGE_BUTTONS.GOUPLIST.x, FORGE_BUTTONS.GOUPLIST.y-offy, FORGE_BUTTONS.GOUPLIST.z, buttonscalex, buttonscaley, 1, 
																-- COMMONUPGRADELIST[n][1], 45, 0, 0, 0, 1, onclickTabItem, true)
										-- offy = offy + 118
									-- end
									
									-- local listButtScale = 0.7
									
									-- self:AddSpecialButton(self.forge, doer, "upgrade", "gouplist", 
															-- "images/buttons/forgebuttons.xml", "listup",
															-- FORGE_BUTTONS.GOUPLIST.x, FORGE_BUTTONS.GOUPLIST.y, FORGE_BUTTONS.GOUPLIST.z, listButtScale, listButtScale, listButtScale, 
															-- "", 45, 0, 0, 0, 1, onclickScrollList, true)		

									-- self:AddSpecialButton(self.forge, doer, "upgrade", "godownlist", 
															-- "images/buttons/forgebuttons.xml", "listdown",
															-- FORGE_BUTTONS.GODOWNLIST.x, FORGE_BUTTONS.GODOWNLIST.y, FORGE_BUTTONS.GODOWNLIST.z, listButtScale, listButtScale, listButtScale, 
															-- "", 45, 0, 0, 0, 1, onclickScrollList, true)		

									-- self.buttons["upgrade"]["gouplist"]:Disable()
									-- self.buttons["upgrade"].currentCategoryGroup = 1
									-- self.buttons["upgrade"].currentListGroup = 1
									-- if #SPECUPGRADELIST + #COMMONUPGRADELIST <= 5 then
										-- self.buttons["upgrade"]["godownlist"]:Disable()
									-- end
									
									-- self.isBusy = false
								-- end
		-- )
		
		-- return false
	-- else	
		-- local itemToUpgrade = itemInSlot
		
		-- local lastClickedEntryPattern = SplitString(self.buttons["general"]["forge"].item, '_')
		
		-- local upType = lastClickedEntryPattern[1] == "common" and "common" or itemToUpgrade.prefab
		
		-- local REQ_ITEMS_LIST = FORGE_ITEM_LIST.UPGRADE[upType]
		
		-- local matchingKey = GetKeyFromValue(REQ_ITEMS_LIST, self.buttons["general"]["forge"].item, "UPGRD")
		
		-- REQ_ITEMS_LIST = FORGE_ITEM_LIST.UPGRADE[upType][matchingKey]
		
		-- if REQ_ITEMS_LIST == nil then		
			-- self.isBusy = true
			
			-- GiveBackItemsToDoer(self, doer, 2, 11)
			
			-- KillAllSideButtons(self, true)
			
			-- delay_anim = 0
			
			-- if self.categoryListIsOpen then
				-- print("Category List was open... Closing it...")
				-- self.categoryListIsOpen = false
				-- self.bganim:GetAnimState():PlayAnimation("forge_close_list", false)
				-- delay_anim = delay_anim + self.bganim:GetAnimState():GetCurrentAnimationLength()
			-- end
			
			-- self.buttons["general"]["forge"]:Disable()
			
			-- ActivateForgeContainerSlots(self, 1, 1)
		
			-- self.bganim:GetAnimState():PushAnimation("forge_init", false)
			
			-- if self.checkitemstask ~= nil then
				-- self.inst:RemoveEventCallback("itemlose", self.onitemlosefn, self.forge)	
				-- self.inst:RemoveEventCallback("itemget", self.onitemgetfn, self.forge)
			-- end
		
			-- self.checkitemstask = 1
			
			-- self.onitemlosefn = function(inst, data) self:OnItemLose(doer, name) end
			-- self.inst:ListenForEvent("itemlose", self.onitemlosefn, self.forge)

			-- self.onitemgetfn = function(inst, data) self:OnItemGet(doer, name) end
			-- self.inst:ListenForEvent("itemget", self.onitemgetfn, self.forge)
			
			-- self.inst:DoTaskInTime(delay_anim, function() 
													-- self.isBusy = false 
													-- DoUpgradeButtonCheckFunc(self, doer, groupname, name)
												-- end
			-- )
			
			-- return false
		-- end
		
		-- print("Item to upgrade -> ", itemToUpgrade)
		
		-- for i, v in ipairs(REQ_ITEMS_LIST) do
			-- if i > 1 and i < #REQ_ITEMS_LIST then
				-- local hasitem, numfound = container:Has(REQ_ITEMS_LIST[i][1], REQ_ITEMS_LIST[i][2])
				-- if not hasitem then
					-- print("item missing : ", REQ_ITEMS_LIST[i][1], " (found ", numfound," need ", REQ_ITEMS_LIST[i][2],")")
					-- return false
				-- end
			-- end
		-- end	
		
		-- return true
	-- end
-- end

-- local function DoCraftButtonCheckFunc(self, doer, groupname, name)
	-- print("I perform the check for the Craft Button")
	-- print("data = ")
	-- print("doer = ", doer, " / groupname = ", groupname, " / name = ", name)	
	-- local container = self.forge.replica and self.forge.replica.container

	-- if not container then
		-- return false
	-- end
	
	-- if container:GetItemInSlot(11) ~= nil then
		-- return false
	-- end
	
	-- if self.isBusy then
		-- return false
	-- end
	
	-- -- local itemtocraft = string.lower(string.gsub(name, "%s", ""))
	-- local itemtocraft = name
	
	-- local itemCategory = SplitString(name, '_')
	
	-- if not TableContainsKey(FORGE_ITEM_LIST.CRAFT, itemCategory[1]) or not TableContainsKey(FORGE_ITEM_LIST.CRAFT[itemCategory[1]], itemtocraft) then
		-- return false
	-- end
	
	-- print("Item Category = ", itemCategory[1])
	-- print("Category Group = ", self.buttons[groupname].currentCategoryGroup)	
	-- print("List Group = ", self.buttons[groupname].currentListGroup and (self.buttons[groupname].currentListGroup + 1))
	
	-- local REQ_ITEMS_LIST = FORGE_ITEM_LIST.CRAFT[itemCategory[1]][itemtocraft]
	
	-- for i, v in ipairs(REQ_ITEMS_LIST) do
		-- if i > 1 then
			-- local hasitem, numfound = container:Has(REQ_ITEMS_LIST[i][1], REQ_ITEMS_LIST[i][2])
			-- if not hasitem then
				-- print("item missing : ", REQ_ITEMS_LIST[i][1], " (found ", numfound," need ", REQ_ITEMS_LIST[i][2],")")
				-- return false
			-- end
		-- end
	-- end
	
	-- return true
-- end

-- function ForgeWidget:RefreshButton(doer, name, killIngrListOnly)
	-- print("I Refresh The Buttons")
	-- print("data = ")
	-- print("doer = ", doer, " / name = ", name)	
	-- local container = (self.forge.replica and self.forge.replica.container) or (self.forge.components and self.forge.components.container)
	
    -- if self.isopen then
        -- local widget = self.forge.replica.container:GetWidget()
        -- if widget ~= nil and self.buttons["general"] then
			-- if self.currentMode == "repair" then
				-- if killIngrListOnly and container and container:GetItemInSlot(1) == nil then
					-- KillAllText(self)
					-- GiveBackItemsToDoer(self, doer, 2, 11)
					-- self.buttons["general"]["forge"]:Disable()
				-- elseif DoRepairButtonCheckFunc(self, doer, self.currentMode) then
					-- self.buttons["general"]["forge"]:Enable()
				-- else
					-- self.buttons["general"]["forge"]:Disable()
				-- end
			-- elseif self.currentMode == "upgrade" then
				-- if DoUpgradeButtonCheckFunc(self, doer, self.currentMode, name) then
					-- self.buttons["general"]["forge"]:Enable()
				-- else
					-- self.buttons["general"]["forge"]:Disable()
				-- end			
			-- elseif self.currentMode == "craft" and doer and self.currentMode and name then
				-- if DoCraftButtonCheckFunc(self, doer, self.currentMode, name) then
					-- self.buttons["general"]["forge"]:Enable()
				-- else
					-- self.buttons["general"]["forge"]:Disable()
				-- end			
			-- end
        -- end
    -- end
-- end

-- function ForgeWidget:OnItemGet(doer, groupname, name)
	-- print("I triggered the OnItemGet for ", self.forge)
	-- print("data =")
	-- print("doer = ", doer, " / groupname = ", groupname, " / name = ", name)

	-- local container = (self.forge.replica and self.forge.replica.container) or (self.forge.components and self.forge.components.container)
	
    -- if self.buttons ~= nil and self.forge ~= nil and doer == ThePlayer then
        -- self.inst:DoTaskInTime(0.2, function() self:RefreshButton(doer, name, false) end)
    -- end
-- end

-- function ForgeWidget:OnItemLose(doer, groupname, name)
	-- print("I triggered the OnItemLose for ", self.forge)
	-- print("data =")
	-- print("doer = ", doer, " / groupname = ", groupname, " / name = ", name)

	-- local container = (self.forge.replica and self.forge.replica.container) or (self.forge.components and self.forge.components.container)
	
	-- if self.currentMode == "repair" and container and container:GetItemInSlot(1) == nil then		
		-- ActivateForgeContainerSlots(self, 1, 1)
	-- end
	
	-- if self.currentMode == "upgrade"  and container:GetItemInSlot(1) == nil then
		-- self.inst:DoTaskInTime(0, function()
										-- if self.currentMode == "upgrade" then
											-- self.isBusy = true
											
											-- GiveBackItemsToDoer(self, doer, 2, 11)
											
											-- ActivateForgeContainerSlots(self, 0, 0)
											
											-- KillAllSideButtons(self, true)
											
											-- self.bganim:GetAnimState():GetCurrentAnimationLength()
											-- delay_anim = self.bganim:GetAnimState():GetCurrentAnimationLength()
											
											-- self.inst:DoTaskInTime(delay_anim, function()
																					-- KillAllSideButtons(self, true)
																																
																					-- if self.categoryListIsOpen then
																						-- print("Category List was open... Closing it...")
																						-- self.categoryListIsOpen = false
																						-- self.bganim:GetAnimState():PlayAnimation("forge_close_list", false)
																						-- delay_anim = self.bganim:GetAnimState():GetCurrentAnimationLength()
																					-- end
																					
																					-- self.buttons["general"]["forge"]:Disable()																			
																				
																					-- self.bganim:GetAnimState():PushAnimation("forge_init", false)
																					
																					-- if self.checkitemstask ~= nil then
																						-- self.inst:RemoveEventCallback("itemlose", self.onitemlosefn, self.forge)	
																						-- self.inst:RemoveEventCallback("itemget", self.onitemgetfn, self.forge)
																					-- end
																				
																					-- self.checkitemstask = 1
																					
																					-- self.onitemlosefn = function(inst, data) self:OnItemLose(doer, name) end
																					-- self.inst:ListenForEvent("itemlose", self.onitemlosefn, self.forge)

																					-- self.onitemgetfn = function(inst, data) self:OnItemGet(doer, name) end
																					-- self.inst:ListenForEvent("itemget", self.onitemgetfn, self.forge)
																					
																					-- self.inst:DoTaskInTime(delay_anim, function() 
																															-- self.isBusy = false 
																															-- ActivateForgeContainerSlots(self, 1, 1)
																															-- DoUpgradeButtonCheckFunc(self, doer, groupname, name)
																														-- end
																					-- )
																				-- end
											-- )
										-- end
									-- end
		-- )
	-- end
	
    -- if self.buttons ~= nil and self.forge ~= nil and doer == ThePlayer and not self.currentMode == "upgrade" then
        -- self.inst:DoTaskInTime(0, function() self:RefreshButton(doer, name, true) end)
    -- end
-- end

-- local function onclickClose(self, doer, groupname, name)
	-- GiveBackItemsToDoer(self, doer, 1, 11)
	-- self:Close(self.forge)
-- end

-- local function onclickDoButton(self, doer, groupname)
	-- local container = self.forge.components and self.forge.components.container

	-- if container == nil then
		-- return
	-- end
	
-- ---------------------------------DO REPAIR---------------------------------------------------
	-- if self.currentMode == "repair" then
		-- print("I started the REPAIR precess ", self.forge)
		-- print("data =")
		-- print("doer = ", doer, " / groupname = ", groupname, " / mode = ", self.currentMode)
		
		-- local REQ_ITEMS_LIST = self.repairReqList
	
		-- self:Close(self.forge)
		
		-- local iteminweapslot = container and container:RemoveItemBySlot(1)
		
		-- if iteminweapslot then				
			-- self.forge:AddTag("processing_forge_task")
			-- self.forge:DoTaskInTime(5, function()
											-- if iteminweapslot.components and iteminweapslot.components.finiteuses then
												-- iteminweapslot.components.finiteuses:SetUses(iteminweapslot.components.finiteuses.total)
												-- RemoveNeedsRepairingTag(iteminweapslot)
												-- container.itemtestfn = function() return true end
												-- print("Container Should Accept Item : ", iteminweapslot ~= nil, " & ", iteminweapslot.components.inventoryitem ~= nil, " & ", container.itemtestfn(container, iteminweapslot, 11))
												-- print(container:CanTakeItemInSlot(iteminweapslot, 11))
												-- print(container:GiveItem(iteminweapslot, 11))
												-- container.itemtestfn = self.forge.itemtestfn
											-- end
											
											-- for i, v in ipairs(REQ_ITEMS_LIST) do
												-- container:ConsumeByName(REQ_ITEMS_LIST[i][1], REQ_ITEMS_LIST[i][2])
											-- end
											
											-- for n = 1, 10, 1 do
												-- container:DropItemBySlot(n)
											-- end
											
											-- if self.forge:HasTag("processing_forge_task") then
												-- self.forge:RemoveTag("processing_forge_task")
											-- end
										-- end
			-- )
		-- end
-- ---------------------------------DO UPGRADE---------------------------------------------------		
	-- elseif self.currentMode == "upgrade" then
		-- print("I started the UPGRADE precess ", self.forge)
		-- print("data =")
		-- print("doer = ", doer, " / groupname = ", groupname, " / mode = ", self.currentMode, " / item = ", self.buttons["general"]["forge"].item )
		
		-- local itemToUpgrade = container:GetItemInSlot(1)
		-- local upgradeName = self.buttons["general"]["forge"].item
		
		-- if itemToUpgrade == nil then
			-- return
		-- end
		
		-- local upType = SplitString(upgradeName, '_')[1] == "common" and "common" or upgradeName
		
		-- local matchingKey = GetKeyFromValue(FORGE_ITEM_LIST.UPGRADE[upType], upgradeName, "UPGRD")
		
		-- local REQ_ITEMS_LIST = FORGE_ITEM_LIST.UPGRADE[upType][matchingKey]
		
		-- self.forge:AddTag("processing_forge_task")
		-- self.forge:DoTaskInTime(5, function()										
									-- for i, v in ipairs(REQ_ITEMS_LIST) do
										-- if i > 1 and i < #REQ_ITEMS_LIST then
											-- container:ConsumeByName(REQ_ITEMS_LIST[i][1], REQ_ITEMS_LIST[i][2])
										-- end
									-- end								
									
									-- if REQ_ITEMS_LIST[#REQ_ITEMS_LIST][1] ~= "none" then
										-- upType = SplitString(upgradeName, '_')[2]
										
										-- if itemToUpgrade:HasTag("upgraded_"..upType.."_"..#itemToUpgrade.upgrademodtags[upType]) then
											-- itemToUpgrade:RemoveTag("upgraded_"..upType.."_"..#itemToUpgrade.upgrademodtags[upType])
										-- end
										
										-- table.insert(itemToUpgrade.upgrademodtags[upType], REQ_ITEMS_LIST[#REQ_ITEMS_LIST][1])
										-- itemToUpgrade:AddTag("upgraded_"..upType.."_"..#itemToUpgrade.upgrademodtags[upType])
										
										-- REQ_ITEMS_LIST[#REQ_ITEMS_LIST][2](itemToUpgrade)
																				
										-- local item = container:RemoveItemBySlot(1)
										
										-- if item ~= nil then
											-- item.Transform:SetPosition(container.inst.Transform:GetWorldPosition())
											-- if item.components.inventoryitem ~= nil then
												-- item.components.inventoryitem:OnDropped(true)
											-- end
											-- item.prevcontainer = nil
											-- item.prevslot = nil
											-- container.inst:PushEvent("dropitem", { item = item })
										
											-- container.itemtestfn = function() return true end
											-- container:GiveItem(item, 11)
											-- container.itemtestfn = self.forge.itemtestfn
										-- end	
									-- else
										-- itemToUpgrade:Remove()
										
										-- local upgradedItem = SpawnPrefab(REQ_ITEMS_LIST.RESULT)
										
										-- container.itemtestfn = function() return true end
										-- container:GiveItem(upgradedItem, 11)
										-- container.itemtestfn = self.forge.itemtestfn
									-- end
									
									-- for n = 2, 10, 1 do
										-- container:DropItemBySlot(n)
									-- end
									
									-- if self.forge:HasTag("processing_forge_task") then
										-- self.forge:RemoveTag("processing_forge_task")
									-- end
								-- end
		-- )	
		-- self:Close(self.forge)
				
-- ---------------------------------DO CRAFT---------------------------------------------------		
	-- elseif self.currentMode == "craft" then
		-- print("I started the CRAFT process ", self.forge)
		-- print("data =")
		-- print("doer = ", doer, " / groupname = ", groupname, " / mode = ", self.currentMode, " / item = ", self.buttons["general"]["forge"].item )
		
		-- local itemToCraft = self.buttons["general"]["forge"].item
		-- local itemtocraftkey = SplitString(itemToCraft, '_')[1]
		-- if itemtocraftkey then
			
			-- local REQ_ITEMS_LIST = FORGE_ITEM_LIST.CRAFT[itemtocraftkey][itemToCraft]
			
			-- self.forge:AddTag("processing_forge_task")
			-- self.forge:DoTaskInTime(5, function()
											-- container.itemtestfn = function() return true end
											-- container:GiveItem(SpawnPrefab(itemToCraft), 11)
											-- container.itemtestfn = self.forge.itemtestfn
																						
											-- for i, v in ipairs(REQ_ITEMS_LIST) do
												-- if i > 1 then
													-- container:ConsumeByName(REQ_ITEMS_LIST[i][1], REQ_ITEMS_LIST[i][2])
												-- end
											-- end
											
											-- for n = 1, 10, 1 do
												-- container:DropItemBySlot(n)
											-- end
											
											-- if self.forge:HasTag("processing_forge_task") then
												-- self.forge:RemoveTag("processing_forge_task")
											-- end
										-- end
			-- )
		-- end
		-- self:Close(self.forge)
	-- end
-- end

-- local function onclickCategoryItem(self, doer, groupname, name)
	-- self.isBusy = true

	-- print("I clicked on the category ", name, " from the group ", groupname, " (Operated Forge = ", self.forge, ")")
	
	-- KillAllSideButtons(self, false)
	
	-- local ITEMLIST = FORGE_ITEM_LIST[string.upper(groupname)][name]
	
	-- self.buttons[name] = {}

	-- self.bganim:GetAnimState():PlayAnimation("forge_close_list", false)
	-- delay_anim = self.bganim:GetAnimState():GetCurrentAnimationLength()
	
	-- self.inst:DoTaskInTime(delay_anim, function()
											-- self.bganim:GetAnimState():PlayAnimation("forge_open_list", false)
											-- delay_anim = self.bganim:GetAnimState():GetCurrentAnimationLength()
											-- self.inst:DoTaskInTime(delay_anim, 
																	-- function()
																		-- local offy = 118
																		
																		-- local sortedKeysList = GetSortedKeysList(ITEMLIST, { "name" })
																		
																		-- local maxItemListSize = math.min(5, #sortedKeysList)
																		
																		-- for n = 1, maxItemListSize, 1 do
																			-- local buttonscalex = 0.65
																			-- local buttonscaley = 0.65

																			-- self:AddSpecialButton(self.forge, doer, groupname, sortedKeysList[n], 
																									-- "images/buttons/forgebuttons.xml", "listbutton",
																									-- FORGE_BUTTONS.GOUPLIST.x, FORGE_BUTTONS.GOUPLIST.y-offy, FORGE_BUTTONS.GOUPLIST.z, buttonscalex, buttonscaley, 1, 
																									-- ITEMLIST[sortedKeysList[n]][1], 45, 0, 0, 0, 1, onclickTabItem, true)
																			-- offy = offy + 118
																		-- end
																		
																		-- local listButtScale = 0.7
																		
																		-- self:AddSpecialButton(self.forge, doer, groupname, "gouplist", 
																								-- "images/buttons/forgebuttons.xml", "listup",
																								-- FORGE_BUTTONS.GOUPLIST.x, FORGE_BUTTONS.GOUPLIST.y, FORGE_BUTTONS.GOUPLIST.z, listButtScale, listButtScale, listButtScale, 
																								-- "", 45, 0, 0, 0, 1, onclickScrollList, true)		

																		-- self:AddSpecialButton(self.forge, doer, groupname, "godownlist", 
																								-- "images/buttons/forgebuttons.xml", "listdown",
																								-- FORGE_BUTTONS.GODOWNLIST.x, FORGE_BUTTONS.GODOWNLIST.y, FORGE_BUTTONS.GODOWNLIST.z, listButtScale, listButtScale, listButtScale, 
																								-- "", 45, 0, 0, 0, 1, onclickScrollList, true)		

																		-- self.buttons[groupname]["gouplist"]:Disable()
																		-- self.buttons[groupname].currentListGroup = 1
																		-- if #sortedKeysList <= 5 then
																			-- self.buttons[groupname]["godownlist"]:Disable()
																		-- end
																		
																		-- self.buttons[groupname]["gouplist"].currentCategory = name
																		-- self.buttons[groupname]["godownlist"].currentCategory = name
																		
																		-- self.isBusy = false
																	-- end
											-- )
										-- end
	-- )
-- end

-- local function onclickScrollCategory(self, doer, groupname, name)
	-- self.isBusy = true

	-- KillAllSideButtons(self, false)
	
	-- if self.checkitemstask ~= nil then
		-- self.inst:RemoveEventCallback("itemlose", self.onitemlosefn, self.forge)	
		-- self.inst:RemoveEventCallback("itemget", self.onitemgetfn, self.forge)
	-- end
	
	-- self.buttons["general"]["forge"]:Disable()
	
	-- if name == "gouplist" then
		-- self.buttons[groupname].currentCategoryGroup = self.buttons[groupname].currentCategoryGroup - 1 
	-- elseif name == "godownlist" then
		-- self.buttons[groupname].currentCategoryGroup = self.buttons[groupname].currentCategoryGroup + 1
	-- end

	-- local ITEMLIST = FORGE_ITEM_LIST[string.upper(groupname)]
	
	-- local offy = 118
	
	-- local sortedKeysList = GetSortedKeysList(ITEMLIST)
	
	-- local firstEntryToDisplay = 1 + (self.buttons[groupname].currentCategoryGroup - 1) * 5
	-- local lastEntryToDisplay = math.min(firstEntryToDisplay+4, #sortedKeysList)
	
	-- print("currentCategoryGroup = ", self.buttons[groupname].currentCategoryGroup, " / firstEntryToDisplay = ", firstEntryToDisplay)
	
	-- for n = firstEntryToDisplay, lastEntryToDisplay, 1 do
		-- local buttonscalex = 0.65
		-- local buttonscaley = 0.65

		-- self:AddSpecialButton(self.forge, doer, groupname, sortedKeysList[n], 
								-- "images/buttons/forgebuttons.xml", "listbutton",
								-- FORGE_BUTTONS.GOUPLIST.x, FORGE_BUTTONS.GOUPLIST.y-offy, FORGE_BUTTONS.GOUPLIST.z, buttonscalex, buttonscaley, 1, 
								-- ITEMLIST[sortedKeysList[n]].name, 45, 0, 0, 0, 1, onclickCategoryItem, true)
		-- offy = offy + 118
	-- end
	
	-- local listButtScale = 0.7
	
	-- self:AddSpecialButton(self.forge, doer, groupname, "gouplist", 
							-- "images/buttons/forgebuttons.xml", "listup",
							-- FORGE_BUTTONS.GOUPLIST.x, FORGE_BUTTONS.GOUPLIST.y, FORGE_BUTTONS.GOUPLIST.z, listButtScale, listButtScale, listButtScale, 
							-- "", 45, 0, 0, 0, 1, onclickScrollCategory, true)		

	-- self:AddSpecialButton(self.forge, doer, groupname, "godownlist", 
							-- "images/buttons/forgebuttons.xml", "listdown",
							-- FORGE_BUTTONS.GODOWNLIST.x, FORGE_BUTTONS.GODOWNLIST.y, FORGE_BUTTONS.GODOWNLIST.z, listButtScale, listButtScale, listButtScale, 
							-- "", 45, 0, 0, 0, 1, onclickScrollCategory, true)		
	
	-- if self.buttons[groupname].currentCategoryGroup == 1 then
		-- self.buttons[groupname]["gouplist"]:Disable()
	-- else
		-- self.buttons[groupname]["gouplist"]:Enable()
	-- end
	
	-- if self.buttons[groupname].currentCategoryGroup == math.ceil(#sortedKeysList/5) then
		-- self.buttons[groupname]["godownlist"]:Disable()	
	-- else
		-- self.buttons[groupname]["godownlist"]:Enable()
	-- end
	
	-- self.isBusy = false
-- end

-- local function onclickTab(self, doer, groupname, name)
	-- self.isBusy = true
	
	-- local container = self.forge.replica and self.forge.components.rerplica
	
	-- GiveBackItemsToDoer(self, doer, 1, 11)
	
	-- KillAllSideButtons(self, true)
	
	-- self.currentMode = name
	
	-- local ITEMLIST = FORGE_ITEM_LIST[string.upper(name)]
	
	-- self.buttons[name] = {}
	
	-- delay_anim = 0
	
	-- if self.categoryListIsOpen then
		-- print("Category List was open... Closing it...")
		-- self.categoryListIsOpen = false
		-- self.bganim:GetAnimState():PlayAnimation("forge_close_list", false)
		-- delay_anim = delay_anim + self.bganim:GetAnimState():GetCurrentAnimationLength()
	-- end
	
	-- if name == "craft" then
		-- ActivateForgeContainerSlots(self, 0, 0)
	
		-- self.inst:DoTaskInTime(	delay_anim, 
								-- function()
									-- self.bganim:GetAnimState():PlayAnimation("forge_open_list", false)
									-- delay_anim = self.bganim:GetAnimState():GetCurrentAnimationLength()
									-- self.categoryListIsOpen = true
									-- self.inst:DoTaskInTime(delay_anim, 
															-- function()
																-- local offy = 118
																
																-- local sortedKeysList = GetSortedKeysList(ITEMLIST)
																
																-- local maxCatListSize = math.min(5, #sortedKeysList)
																
																-- for n = 1, maxCatListSize, 1 do										
																	-- local buttonscalex = 0.65
																	-- local buttonscaley = 0.65

																	-- self:AddSpecialButton(self.forge, doer, name, sortedKeysList[n], 
																							-- "images/buttons/forgebuttons.xml", "listbutton",
																							-- FORGE_BUTTONS.GOUPLIST.x, FORGE_BUTTONS.GOUPLIST.y-offy, FORGE_BUTTONS.GOUPLIST.z, buttonscalex, buttonscaley, 1, 
																							-- ITEMLIST[sortedKeysList[n]].name, 45, 0, 0, 0, 1, onclickCategoryItem, true)
																	-- offy = offy + 118
																-- end
																
																-- local listButtScale = 0.7
																
																-- self:AddSpecialButton(self.forge, doer, name, "gouplist", 
																						-- "images/buttons/forgebuttons.xml", "listup",
																						-- FORGE_BUTTONS.GOUPLIST.x, FORGE_BUTTONS.GOUPLIST.y, FORGE_BUTTONS.GOUPLIST.z, listButtScale, listButtScale, listButtScale, 
																						-- "", 45, 0, 0, 0, 1, onclickScrollCategory, true)		

																-- self:AddSpecialButton(self.forge, doer, name, "godownlist", 
																						-- "images/buttons/forgebuttons.xml", "listdown",
																						-- FORGE_BUTTONS.GODOWNLIST.x, FORGE_BUTTONS.GODOWNLIST.y, FORGE_BUTTONS.GODOWNLIST.z, listButtScale, listButtScale, listButtScale, 
																						-- "", 45, 0, 0, 0, 1, onclickScrollCategory, true)		

																-- self.buttons[name]["gouplist"]:Disable()
																-- self.buttons[name].currentCategoryGroup = 1
																-- if #sortedKeysList <= 5 then
																	-- self.buttons[name]["godownlist"]:Disable()
																-- end
																
																-- self.isBusy = false
															-- end
									-- )
								-- end
		-- )
	-- else
		-- self.buttons["general"]["forge"]:Disable()
		
		-- ActivateForgeContainerSlots(self, 1, 1)
	
		-- self.bganim:GetAnimState():PushAnimation("forge_init", false)

		-- if self.checkitemstask ~= nil then
			-- self.inst:RemoveEventCallback("itemlose", self.onitemlosefn, self.forge)	
			-- self.inst:RemoveEventCallback("itemget", self.onitemgetfn, self.forge)
		-- end
	
		-- self.checkitemstask = 1
		
		-- self.onitemlosefn = function(inst, data) self:OnItemLose(doer, name) end
		-- self.inst:ListenForEvent("itemlose", self.onitemlosefn, self.forge)

		-- self.onitemgetfn = function(inst, data) self:OnItemGet(doer, name) end
		-- self.inst:ListenForEvent("itemget", self.onitemgetfn, self.forge)
		
		-- if doer == ThePlayer then
			-- self:RefreshButton(doer, name)
		-- end
		
		-- self.inst:DoTaskInTime(delay_anim, function() self.isBusy = false end)
	-- end
-- end

-- function ForgeWidget:Open(forge, doer)
	-- print("************** I entered the Open function of my ForgeWidget")
	
    -- self.bganim:GetAnimState():SetBank("ui_vnzforgepanel")
    -- self.bganim:GetAnimState():SetBuild("ui_vnzforgepanel")
	
	-- self.forge = forge
	
    -- self.isopen = true
    -- self:Show()
	
	-- local actionsButtonsScale = 0.65
	
	-- self:AddSpecialButton(	forge, doer, "general", "repair", 
							-- "images/buttons/forgebuttons.xml", "repair",
							-- FORGE_BUTTONS.REPAIR.x, FORGE_BUTTONS.REPAIR.y, FORGE_BUTTONS.REPAIR.z, actionsButtonsScale, actionsButtonsScale, actionsButtonsScale, 
							-- "", 45, 0, 0, 0, 1, onclickTab, true, false, "Repair")
							
	-- self:AddSpecialButton(	forge, doer, "general", "upgrade", 
							-- "images/buttons/forgebuttons.xml", "upgrade",
							-- FORGE_BUTTONS.UPGRADE.x, FORGE_BUTTONS.UPGRADE.y, FORGE_BUTTONS.UPGRADE.z, actionsButtonsScale, actionsButtonsScale, actionsButtonsScale, 
							-- "", 45, 0, 0, 0, 1, onclickTab, true, false, "Upgrade")
							
	-- self:AddSpecialButton(	forge, doer, "general", "craft", 
							-- "images/buttons/forgebuttons.xml", "craft",
							-- FORGE_BUTTONS.CRAFT.x, FORGE_BUTTONS.CRAFT.y, FORGE_BUTTONS.CRAFT.z, actionsButtonsScale, actionsButtonsScale, actionsButtonsScale, 
							-- "", 45, 0, 0, 0, 1, onclickTab, true, false, "Craft")
							
	-- self:AddSpecialButton(	forge, doer, "general", "close", 
							-- "images/buttons/forgebuttons.xml", "close",
							-- FORGE_BUTTONS.CLOSE.x, FORGE_BUTTONS.CLOSE.y, FORGE_BUTTONS.CLOSE.z, actionsButtonsScale, actionsButtonsScale, actionsButtonsScale, 
							-- "", 45, 0, 0, 0, 1, onclickClose, nil, true, "Close")
		
	-- local doActionButtonScale = 0.65

	-- self.isBusy = true
	
	-- doer:DoTaskInTime(0.1, function()
								-- print("doer = ", doer, " ( == ThePlayer ? ", doer == ThePlayer, ") HUD.controls.containers ? ", doer.HUD.controls.containers, " / this container ? ", doer.HUD.controls.containers[forge])
								-- for k, v in pairs(doer.HUD.controls.containers) do
									-- print(k, " / ", v)
									-- if k.prefab == "vnzforge" then
										-- self.CwidgetRef = v
										-- break
									-- end
								-- end
								
								-- if self.CwidgetRef then
									-- print("Adding the DO button to the container widget itself")
									-- AddSpecialButtonToWidget(	self.CwidgetRef, self.forge, doer, "general", "forge", 
																-- "images/buttons/forgebuttons.xml", "forge",
																-- FORGE_BUTTONS.DOBUTTONS.x, FORGE_BUTTONS.DOBUTTONS.y, FORGE_BUTTONS.DOBUTTONS.z, doActionButtonScale, doActionButtonScale, doActionButtonScale, 
																-- "", 45, 0, 0, 0, 1, onclickDoButton, nil, true)
																
									-- self.buttons["general"]["forge"] = self.CwidgetRef.buttons["general"]["forge"]
								-- else
									-- self:AddSpecialButton(	self.forge, doer, "general", "forge", 
															-- "images/buttons/forgebuttons.xml", "forge",
															-- FORGE_BUTTONS.DOBUTTONS.x, FORGE_BUTTONS.DOBUTTONS.y, FORGE_BUTTONS.DOBUTTONS.z, doActionButtonScale, doActionButtonScale, doActionButtonScale, 
															-- "", 45, 0, 0, 0, 1, onclickDoButton, nil, true)
								-- end
								
								-- self.buttons["general"]["forge"]:Disable()
								
								-- if self.CwidgetRef then
									-- print("Pushing Forge Container Widget in front")
									-- self.CwidgetRef:MoveToFront()
									-- self.CwidgetRef.inv[11]:MoveToFront()
								-- end
								
								-- -- self.buttons["general"]["forge"]:MoveToFront()
								
								-- -- self.buttons["general"]["repair"]:GetAnimState():SetOrder(0)

								-- ActivateForgeContainerSlots(self, 0, 0)
								
								-- -- local container = self.forge.replica and self.forge.replica.container
								-- -- container.itemtestfn = function() return false end
								-- -- container.itemtestfn = self.forge.ItemTestRepairInit
								
								-- self.isBusy = false
	-- end)
	
	-- print("****** I should now play the Open Animation")
								
	-- self.bganim:GetAnimState():PlayAnimation("forge_init")
	
	-- print("The Widget is now open? ", self.isopen)
-- end


-- function ForgeWidget:Close(forge)
	-- print("++++++++++++++ I now enter the Close function of ForgeWidget")
	
	-- if self.checkitemstask ~= nil then
		-- self.inst:RemoveEventCallback("itemlose", self.onitemlosefn, self.forge)	
		-- self.inst:RemoveEventCallback("itemget", self.onitemgetfn, self.forge)
	-- end
	
	-- self.checkitemtask = nil
	
	-- self.currentMode = nil
	
	-- if forge.components.container then
		-- forge.components.container:Close()
	-- elseif forge.replica.container then
		-- forge.replica.container:Close()
	-- end
	
	-- if forge.Cwidget then 
		-- forge.Cwidget:Close()
		-- forge.Cwidget = nil
	-- end	
	
    -- if self.isopen then
	-- self.categoryListIsOpen = nil
	
        -- if self.buttons ~= nil then
			-- for k1, v1 in pairs(self.buttons) do
				-- for k2, v2 in pairs(self.buttons[k1]) do
					-- if k2 ~= "currentCategoryGroup" and k2 ~= "currentListGroup" then
						-- self.buttons[k1][k2]:Kill()
						-- self.buttons[k1][k2] = nil
					-- end
				-- end
			-- end
        -- end
		
		-- if self.inv ~= nil then
			-- for k, v in pairs(self.inv) do
				-- self.inv[k]:Kill()
				-- self.inv[k] = nil
			-- end
        -- end

        -- -- self.bganim:GetAnimState():PlayAnimation("Close")

        -- self.isopen = false
	
		-- forge.Fwidget = nil
	
		-- self.inst:DoTaskInTime(.3, function() self.should_close_widget = true end)
    -- end
-- end

return ArrowCarverWidget
