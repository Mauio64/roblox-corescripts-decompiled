local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateCurveAnim = require(ParentParent.flags.getFFlagUGCValidateMigrateCurveAnim)
local getFFlagUGCValidateCurveAnimMinTimeFix = require(ParentParent.flags.getFFlagUGCValidateCurveAnimMinTimeFix)
local GetFStringUGCValidateCurveAnimationMinLength = require(ParentParent.flags.GetFStringUGCValidateCurveAnimationMinLength)
local GetFStringUGCValidationMaxAnimationLength = require(ParentParent.flags.GetFStringUGCValidationMaxAnimationLength)
local getFFlagUGCValidationAnimationPackSupport = require(ParentParent.flags.getFFlagUGCValidationAnimationPackSupport)
local t1 = {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION }
}

if getFFlagUGCValidationAnimationPackSupport() then
	table.insert(t1.categories, ValidationEnums.UploadCategory.ANIMATION)
end

t1.requiredData = {
	ValidationEnums.SharedDataMember.curveAnimations,
	ValidationEnums.SharedDataMember.curveAnimComputedFrames
}
t1.fflag = getFFlagUGCValidateMigrateCurveAnim
t1.expectedFailures = {}
t1.prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }

function t1.run(p1, p2) -- line: 27
	-- upvalues: getFFlagUGCValidateCurveAnimMinTimeFix (copy), GetFStringUGCValidateCurveAnimationMinLength (copy), GetFStringUGCValidationMaxAnimationLength (copy), ErrorSourceStrings (copy)
	local animLength = p2.curveAnimComputedFrames.animLength
	local v13 = not getFFlagUGCValidateCurveAnimMinTimeFix() and 0 or GetFStringUGCValidateCurveAnimationMinLength.asNumber()

	if animLength <= v13 or animLength > GetFStringUGCValidationMaxAnimationLength.asNumber() then
		p1:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidLength, {
			minLength = tostring(v13),
			maxLength = GetFStringUGCValidationMaxAnimationLength.asString()
		})
	end
end

return t1
