local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent

require(parent.util.Types)
local pcallDeferred = require(parent.util.pcallDeferred)
local getFIntUGCValidationVertexDensityThreshold = require(parent.flags.getFIntUGCValidationVertexDensityThreshold)

local Analytics = require(parent.Analytics)

local function validateMaxCubeDensity(p, p2, vector3: Vector3)
	local now = tick()
	local isServer = p2.isServer

	local v, v2 = pcallDeferred(function()
		return UGCValidationService:GetEditableMeshMaxNearbyVerticesCollisions(p.editableMesh, vector3)
	end, p2)

	if v then
		if getFIntUGCValidationVertexDensityThreshold() < v2 then
			Analytics.reportFailure(Analytics.ErrorType.validateVertexDensity_MaxDensityExceeded, nil, p2)

			return
				false,
				{ "The maximum vertex density has been exceeded. Reduce the number of vertices that are very close to each other." }
		end

		Analytics.recordScriptTime(script.Name, now, p2)
		return true
	end

	if isServer ~= nil and isServer then
		error(string.format(
			"Failed to execute vertex density check for '%s'. Make sure mesh exists and try again.",
			p.fullName
		))
	end

	Analytics.reportFailure(Analytics.ErrorType.validateVertexDensity_FailedToExecute, nil, p2)

	return
		false,
		{ string.format(
				"Failed to execute vertex density check for '%s'. Make sure mesh exists and try again.",
				p.fullName
			) }
end

return validateMaxCubeDensity
