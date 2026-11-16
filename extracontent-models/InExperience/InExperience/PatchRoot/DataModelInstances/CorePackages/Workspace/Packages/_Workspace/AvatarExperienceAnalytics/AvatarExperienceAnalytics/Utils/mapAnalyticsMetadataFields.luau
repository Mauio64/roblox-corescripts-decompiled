local parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local v = {
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

for _, v2 in v do
	for _, alias in v2.aliases do
		aliasSet[alias] = true
	end
end

local function mapAnalyticsMetadataFields(items, flag: boolean?)
	local result = {}

	if items == nil then
		return result
	end

	for k, item in items do
		if FFlagAXUnifiedEventStrictPayloads and flag and aliasSet[k] then
			result[k] = item
		end

		if not aliasSet[k] then
			result[k] = item
		end
	end

	for _, v2 in v do
		if result[v2.protoKey] ~= nil then
			continue
		end

		for _, alias in v2.aliases do
			if items[alias] ~= nil then
				result[v2.protoKey] = items[alias]
				break
			end
		end
	end

	return result
end

return mapAnalyticsMetadataFields
