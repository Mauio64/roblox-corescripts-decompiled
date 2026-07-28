local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
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
	run = function(p1, p2) -- line: 16
		-- upvalues: getAllInstancesIsA (copy), R15plusUtils (copy), getAllInstancesWithName (copy), ErrorSourceStrings (copy)
		local rootInstance = p2.rootInstance

		for _, v11 in getAllInstancesIsA(rootInstance, "MeshPart") do
			p1:setReportingInstance(v11)

			local v12 = R15plusUtils.getAvatarBoneSchema(v11.Name)

			for v13, v14 in (R15plusUtils.getNameWhitelistOfClassInSchema(v12, "Attachment")) do
				if v14 then
					local v15 = getAllInstancesWithName(v11, v13)

					if #v15 ~= 1 or v15[1].ClassName ~= "Attachment" then
						p1:fail(ErrorSourceStrings.Keys.MissingRequiredAttachment, {
							attName = v13,
							partName = v11.Name
						})
					end
				end
			end
		end
	end
}
