local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")
local AvatarExperienceCatalogParent = AvatarExperienceCatalog.Parent
local DataHydration = require(AvatarExperienceCatalogParent.DataHydration)
local getSduiApiStore = require(AvatarExperienceCatalogParent.SduiSharedUtilities).getSduiApiStore

require(AvatarExperienceCatalog.Models.WidgetListInfo)

local function asLegacyContent(p1) -- line: 28
	if typeof(p1) ~= "table" then
		return {}
	end

	local t1 = {}

	for _, v10 in p1 do
		if typeof(v10) == "table" then
			table.insert(t1, v10)
		end
	end

	return t1
end
local function buildOrderedWidgetsFromCatalogPage(s1: string, s2: string?) -- line: 42
	-- upvalues: getSduiApiStore (copy), DataHydration (copy), asLegacyContent (copy)
	local t2 = {}
	local v14 = getSduiApiStore().getInputData(s1, s2)

	if typeof(v14) ~= "table" then
		return t2
	end

	local entry_order = v14.entry_order
	local entry_map = v14.entry_map

	if typeof(entry_order) ~= "table" or typeof(entry_map) ~= "table" then
		return t2
	end

	local v17 = DataHydration.MarketplaceCatalogSort.getMarketplaceCatalogSortStore(false)

	for _, v19 in entry_order do
		if typeof(v19) == "string" and v19 ~= "" then
			local v20 = entry_map[v19]

			if typeof(v20) == "table" then
				local value = nil

				if typeof(v20.input_data) == "table" and typeof(v20.input_data.kind) == "table" and typeof(v20.input_data.kind.value) == "table" then
					value = v20.input_data.kind.value
				end

				local v22 = if typeof(value) ~= "table" or typeof(value.id) ~= "string" then nil else value.id

				if v22 ~= nil and v22 ~= "" then
					local v23 = v17.getMarketplaceCatalogSort(v22)
					local v24 = if not v23 or not v23.data then nil else v23.data(false)

					if v24 then
						table.insert(t2, {
							id = v22,
							type = v24.type,
							tagId = v24.tagId,
							content = asLegacyContent(v24.content)
						})
					else
						table.insert(t2, {
							type = nil,
							tagId = nil,
							id = v22,
							content = {}
						})
					end
				end
			end
		end
	end

	return t2
end

return buildOrderedWidgetsFromCatalogPage
