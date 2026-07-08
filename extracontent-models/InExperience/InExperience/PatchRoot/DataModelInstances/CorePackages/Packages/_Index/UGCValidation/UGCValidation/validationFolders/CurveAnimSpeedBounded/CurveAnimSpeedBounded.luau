local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateCurveAnim = require(ParentParent.flags.getFFlagUGCValidateMigrateCurveAnim)
local getFFlagUGCValidateFixCurveAnimFrameTimeErrorMessage = require(ParentParent.flags.getFFlagUGCValidateFixCurveAnimFrameTimeErrorMessage)
local GetFStringUGCValidationMaxAnimationDeltas = require(ParentParent.flags.GetFStringUGCValidationMaxAnimationDeltas)
local getFIntUGCValidateMaxAnimationFPS = require(ParentParent.flags.getFIntUGCValidateMaxAnimationFPS)
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
	-- upvalues: getFIntUGCValidateMaxAnimationFPS (copy), GetFStringUGCValidationMaxAnimationDeltas (copy), getFFlagUGCValidateFixCurveAnimFrameTimeErrorMessage (copy), ErrorSourceStrings (copy)
	local animFrames = p2.curveAnimComputedFrames.animFrames
	local v13 = 1 / getFIntUGCValidateMaxAnimationFPS()
	local v14 = v13 / 0.03333333333333333
	local v15 = GetFStringUGCValidationMaxAnimationDeltas.asNumber() * v14
	local v16 = nil

	if getFFlagUGCValidateFixCurveAnimFrameTimeErrorMessage() then
		v16 = GetFStringUGCValidationMaxAnimationDeltas.asNumber() * 30
	end

	local t2 = {}

	for v18, v19 in animFrames do
		for v20, v21 in v19 do
			local v22 = t2[v20]

			if not v22 then
				continue
			end

			local Magnitude = (v21.Position - v22.Position).Magnitude

			if v15 < Magnitude then
				if getFFlagUGCValidateFixCurveAnimFrameTimeErrorMessage() then
					local v24 = (v18 - 1) * v13
					local v25 = Magnitude / v14 * 30

					p1:fail(ErrorSourceStrings.Keys.CurveAnim_SpeedTooFast, {
						time = string.format("%.2f", v24),
						bodyPart = v20,
						speed = string.format("%.2f", v25),
						maxSpeed = string.format("%.2f", v16)
					})

					return
				end

				p1:fail(ErrorSourceStrings.Keys.CurveAnim_SpeedTooFastLegacy, {
					bodyPart = v20,
					maxMovement = GetFStringUGCValidationMaxAnimationDeltas.asString()
				})

				return
			end
		end

		t2 = v19
	end
end

return t1
