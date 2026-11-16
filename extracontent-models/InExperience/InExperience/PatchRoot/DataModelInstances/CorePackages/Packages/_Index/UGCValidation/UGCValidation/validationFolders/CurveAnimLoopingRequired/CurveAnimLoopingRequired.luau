local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

return {
	categories = { ValidationEnums.UploadCategory.ANIMATION },
	requiredData = { ValidationEnums.SharedDataMember.curveAnimations, ValidationEnums.SharedDataMember.uploadEnum },
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable },
	run = function(object, p)
		if p.uploadEnum.assetType == Enum.AssetType.JumpAnimation then
			return
		end

		for _, curveAnimation in p.curveAnimations do
			if not curveAnimation.Loop then
				object:fail(ErrorSourceStrings.Keys.CurveAnim_LoopingNotEnabled, {
					animationName = curveAnimation:GetFullName()
				})
			end
		end
	end
}
