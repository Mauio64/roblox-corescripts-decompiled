local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateSchemaProperties = require(ParentParent.flags.getFFlagUGCValidateMigrateSchemaProperties)

return {
	categories = {
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY,
		ValidationEnums.UploadCategory.EMOTE_ANIMATION,
		ValidationEnums.UploadCategory.MAKEUP
	},
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	fflag = getFFlagUGCValidateMigrateSchemaProperties,
	expectedFailures = {},
	run = function(p1, p2) -- line: 24
		-- upvalues: Constants (copy), ErrorSourceStrings (copy)
		local rootInstance = p2.rootInstance

		if Constants.BANNED_NAMES[rootInstance.Name] then
			p1:fail(ErrorSourceStrings.Keys.InstanceTreeBannedName, {
				InstancePath = rootInstance:GetFullName()
			})
		end

		for _, descendant in rootInstance:GetDescendants() do
			for _, v12 in Constants.BANNED_CLASS_NAMES do
				if descendant:IsA(v12) then
					p1:fail(ErrorSourceStrings.Keys.InstanceTreeBannedClass, {
						InstancePath = descendant:GetFullName(),
						ClassName = v12
					})
				end
			end

			if Constants.BANNED_NAMES[descendant.Name] then
				p1:fail(ErrorSourceStrings.Keys.InstanceTreeBannedName, {
					InstancePath = descendant:GetFullName()
				})
			end
		end
	end
}
