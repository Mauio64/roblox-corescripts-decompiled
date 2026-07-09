local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local InventoryItemType = AvatarExperienceSlotBasedEditor.Enums.InventoryItemType
local AvatarEditorCategories = AvatarExperienceSlotBasedEditor.Enums.AvatarEditorCategories
local InventorySorts = AvatarExperienceSlotBasedEditor.Enums.InventorySorts
local InventoryFilters = AvatarExperienceSlotBasedEditor.Enums.InventoryFilters
local isDurableItemExpired = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.isDurableItemExpired
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)

require(script.Parent.InventoryItemsList)

local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXModeratedItemsFlow = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXModeratedItemsFlow
local v17 = GetFFlagAXEnableSlotBasedEditor() and game:DefineFastFlag("AXDisableEquippedItemUprankingInAllTab2", false)
local FFlagAXUprankBundles = require(Modules.AvatarExperience.Flags.FFlagAXUprankBundles)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXPhotoboothIsStandalone = AvatarExperienceFlags.FFlagAXPhotoboothIsStandalone
local FFlagAXEnableModeratedItemsFlowForDurables = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXEnableModeratedItemsFlowForDurables
local FFlagAXRemoveExpiredItemsFromInventory = AvatarExperienceFlags.FFlagAXRemoveExpiredItemsFromInventory
local FFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter
local v24 = if not FFlagAXInventoryDurablesExpiredFilter then nil else function(p1, p2) -- line: 52
	-- upvalues: Constants (copy)
	local t1 = {}

	if p2.AssetTypeIdStrings then
		for _, v30 in p2.AssetTypeIdStrings do
			local v31 = p1.grantedAssetsByType[v30]

			if v31 then
				for _, v33 in v31 do
					t1[v33] = true
				end
			end
		end
	end

	if p2.BundleTypeIdStrings then
		for _, v35 in p2.BundleTypeIdStrings do
			local v36 = Constants.BundleTypeIdStringToOutfitType[v35]
			local v37 = if not v36 then nil else p1.grantedOutfitsByType[v36]

			if v37 then
				for _, v39 in v37 do
					t1[v39] = true
				end
			end
		end
	end

	return t1
end

