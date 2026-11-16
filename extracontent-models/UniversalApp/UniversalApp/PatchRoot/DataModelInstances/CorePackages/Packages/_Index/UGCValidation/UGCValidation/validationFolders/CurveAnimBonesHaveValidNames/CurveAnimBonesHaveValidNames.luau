local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local CurveAnimationHierarchyUtils = require(parent.util.CurveAnimationHierarchyUtils)
local CurveAnimBoneHierarchyUtils = require(parent.util.CurveAnimBoneHierarchyUtils)

return {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION, ValidationEnums.UploadCategory.ANIMATION },
	requiredData = { ValidationEnums.SharedDataMember.curveAnimations },
	conditionalData = { ValidationEnums.SharedDataMember.curveAnimBoneData },
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable },
	run = function(object, p)
		for _, folder in p.curveAnimations do
			for _, folder2 in folder:GetDescendants() do
				if not folder2:IsA("Folder") then
					continue
				end

				local folderHasAnimationTracks = CurveAnimationHierarchyUtils.folderHasAnimationTracks(folder2)
				local bodyPartFolderNameValid = CurveAnimationHierarchyUtils.isBodyPartFolderNameValid(folder2.Name)
				local boneFolderName = CurveAnimBoneHierarchyUtils.isBoneFolderName(folder2.Name)

				if not folderHasAnimationTracks or (bodyPartFolderNameValid or boneFolderName) then
					continue
				end

				object:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidBoneName, {
					boneName = folder2.Name
				})
			end
		end
	end
}
