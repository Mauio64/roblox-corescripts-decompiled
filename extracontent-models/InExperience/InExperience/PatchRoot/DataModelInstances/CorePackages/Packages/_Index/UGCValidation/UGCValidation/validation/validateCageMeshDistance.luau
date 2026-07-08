local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)
local getFIntUGCValidateCageMeshDistanceThreshold = require(ParentParent.flags.getFIntUGCValidateCageMeshDistanceThreshold)

local function validateCageMeshDistance(p1, p2, p3, cFrame: CFrame, cFrame2: CFrame, p4) -- line: 16
	-- upvalues: pcallDeferred (copy), UGCValidationService (copy), Analytics (copy), getFIntUGCValidateCageMeshDistanceThreshold (copy)
	local v13, v14 = pcallDeferred(function() -- line: 24
		-- upvalues: UGCValidationService (copy), p1 (copy), p2 (copy), p3 (copy), cFrame (copy), cFrame2 (copy)
		return UGCValidationService:CalculateAverageEditableCageMeshDistance(p1.editableMesh, p2.editableMesh, p3.editableMesh, cFrame, cFrame2)
	end, p4)

	if not v13 then
		Analytics.reportFailure(Analytics.ErrorType.validateCageMeshDistance_FailedToExecute, nil, p4)

		return false, { string.format("Failed to execute cage mesh distance validation for '%s'. Make sure the cage mesh exists and try again.", p3.fullName) }
	end

	local t1 = {}
	local v16 = true

	if v14 * 100 > getFIntUGCValidateCageMeshDistanceThreshold() or v14 < 0 then
		v16 = false
		Analytics.reportFailure(Analytics.ErrorType.validateCageMeshDistance_OuterCageToMeshDistance, nil, p4)

		if v14 < 0 then
			table.insert(t1, "Average distance between outer cage to mesh is too high. Mesh seems to be outside of the outer cage." .. "[Read more](https://create.roblox.com/docs/art/validation-errors#cageMeshDistance)")
		else
			table.insert(t1, string.format("Average distance between outer cage to mesh is too high (%.2f). Make adjustment to cage to fit the mesh better.", v14) .. "[Read more](https://create.roblox.com/docs/art/validation-errors#cageMeshDistance)")
		end
	end

	return v16, t1
end

return validateCageMeshDistance
