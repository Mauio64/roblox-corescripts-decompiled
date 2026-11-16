local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module = require("@luauforge/bundled/fuM")
local avatarEditorCategories = require("@luauforge/bundled/dMd").Enums.AvatarEditorCategories
local inventorySorts = module.Enums.InventorySorts
local inventoryFilters = module.Enums.InventoryFilters

local isDurableItemExpired = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Utils.isDurableItemExpired
local inventoryItemType = module.Enums.InventoryItemType
local module2 = require("@luauforge/bundled/dMx")
local module3 = require("@luauforge/bundled/fvh")
require("@luauforge/deferred/gQC")

local v5 = require("@luauforge/bundled/dOc")()
	and game:DefineFastFlag("AXDisableEquippedItemUprankingInAllTab2", false)
local module4 = require("@luauforge/bundled/dPy")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXRemoveExpiredItemsFromInventory = AvatarExperienceFlags.FFlagAXRemoveExpiredItemsFromInventory
local fFlagAXInventoryDurablesExpiredFilter = AvatarExperienceFlags.FFlagAXInventoryDurablesExpiredFilter
local fFlagAXBackgroundGeneration = AvatarExperienceFlags.FFlagAXBackgroundGeneration

local fFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled = AvatarExperienceFlags.FFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled
local fFlagAXMigrateOutfitsToUserInventory = AvatarExperienceFlags.FFlagAXMigrateOutfitsToUserInventory
local fFlagAXRefetchInventoryOnUpdate = AvatarExperienceFlags.FFlagAXRefetchInventoryOnUpdate

local BACKGROUNDS_CREATE_TILE_ID = require("@luauforge/deferred/gQF").BACKGROUNDS_CREATE_TILE_ID
local module6 = require("@luauforge/deferred/gSf")

local fn = fFlagAXInventoryDurablesExpiredFilter and function(p2, data)
	local result = {}

	if fFlagAXMigrateOutfitsToUserInventory and data.InventoryOutfitTypes then
		for k, inventoryOutfitType in data.InventoryOutfitTypes do
			local v6 = module2.InventoryOutfitTypeToOutfitType[inventoryOutfitType]
			local v7 = if v6 then p2.grantedOutfitsByType[v6] else nil

			if not v7 then
				continue
			end

			for k2, v8 in v7 do
				result[v8] = true
			end
		end
	end

	if data.AssetTypeIdStrings then
		for k, assetTypeIdString in data.AssetTypeIdStrings do
			local grantedAsset = p2.grantedAssetsByType[assetTypeIdString]

			if not grantedAsset then
				continue
			end

			for k2, v6 in grantedAsset do
				result[v6] = true
			end
		end
	end

	if fFlagAXMigrateOutfitsToUserInventory or not data.BundleTypeIdStrings then
		return result
	end

	for k, bundleTypeIdString in data.BundleTypeIdStrings do
		local v6 = module2.BundleTypeIdStringToOutfitType[bundleTypeIdString]
		local v7 = if v6 then p2.grantedOutfitsByType[v6] else nil

		if not v7 then
			continue
		end

		for k2, v8 in v7 do
			result[v8] = true
		end
	end

	return result
end or nil

