local gameEntryUtils = require("@game/CorePackages/Workspace/Packages/_Index/UnifiedLogging/UnifiedLogging/gameEntryUtils")

local flaggedMutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/UnifiedLogging/Loggers").flaggedMutedError

return function(items, p2, p3)
	local universeIds = {}
	local placeIds = {}

	for k, item in items do
		local v5 = p2[item]

		if v5 == nil then
			flaggedMutedError(
				"BuildGameMetadataFields",
				`Entry at index {item} was nil when building game metadata fields for collection {p3}`
			)
		else
			local fieldsFromGameEntry = gameEntryUtils.extractFieldsFromGameEntry(v5)

			table.insert(universeIds, fieldsFromGameEntry.universeId or "")
			table.insert(placeIds, fieldsFromGameEntry.placeId or "")
		end
	end

	return {
		universeId_arr = table.concat(universeIds, ","),
		placeId_arr = table.concat(placeIds, ",")
	}
end
