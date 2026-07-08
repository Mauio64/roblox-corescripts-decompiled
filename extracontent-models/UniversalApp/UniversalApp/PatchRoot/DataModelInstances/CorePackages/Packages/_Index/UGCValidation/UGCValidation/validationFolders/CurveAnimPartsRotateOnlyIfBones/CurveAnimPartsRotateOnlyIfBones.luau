local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local CurveAnimationHierarchyUtils = require(ParentParent.util.CurveAnimationHierarchyUtils)
local CurveAnimBoneHierarchyUtils = require(ParentParent.util.CurveAnimBoneHierarchyUtils)
local getFFlagUGCValidateEmotesBonesAllowed = require(ParentParent.flags.getFFlagUGCValidateEmotesBonesAllowed)
local getFFlagUGCValidateAnimPartsRotationOnly = require(ParentParent.flags.getFFlagUGCValidateAnimPartsRotationOnly)
local getFFlagUGCValidationAnimationPackSupport = require(ParentParent.flags.getFFlagUGCValidationAnimationPackSupport)
local t1 = {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION }
}

if getFFlagUGCValidateAnimPartsRotationOnly() and getFFlagUGCValidationAnimationPackSupport() then
	table.insert(t1.categories, ValidationEnums.UploadCategory.ANIMATION)
end

t1.requiredData = { ValidationEnums.SharedDataMember.curveAnimations }

if getFFlagUGCValidateAnimPartsRotationOnly() then
	t1.conditionalData = {}
else
	t1.conditionalData = { ValidationEnums.SharedDataMember.curveAnimBoneData }
end

function t1.fflag() -- line: 27
	-- upvalues: getFFlagUGCValidateEmotesBonesAllowed (copy), getFFlagUGCValidateAnimPartsRotationOnly (copy)
	return getFFlagUGCValidateEmotesBonesAllowed() or getFFlagUGCValidateAnimPartsRotationOnly()
end

t1.expectedFailures = {}
t1.prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }

local function bodyPartPositionHasKeyframes(p1) -- line: 33
	local Position = p1:FindFirstChild("Position")

	if not Position or not Position:IsA("Vector3Curve") then
		return false
	end

	for _, v14 in {
		"X",
		"Y",
		"Z"
	} do
		local v15 = Position:FindFirstChild(v14)

		if v15 and v15:IsA("FloatCurve") and #v15:GetKeys() > 0 then
			return true
		end
	end

	return false
end

function t1.run(p2, p3) -- line: 47
	-- upvalues: getFFlagUGCValidateAnimPartsRotationOnly (copy), ValidationEnums (copy), CurveAnimBoneHierarchyUtils (copy), CurveAnimationHierarchyUtils (copy), bodyPartPositionHasKeyframes (copy), ErrorSourceStrings (copy)
	local v18 = getFFlagUGCValidateAnimPartsRotationOnly() and p3.uploadCategory == ValidationEnums.UploadCategory.ANIMATION

	for _, v20 in p3.curveAnimations do
		if not v18 then
			local v21 = false

			for _, descendant in v20:GetDescendants() do
				if descendant:IsA("Folder") and CurveAnimBoneHierarchyUtils.isBoneFolderName(descendant.Name) then
					v21 = true

					break
				end
			end

			if not v21 then
				continue
			end
		end

		for _, descendant in v20:GetDescendants() do
			if descendant:IsA("Folder") and CurveAnimationHierarchyUtils.isBodyPartFolderNameValid(descendant.Name) and bodyPartPositionHasKeyframes(descendant) then
				if v18 then
					p2:fail(ErrorSourceStrings.Keys.CurveAnim_BodyPartHasPosition, {
						bodyPartName = descendant.Name
					})
				else
					p2:fail(ErrorSourceStrings.Keys.CurveAnim_BodyPartWithBoneHasPosition, {
						bodyPartName = descendant.Name
					})
				end
			end
		end
	end
end

return t1
