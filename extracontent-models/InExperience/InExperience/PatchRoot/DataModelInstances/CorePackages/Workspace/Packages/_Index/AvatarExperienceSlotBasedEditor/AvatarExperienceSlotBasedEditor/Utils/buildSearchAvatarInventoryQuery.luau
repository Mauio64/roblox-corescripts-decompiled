local HttpService = game:GetService("HttpService")

local AvatarExperienceSlotBasedEditor = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor")

local InventorySearchConstants = require(AvatarExperienceSlotBasedEditor.InventorySearchConstants)
require(AvatarExperienceSlotBasedEditor.Types)
local InventorySearchSortOption = require(AvatarExperienceSlotBasedEditor.Enums.InventorySearchSortOption)

local function isSortOption(sortOption: string): boolean -- 1 equivalent call inferred from this helper
	for _, v in InventorySearchSortOption do
		if v == sortOption then
			return true
		end
	end

	return false
end

local function isPositiveInteger(pageLimit): boolean -- 1 equivalent call inferred from this helper
	return type(pageLimit) == "number" and pageLimit >= 1 and pageLimit % 1 == 0
end

local function buildSearchAvatarInventoryQuery(data)
	if type(data.query) ~= "string" then
		return nil
	end

	local query = string.match(data.query, "^%s*(.-)%s*$")

	if not (query ~= "" and utf8.len(query)) then
		return nil
	end

	local sortOption = data.sortOption or InventorySearchSortOption.Relevance

	if not isSortOption(sortOption) then -- inferred equivalent call
		return nil
	end

	local v = { query = query, sortOption = sortOption }

	local itemCategories = data.itemCategories

	if itemCategories ~= nil then
		if #itemCategories == 0 then
			return nil
		end

		for k, itemCategory in itemCategories do
			local searchableSubtype = InventorySearchConstants.SearchableSubtypesByItemType[itemCategory.itemType]

			if searchableSubtype and searchableSubtype[itemCategory.itemSubType] then
				local v2 = k - 1
				v[`itemCategories[{v2}].itemType`] = itemCategory.itemType
				v[`itemCategories[{v2}].itemSubType`] = itemCategory.itemSubType
			else
				return nil
			end
		end
	end

	if data.pageLimit ~= nil then
		if not isPositiveInteger(data.pageLimit) or data.pageLimit > InventorySearchConstants.MaxPageLimit then -- inferred equivalent call
			return nil
		end

		v.pageLimit = data.pageLimit
	end

	if data.pageToken ~= nil and data.pageToken ~= "" then
		v.pageToken = data.pageToken
	end

	local result = {}

	for k, v2 in v do
		result[k] = HttpService:UrlEncode((tostring(v2)))
	end

	return result
end

return buildSearchAvatarInventoryQuery
