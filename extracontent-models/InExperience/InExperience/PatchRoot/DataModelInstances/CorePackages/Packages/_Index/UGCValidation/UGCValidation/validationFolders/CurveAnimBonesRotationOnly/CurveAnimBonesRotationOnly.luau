local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local CurveAnimBoneHierarchyUtils = require(parent.util.CurveAnimBoneHierarchyUtils)
local CurveAnimTranslationUtils = require(parent.util.CurveAnimTranslationUtils)

local getFFlagUGCValidateAnimTranslationThreshold = require(parent.flags.getFFlagUGCValidateAnimTranslationThreshold)

local defineFastInt = game:DefineFastInt("UGCValidateBoneTranslationMaxDistanceHundredths", 100)

return {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION, ValidationEnums.UploadCategory.ANIMATION },
	requiredData = { ValidationEnums.SharedDataMember.curveAnimations },
	conditionalData = { ValidationEnums.SharedDataMember.curveAnimBoneData },
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable },
	run = function(object, p)
		local v = defineFastInt / 100

		for _, folder in p.curveAnimations do
			for _, folder2 in folder:GetDescendants() do
				if not (folder2:IsA("Folder") and CurveAnimBoneHierarchyUtils.isBoneFolderName(folder2.Name)) then
					continue
				end

				if getFFlagUGCValidateAnimTranslationThreshold() then
					local translationExceedsThreshold, v2 = CurveAnimTranslationUtils.translationExceedsThreshold(
						folder2,
						v
					)

					if translationExceedsThreshold then
						object:fail(ErrorSourceStrings.Keys.CurveAnim_BoneTranslationExceedsThreshold, {
							boneName = folder2.Name,
							distance = string.format("%.3f", v2),
							maxDistance = string.format("%.3f", v)
						})
					end
				elseif CurveAnimTranslationUtils.positionHasKeyframes(folder2) then
					object:fail(ErrorSourceStrings.Keys.CurveAnim_BonePositionNotAllowed, {
						boneName = folder2.Name
					})
				end
			end
		end
	end
}
