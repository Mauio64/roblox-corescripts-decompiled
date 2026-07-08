local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent
local getFIntMaxTotalSurfaceArea = require(ParentParent.flags.getFIntMaxTotalSurfaceArea)

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local Analytics = require(ParentParent.Analytics)

local function validateTotalSurfaceArea(p1, vector3: Vector3, p2) -- line: 16
	-- upvalues: pcallDeferred (copy), UGCValidationService (copy), Analytics (copy), getFIntMaxTotalSurfaceArea (copy)
	local timestamp = tick()
	local isServer = p2.isServer
	local v12, v13 = pcallDeferred(function() -- line: 25
		-- upvalues: UGCValidationService (copy), p1 (copy), vector3 (copy)
		return UGCValidationService:CalculateEditableMeshTotalSurfaceArea(p1.editableMesh, vector3)
	end, p2)

	if not v12 then
		local v14 = string.format("Failed to execute max total surface area check for '%s'. Make sure mesh exists and try again.", p1.fullName)

		if isServer ~= nil and isServer then
			error(v14)
		end

		Analytics.reportFailure(Analytics.ErrorType.validateTotalSurfaceArea_FailedToExecute, nil, p2)

		return false, { v14 }
	end

	if v13 > getFIntMaxTotalSurfaceArea() then
		Analytics.reportFailure(Analytics.ErrorType.validateTotalSurfaceArea_maxTotalSurfaceAreaExceeded, nil, p2)

		return false, { string.format("The total surface area of model mesh '%s' is %.2f, it cannot be greater than %d. You must reduce the number and/or size of all triangles.", p1.fullName, v13, getFIntMaxTotalSurfaceArea()) }
	end

	Analytics.recordScriptTime(script.Name, timestamp, p2)

	return true
end

return validateTotalSurfaceArea
