local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local CurveAnimBoneHierarchyUtils = require(ParentParent.util.CurveAnimBoneHierarchyUtils)
local getFFlagUGCValidateEmotesBonesAllowed = require(ParentParent.flags.getFFlagUGCValidateEmotesBonesAllowed)
local getFFlagUGCValidateAnimBonesSupport = require(ParentParent.flags.getFFlagUGCValidateAnimBonesSupport)
local getFFlagUGCValidationAnimationPackSupport = require(ParentParent.flags.getFFlagUGCValidationAnimationPackSupport)
local t1 = {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION }
}

if getFFlagUGCValidateAnimBonesSupport() and getFFlagUGCValidationAnimationPackSupport() then
	table.insert(t1.categories, ValidationEnums.UploadCategory.ANIMATION)
end

t1.requiredData = { ValidationEnums.SharedDataMember.curveAnimations }
t1.conditionalData = { ValidationEnums.SharedDataMember.curveAnimBoneData }

function t1.fflag() -- line: 22
	-- upvalues: getFFlagUGCValidateEmotesBonesAllowed (copy), getFFlagUGCValidateAnimBonesSupport (copy)
	return getFFlagUGCValidateEmotesBonesAllowed() or getFFlagUGCValidateAnimBonesSupport()
end

t1.expectedFailures = {}
t1.prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }

local function bonePositionHasKeyframes(p1) -- line: 28
	local Position = p1:FindFirstChild("Position")

	if not Position or not Position:IsA("Vector3Curve") then
		return false
	end

	for _, v13 in {
		"X",
		"Y",
		"Z"
	} do
		local v14 = Position:FindFirstChild(v13)

		if v14 and v14:IsA("FloatCurve") and #v14:GetKeys() > 0 then
			return true
		end
	end

	return false
end

function t1.run(p2, p3) -- line: 42
	-- upvalues: CurveAnimBoneHierarchyUtils (copy), bonePositionHasKeyframes (copy), ErrorSourceStrings (copy)
	for _, v18 in p3.curveAnimations do
		for _, descendant in v18:GetDescendants() do
			if descendant:IsA("Folder") and CurveAnimBoneHierarchyUtils.isBoneFolderName(descendant.Name) and bonePositionHasKeyframes(descendant) then
				p2:fail(ErrorSourceStrings.Keys.CurveAnim_BonePositionNotAllowed, {
					boneName = descendant.Name
				})
			end
		end
	end
end

return t1
