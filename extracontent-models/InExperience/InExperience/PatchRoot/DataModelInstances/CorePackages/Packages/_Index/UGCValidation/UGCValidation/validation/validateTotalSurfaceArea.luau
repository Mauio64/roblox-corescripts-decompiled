local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent

local getFIntMaxTotalSurfaceArea = require(parent.flags.getFIntMaxTotalSurfaceArea)

require(parent.util.Types)
local pcallDeferred = require(parent.util.pcallDeferred)

local Analytics = require(parent.Analytics)

local function validateTotalSurfaceArea(p, vector3: Vector3, p2)
	local now = tick()

	local isServer = p2.isServer

	local v, v2 = pcallDeferred(function()
		return UGCValidationService:CalculateEditableMeshTotalSurfaceArea(p.editableMesh, vector3)
	end, p2)

	if v then
		if getFIntMaxTotalSurfaceArea() < v2 then
			Analytics.reportFailure(Analytics.ErrorType.validateTotalSurfaceArea_maxTotalSurfaceAreaExceeded, nil, p2)

			return
				false,
				{ string.format(
						"The total surface area of model mesh '%s' is %.2f, it cannot be greater than %d. You must reduce the number and/or size of all triangles.",
						p.fullName,
						v2,
						getFIntMaxTotalSurfaceArea()
					) }
		end

		Analytics.recordScriptTime(script.Name, now, p2)
		return true
	else
		local v3 = string.format(
			"Failed to execute max total surface area check for '%s'. Make sure mesh exists and try again.",
			p.fullName
		)

		if isServer ~= nil and isServer then
			error(v3)
		end

		Analytics.reportFailure(Analytics.ErrorType.validateTotalSurfaceArea_FailedToExecute, nil, p2)
		return false, { v3 }
	end
end

return validateTotalSurfaceArea
