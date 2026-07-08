local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateCurveAnim = require(ParentParent.flags.getFFlagUGCValidateMigrateCurveAnim)
local GetFStringUGCValidationMaxAnimationLength = require(ParentParent.flags.GetFStringUGCValidationMaxAnimationLength)
local GetFStringUGCValidateFrameDeltaKeyTimeTol = require(ParentParent.flags.GetFStringUGCValidateFrameDeltaKeyTimeTol)
local getFIntUGCValidateMaxAnimationFPS = require(ParentParent.flags.getFIntUGCValidateMaxAnimationFPS)
local getFIntUGCValidateMaxMarkerCurveValueLength = require(ParentParent.flags.getFIntUGCValidateMaxMarkerCurveValueLength)
local getFFlagUGCValidateRestrictNumMarkersInsideMarkerCurves = require(ParentParent.flags.getFFlagUGCValidateRestrictNumMarkersInsideMarkerCurves)
local getFIntUGCValidateMaxTotalInternalMarkers = require(ParentParent.flags.getFIntUGCValidateMaxTotalInternalMarkers)
local getFFlagUGCValidationAnimationPackSupport = require(ParentParent.flags.getFFlagUGCValidationAnimationPackSupport)
local t1 = {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION }
}

if getFFlagUGCValidationAnimationPackSupport() then
	table.insert(t1.categories, ValidationEnums.UploadCategory.ANIMATION)
end

t1.requiredData = { ValidationEnums.SharedDataMember.curveAnimations }
t1.fflag = getFFlagUGCValidateMigrateCurveAnim
t1.expectedFailures = {}
t1.prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }

local function areNumbersGood(...) -- line: 30
	local function isNaN(n1: number) -- line: 31
		return n1 ~= n1
	end
	local function isInfinite(n2: number) -- line: 35
		return n2 == 1e999 or n2 == -1e999
	end

	for _, v17 in { ... } do
		if v17 ~= v17 then
			return false
		end

		if v17 == 1e999 or v17 == -1e999 then
			return false
		end
	end

	return true
end

function t1.run(p1, p2) -- line: 50
	-- upvalues: getFIntUGCValidateMaxAnimationFPS (copy), GetFStringUGCValidateFrameDeltaKeyTimeTol (copy), GetFStringUGCValidationMaxAnimationLength (copy), getFFlagUGCValidateRestrictNumMarkersInsideMarkerCurves (copy), getFIntUGCValidateMaxTotalInternalMarkers (copy), ErrorSourceStrings (copy), areNumbersGood (copy), getFIntUGCValidateMaxMarkerCurveValueLength (copy)
	local v20 = 1 / getFIntUGCValidateMaxAnimationFPS() * GetFStringUGCValidateFrameDeltaKeyTimeTol.asNumber()
	local v21 = math.ceil(1 / v20 * GetFStringUGCValidationMaxAnimationLength.asNumber())

	for _, v23 in p2.curveAnimations do
		for _, descendant in v23:GetDescendants() do
			if not descendant:IsA("MarkerCurve") then
				if not descendant:IsA("FloatCurve") then
					continue
				end

				local Keys = descendant:GetKeys()

				if v21 < #Keys then
					p1:fail(ErrorSourceStrings.Keys.CurveAnim_TooManyKeys, {
						maxAllowed = tostring(v21)
					})

					return
				end

				local Time = nil

				for _, v29 in Keys do
					if not v29.Time or not areNumbersGood(v29.Time) or not v29.Value or not areNumbersGood(v29.Value) then
						p1:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidCurveData)

						return
					end

					if Time then
						if Time + v20 > v29.Time then
							local v30 = not descendant.Parent.Parent and "-" or descendant.Parent.Parent.Name

							p1:fail(ErrorSourceStrings.Keys.CurveAnim_KeysTooClose, {
								curvePath = `{ v30 }.{ descendant.Parent.Name }.{ descendant.Name }`,
								maxFPS = tostring(getFIntUGCValidateMaxAnimationFPS())
							})

							return
						end
					elseif v29.Time < 0 then
						local v31 = not descendant.Parent.Parent and "-" or descendant.Parent.Parent.Name

						p1:fail(ErrorSourceStrings.Keys.CurveAnim_NegativeKeyTime, {
							curvePath = `{ v31 }.{ descendant.Parent.Name }.{ descendant.Name }`
						})

						return
					end

					Time = v29.Time
				end

				continue
			end

			local Markers = descendant:GetMarkers()

			if getFFlagUGCValidateRestrictNumMarkersInsideMarkerCurves() then
				local v33 = math.min(getFIntUGCValidateMaxTotalInternalMarkers(), v21)

				if v33 < #Markers then
					p1:fail(ErrorSourceStrings.Keys.CurveAnim_TooManyMarkers, {
						count = tostring(#Markers),
						maxAllowed = tostring(v33)
					})

					return
				end
			elseif v21 < #Markers then
				p1:fail(ErrorSourceStrings.Keys.CurveAnim_TooManyMarkers, {
					count = tostring(#Markers),
					maxAllowed = tostring(v21)
				})

				return
			end

			for _, v35 in Markers do
				if not v35.Time or not areNumbersGood(v35.Time) or not v35.Value or #v35.Value > getFIntUGCValidateMaxMarkerCurveValueLength() then
					p1:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidMarkerData)

					return
				end
			end
		end
	end
end

return t1
