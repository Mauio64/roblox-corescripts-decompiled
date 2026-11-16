local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getAllInstancesIsA = require(parent.util.getAllInstancesIsA)
local getAllInstancesWithName = require(parent.util.getAllInstancesWithName)
local R15plusUtils = require(parent.util.R15plusUtils)
return {
	categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS, ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	["fflag"] = R15plusUtils.checkFlagEnabledForAllowHrd,
	run = function(object, p)
		for _, v in getAllInstancesIsA(p.rootInstance, "MeshPart") do
			object:setReportingInstance(v)
			local avatarBoneSchema = R15plusUtils.getAvatarBoneSchema(v.Name)
			local nameWhitelistOfClassInSchema = R15plusUtils.getNameWhitelistOfClassInSchema(
				avatarBoneSchema,
				"Attachment"
			)

			for k, v2 in nameWhitelistOfClassInSchema do
				if not v2 then
					continue
				end

				local allInstancesWithName = getAllInstancesWithName(v, k)

				if #allInstancesWithName ~= 1 or allInstancesWithName[1].ClassName ~= "Attachment" then
					object:fail(ErrorSourceStrings.Keys.MissingRequiredAttachment, {
						attName = k,
						partName = v.Name
					})
				end
			end
		end
	end
}
