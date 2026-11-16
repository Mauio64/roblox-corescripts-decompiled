local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent

local Analytics = require(parent.Analytics)

local getFIntUGCValidateRenderMeshInsideOuterCageMeshThreshold = require(parent.flags.getFIntUGCValidateRenderMeshInsideOuterCageMeshThreshold)

require(parent.util.Types)
local pcallDeferred = require(parent.util.pcallDeferred)

local function validateRenderMeshInsideOuterCageMesh(p, p2, p3, p4)
	local now = tick()

	local v, v2 = pcallDeferred(function()
		return UGCValidationService:CalculateEditableMeshInsideMeshPercentage(
			p2.editableMesh,
			p3.editableMesh,
			p.CageOrigin:Inverse(),
			Vector3.new(1, 1, 1)
		)
	end, p4)

	if v then
		local v3 = v2 * 100

		if v3 < getFIntUGCValidateRenderMeshInsideOuterCageMeshThreshold() then
			Analytics.reportFailure(
				Analytics.ErrorType.validateRenderMeshInsideOuterCageMesh_MaxOutsideCageMeshExceeded,
				nil,
				p4
			)

			return
				false,
				{ string.format(
						"Validation detected %d%% of the accessory is outside its outer cage. Make adjustments to have more of the accessory placed between the cages",
						100 - math.floor(v3)
					) .. "[Read more](https://create.roblox.com/docs/art/validation-errors#cageInsideMesh)" }
		end

		Analytics.recordScriptTime(script.Name, now, p4)
		return true
	else
		local v3 = string.format(
			"Failed to execute render mesh inside outer mesh check for '%s' and '%s'. Make sure the meshes exists and try again.",
			p2.fullName,
			p3.fullName
		)

		if p4.isServer then
			error(v3)
		end

		Analytics.reportFailure(Analytics.ErrorType.validateRenderMeshInsideOuterCageMesh_FailedToExecute, nil, p4)

		return false, { v3 }
	end
end

return validateRenderMeshInsideOuterCageMesh
