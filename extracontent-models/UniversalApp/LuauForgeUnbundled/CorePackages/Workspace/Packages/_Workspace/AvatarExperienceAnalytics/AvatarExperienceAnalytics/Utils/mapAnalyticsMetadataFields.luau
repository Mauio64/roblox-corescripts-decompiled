local fFlagAXUnifiedEventStrictPayloads = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags").FFlagAXUnifiedEventStrictPayloads

local v5 = {
	{
		protoKey = "sort",
		aliases = { "sortEnumValue" }
	},
	{
		protoKey = "filterSalesType",
		aliases = { "filterSalesTypeEnumValue" }
	},
	{
		protoKey = "filterCreators",
		aliases = { "filterCreatorsType", "filterCreatorsTypeEnumValue" }
	},
	{
		protoKey = "filterPrice",
		aliases = { "filterPriceEnumValue" }
	},
	{
		protoKey = "filterUnavailableItems",
		aliases = { "filterUnavailableItemsEnumValue" }
	}
}

local aliasSet = {}

for k, v6 in v5 do
	for k2, alias in v6.aliases do
		aliasSet[alias] = true
	end
end

local function mapAnalyticsMetadataFields(items, p2)
	local result = {}

	if items == nil then
		return result
	end

	for k, item in items do
		if fFlagAXUnifiedEventStrictPayloads and p2 and aliasSet[k] then
			result[k] = item
		end

		if not aliasSet[k] then
			result[k] = item
		end
	end

	for k, v6 in v5 do
		if result[v6.protoKey] ~= nil then
			continue
		end

		for k2, alias in v6.aliases do
			if items[alias] ~= nil then
				result[v6.protoKey] = items[alias]
				break
			end
		end
	end

	return result
end

return mapAnalyticsMetadataFields
