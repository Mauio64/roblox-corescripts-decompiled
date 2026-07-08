local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local CurveAnimationHierarchyUtils = require(ParentParent.util.CurveAnimationHierarchyUtils)
local getFFlagUGCValidateMigrateCurveAnim = require(ParentParent.flags.getFFlagUGCValidateMigrateCurveAnim)
local getFFlagUGCValidateDuplicatesInAnimation = require(ParentParent.flags.getFFlagUGCValidateDuplicatesInAnimation)
local getFFlagUGCValidateMaxTotalInstances = require(ParentParent.flags.getFFlagUGCValidateMaxTotalInstances)
local getFFlagUGCValidationAnimationPackSupport = require(ParentParent.flags.getFFlagUGCValidationAnimationPackSupport)
local getFFlagUGCValidateEmotesBonesAllowed = require(ParentParent.flags.getFFlagUGCValidateEmotesBonesAllowed)
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
	-- upvalues: getFFlagUGCValidateMaxTotalInstances (copy), ErrorSourceStrings (copy), CurveAnimationHierarchyUtils (copy), getFFlagUGCValidateDuplicatesInAnimation (copy), getFFlagUGCValidateEmotesBonesAllowed (copy)
	for _, v14 in p2.curveAnimations do
		local v15 = #v14:GetDescendants()

		if v15 > getFFlagUGCValidateMaxTotalInstances() then
			p1:fail(ErrorSourceStrings.Keys.CurveAnim_TooManyDescendants, {
				count = tostring(v15),
				maxAllowed = tostring(getFFlagUGCValidateMaxTotalInstances())
			})

			return
		end

		local n1 = 0

		for _, child in v14:GetChildren() do
			if not child:IsA("Folder") or not CurveAnimationHierarchyUtils.isBodyPartFolderNameValid(child.Name) then
				continue
			end

			n1 += 1

			if n1 > 1 then
				p1:fail(ErrorSourceStrings.Keys.CurveAnim_MultipleBodyRoots)

				return
			end
		end

		if getFFlagUGCValidateDuplicatesInAnimation() and n1 == 0 then
			p1:fail(ErrorSourceStrings.Keys.CurveAnim_NoBodyRoot)

			return
		end

		for _, child in v14:GetChildren() do
			if not child:IsA("MarkerCurve") and not child:IsA("AnimationRigData") then
				if not child:IsA("Folder") then
					p1:fail(ErrorSourceStrings.Keys.CurveAnim_UnexpectedChild, {
						childName = child.Name
					})

					return
				end

				if not getFFlagUGCValidateDuplicatesInAnimation() then
					if getFFlagUGCValidateEmotesBonesAllowed() or CurveAnimationHierarchyUtils.validateCurveAnimationBodyPartFolder(child) then
						continue
					end

					p1:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidBodyPartHierarchy, {
						folderName = child.Name
					})

					return
				end

				if not CurveAnimationHierarchyUtils.isBodyPartFolderNameValid(child.Name) and not getFFlagUGCValidateEmotesBonesAllowed() then
					p1:fail(ErrorSourceStrings.Keys.CurveAnim_UnexpectedChild, {
						childName = child.Name
					})

					return
				end

				if getFFlagUGCValidateEmotesBonesAllowed() or CurveAnimationHierarchyUtils.validateCurveAnimationBodyPartFolder(child) then
					continue
				end

				p1:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidBodyPartHierarchy, {
					folderName = child.Name
				})

				return
			end

			if getFFlagUGCValidateDuplicatesInAnimation() and #child:GetChildren() > 0 then
				p1:fail(ErrorSourceStrings.Keys.CurveAnim_ChildrenOnMarkerOrRig)

				return
			end
		end
	end
end

return t1
