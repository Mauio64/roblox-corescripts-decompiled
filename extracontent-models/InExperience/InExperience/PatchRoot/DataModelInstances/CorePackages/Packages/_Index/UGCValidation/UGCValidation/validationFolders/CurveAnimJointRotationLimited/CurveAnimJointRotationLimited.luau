local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFIntUGCValidateMaxAnimationFPS = require(ParentParent.flags.getFIntUGCValidateMaxAnimationFPS)
local getFFlagUGCValidationAnimationPackSupport = require(ParentParent.flags.getFFlagUGCValidationAnimationPackSupport)
local GetFStringUGCValidateMaxJointRotationPerPart = require(script.Parent.GetFStringUGCValidateMaxJointRotationPerPart)

return {
	categories = { ValidationEnums.UploadCategory.ANIMATION },
	requiredData = {
		ValidationEnums.SharedDataMember.curveAnimations,
		ValidationEnums.SharedDataMember.curveAnimComputedFrames
	},
	fflag = getFFlagUGCValidationAnimationPackSupport,
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable },
	run = function(p1, p2) -- line: 23
		-- upvalues: getFIntUGCValidateMaxAnimationFPS (copy), GetFStringUGCValidateMaxJointRotationPerPart (copy), ErrorSourceStrings (copy)
		local curveAnimComputedFrames = p2.curveAnimComputedFrames
		local animLength = curveAnimComputedFrames.animLength
		local tracks = curveAnimComputedFrames.tracks
		local v12 = 1 / getFIntUGCValidateMaxAnimationFPS()
		local t1 = {}

		for v14, v15 in tracks do
			if not v15.rot then
				continue
			end

			local str = tostring(v14)

			if not t1[str] then
				t1[str] = GetFStringUGCValidateMaxJointRotationPerPart.asNumber(str)
			end

			local v17 = t1[str]
			local n1 = 0

			while n1 <= animLength do
				local _, v20 = v15.rot:GetRotationAtTime(n1):ToAxisAngle()
				local v21 = math.deg((math.abs(v20)))

				if v17 < v21 then
					p1:fail(ErrorSourceStrings.Keys.CurveAnim_JointRotationExceeded, {
						time = string.format("%.2f", n1),
						bodyPart = str,
						rotation = string.format("%.2f", v21),
						maxRotation = tostring(v17)
					})

					return
				end

				n1 += v12
			end

			if animLength >= 0 then
				local _, v23 = v15.rot:GetRotationAtTime(animLength):ToAxisAngle()
				local v24 = math.deg((math.abs(v23)))

				if not (v17 < v24) then
					continue
				end

				p1:fail(ErrorSourceStrings.Keys.CurveAnim_JointRotationExceeded, {
					time = string.format("%.2f", animLength),
					bodyPart = str,
					rotation = string.format("%.2f", v24),
					maxRotation = tostring(v17)
				})

				return
			end
		end
	end
}