local function useInventoryItems(p2, data, p3, p4)
	if not fFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled then
		p4 = nil
	end

	local v6 = {}

	local v7 = useSelector(function(p5)
		return p5.AvatarExperience.AvatarEditor.Character.EquippedAssets
	end)

	local v8 = useSelector(function(p5)
		return p5.AvatarExperience.AvatarEditor.UprankedItems
	end)
	local v9

	if fFlagAXRemoveExpiredItemsFromInventory or fFlagAXBackgroundGeneration then
		v9 = useSelector(function(p5)
			return p5.AvatarExperience.Common.AssetInfos
		end)
	end

	local v10 = useSelector(function(p5)
		return p5.AvatarExperience.AvatarEditor.GrantedItems
	end)

	local v11 = React.useMemo(function()
		return module3.getEquippedAssetIdsForCategory(v7, data)
	end, { data })

	local v12 = useSignalState(p3.getSortAndFilters)
	local v13

	if fFlagAXInventoryDurablesExpiredFilter then
		v13 = v12.filter == inventoryFilters.Expired
	end

	if not (fFlagAXInventoryDurablesExpiredFilter and v13) then
		if
			not v5
			or data.NavigationKey ~= avatarEditorCategories.All
			or v12.sort == inventorySorts.RecentlyWorn
		then
			for k, v14 in v11 do
				table.insert(v6, {
					itemId = v14,
					inventoryItemType = inventoryItemType.Asset
				})
			end
		end

		if fFlagAXMigrateOutfitsToUserInventory then
			if data.AssetTypeIdStrings then
				for k, assetTypeIdString in data.AssetTypeIdStrings do
					local grantedAsset = v10.grantedAssetsByType[assetTypeIdString]

					if not grantedAsset then
						continue
					end

					for k2, v14 in grantedAsset do
						table.insert(v6, {
							itemId = v14,
							inventoryItemType = inventoryItemType.Asset
						})
					end
				end
			end

			if data.InventoryOutfitTypes and not fFlagAXRefetchInventoryOnUpdate then
				for k, inventoryOutfitType in data.InventoryOutfitTypes do
					local v14 = module2.InventoryOutfitTypeToOutfitType[inventoryOutfitType]

					local v15 = if v14 then v10.grantedOutfitsByType[v14] else nil

					if not v15 then
						continue
					end

					for k2, v16 in v15 do
						table.insert(v6, {
							itemId = v16,
							inventoryItemType = inventoryItemType.Outfit
						})
					end
				end
			end
		else
			if data.AssetTypeIdStrings then
				for k, assetTypeIdString in data.AssetTypeIdStrings do
					local grantedAsset = v10.grantedAssetsByType[assetTypeIdString]

					if not grantedAsset then
						continue
					end

					for k2, v14 in grantedAsset do
						table.insert(v6, {
							itemId = v14,
							inventoryItemType = inventoryItemType.Asset
						})
					end
				end
			end

			if data.BundleTypeIdStrings then
				for k, bundleTypeIdString in data.BundleTypeIdStrings do
					local v14 = module2.BundleTypeIdStringToOutfitType[bundleTypeIdString]

					local v15 = if v14 then v10.grantedOutfitsByType[v14] else nil

					if not v15 then
						continue
					end

					for k2, v16 in v15 do
						table.insert(v6, {
							itemId = v16,
							inventoryItemType = inventoryItemType.Outfit
						})
					end
				end
			end
		end

		if module4() and v8 and data.NavigationKey ~= avatarEditorCategories.All then
			for k, v14 in v8 do
				local id = tostring(v14.id)
				local v15 = module2.InventoryTypeToBundleTypeId[v14.inventoryType]

				if v15 and data.BundleTypeIdStrings and module3.Contains(data.BundleTypeIdStrings, v15) then
					table.insert(v6, {
						itemId = id,
						inventoryItemType = inventoryItemType.Outfit
					})
				end
			end
		end
	end

	local v14 = useSignalState(p2.getItems)

	if v14 then
		for k, v15 in v14 do
			local where = Cryo.List.findWhere(v6, function(p5): boolean
				return p5.itemId == v15.itemId
			end)

			if where then
				v6[where] = v15
			else
				table.insert(v6, v15)
			end
		end
	else
		for i = 1, module2.ShimmerCardsToDisplay do
			table.insert(v6, {})
		end
	end

	local v15 = if fFlagAXInventoryDurablesExpiredFilter and v13 and v10 then fn(v10, data) else nil

	local v16 = {
		[inventoryItemType.Asset] = {},
		[inventoryItemType.Outfit] = {},
		[inventoryItemType.Unknown] = {}
	}
	local result = {}

	for k, v17 in v6 do
		local itemId = v17.itemId
		local inventoryItemType2 = v17.inventoryItemType

		if
			fFlagAXRemoveExpiredItemsFromInventory
			and not (fFlagAXInventoryDurablesExpiredFilter and v13)
			and itemId
			and inventoryItemType2 == inventoryItemType.Asset
		then
			local v18 = if fFlagAXInventoryDurablesExpiredFilter then v9 and v9[itemId] else v9[itemId]

			if v18 and v18.expirationTime and isDurableItemExpired(v18.expirationTime) then
				continue
			end
		end

		if fFlagAXInventoryDurablesExpiredFilter and v13 and itemId and v15 and v15[itemId] then
			continue
		end

		if itemId and inventoryItemType2 then
			if not v16[inventoryItemType2][itemId] then
				v16[inventoryItemType2][itemId] = true
				table.insert(result, v17)
			end
		else
			table.insert(result, v17)
		end
	end

	if not fFlagAXBackgroundGeneration or data.NavigationKey ~= avatarEditorCategories.Backgrounds then
		return result
	end

	if v9 then
		for k, v17 in result do
			local itemId = v17.itemId

			if not (itemId and v9[itemId] and v9[itemId].isPlusExclusive) then
				continue
			end

			local clone = table.clone(v17)
			clone.isPlusExclusive = true
			result[k] = clone
		end
	end

	if p4 ~= false then
		table.insert(result, 1, {
			itemId = BACKGROUNDS_CREATE_TILE_ID,
			inventoryItemType = inventoryItemType.Unknown
		})

		return (module6(result))
	end

	if not fFlagAXBackgroundsHidePlusUpsellsWhenGuacDisabled then
		return result
	end

	local v17 = {}

	for k, v18 in result do
		if not v18.isPlusExclusive then
			table.insert(v17, v18)
		end
	end

	result = v17
	return result
end

return useInventoryItems
