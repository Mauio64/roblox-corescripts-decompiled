local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local getFIntUGCValidateRenderMeshInsideOuterCageMeshThreshold = require(ParentParent.flags.getFIntUGCValidateRenderMeshInsideOuterCageMeshThreshold)

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)

local function validateRenderMeshInsideOuterCageMesh(p1, p2, p3, p4) -- line: 17
	-- upvalues: pcallDeferred (copy), UGCValidationService (copy), Analytics (copy), getFIntUGCValidateRenderMeshInsideOuterCageMeshThreshold (copy)
	local timestamp = tick()
	local v12, v13 = pcallDeferred(function() -- line: 28
		-- upvalues: UGCValidationService (copy), p2 (copy), p3 (copy), p1 (copy)
		return UGCValidationService:CalculateEditableMeshInsideMeshPercentage(p2.editableMesh, p3.editableMesh, p1.CageOrigin:Inverse(), (Vector3.new(1, 1, 1)))
	end, p4)

	if not v12 then
		local v14 = string.format("Failed to execute render mesh inside outer mesh check for '%s' and '%s'. Make sure the meshes exists and try again.", p2.fullName, p3.fullName)

		if p4.isServer then
			error(v14)
		end

		Analytics.reportFailure(Analytics.ErrorType.validateRenderMeshInsideOuterCageMesh_FailedToExecute, nil, p4)

		return false, { v14 }
	end

	local v15 = v13 * 100

	if v15 < getFIntUGCValidateRenderMeshInsideOuterCageMeshThreshold() then
		Analytics.reportFailure(Analytics.ErrorType.validateRenderMeshInsideOuterCageMesh_MaxOutsideCageMeshExceeded, nil, p4)

		return false, { string.format("Validation detected %d%% of the accessory is outside its outer cage. Make adjustments to have more of the accessory placed between the cages", 100 - math.floor(v15)) .. "[Read more](https://create.roblox.com/docs/art/validation-errors#cageInsideMesh)" }
	end

	Analytics.recordScriptTime(script.Name, timestamp, p4)

	return true
end

return validateRenderMeshInsideOuterCageMesh
