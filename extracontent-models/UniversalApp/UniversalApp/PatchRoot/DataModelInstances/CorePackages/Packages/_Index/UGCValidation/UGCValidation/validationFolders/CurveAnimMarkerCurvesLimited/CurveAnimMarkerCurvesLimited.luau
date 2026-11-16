local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFIntUGCValidateMaxTotalMarkerCurves = require(parent.flags.getFIntUGCValidateMaxTotalMarkerCurves)
return {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION, ValidationEnums.UploadCategory.ANIMATION },
	requiredData = { ValidationEnums.SharedDataMember.curveAnimations },
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable },
	run = function(object, p)
		local fIntUGCValidateMaxTotalMarkerCurves = getFIntUGCValidateMaxTotalMarkerCurves()

		for _, folder in p.curveAnimations do
			local count = 0

			for _, markerCurve in folder:GetDescendants() do
				if not markerCurve:IsA("MarkerCurve") then
					continue
				end

				count += 1

				if fIntUGCValidateMaxTotalMarkerCurves < count then
					object:fail(ErrorSourceStrings.Keys.CurveAnim_TooManyMarkerCurves, {
						maxAllowed = tostring(fIntUGCValidateMaxTotalMarkerCurves)
					})

					return
				end
			end
		end
	end
}
