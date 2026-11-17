local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local CurveAnimationHierarchyUtils = require(parent.util.CurveAnimationHierarchyUtils)
local CurveAnimBoneHierarchyUtils = require(parent.util.CurveAnimBoneHierarchyUtils)
local CurveAnimTranslationUtils = require(parent.util.CurveAnimTranslationUtils)

local defineFastInt = game:DefineFastInt("UGCValidateBodyPartTranslationMaxDistanceHundredths", 100)

local defineFastInt2 = game:DefineFastInt("UGCValidateLowerTorsoTranslationMaxDistanceHundredths", 200)

return {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION, ValidationEnums.UploadCategory.ANIMATION },
	requiredData = { ValidationEnums.SharedDataMember.curveAnimations },
	conditionalData = {},
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable },
	run = function(object, p)
		local v = p.uploadCategory == ValidationEnums.UploadCategory.ANIMATION

		local v2 = defineFastInt / 100
		local v3 = defineFastInt2 / 100

		for _, folder in p.curveAnimations do
			if not v then
				local v4 = false

				for _, folder2 in folder:GetDescendants() do
					if folder2:IsA("Folder") and CurveAnimBoneHierarchyUtils.isBoneFolderName(folder2.Name) then
						v4 = true
						break
					end
				end

				if not v4 then
					continue
				end
			end

			for _, folder2 in folder:GetDescendants() do
				if not (folder2:IsA("Folder") and CurveAnimationHierarchyUtils.isBodyPartFolderNameValid(folder2.Name)) then
					continue
				end

				local v4

				if folder2.Name == "LowerTorso" then
					v4 = v3
				else
					v4 = v2
				end

				local translationExceedsThreshold, v5 = CurveAnimTranslationUtils.translationExceedsThreshold(
					folder2,
					v4
				)

				if translationExceedsThreshold then
					object:fail(ErrorSourceStrings.Keys.CurveAnim_BodyPartTranslationExceedsThreshold, {
						bodyPartName = folder2.Name,
						distance = string.format("%.3f", v5),
						maxDistance = string.format("%.3f", v4)
					})
				end
			end
		end
	end
}
