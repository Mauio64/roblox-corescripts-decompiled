local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFFlagUGCValidateFacsJointCountBounded = require(parent.flags.getFFlagUGCValidateFacsJointCountBounded)
local getFIntUGCValidateFacsJointCountMaximum = require(parent.flags.getFIntUGCValidateFacsJointCountMaximum)

return {
	categories = { ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	["fflag"] = getFFlagUGCValidateFacsJointCountBounded,
	expectedFailures = { "Asset_EF_DynamicHeadExcessiveFacs" },
	run = function(object, p)
		local count = #p.renderMeshesData.Head.editable:GetBones()
		local fIntUGCValidateFacsJointCountMaximum = getFIntUGCValidateFacsJointCountMaximum()

		if fIntUGCValidateFacsJointCountMaximum < count then
			object:fail(ErrorSourceStrings.Keys.FacsJointCountBounded, {
				maxFacsJointCount = string.format("%d", fIntUGCValidateFacsJointCountMaximum),
				actualJointCount = string.format("%d", count)
			})
		end
	end
}
