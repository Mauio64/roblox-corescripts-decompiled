local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local getFIntUGCLCCageVerticesSimilarityMaximum = require(ParentParent.flags.getFIntUGCLCCageVerticesSimilarityMaximum)
local Analytics = require(ParentParent.Analytics)

local function validateVerticesSimilarity(p1, p2, vector3: Vector3, s1: string) -- line: 14
	-- upvalues: pcallDeferred (copy), UGCValidationService (copy), Analytics (copy), getFIntUGCLCCageVerticesSimilarityMaximum (copy)
	local timestamp = tick()
	local isServer = p2.isServer
	local v13, v14 = pcallDeferred(function() -- line: 24
		-- upvalues: UGCValidationService (copy), p1 (copy), vector3 (copy)
		return UGCValidationService:GetEditableMeshVerticesSimilarityRate(p1.editableMesh, vector3)
	end, p2)

	if not v13 then
		if isServer ~= nil and isServer then
			error(string.format("Failed to execute similarity mesh vertex check for '%s'. Make sure mesh exists and try again.", p1.fullName))
		end

		Analytics.reportFailure(Analytics.ErrorType.validateVerticesSimilarity_FailedToExecute, nil, p2)

		return false, { string.format("Failed to execute similarity mesh vertex check for '%s'. Make sure mesh exists and try again.", p1.fullName) }
	end

	local v15 = math.floor(v14 * 100)

	if v15 > getFIntUGCLCCageVerticesSimilarityMaximum() then
		Analytics.reportFailure(Analytics.ErrorType.validateVerticesSimilarity_MaxSimilarityExceeded, nil, p2)

		return false, { string.format("%s has %d%% of vertices too close to each other. Please edit the vertices to have at most %d%% coincident or close to one another.", s1, v15, getFIntUGCLCCageVerticesSimilarityMaximum()) .. "[Read more](https://create.roblox.com/docs/art/validation-errors#cageDensity)" }
	end

	Analytics.recordScriptTime(script.Name, timestamp, p2)

	return true
end

return validateVerticesSimilarity
