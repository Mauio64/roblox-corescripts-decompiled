local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateCurveAnim = require(ParentParent.flags.getFFlagUGCValidateMigrateCurveAnim)
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

function t1.run(p1, p2) -- line: 24
	-- upvalues: ErrorSourceStrings (copy)
	for _, v10 in p2.curveAnimComputedFrames.tracks do
		if v10.pos or v10.rot then
			return
		end
	end

	p1:fail(ErrorSourceStrings.Keys.CurveAnim_NoJointManipulation)
end

return t1
