local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateCurveAnim = require(ParentParent.flags.getFFlagUGCValidateMigrateCurveAnim)
local GetFStringUGCValidateMaxAnimationMovementPerPart = require(ParentParent.flags.GetFStringUGCValidateMaxAnimationMovementPerPart)
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
	-- upvalues: Constants (copy), GetFStringUGCValidateMaxAnimationMovementPerPart (copy), ErrorSourceStrings (copy)
	local t2 = {}

	for _, v13 in p2.curveAnimComputedFrames.positionMagnitudeFrames do
		for v14, v15 in v13 do
			if v14 == Constants.NAMED_R15_BODY_PARTS.LowerTorso then
				continue
			end

			if not t2[v14] then
				t2[v14] = GetFStringUGCValidateMaxAnimationMovementPerPart.asNumber(v14)
			end

			if v15 > t2[v14] then
				p1:fail(ErrorSourceStrings.Keys.CurveAnim_PositionSeparation, {
					bodyPart = v14,
					maxMovement = tostring(t2[v14])
				})

				return
			end
		end
	end
end

return t1
