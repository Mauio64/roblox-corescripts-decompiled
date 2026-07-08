local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidationAnimationPackSupport = require(ParentParent.flags.getFFlagUGCValidationAnimationPackSupport)

return {
	categories = { ValidationEnums.UploadCategory.ANIMATION },
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.uploadEnum
	},
	fflag = getFFlagUGCValidationAnimationPackSupport,
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.ExpectedRootSchema },
	run = function(p1, p2) -- line: 20
		-- upvalues: ErrorSourceStrings (copy)
		if p2.uploadEnum.assetType ~= Enum.AssetType.IdleAnimation then
			return
		end

		for _, descendant in p2.rootInstance:GetDescendants() do
			if descendant:IsA("NumberValue") and descendant.Name == "Weight" then
				local descendantValue = descendant.Value

				if descendantValue <= 0 then
					p1:fail(ErrorSourceStrings.Keys.Animation_WeightNotPositive, {
						animationName = not descendant.Parent and "Unknown" or descendant.Parent:GetFullName(),
						weight = tostring(descendantValue)
					})
				end
			end
		end
	end
}