local function useInventoryItems(p3, p4, p5) -- line: 79
	-- upvalues: useSelector (copy), FFlagAXRemoveExpiredItemsFromInventory (copy), React (copy), Utils (copy), useSignalState (copy), FFlagAXInventoryDurablesExpiredFilter (copy), InventoryFilters (copy), v17 (copy), AvatarEditorCategories (copy), InventorySorts (copy), InventoryItemType (copy), FFlagAXPhotoboothIsStandalone (copy), Constants (copy), FFlagAXUprankBundles (copy), FFlagAXModeratedItemsFlow (copy), FFlagAXEnableModeratedItemsFlowForDurables (copy), Cryo (copy), v24 (copy), isDurableItemExpired (copy)
	local t2 = {}
	local v44 = useSelector(function(p6) -- line: 86
		return p6.AvatarExperience.AvatarEditor.Character.EquippedAssets
	end)
	local v45 = useSelector(function(p7) -- line: 90
		return p7.AvatarExperience.AvatarEditor.UprankedItems
	end)
	local v46 = nil

	if FFlagAXRemoveExpiredItemsFromInventory then
		v46 = useSelector(function(p8) -- line: 96
			return p8.AvatarExperience.Common.AssetInfos
		end)
	end

	local v47 = useSelector(function(p9) -- line: 101
		return p9.AvatarExperience.AvatarEditor.GrantedItems
	end)
	local v48 = React.useMemo(function() -- line: 105
		-- upvalues: Utils (copy), v44 (copy), p4 (copy)
		return Utils.getEquippedAssetIdsForCategory(v44, p4)
	end, { p4 })
	local v49 = useSignalState(p5.getSortAndFilters)
	local v50 = if not FFlagAXInventoryDurablesExpiredFilter then nil else v49.filter == InventoryFilters.Expired

	if not FFlagAXInventoryDurablesExpiredFilter or not v50 then
		if not v17 or p4.NavigationKey ~= AvatarEditorCategories.All or v49.sort == InventorySorts.RecentlyWorn then
			for _, v52 in v48 do
				table.insert(t2, {
					itemId = v52,
					inventoryItemType = InventoryItemType.Asset
				})
			end
		end

		if FFlagAXPhotoboothIsStandalone and v47 and p4.AssetTypeIdStrings or not FFlagAXPhotoboothIsStandalone and p4.AssetTypeIdStrings then
			for _, v54 in p4.AssetTypeIdStrings do
				local v55 = v47.grantedAssetsByType[v54]

				if v55 then
					for _, v57 in v55 do
						table.insert(t2, {
							itemId = v57,
							inventoryItemType = InventoryItemType.Asset
						})
					end
				end
			end
		end

		if FFlagAXPhotoboothIsStandalone and v47 and p4.BundleTypeIdStrings or not FFlagAXPhotoboothIsStandalone and p4.BundleTypeIdStrings then
			for _, v59 in p4.BundleTypeIdStrings do
				local v60 = Constants.BundleTypeIdStringToOutfitType[v59]
				local v61 = if not v60 then nil else v47.grantedOutfitsByType[v60]

				if v61 then
					for _, v63 in v61 do
						table.insert(t2, {
							itemId = v63,
							inventoryItemType = InventoryItemType.Outfit
						})
					end
				end
			end
		end

		if FFlagAXUprankBundles() and v45 and p4.NavigationKey ~= AvatarEditorCategories.All then
			for _, v65 in v45 do
				local str = tostring(v65.id)
				local v67 = Constants.InventoryTypeToBundleTypeId[v65.inventoryType]

				if v67 and p4.BundleTypeIdStrings and Utils.Contains(p4.BundleTypeIdStrings, v67) then
					table.insert(t2, {
						itemId = str,
						inventoryItemType = InventoryItemType.Outfit
					})
				end
			end
		end
	end

	local v68 = useSignalState(p3.getItems)

	if v68 then
		if not FFlagAXModeratedItemsFlow and not FFlagAXEnableModeratedItemsFlowForDurables then
			t2 = Cryo.List.join(t2, v68)
		else
			for _, v70 in v68 do
				local v71 = Cryo.List.findWhere(t2, function(p10) -- line: 197
					-- upvalues: v70 (copy)
					return p10.itemId == v70.itemId
				end)

				if v71 then
					t2[v71] = v70
				else
					table.insert(t2, v70)
				end
			end
		end
	else
		for _ = 1, Constants.ShimmerCardsToDisplay do
			table.insert(t2, {})
		end
	end

	local v73 = if not FFlagAXInventoryDurablesExpiredFilter or (not v50 or not v47) then nil else v24(v47, p4)
	local t3 = {}
	local t4 = {
		[InventoryItemType.Asset] = {},
		[InventoryItemType.Outfit] = {},
		[InventoryItemType.Unknown] = {}
	}

	for _, v77 in t2 do
		local itemId = v77.itemId
		local inventoryItemType = v77.inventoryItemType

		if FFlagAXRemoveExpiredItemsFromInventory and ((not FFlagAXInventoryDurablesExpiredFilter or not v50) and itemId and inventoryItemType == InventoryItemType.Asset) then
			local v80 = if not FFlagAXInventoryDurablesExpiredFilter then v46[itemId] else v46 and v46[itemId]

			if v80 and v80.expirationTime and isDurableItemExpired(v80.expirationTime) then
				continue
			end
		end

		if not FFlagAXInventoryDurablesExpiredFilter or not v50 or not itemId or not v73 or not v73[itemId] then
			if not itemId or not inventoryItemType then
				table.insert(t3, v77)
			elseif not t4[inventoryItemType][itemId] then
				t4[inventoryItemType][itemId] = true
				table.insert(t3, v77)
			end
		end
	end

	return t3
end

return useInventoryItems
