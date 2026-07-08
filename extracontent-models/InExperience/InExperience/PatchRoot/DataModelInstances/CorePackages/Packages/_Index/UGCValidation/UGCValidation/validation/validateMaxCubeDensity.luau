local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local getFIntUGCValidationVertexDensityThreshold = require(ParentParent.flags.getFIntUGCValidationVertexDensityThreshold)
local Analytics = require(ParentParent.Analytics)

local function validateMaxCubeDensity(p1, p2, vector3: Vector3) -- line: 11
	-- upvalues: pcallDeferred (copy), UGCValidationService (copy), Analytics (copy), getFIntUGCValidationVertexDensityThreshold (copy)
	local timestamp = tick()
	local isServer = p2.isServer
	local v12, v13 = pcallDeferred(function() -- line: 19
		-- upvalues: UGCValidationService (copy), p1 (copy), vector3 (copy)
		return UGCValidationService:GetEditableMeshMaxNearbyVerticesCollisions(p1.editableMesh, vector3)
	end, p2)

	if not v12 then
		if isServer ~= nil and isServer then
			error(string.format("Failed to execute vertex density check for '%s'. Make sure mesh exists and try again.", p1.fullName))
		end

		Analytics.reportFailure(Analytics.ErrorType.validateVertexDensity_FailedToExecute, nil, p2)

		return false, { string.format("Failed to execute vertex density check for '%s'. Make sure mesh exists and try again.", p1.fullName) }
	end

	if v13 > getFIntUGCValidationVertexDensityThreshold() then
		Analytics.reportFailure(Analytics.ErrorType.validateVertexDensity_MaxDensityExceeded, nil, p2)

		return false, { "The maximum vertex density has been exceeded. Reduce the number of vertices that are very close to each other." }
	end

	Analytics.recordScriptTime(script.Name, timestamp, p2)

	return true
end

return validateMaxCubeDensity
