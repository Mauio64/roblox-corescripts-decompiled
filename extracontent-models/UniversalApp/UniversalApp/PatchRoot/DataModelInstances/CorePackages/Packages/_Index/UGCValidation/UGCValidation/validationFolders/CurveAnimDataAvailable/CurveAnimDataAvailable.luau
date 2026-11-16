local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local FetchAllDesiredData = require(parent.validationSystem.dataFetchModules.FetchAllDesiredData)

return {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION, ValidationEnums.UploadCategory.ANIMATION },
	requiredData = {},
	expectedFailures = {},
	run = function(object, p)
		local curveAnimations = p.curveAnimations

		if not curveAnimations or curveAnimations == FetchAllDesiredData.DATA_FETCH_FAILURE then
			object:fail(ErrorSourceStrings.Keys.CurveAnim_FetchFailed)
			return
		end

		if #curveAnimations == 0 then
			object:fail(ErrorSourceStrings.Keys.CurveAnim_NotCurveAnimation)
			return
		end

		local curveAnimComputedFrames = p.curveAnimComputedFrames

		if curveAnimComputedFrames and curveAnimComputedFrames ~= FetchAllDesiredData.DATA_FETCH_FAILURE then
			return
		end

		object:fail(ErrorSourceStrings.Keys.CurveAnim_FetchFailed)
	end
}
