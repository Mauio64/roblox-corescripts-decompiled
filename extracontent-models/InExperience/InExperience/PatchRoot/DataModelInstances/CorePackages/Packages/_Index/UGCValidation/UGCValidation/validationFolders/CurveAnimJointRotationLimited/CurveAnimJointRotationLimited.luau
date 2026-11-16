local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFIntUGCValidateMaxAnimationFPS = require(parent.flags.getFIntUGCValidateMaxAnimationFPS)

local GetFStringUGCValidateMaxJointRotationPerPart = require(script.Parent.GetFStringUGCValidateMaxJointRotationPerPart)

return {
	categories = { ValidationEnums.UploadCategory.ANIMATION },
	requiredData = {
		ValidationEnums.SharedDataMember.curveAnimations,
		ValidationEnums.SharedDataMember.curveAnimComputedFrames
	},
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable },
	run = function(object, p)
		local curveAnimComputedFrames = p.curveAnimComputedFrames
		local animLength = curveAnimComputedFrames.animLength
		local tracks = curveAnimComputedFrames.tracks
		local v = 1 / getFIntUGCValidateMaxAnimationFPS()

		local v2 = {}

		for k, track in tracks do
			if not track.rot then
				continue
			end

			local bodyPart = tostring(k)

			if not v2[bodyPart] then
				v2[bodyPart] = GetFStringUGCValidateMaxJointRotationPerPart.asNumber(bodyPart)
			end

			local v3 = v2[bodyPart]
			local total = 0

			while total <= animLength do
				local _, v4 = track.rot:GetRotationAtTime(total):ToAxisAngle()
				local v5 = math.deg((math.abs(v4)))

				if v3 < v5 then
					object:fail(ErrorSourceStrings.Keys.CurveAnim_JointRotationExceeded, {
						time = string.format("%.2f", total),
						bodyPart = bodyPart,
						rotation = string.format("%.2f", v5),
						maxRotation = tostring(v3)
					})

					return
				end

				total += v
			end

			if not (animLength >= 0) then
				continue
			end

			local _, v4 = track.rot:GetRotationAtTime(animLength):ToAxisAngle()
			local v5 = math.deg((math.abs(v4)))

			if v3 < v5 then
				object:fail(ErrorSourceStrings.Keys.CurveAnim_JointRotationExceeded, {
					time = string.format("%.2f", animLength),
					bodyPart = bodyPart,
					rotation = string.format("%.2f", v5),
					maxRotation = tostring(v3)
				})
				break
			end
		end
	end
}
