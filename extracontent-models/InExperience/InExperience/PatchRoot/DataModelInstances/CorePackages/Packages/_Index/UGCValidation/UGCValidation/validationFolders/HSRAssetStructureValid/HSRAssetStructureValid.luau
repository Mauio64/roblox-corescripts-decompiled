local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)

return {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.LAYERED_CLOTHING
	},
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	fflag = getFFlagUGCValidateMigrateSchemaProperties,
	expectedFailures = {},
	run = function(p1, p2) -- line: 22
		-- upvalues: ValidationEnums (copy), ErrorSourceStrings (copy)
		if p2.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.IEC or p2.consumerConfig.source == "AutoSetup" then
			return
		end

		local rootInstance = p2.rootInstance
		local descendants = rootInstance:GetDescendants()

		table.insert(descendants, rootInstance)

		for _, v10 in descendants do
			if v10:IsA("BaseWrap") and not v10:IsHSRReady() then
				p1:fail(ErrorSourceStrings.Keys.HSRDataNotReady, {
					InstancePath = v10:GetFullName()
				})
			end
		end
	end
}
