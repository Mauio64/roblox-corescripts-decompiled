local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFIntUGCValidationVertexDensityThreshold = require(parent.flags.getFIntUGCValidationVertexDensityThreshold)
return {
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING, ValidationEnums.UploadCategory.EYEBROW_EYELASH },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {},
	run = function(object, p)
		for _, v in p.renderMeshesData do
			if not (UGCValidationService:GetEditableMeshMaxNearbyVerticesCollisions(v.editable, v.scale) > getFIntUGCValidationVertexDensityThreshold()) then
				continue
			end

			object:fail(ErrorSourceStrings.Keys.MeshGeometry_VertexDensityExceeded, {})
		end
	end
}
