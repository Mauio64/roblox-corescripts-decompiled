local HttpService = game:GetService("HttpService")

local InventorySearchConstants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/InventorySearchConstants")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Types")
local InventorySearchSortOption = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSlotBasedEditor/AvatarExperienceSlotBasedEditor/Enums/InventorySearchSortOption")

local function isSortOption(p2): boolean
	for k, v5 in InventorySearchSortOption do
		if v5 == p2 then
			return true
		end
	end

	return false
end

local function isPositiveInteger(value): boolean
	return type(value) == "number" and value >= 1 and value % 1 == 0
end

local function buildSearchAvatarInventoryQuery(data)
	if type(data.query) ~= "string" then
		return nil
	end

	local v5 = string.match(data.query, "^%s*(.-)%s*$")

	if not (v5 ~= "" and utf8.len(v5)) then
		return nil
	end

	local sortOption = data.sortOption or InventorySearchSortOption.Relevance
	local flag = true
	local v6

	for k, v7 in InventorySearchSortOption do
		if v7 == sortOption then
			v6 = true
			flag = false
			break
		end
	end

	if flag then
		v6 = false
	end

	if not v6 then
		return nil
	end

	local v7 = { query = v5, sortOption = sortOption }

	local itemCategories = data.itemCategories

	if itemCategories ~= nil then
		if #itemCategories == 0 then
			return nil
		end

		for k, itemCategory in itemCategories do
			local searchableSubtype = InventorySearchConstants.SearchableSubtypesByItemType[itemCategory.itemType]

			if searchableSubtype and searchableSubtype[itemCategory.itemSubType] then
				local v8 = k - 1
				v7[`itemCategories[{v8}].itemType`] = itemCategory.itemType
				v7[`itemCategories[{v8}].itemSubType`] = itemCategory.itemSubType
			else
				return nil
			end
		end
	end

	if data.pageLimit ~= nil then
		local pageLimit = data.pageLimit
		local v8 = type(pageLimit) == "number" and pageLimit >= 1 and pageLimit % 1 == 0

		if not v8 or data.pageLimit > InventorySearchConstants.MaxPageLimit then
			return nil
		end

		v7.pageLimit = data.pageLimit
	end

	if data.pageToken ~= nil and data.pageToken ~= "" then
		v7.pageToken = data.pageToken
	end

	local result = {}

	for k, v8 in v7 do
		result[k] = HttpService:UrlEncode((tostring(v8)))
	end

	return result
end

return buildSearchAvatarInventoryQuery
