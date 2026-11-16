local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local GetFStringUGCValidationMaxAnimationLength = require(parent.flags.GetFStringUGCValidationMaxAnimationLength)
local GetFStringUGCValidateFrameDeltaKeyTimeTol = require(parent.flags.GetFStringUGCValidateFrameDeltaKeyTimeTol)
local getFIntUGCValidateMaxAnimationFPS = require(parent.flags.getFIntUGCValidateMaxAnimationFPS)
local getFIntUGCValidateMaxMarkerCurveValueLength = require(parent.flags.getFIntUGCValidateMaxMarkerCurveValueLength)
local getFIntUGCValidateMaxTotalInternalMarkers = require(parent.flags.getFIntUGCValidateMaxTotalInternalMarkers)
local CurveAnimNumericalDataValid = {}

CurveAnimNumericalDataValid.categories = {
	ValidationEnums.UploadCategory.EMOTE_ANIMATION,
	ValidationEnums.UploadCategory.ANIMATION
}
CurveAnimNumericalDataValid.requiredData = { ValidationEnums.SharedDataMember.curveAnimations }

CurveAnimNumericalDataValid.expectedFailures = {}
CurveAnimNumericalDataValid.prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }

local function areNumbersGood(...): boolean
	local function isNaN(p: number): boolean -- 1 equivalent call inferred from this helper
		return p ~= p
	end

	local function isInfinite(p: number): boolean -- 1 equivalent call inferred from this helper
		return p == 1e999 or p == -1e999
	end

	for _, v in { ... } do
		if isNaN(v) or isInfinite(v) then -- inferred equivalent call
			return false
		end
	end

	return true
end

function CurveAnimNumericalDataValid.run(object, p)
	local v = 1 / getFIntUGCValidateMaxAnimationFPS() * GetFStringUGCValidateFrameDeltaKeyTimeTol.asNumber()
	local v2 = math.ceil(1 / v * GetFStringUGCValidationMaxAnimationLength.asNumber())

	for _, folder in p.curveAnimations do
		for _, descendant in folder:GetDescendants() do
			if descendant:IsA("MarkerCurve") then
				local markers = descendant:GetMarkers()
				local v3 = math.min(getFIntUGCValidateMaxTotalInternalMarkers(), v2)

				if v3 < #markers then
					object:fail(ErrorSourceStrings.Keys.CurveAnim_TooManyMarkers, {
						count = tostring(#markers),
						maxAllowed = tostring(v3)
					})

					return
				end

				for _, marker in markers do
					if
						not marker.Time
						or not areNumbersGood(marker.Time)
						or not marker.Value
						or #marker.Value > getFIntUGCValidateMaxMarkerCurveValueLength()
					then
						object:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidMarkerData)
						return
					end
				end
			elseif descendant:IsA("FloatCurve") then
				local keys = descendant:GetKeys()

				if v2 < #keys then
					object:fail(ErrorSourceStrings.Keys.CurveAnim_TooManyKeys, {
						maxAllowed = tostring(v2)
					})

					return
				end

				local time = nil

				for _, key in keys do
					if not (key.Time and areNumbersGood(key.Time) and key.Value and areNumbersGood(key.Value)) then
						object:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidCurveData)
						return
					end

					if time then
						if time + v > key.Time then
							local v3 = not descendant.Parent.Parent and "-" or descendant.Parent.Parent.Name
							object:fail(ErrorSourceStrings.Keys.CurveAnim_KeysTooClose, {
								curvePath = `{v3}.{descendant.Parent.Name}.{descendant.Name}`,
								maxFPS = tostring(getFIntUGCValidateMaxAnimationFPS())
							})

							return
						end
					elseif key.Time < 0 then
						local v3 = not descendant.Parent.Parent and "-" or descendant.Parent.Parent.Name
						object:fail(ErrorSourceStrings.Keys.CurveAnim_NegativeKeyTime, {
							curvePath = `{v3}.{descendant.Parent.Name}.{descendant.Name}`
						})

						return
					end

					time = key.Time
				end
			end
		end
	end
end

return CurveAnimNumericalDataValid
