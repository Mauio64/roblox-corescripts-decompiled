local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFIntUniqueUVTolerance = require(parent.flags.getFIntUniqueUVTolerance)

return {
	categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS, ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.outerCagesData },
	conditionalData = {},
	expectedFailures = {},
	run = function(object, p)
		for k, v in p.outerCagesData do
			local v2 = Constants.WRAP_TARGET_CAGE_MESH_UV_COUNTS[k]

			if not v2 then
				continue
			end

			local editableMeshUniqueUVCount = UGCValidationService:CalculateEditableMeshUniqueUVCount(v.editable)

			if math.abs(editableMeshUniqueUVCount - v2) > getFIntUniqueUVTolerance() then
				object:fail(ErrorSourceStrings.Keys.CageUV_IncorrectUVCount, {
					partName = k,
					requiredUVCount = tostring(v2),
					actualUVCount = tostring(editableMeshUniqueUVCount)
				})
			end
		end
	end
}
