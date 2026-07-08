local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)

return {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY
	},
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	fflag = getFFlagUGCValidateMigrateSchemaProperties,
	expectedFailures = {},
	run = function(p1, p2) -- line: 24
		-- upvalues: Constants (copy), ErrorSourceStrings (copy)
		local rootInstance = p2.rootInstance
		local descendants = rootInstance:GetDescendants()

		table.insert(descendants, rootInstance)

		for _, v11 in descendants do
			if v11:IsA("StringValue") and v11.Name == "AvatarPartScaleType" and not Constants.AvatarPartScaleTypes[v11.Value] then
				p1:fail(ErrorSourceStrings.Keys.ScaleTypeInvalid, {
					ParentName = if not v11.Parent then v11.Name else v11.Parent.Name
				})
			end
		end
	end
}
