local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateCurveAnim = require(ParentParent.flags.getFFlagUGCValidateMigrateCurveAnim)
local getFIntUGCValidateMaxTotalMarkerCurves = require(ParentParent.flags.getFIntUGCValidateMaxTotalMarkerCurves)
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

function t1.run(p1, p2) -- line: 24
	-- upvalues: getFIntUGCValidateMaxTotalMarkerCurves (copy), ErrorSourceStrings (copy)
	local v10 = getFIntUGCValidateMaxTotalMarkerCurves()

	for _, v12 in p2.curveAnimations do
		local n1 = 0

		for _, descendant in v12:GetDescendants() do
			if not descendant:IsA("MarkerCurve") then
				continue
			end

			n1 += 1

			if v10 < n1 then
				p1:fail(ErrorSourceStrings.Keys.CurveAnim_TooManyMarkerCurves, {
					maxAllowed = tostring(v10)
				})

				return
			end
		end
	end
end

return t1
