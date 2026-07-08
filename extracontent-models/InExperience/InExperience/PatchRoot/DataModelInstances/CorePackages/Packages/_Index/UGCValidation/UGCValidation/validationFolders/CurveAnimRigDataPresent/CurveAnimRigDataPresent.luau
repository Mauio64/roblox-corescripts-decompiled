local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local CurveAnimBoneHierarchyUtils = require(ParentParent.util.CurveAnimBoneHierarchyUtils)
local getFFlagUGCValidateMigrateCurveAnim = require(ParentParent.flags.getFFlagUGCValidateMigrateCurveAnim)
local getFFlagUGCValidationAnimationPackSupport = require(ParentParent.flags.getFFlagUGCValidationAnimationPackSupport)
local getFFlagUGCValidateEmotesBonesAllowed = require(ParentParent.flags.getFFlagUGCValidateEmotesBonesAllowed)
local getFFlagUGCValidateCurveAnimRigDataR15Plus = require(ParentParent.flags.getFFlagUGCValidateCurveAnimRigDataR15Plus)
local getEngineFeatureIsValidR15Plus = require(ParentParent.flags.getEngineFeatureIsValidR15Plus)
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

function t1.run(p1, p2) -- line: 27
	-- upvalues: ErrorSourceStrings (copy), getFFlagUGCValidateEmotesBonesAllowed (copy), CurveAnimBoneHierarchyUtils (copy), getFFlagUGCValidateCurveAnimRigDataR15Plus (copy), getEngineFeatureIsValidR15Plus (copy)
	for _, v14 in p2.curveAnimations do
		local n1 = 0

		for _, child in v14:GetChildren() do
			if not child:IsA("AnimationRigData") then
				continue
			end

			n1 += 1

			if n1 > 1 then
				p1:fail(ErrorSourceStrings.Keys.CurveAnim_MultipleRigData)

				return
			end
		end

		if n1 == 0 then
			p1:fail(ErrorSourceStrings.Keys.CurveAnim_NoRigData)

			return
		end

		if getFFlagUGCValidateEmotesBonesAllowed() and CurveAnimBoneHierarchyUtils.hasBoneFolders(v14) then
			if getFFlagUGCValidateCurveAnimRigDataR15Plus() and getEngineFeatureIsValidR15Plus() then
				for _, child in v14:GetChildren() do
					if child:IsA("AnimationRigData") and not child:IsValidR15Plus() then
						p1:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidRigDataR15Plus)

						return
					end
				end
			end
		else
			for _, child in v14:GetChildren() do
				if child:IsA("AnimationRigData") and not child:IsValidR15() then
					p1:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidRigData)

					return
				end
			end
		end
	end
end

return t1
