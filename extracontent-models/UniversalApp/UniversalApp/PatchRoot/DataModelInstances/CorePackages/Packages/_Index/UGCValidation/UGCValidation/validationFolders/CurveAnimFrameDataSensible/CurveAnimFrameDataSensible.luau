local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateCurveAnim = require(ParentParent.flags.getFFlagUGCValidateMigrateCurveAnim)
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

local function areNumbersGood(...) -- line: 24
	local function isNaN(n1: number) -- line: 25
		return n1 ~= n1
	end
	local function isInfinite(n2: number) -- line: 29
		return n2 == 1e999 or n2 == -1e999
	end

	for _, v11 in { ... } do
		if v11 ~= v11 then
			return false
		end

		if v11 == 1e999 or v11 == -1e999 then
			return false
		end
	end

	return true
end

function t1.run(p1, p2) -- line: 44
	-- upvalues: areNumbersGood (copy), ErrorSourceStrings (copy)
	local curveAnimComputedFrames = p2.curveAnimComputedFrames

	for _, v16 in curveAnimComputedFrames.animFrames do
		for _, v18 in v16 do
			if not areNumbersGood(v18:GetComponents()) then
				p1:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidNumericalData)

				return
			end
		end
	end

	for _, v20 in curveAnimComputedFrames.positionMagnitudeFrames do
		for _, v22 in v20 do
			if not areNumbersGood(v22) then
				p1:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidNumericalData)

				return
			end
		end
	end
end

return t1
