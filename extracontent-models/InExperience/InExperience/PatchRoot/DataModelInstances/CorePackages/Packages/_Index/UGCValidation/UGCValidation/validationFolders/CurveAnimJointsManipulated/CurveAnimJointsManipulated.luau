local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local CurveAnimationHierarchyUtils = require(ParentParent.util.CurveAnimationHierarchyUtils)
local getFFlagUGCValidateMigrateCurveAnim = require(ParentParent.flags.getFFlagUGCValidateMigrateCurveAnim)
local getFFlagUGCValidateDuplicatesInAnimation = require(ParentParent.flags.getFFlagUGCValidateDuplicatesInAnimation)
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

function t1.run(p1, p2) -- line: 25
	-- upvalues: getFFlagUGCValidateDuplicatesInAnimation (copy), CurveAnimationHierarchyUtils (copy), ErrorSourceStrings (copy)
	for _, v12 in p2.curveAnimations do
		local descendants

		if getFFlagUGCValidateDuplicatesInAnimation() then
			local v13 = CurveAnimationHierarchyUtils.getBodyPartFolderRoot(v12)

			if not v13 then
				p1:fail(ErrorSourceStrings.Keys.CurveAnim_NoJointManipulation)

				return
			end

			descendants = v13:GetDescendants()
			table.insert(descendants, v13)
		else
			descendants = v12:GetDescendants()
		end

		local v15 = false

		for _, v17 in descendants do
			if not v17:IsA("Folder") or not CurveAnimationHierarchyUtils.getBodyPartToParentMap()[v17.Name] then
				continue
			end

			local Position = v17:FindFirstChild("Position")
			local Rotation = v17:FindFirstChild("Rotation")

			if Position and Position:IsA("Vector3Curve") and Rotation and Rotation:IsA("EulerRotationCurve") then
				v15 = true

				break
			end
		end

		if not v15 then
			p1:fail(ErrorSourceStrings.Keys.CurveAnim_NoJointManipulation)

			return
		end
	end
end

return t1
