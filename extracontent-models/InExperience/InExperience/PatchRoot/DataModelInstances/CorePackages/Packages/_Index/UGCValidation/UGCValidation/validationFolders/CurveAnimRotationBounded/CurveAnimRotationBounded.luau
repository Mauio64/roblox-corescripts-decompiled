local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateCurveAnim = require(ParentParent.flags.getFFlagUGCValidateMigrateCurveAnim)
local getFFlagUGCValidateCurveAnimRotationSpeed = require(ParentParent.flags.getFFlagUGCValidateCurveAnimRotationSpeed)
local getFIntUGCValidateMaxAnimationFPS = require(ParentParent.flags.getFIntUGCValidateMaxAnimationFPS)
local getFIntUGCValidationMaxAnimationRotationSpeedPerSecond = require(ParentParent.flags.getFIntUGCValidationMaxAnimationRotationSpeedPerSecond)
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

function t1.run(p1, p2) -- line: 28
	-- upvalues: getFFlagUGCValidateCurveAnimRotationSpeed (copy), getFIntUGCValidateMaxAnimationFPS (copy), getFIntUGCValidationMaxAnimationRotationSpeedPerSecond (copy), ErrorSourceStrings (copy)
	if not getFFlagUGCValidateCurveAnimRotationSpeed() then
		return
	end

	local animFrames = p2.curveAnimComputedFrames.animFrames
	local v13 = 1 / getFIntUGCValidateMaxAnimationFPS()
	local v14 = getFIntUGCValidationMaxAnimationRotationSpeedPerSecond()
	local v15 = v14 / getFIntUGCValidateMaxAnimationFPS()
	local t2 = {}

	for v17, v18 in animFrames do
		for v19, v20 in v18 do
			local v21 = t2[v19]

			if not v21 then
				continue
			end

			local v22 = math.deg((math.abs((v20:AngleBetween(v21)))))

			if v15 < v22 then
				local v23 = (v17 - 1) * v13
				local v24 = v22 * getFIntUGCValidateMaxAnimationFPS()

				p1:fail(ErrorSourceStrings.Keys.CurveAnim_RotationTooFast, {
					time = string.format("%.2f", v23),
					bodyPart = v19,
					speed = string.format("%.2f", v24),
					maxSpeed = tostring(v14)
				})

				return
			end
		end

		t2 = v18
	end
end

return t1
