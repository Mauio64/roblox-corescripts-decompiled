local parent = script:FindFirstAncestor("UnifiedLogging").Parent

local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local SharedFlags = require(parent.SharedFlags)
local FFlagUnifiedLoggingCoerceMetadataFieldValues = SharedFlags.FFlagUnifiedLoggingCoerceMetadataFieldValues

local v = {
	collectionId = true,
	collectionPosition = true,
	contentType = true,
	id = true,
	itemPosition = true,
	itemsPerRow = true,
	rowNumber = true,
	totalNumberOfItems = true
}

local function shouldIgnoreKey(k: string) -- 1 equivalent call inferred from this helper
	return v[k]
end

local function buildItemMetadataFields(list, p, collectionId)
	local v2 = {}

	for k, item in list do
		local v3

		if p then
			v3 = p[item] or nil
		end

		if v3 == nil then
			DiscoveryEventErrorLogger.reportError(
				"buildMetadataFields",
				"Entry was nil when building item metadataFields for collection",
				{ entryIndex = item, collectionId = collectionId }
			)
		else
			for k2, v4 in v3 do
				if shouldIgnoreKey(k2) then -- inferred equivalent call
					continue
				end

				if v2[k2] == nil then
					v2[k2] = {}
				end

				local v5 = v2[k2]

				if FFlagUnifiedLoggingCoerceMetadataFieldValues then
					v5[k] = tostring(v4)
				else
					v5[k] = v4
				end
			end
		end
	end

	for k, _ in v2 do
		for i = 1, #list do
			if v2[k][i] == nil then
				v2[k][i] = ""
			end
		end
	end

	local itemMetadataFields = {}

	for k, list2 in v2 do
		itemMetadataFields[`{k}_arr`] = table.concat(list2, ",")
	end

	return itemMetadataFields
end

return buildItemMetadataFields
