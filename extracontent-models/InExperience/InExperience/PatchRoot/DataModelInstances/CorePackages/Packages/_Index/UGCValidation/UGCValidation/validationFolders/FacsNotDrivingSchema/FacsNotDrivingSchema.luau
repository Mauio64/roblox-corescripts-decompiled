local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local R15plusUtils = require(ParentParent.util.R15plusUtils)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local Constants = require(ParentParent.Constants)

return {
	fflag = require(ParentParent.flags.getFFlagUGCValidationEnableR15plusSkinning),
	categories = { ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	run = function(p1, p2) -- line: 14
		-- upvalues: R15plusUtils (copy), UGCValidationService (copy), Constants (copy), ErrorSourceStrings (copy)
		local v9 = R15plusUtils.getJointNameWhitelist()
		local Head = p2.renderMeshesData.Head

		for _, v12 in { UGCValidationService:GetFacsDrivenJointNamesFromEditableMesh(Head.editable) } do
			if v9[v12] or Constants.ALLOWED_SKINNING_TRANSFER_JOINT_NAMES[v12] then
				p1:fail(ErrorSourceStrings.Keys.UnallowedFacsJoints, {
					jointName = v12
				})
			end
		end
	end
}
