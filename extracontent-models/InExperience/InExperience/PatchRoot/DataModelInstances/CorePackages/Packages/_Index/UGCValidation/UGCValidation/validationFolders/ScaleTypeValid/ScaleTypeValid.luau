local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

return {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.EYEBROW_EYELASH,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY
	},
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	expectedFailures = {},
	run = function(object, p)
		local rootInstance = p.rootInstance

		local descendants = rootInstance:GetDescendants()
		table.insert(descendants, rootInstance)

		for _, stringValue in descendants do
			if
				not stringValue:IsA("StringValue")
				or stringValue.Name ~= "AvatarPartScaleType"
				or Constants.AvatarPartScaleTypes[stringValue.Value]
			then
				continue
			end

			local scaleTypeInvalid = ErrorSourceStrings.Keys.ScaleTypeInvalid
			local parentName

			if stringValue.Parent then
				parentName = stringValue.Parent.Name
			else
				parentName = stringValue.Name
			end

			object:fail(scaleTypeInvalid, { ParentName = parentName })
		end
	end
}
