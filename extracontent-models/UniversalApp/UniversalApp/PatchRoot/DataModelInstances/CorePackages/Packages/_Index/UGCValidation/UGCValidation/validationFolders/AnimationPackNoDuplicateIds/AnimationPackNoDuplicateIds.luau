local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

return {
	categories = { ValidationEnums.UploadCategory.ANIMATION_PACK },
	requiredData = { ValidationEnums.SharedDataMember.contentIds },
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.ExpectedRootSchema },
	run = function(object, p)
		for k, contentId in p.contentIds do
			if not (#contentId > 1) then
				continue
			end

			local fullNames = {}

			for _, v in contentId do
				table.insert(fullNames, v.instance:GetFullName())
			end

			object:fail(ErrorSourceStrings.Keys.AnimationPack_DuplicateAnimationId, {
				animationId = k,
				instancePaths = table.concat(fullNames, ", ")
			})
		end
	end
}
