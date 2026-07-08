local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateCageUV = require(ParentParent.flags.getFFlagUGCValidateMigrateCageUV)
local getFIntUniqueUVTolerance = require(ParentParent.flags.getFIntUniqueUVTolerance)

return {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	requiredData = { ValidationEnums.SharedDataMember.outerCagesData },
	conditionalData = {},
	fflag = getFFlagUGCValidateMigrateCageUV,
	expectedFailures = {},
	run = function(p1, p2) -- line: 38
		-- upvalues: Constants (copy), UGCValidationService (copy), getFIntUniqueUVTolerance (copy), ErrorSourceStrings (copy)
		for v10, v11 in p2.outerCagesData do
			local v12 = Constants.WRAP_TARGET_CAGE_MESH_UV_COUNTS[v10]

			if v12 then
				local v13 = UGCValidationService:CalculateEditableMeshUniqueUVCount(v11.editable)

				if math.abs(v13 - v12) > getFIntUniqueUVTolerance() then
					p1:fail(ErrorSourceStrings.Keys.CageUV_IncorrectUVCount, {
						partName = v10,
						requiredUVCount = tostring(v12),
						actualUVCount = tostring(v13)
					})
				end
			end
		end
	end
}
