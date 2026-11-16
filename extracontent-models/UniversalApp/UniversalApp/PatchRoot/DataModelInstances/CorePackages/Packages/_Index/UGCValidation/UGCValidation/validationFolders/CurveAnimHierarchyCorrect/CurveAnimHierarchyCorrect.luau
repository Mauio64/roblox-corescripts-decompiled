local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local CurveAnimationHierarchyUtils = require(parent.util.CurveAnimationHierarchyUtils)

local getFFlagUGCValidateMaxTotalInstances = require(parent.flags.getFFlagUGCValidateMaxTotalInstances)

return {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION, ValidationEnums.UploadCategory.ANIMATION },
	requiredData = { ValidationEnums.SharedDataMember.curveAnimations },
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable },
	run = function(object, p)
		for _, folder in p.curveAnimations do
			local count = #folder:GetDescendants()

			if getFFlagUGCValidateMaxTotalInstances() < count then
				object:fail(ErrorSourceStrings.Keys.CurveAnim_TooManyDescendants, {
					count = tostring(count),
					maxAllowed = tostring(getFFlagUGCValidateMaxTotalInstances())
				})
				break
			end

			local count2 = 0

			for _, folder2 in folder:GetChildren() do
				if not (folder2:IsA("Folder") and CurveAnimationHierarchyUtils.isBodyPartFolderNameValid(folder2.Name)) then
					continue
				end

				count2 += 1

				if count2 > 1 then
					object:fail(ErrorSourceStrings.Keys.CurveAnim_MultipleBodyRoots)
					return
				end
			end

			if count2 == 0 then
				object:fail(ErrorSourceStrings.Keys.CurveAnim_NoBodyRoot)
				break
			end

			for _, child in folder:GetChildren() do
				if child:IsA("MarkerCurve") or child:IsA("AnimationRigData") then
					if #child:GetChildren() > 0 then
						object:fail(ErrorSourceStrings.Keys.CurveAnim_ChildrenOnMarkerOrRig)
						return
					end
				elseif not child:IsA("Folder") then
					object:fail(ErrorSourceStrings.Keys.CurveAnim_UnexpectedChild, {
						childName = child.Name
					})

					return
				end
			end
		end
	end
}
