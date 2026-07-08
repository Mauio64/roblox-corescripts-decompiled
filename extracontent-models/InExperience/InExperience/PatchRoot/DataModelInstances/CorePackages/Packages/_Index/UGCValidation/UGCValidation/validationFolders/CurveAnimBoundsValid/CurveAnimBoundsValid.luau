local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateCurveAnim = require(ParentParent.flags.getFFlagUGCValidateMigrateCurveAnim)
local getFFlagUGCValidateCurveAnimTimeErrorMessageFix = require(ParentParent.flags.getFFlagUGCValidateCurveAnimTimeErrorMessageFix)
local GetFStringUGCValidateAnimationHeightTol = require(ParentParent.flags.GetFStringUGCValidateAnimationHeightTol)
local GetFStringUGCValidationMaxAnimationBounds = require(ParentParent.flags.GetFStringUGCValidationMaxAnimationBounds)
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

function t1.run(p1, p2) -- line: 29
	-- upvalues: getFIntUGCValidateMaxAnimationFPS (copy), getFFlagUGCValidateCurveAnimTimeErrorMessageFix (copy), GetFStringUGCValidateAnimationHeightTol (copy), GetFStringUGCValidationMaxAnimationBounds (copy), ErrorSourceStrings (copy)
	local curveAnimComputedFrames = p2.curveAnimComputedFrames
	local animFrames = curveAnimComputedFrames.animFrames
	local animLength = curveAnimComputedFrames.animLength
	local v16 = 1 / getFIntUGCValidateMaxAnimationFPS()

	if getFFlagUGCValidateCurveAnimTimeErrorMessageFix() then
		local v17 = GetFStringUGCValidateAnimationHeightTol.asNumber()
		local v18 = GetFStringUGCValidationMaxAnimationBounds.asNumber()

		for v19, v20 in animFrames do
			for v21, v22 in v20 do
				if v17 > v22.Position.Y then
					p1:fail(ErrorSourceStrings.Keys.CurveAnim_PartTooLow, {
						time = string.format("%.2f", (math.min(animLength, (v19 - 1) * v16))),
						bodyPart = v21,
						height = string.format("%.2f", v22.Position.Y),
						minHeight = GetFStringUGCValidateAnimationHeightTol.asString()
					})

					return
				end

				if v18 < v22.Position.Magnitude then
					p1:fail(ErrorSourceStrings.Keys.CurveAnim_PartTooFar, {
						time = string.format("%.2f", (math.min(animLength, (v19 - 1) * v16))),
						bodyPart = v21,
						distance = string.format("%.2f", v22.Position.Magnitude),
						maxDistance = GetFStringUGCValidationMaxAnimationBounds.asString()
					})

					return
				end
			end
		end

		return
	end

	local n1 = 1e999
	local n2 = 0

	for _, v26 in animFrames do
		for _, v28 in v26 do
			n2 = math.max(n2, v28.Position.Magnitude)
			n1 = math.min(n1, v28.Position.Y)
		end
	end

	if n1 < GetFStringUGCValidateAnimationHeightTol.asNumber() then
		p1:fail(ErrorSourceStrings.Keys.CurveAnim_BoundsExceeded, {
			minHeight = GetFStringUGCValidateAnimationHeightTol.asString(),
			maxDistance = GetFStringUGCValidationMaxAnimationBounds.asString()
		})
	end

	if n2 > GetFStringUGCValidationMaxAnimationBounds.asNumber() then
		p1:fail(ErrorSourceStrings.Keys.CurveAnim_BoundsExceeded, {
			minHeight = GetFStringUGCValidateAnimationHeightTol.asString(),
			maxDistance = GetFStringUGCValidationMaxAnimationBounds.asString()
		})
	end
end

return t1
