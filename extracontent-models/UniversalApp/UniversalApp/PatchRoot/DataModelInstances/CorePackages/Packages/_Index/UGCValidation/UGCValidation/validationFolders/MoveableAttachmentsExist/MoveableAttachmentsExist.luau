local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getEngineFeatureEngineUGCValidationExpandReturnSchema = require(ParentParent.flags.getEngineFeatureEngineUGCValidationExpandReturnSchema)
local getAllInstancesIsA = require(ParentParent.util.getAllInstancesIsA)
local getAllInstancesWithName = require(ParentParent.util.getAllInstancesWithName)
local R15plusUtils = require(ParentParent.util.R15plusUtils)

return {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	fflag = R15plusUtils.checkFlagEnabledForAllowHrd,
	run = function(p1, p2) -- line: 18
		-- upvalues: getAllInstancesIsA (copy), getEngineFeatureEngineUGCValidationExpandReturnSchema (copy), R15plusUtils (copy), getAllInstancesWithName (copy), ErrorSourceStrings (copy)
		local rootInstance = p2.rootInstance

		for _, v12 in getAllInstancesIsA(rootInstance, "MeshPart") do
			if getEngineFeatureEngineUGCValidationExpandReturnSchema() then
				p1:setReportingInstance(v12)
			end

			local v13 = R15plusUtils.getAvatarBoneSchema(v12.Name)

			for v14, v15 in (R15plusUtils.getNameWhitelistOfClassInSchema(v13, "Attachment")) do
				if v15 then
					local v16 = getAllInstancesWithName(v12, v14)

					if #v16 ~= 1 or v16[1].ClassName ~= "Attachment" then
						p1:fail(ErrorSourceStrings.Keys.MissingRequiredAttachment, {
							attName = v14,
							partName = v12.Name
						})
					end
				end
			end
		end
	end
}
