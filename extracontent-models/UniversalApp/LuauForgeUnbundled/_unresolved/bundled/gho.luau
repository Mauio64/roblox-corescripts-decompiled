local module = require("@luauforge/bundled/dwM")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module2 = require("@luauforge/bundled/fuM")
local module3 = require("@luauforge/bundled/dMd")

local module4 = require("@luauforge/bundled/dOi")
local module5 = require("@luauforge/bundled/dOj")
local module6 = require("@luauforge/bundled/dNQ")
local module7 = require("@luauforge/bundled/fvh")
local module8 = require("@luauforge/bundled/dMx")

local getStaleInventoryGrantStore = module2.Stores.getStaleInventoryGrantStore
local avatarEditorCategories = module3.Enums.AvatarEditorCategories
local inventoryOutfitType = module3.Enums.InventoryOutfitType

local editableMakeupOutfitKeysByCreatedMakeup = {
	[inventoryOutfitType.CreatedMakeup] = module6.EditableMakeupOutfitKey
}

local v5 = {
	[inventoryOutfitType.Avatar] = true,
	[inventoryOutfitType.CreatedMakeup] = true,
	[inventoryOutfitType.Body] = false,
	[inventoryOutfitType.PurchasedMakeup] = false
}

local function addSearchUuid(list, p2, p3)
	if p3 and not p2[p3] then
		p2[p3] = true
		list[#list + 1] = p3
	end
end

local function collectOutfitBearingSearchUuids(items, searchUuids, set)
	for k, item in items do
		if item.SearchUuid and item.InventoryOutfitTypes then
			local searchUuid = item.SearchUuid

			if searchUuid and not set[searchUuid] then
				set[searchUuid] = true
				searchUuids[#searchUuids + 1] = searchUuid
			end
		end

		if item.Subcategories then
			collectOutfitBearingSearchUuids(item.Subcategories, searchUuids, set)
		end

		if item.SubcategoryFilters then
			collectOutfitBearingSearchUuids(item.SubcategoryFilters, searchUuids, set)
		end
	end
end

local function getAllTabSearchUuid()
	for k, v6 in module5() do
		if v6.Id == avatarEditorCategories.All and v6.SearchUuid then
			return v6.SearchUuid
		end
	end

	return nil
end

local function collectSearchUuidsForOutfitType(items, p2, searchUuids, p3)
	for k, item in items do
		if item.SearchUuid and item.InventoryOutfitTypes then
			for k2, inventoryOutfitType2 in item.InventoryOutfitTypes do
				if inventoryOutfitType2 ~= p2 then
					continue
				end

				local searchUuid = item.SearchUuid

				if not searchUuid or p3[searchUuid] then
					continue
				end

				p3[searchUuid] = true
				searchUuids[#searchUuids + 1] = searchUuid
			end
		end

		if item.Subcategories then
			collectSearchUuidsForOutfitType(item.Subcategories, p2, searchUuids, p3)
		end

		if item.SubcategoryFilters then
			collectSearchUuidsForOutfitType(item.SubcategoryFilters, p2, searchUuids, p3)
		end
	end
end

local function collectSearchUuidsForInventoryOutfitType(p2, list, p3)
	collectSearchUuidsForOutfitType(module5(), p2, list, p3)
	local v6 = editableMakeupOutfitKeysByCreatedMakeup[p2]

	if v6 then
		if p3[v6] then
			return
		end

		p3[v6] = true
		list[#list + 1] = v6
	end
end

local function collectSearchUuidsForOutfit(outfitType, isEditable, searchUuidsForUpdate, set)
	for k, v6 in module8.InventoryOutfitTypeToOutfitType do
		local v7 = v5[k]
		local v8 = isEditable == nil or v7 == nil or v7 == isEditable

		if not (v6 == outfitType and v8) then
			continue
		end

		collectSearchUuidsForOutfitType(module5(), k, searchUuidsForUpdate, set)
		local v9 = editableMakeupOutfitKeysByCreatedMakeup[k]

		if not v9 or set[v9] then
			continue
		end

		set[v9] = true
		searchUuidsForUpdate[#searchUuidsForUpdate + 1] = v9
	end
end

local function getSearchUuidsForUpdate(data)
	local searchUuidsForUpdate = {}
	local set = {}

	if data.assetTypeIdString then
		local assetTypeToSearchUuid = module4().AssetTypeToSearchUuids[data.assetTypeIdString]

		if assetTypeToSearchUuid then
			for k, v6 in assetTypeToSearchUuid do
				if not v6 or set[v6] then
					continue
				end

				set[v6] = true
				searchUuidsForUpdate[#searchUuidsForUpdate + 1] = v6
			end
		end
	else
		local inventoryOutfitType2 = data.inventoryOutfitType
		local outfitType = data.outfitType

		if inventoryOutfitType2 then
			collectSearchUuidsForOutfitType(module5(), inventoryOutfitType2, searchUuidsForUpdate, set)
			local v6 = editableMakeupOutfitKeysByCreatedMakeup[inventoryOutfitType2]

			if v6 and not set[v6] then
				set[v6] = true
				searchUuidsForUpdate[#searchUuidsForUpdate + 1] = v6
			end
		elseif outfitType then
			collectSearchUuidsForOutfit(outfitType, data.isEditable, searchUuidsForUpdate, set)
		end

		if outfitType then
			local outfitSubtypeKey = module7.getOutfitSubtypeKey(outfitType, data.isEditable)

			if outfitSubtypeKey ~= "" and outfitSubtypeKey and not set[outfitSubtypeKey] then
				set[outfitSubtypeKey] = true
				searchUuidsForUpdate[#searchUuidsForUpdate + 1] = outfitSubtypeKey
			end
		end

		if data.allOutfitLists then
			collectOutfitBearingSearchUuids(module5(), searchUuidsForUpdate, set)

			for k, v6 in editableMakeupOutfitKeysByCreatedMakeup do
				if not v6 or set[v6] then
					continue
				end

				set[v6] = true
				searchUuidsForUpdate[#searchUuidsForUpdate + 1] = v6
			end
		end
	end

	local flag = true
	local searchUuid

	for k, v6 in module5() do
		if v6.Id == avatarEditorCategories.All and v6.SearchUuid then
			searchUuid = v6.SearchUuid
			flag = false
			break
		end
	end

	if flag then
		searchUuid = nil
	end

	if not searchUuid or set[searchUuid] then
		return searchUuidsForUpdate
	end

	set[searchUuid] = true
	searchUuidsForUpdate[#searchUuidsForUpdate + 1] = searchUuid

	return searchUuidsForUpdate
end

return function(p2, p3)
	module.isType(p2, "table", "markInventoryStaleOnUpdate expects updatedCategory")

	local staleInventoryGrantStore = getStaleInventoryGrantStore()

	for k, v6 in getSearchUuidsForUpdate(p2) do
		staleInventoryGrantStore.markSearchUuidStale(v6, p3)
	end
end
