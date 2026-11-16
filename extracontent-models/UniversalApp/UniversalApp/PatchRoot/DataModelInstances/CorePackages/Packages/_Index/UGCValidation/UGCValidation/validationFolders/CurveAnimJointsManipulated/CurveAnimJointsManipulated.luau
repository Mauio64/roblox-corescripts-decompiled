local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local CurveAnimationHierarchyUtils = require(parent.util.CurveAnimationHierarchyUtils)

return {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION, ValidationEnums.UploadCategory.ANIMATION },
	requiredData = { ValidationEnums.SharedDataMember.curveAnimations },
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable },
	run = function(object, p)
		for _, curveAnimation in p.curveAnimations do
			local bodyPartFolderRoot = CurveAnimationHierarchyUtils.getBodyPartFolderRoot(curveAnimation)

			if not bodyPartFolderRoot then
				object:fail(ErrorSourceStrings.Keys.CurveAnim_NoJointManipulation)
				break
			end

			local descendants = bodyPartFolderRoot:GetDescendants()
			table.insert(descendants, bodyPartFolderRoot)
			local v = false

			for _, folder in descendants do
				if not (folder:IsA("Folder") and CurveAnimationHierarchyUtils.getBodyPartToParentMap()[folder.Name]) then
					continue
				end

				local position = folder:FindFirstChild("Position")
				local rotation = folder:FindFirstChild("Rotation")

				if position and position:IsA("Vector3Curve") and rotation and rotation:IsA("EulerRotationCurve") then
					v = true
					break
				end
			end

			if not v then
				object:fail(ErrorSourceStrings.Keys.CurveAnim_NoJointManipulation)
				break
			end
		end
	end
}
