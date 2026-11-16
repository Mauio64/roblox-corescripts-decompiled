local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

return {
	categories = {
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.EYEBROW_EYELASH,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY,
		ValidationEnums.UploadCategory.EMOTE_ANIMATION,
		ValidationEnums.UploadCategory.MAKEUP
	},
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	expectedFailures = {},
	run = function(object, p)
		local rootInstance = p.rootInstance

		if Constants.BANNED_NAMES[rootInstance.Name] then
			object:fail(ErrorSourceStrings.Keys.InstanceTreeBannedName, {
				InstancePath = rootInstance:GetFullName()
			})
		end

		for _, descendant in rootInstance:GetDescendants() do
			for _, className in Constants.BANNED_CLASS_NAMES do
				if descendant:IsA(className) then
					object:fail(ErrorSourceStrings.Keys.InstanceTreeBannedClass, {
						InstancePath = descendant:GetFullName(),
						ClassName = className
					})
				end
			end

			if Constants.BANNED_NAMES[descendant.Name] then
				object:fail(ErrorSourceStrings.Keys.InstanceTreeBannedName, {
					InstancePath = descendant:GetFullName()
				})
			end
		end
	end
}
