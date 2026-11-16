local UnifiedLogging = script:FindFirstAncestor("UnifiedLogging")
local parent = UnifiedLogging.Parent

local gameEntryUtils = require(UnifiedLogging.gameEntryUtils)

local Loggers = require(parent.Loggers)
local flaggedMutedError = Loggers.flaggedMutedError

return function(items, p, p2)
	local universeIds = {}
	local placeIds = {}

	for _, item in items do
		local v = p[item]

		if v == nil then
			flaggedMutedError(
				"BuildGameMetadataFields",
				`Entry at index {item} was nil when building game metadata fields for collection {p2}`
			)
		else
			local fieldsFromGameEntry = gameEntryUtils.extractFieldsFromGameEntry(v)

			table.insert(universeIds, fieldsFromGameEntry.universeId or "")
			table.insert(placeIds, fieldsFromGameEntry.placeId or "")
		end
	end

	return {
		universeId_arr = table.concat(universeIds, ","),
		placeId_arr = table.concat(placeIds, ",")
	}
end
