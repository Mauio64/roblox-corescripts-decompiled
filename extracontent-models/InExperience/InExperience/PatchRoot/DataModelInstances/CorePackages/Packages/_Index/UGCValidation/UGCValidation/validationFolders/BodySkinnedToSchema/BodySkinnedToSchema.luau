local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)

return {
	fflag = require(ParentParent.flags.getFFlagUGCValidationEnableR15plusSkinning),
	categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	run = function(p1, p2) -- line: 13
		-- upvalues: R15plusUtils (copy), UGCValidationService (copy), ErrorSourceStrings (copy)
		local v8 = R15plusUtils.getJointNameWhitelist()

		for v9, v10 in p2.renderMeshesData do
			for _, v12 in { UGCValidationService:GetSkinnedJointNamesFromEditableMesh(v10.editable) } do
				if not v8[v12] then
					p1:fail(ErrorSourceStrings.Keys.UnallowedJointSkinned, {
						partName = v9,
						jointName = v12
					})
				end
			end
		end
	end
}
