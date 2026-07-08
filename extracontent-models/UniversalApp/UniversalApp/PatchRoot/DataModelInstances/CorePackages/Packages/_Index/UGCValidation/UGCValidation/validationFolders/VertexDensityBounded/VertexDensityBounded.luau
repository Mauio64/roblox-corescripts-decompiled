local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFIntUGCValidationVertexDensityThreshold = require(ParentParent.flags.getFIntUGCValidationVertexDensityThreshold)

return {
	fflag = require(ParentParent.flags.getFFlagUGCValidateMigrateMeshGeometry),
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {},
	run = function(p1, p2) -- line: 19
		-- upvalues: UGCValidationService (copy), getFIntUGCValidationVertexDensityThreshold (copy), ErrorSourceStrings (copy)
		for _, v9 in p2.renderMeshesData do
			if UGCValidationService:GetEditableMeshMaxNearbyVerticesCollisions(v9.editable, v9.scale) > getFIntUGCValidationVertexDensityThreshold() then
				p1:fail(ErrorSourceStrings.Keys.MeshGeometry_VertexDensityExceeded, {})
			end
		end
	end
}
