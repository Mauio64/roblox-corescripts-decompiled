local UGCValidationService = game:GetService("UGCValidationService")
local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local R15plusUtils = require(parent.util.R15plusUtils)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
return {
	["fflag"] = require(parent.flags.getFFlagUGCValidationEnableR15plusSkinning),
	categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	run = function(object, p)
		local jointNameWhitelist = R15plusUtils.getJointNameWhitelist()

		for k, v in p.renderMeshesData do
			for _, jointName in { UGCValidationService:GetSkinnedJointNamesFromEditableMesh(v.editable) } do
				if not jointNameWhitelist[jointName] then
					object:fail(ErrorSourceStrings.Keys.UnallowedJointSkinned, {
						partName = k,
						jointName = jointName
					})
				end
			end
		end
	end
}
