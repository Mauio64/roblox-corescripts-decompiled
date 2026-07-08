local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateMigrateCurveAnim = require(ParentParent.flags.getFFlagUGCValidateMigrateCurveAnim)
local getFFlagUGCValidateAddObjectValueToAcceptableTypes = require(ParentParent.flags.getFFlagUGCValidateAddObjectValueToAcceptableTypes)
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

local t2 = {
	"MarkerCurve",
	"AnimationRigData",
	"Folder",
	"Vector3Curve",
	"EulerRotationCurve",
	"FloatCurve"
}

if getFFlagUGCValidateAddObjectValueToAcceptableTypes() then
	table.insert(t2, "ObjectValue")
end

function t1.run(p1, p2) -- line: 38
	-- upvalues: t2 (copy), ErrorSourceStrings (copy)
	for _, v12 in p2.curveAnimations do
		for _, descendant in v12:GetDescendants() do
			local v15 = false

			for _, v17 in t2 do
				if descendant:IsA(v17) then
					v15 = true

					break
				end
			end

			if not v15 then
				p1:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidInstanceTypes, {
					allowedTypes = table.concat(t2, ", ")
				})

				return
			end
		end
	end
end

return t1
