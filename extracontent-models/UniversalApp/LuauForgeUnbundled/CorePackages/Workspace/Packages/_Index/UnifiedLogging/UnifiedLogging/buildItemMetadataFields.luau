local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/DiscoveryUtils").DiscoveryEventErrorLogger

local fFlagUnifiedLoggingCoerceMetadataFieldValues = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/SharedFlags").FFlagUnifiedLoggingCoerceMetadataFieldValues

local v5 = {
	collectionId = true,
	collectionPosition = true,
	contentType = true,
	id = true,
	itemPosition = true,
	itemsPerRow = true,
	rowNumber = true,
	totalNumberOfItems = true
}

local function shouldIgnoreKey(p2)
	return v5[p2]
end

local function buildItemMetadataFields(list, p2, p3)
	local v6 = {}

	for k, item in list do
		local v7 = if p2 then p2[item] or nil else nil

		if v7 == nil then
			discoveryEventErrorLogger.reportError(
				"buildMetadataFields",
				"Entry was nil when building item metadataFields for collection",
				{ entryIndex = item, collectionId = p3 }
			)
		else
			for k2, v8 in v7 do
				if v5[k2] then
					continue
				end

				if v6[k2] == nil then
					v6[k2] = {}
				end

				local v9 = v6[k2]

				if fFlagUnifiedLoggingCoerceMetadataFieldValues then
					v9[k] = tostring(v8)
				else
					v9[k] = v8
				end
			end
		end
	end

	for k, v7 in v6 do
		for i = 1, #list do
			if v6[k][i] == nil then
				v6[k][i] = ""
			end
		end
	end

	local itemMetadataFields = {}

	for k, list2 in v6 do
		itemMetadataFields[`{k}_arr`] = table.concat(list2, ",")
	end

	return itemMetadataFields
end

return buildItemMetadataFields
