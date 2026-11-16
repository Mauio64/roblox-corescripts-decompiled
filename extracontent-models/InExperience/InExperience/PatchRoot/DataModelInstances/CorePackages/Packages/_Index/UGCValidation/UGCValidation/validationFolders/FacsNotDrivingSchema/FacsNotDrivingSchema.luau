local UGCValidationService = game:GetService("UGCValidationService")
local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local R15plusUtils = require(parent.util.R15plusUtils)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local Constants = require(parent.Constants)
return {
	["fflag"] = require(parent.flags.getFFlagUGCValidationEnableR15plusSkinning),
	categories = { ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	run = function(object, p)
		local jointNameWhitelist = R15plusUtils.getJointNameWhitelist()

		for _, jointName in { UGCValidationService:GetFacsDrivenJointNamesFromEditableMesh(p.renderMeshesData.Head.editable) } do
			if jointNameWhitelist[jointName] or Constants.ALLOWED_SKINNING_TRANSFER_JOINT_NAMES[jointName] then
				object:fail(ErrorSourceStrings.Keys.UnallowedFacsJoints, { jointName = jointName })
			end
		end
	end
}
