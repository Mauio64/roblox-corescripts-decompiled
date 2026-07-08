local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local CurveAnimationHierarchyUtils = require(ParentParent.util.CurveAnimationHierarchyUtils)
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

function t1.fflag() -- line: 23
	-- upvalues: getFFlagUGCValidateEmotesBonesAllowed (copy), getFFlagUGCValidateAnimBonesSupport (copy)
	return getFFlagUGCValidateEmotesBonesAllowed() or getFFlagUGCValidateAnimBonesSupport()
end

t1.expectedFailures = {}
t1.prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }

function t1.run(p1, p2) -- line: 29
	-- upvalues: CurveAnimationHierarchyUtils (copy), CurveAnimBoneHierarchyUtils (copy), ErrorSourceStrings (copy)
	for _, v13 in p2.curveAnimations do
		for _, descendant in v13:GetDescendants() do
			if descendant:IsA("Folder") then
				local v16 = CurveAnimationHierarchyUtils.folderHasAnimationTracks(descendant)
				local v17 = CurveAnimationHierarchyUtils.isBodyPartFolderNameValid(descendant.Name)
				local v18 = CurveAnimBoneHierarchyUtils.isBoneFolderName(descendant.Name)

				if v16 and not v17 and not v18 then
					p1:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidBoneName, {
						boneName = descendant.Name
					})
				end
			end
		end
	end
end

return t1
