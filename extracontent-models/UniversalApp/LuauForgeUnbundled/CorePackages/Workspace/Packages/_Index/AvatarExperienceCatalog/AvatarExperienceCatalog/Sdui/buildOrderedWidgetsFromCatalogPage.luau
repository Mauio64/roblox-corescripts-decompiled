local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/DataHydration")
local getSduiApiStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/SduiSharedUtilities").getSduiApiStore

require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Models/WidgetListInfo")

local function asLegacyContent(content)
	if typeof(content) ~= "table" then
		return {}
	end

	local result = {}

	for k, item in content do
		if typeof(item) == "table" then
			table.insert(result, item)
		end
	end

	return result
end

local function buildOrderedWidgetsFromCatalogPage(p2, p3)
	local orderedWidgetsFromCatalogPage = {}

	local inputData = getSduiApiStore().getInputData(p2, p3)

	if typeof(inputData) ~= "table" then
		return orderedWidgetsFromCatalogPage
	end

	local entry_order = inputData.entry_order
	local entry_map = inputData.entry_map

	if typeof(entry_order) ~= "table" or typeof(entry_map) ~= "table" then
		return orderedWidgetsFromCatalogPage
	end

	local marketplaceCatalogSortStore = DataHydration.MarketplaceCatalogSort.getMarketplaceCatalogSortStore(false)

	for k, v5 in entry_order do
		if not (typeof(v5) == "string" and v5 ~= "") then
			continue
		end

		local v6 = entry_map[v5]

		if typeof(v6) ~= "table" then
			continue
		end

		local value

		if
			typeof(v6.input_data) == "table"
			and typeof(v6.input_data.kind) == "table"
			and typeof(v6.input_data.kind.value) == "table"
		then
			value = v6.input_data.kind.value
		end

		local id = if typeof(value) == "table" and typeof(value.id) == "string" then value.id else nil

		if not (id ~= nil and id ~= "") then
			continue
		end

		local marketplaceCatalogSort = marketplaceCatalogSortStore.getMarketplaceCatalogSort(id)
		local v7

		if marketplaceCatalogSort and marketplaceCatalogSort.data then
			v7 = marketplaceCatalogSort.data(false)
		end

		if v7 then
			table.insert(orderedWidgetsFromCatalogPage, {
				id = id,
				type = v7.type,
				tagId = v7.tagId,
				content = asLegacyContent(v7.content)
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
