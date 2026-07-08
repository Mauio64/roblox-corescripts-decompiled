local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local FetchAllDesiredData = require(ParentParent.validationSystem.dataFetchModules.FetchAllDesiredData)
local getFFlagUGCValidateMigrateCurveAnim = require(ParentParent.flags.getFFlagUGCValidateMigrateCurveAnim)
local getFFlagUGCValidationAnimationPackSupport = require(ParentParent.flags.getFFlagUGCValidationAnimationPackSupport)
local t1 = {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION }
}

if getFFlagUGCValidationAnimationPackSupport() then
	table.insert(t1.categories, ValidationEnums.UploadCategory.ANIMATION)
end

t1.requiredData = {}
t1.fflag = getFFlagUGCValidateMigrateCurveAnim
t1.expectedFailures = {}

function t1.run(p1, p2) -- line: 21
	-- upvalues: FetchAllDesiredData (copy), ErrorSourceStrings (copy)
	local curveAnimations = p2.curveAnimations

	if not curveAnimations or curveAnimations == FetchAllDesiredData.DATA_FETCH_FAILURE then
		p1:fail(ErrorSourceStrings.Keys.CurveAnim_FetchFailed)

		return
	end

	if #curveAnimations == 0 then
		p1:fail(ErrorSourceStrings.Keys.CurveAnim_NotCurveAnimation)

		return
	end

	local curveAnimComputedFrames = p2.curveAnimComputedFrames

	if not curveAnimComputedFrames or curveAnimComputedFrames == FetchAllDesiredData.DATA_FETCH_FAILURE then
		p1:fail(ErrorSourceStrings.Keys.CurveAnim_FetchFailed)

		return
	end
end

return t1
