local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFFlagUGCValidateAddObjectValueToAcceptableTypes = require(parent.flags.getFFlagUGCValidateAddObjectValueToAcceptableTypes)

local CurveAnimAllowedTypes = {}

CurveAnimAllowedTypes.categories = {
	ValidationEnums.UploadCategory.EMOTE_ANIMATION,
	ValidationEnums.UploadCategory.ANIMATION
}
CurveAnimAllowedTypes.requiredData = { ValidationEnums.SharedDataMember.curveAnimations }

CurveAnimAllowedTypes.expectedFailures = {}
CurveAnimAllowedTypes.prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }

local v = {
	"MarkerCurve",
	"AnimationRigData",
	"Folder",
	"Vector3Curve",
	"EulerRotationCurve",
	"FloatCurve"
}

if getFFlagUGCValidateAddObjectValueToAcceptableTypes() then
	table.insert(v, "ObjectValue")
end

function CurveAnimAllowedTypes.run(object, p)
	for _, folder in p.curveAnimations do
		for _, descendant in folder:GetDescendants() do
			local v2 = false

			for _, className in v do
				if descendant:IsA(className) then
					v2 = true
					break
				end
			end

			if not v2 then
				object:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidInstanceTypes, {
					allowedTypes = table.concat(v, ", ")
				})

				return
			end
		end
	end
end

return CurveAnimAllowedTypes
