local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateCurveAnimLoopingRequired = require(ParentParent.flags.getFFlagUGCValidateCurveAnimLoopingRequired)

return {
	categories = { ValidationEnums.UploadCategory.ANIMATION },
	requiredData = {
		ValidationEnums.SharedDataMember.curveAnimations,
		ValidationEnums.SharedDataMember.uploadEnum
	},
	fflag = getFFlagUGCValidateCurveAnimLoopingRequired,
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable },
	run = function(p1, p2) -- line: 20
		-- upvalues: ErrorSourceStrings (copy)
		if p2.uploadEnum.assetType == Enum.AssetType.JumpAnimation then
			return
		end

		for _, v8 in p2.curveAnimations do
			if not v8.Loop then
				p1:fail(ErrorSourceStrings.Keys.CurveAnim_LoopingNotEnabled, {
					animationName = v8:GetFullName()
				})
			end
		end
	end
}
