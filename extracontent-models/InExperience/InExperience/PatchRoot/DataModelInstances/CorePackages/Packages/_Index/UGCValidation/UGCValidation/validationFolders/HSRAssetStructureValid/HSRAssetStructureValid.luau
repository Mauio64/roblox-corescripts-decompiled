local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

return {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.EYEBROW_EYELASH
	},
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	expectedFailures = {},
	run = function(object, p)
		if
			p.consumerConfig.consumerEnv == ValidationEnums.ConsumerEnv.IEC
			or p.consumerConfig.source == "AutoSetup"
		then
			return
		end

		local rootInstance = p.rootInstance

		local descendants = rootInstance:GetDescendants()
		table.insert(descendants, rootInstance)

		for _, baseWrap in descendants do
			if not baseWrap:IsA("BaseWrap") or baseWrap:IsHSRReady() then
				continue
			end

			object:fail(ErrorSourceStrings.Keys.HSRDataNotReady, {
				InstancePath = baseWrap:GetFullName()
			})
		end
	end
}
