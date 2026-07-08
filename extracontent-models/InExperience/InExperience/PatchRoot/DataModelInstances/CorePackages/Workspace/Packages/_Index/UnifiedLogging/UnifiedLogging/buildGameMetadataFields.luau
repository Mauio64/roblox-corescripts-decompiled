local UnifiedLogging = script:FindFirstAncestor("UnifiedLogging")
local UnifiedLoggingParent = UnifiedLogging.Parent
local gameEntryUtils = require(UnifiedLogging.gameEntryUtils)
local flaggedMutedError = require(UnifiedLoggingParent.Loggers).flaggedMutedError

return function(p1, p2, p3) -- line: 8
	-- upvalues: gameEntryUtils (copy), flaggedMutedError (copy)
	local t1 = {}
	local t2 = {}

	for _, v11 in p1 do
		local v12 = p2[v11]

		if v12 ~= nil then
			local v13 = gameEntryUtils.extractFieldsFromGameEntry(v12)

			table.insert(t1, v13.universeId or "")
			table.insert(t2, v13.placeId or "")
		else
			flaggedMutedError("BuildGameMetadataFields", `Entry at index { v11 } was nil when building game metadata fields for collection { p3 }`)
		end
	end

	return {
		universeId_arr = table.concat(t1, ","),
		placeId_arr = table.concat(t2, ",")
	}
end
