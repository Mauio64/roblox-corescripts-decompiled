local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local parent = AvatarExperienceCatalog.Parent

local DataHydration = require(parent.DataHydration)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore

require(AvatarExperienceCatalog.Models.WidgetListInfo)

local function asLegacyContent(content)
	if typeof(content) ~= "table" then
		return {}
	end

	local result = {}

	for _, item in content do
		if typeof(item) == "table" then
			table.insert(result, item)
		end
	end

	return result
end

local function buildOrderedWidgetsFromCatalogPage(p: string, p2: string?)
	local orderedWidgetsFromCatalogPage = {}

	local inputData = getSduiApiStore().getInputData(p, p2)

	if typeof(inputData) ~= "table" then
		return orderedWidgetsFromCatalogPage
	end

	local entry_order = inputData.entry_order
	local entry_map = inputData.entry_map

	if typeof(entry_order) ~= "table" or typeof(entry_map) ~= "table" then
		return orderedWidgetsFromCatalogPage
	end

	local marketplaceCatalogSortStore = DataHydration.MarketplaceCatalogSort.getMarketplaceCatalogSortStore(false)

	for _, v in entry_order do
		if not (typeof(v) == "string" and v ~= "") then
			continue
		end

		local v2 = entry_map[v]

		if typeof(v2) ~= "table" then
			continue
		end

		local value

		if
			typeof(v2.input_data) == "table"
			and typeof(v2.input_data.kind) == "table"
			and typeof(v2.input_data.kind.value) == "table"
		then
			value = v2.input_data.kind.value
		end

		local id

		if typeof(value) == "table" and typeof(value.id) == "string" then
			id = value.id
		end

		if not (id ~= nil and id ~= "") then
			continue
		end

		local marketplaceCatalogSort = marketplaceCatalogSortStore.getMarketplaceCatalogSort(id)
		local v3

		if marketplaceCatalogSort and marketplaceCatalogSort.data then
			v3 = marketplaceCatalogSort.data(false)
		end

		if v3 then
			table.insert(orderedWidgetsFromCatalogPage, {
				id = id,
				type = v3.type,
				tagId = v3.tagId,
				content = asLegacyContent(v3.content)
			})
		else
			table.insert(orderedWidgetsFromCatalogPage, {
				id = id,
				type = nil,
				tagId = nil,
				content = {}
			})
		end
	end

	return orderedWidgetsFromCatalogPage
end

return buildOrderedWidgetsFromCatalogPage
