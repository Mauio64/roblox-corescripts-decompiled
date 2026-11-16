local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local CurveAnimationHierarchyUtils = require(parent.util.CurveAnimationHierarchyUtils)
local CurveAnimBoneHierarchyUtils = require(parent.util.CurveAnimBoneHierarchyUtils)
local CurveAnimTranslationUtils = require(parent.util.CurveAnimTranslationUtils)

local getFFlagUGCValidateAnimPartsRotationOnly = require(parent.flags.getFFlagUGCValidateAnimPartsRotationOnly)
local getFFlagUGCValidateAnimTranslationThreshold = require(parent.flags.getFFlagUGCValidateAnimTranslationThreshold)

local defineFastInt = game:DefineFastInt("UGCValidateBodyPartTranslationMaxDistanceHundredths", 100)

local defineFastInt2 = game:DefineFastInt("UGCValidateLowerTorsoTranslationMaxDistanceHundredths", 200)

local CurveAnimPartsRotateOnlyIfBones = {}

CurveAnimPartsRotateOnlyIfBones.categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION }

if getFFlagUGCValidateAnimPartsRotationOnly() then
	table.insert(CurveAnimPartsRotateOnlyIfBones.categories, ValidationEnums.UploadCategory.ANIMATION)
end

CurveAnimPartsRotateOnlyIfBones.requiredData = { ValidationEnums.SharedDataMember.curveAnimations }

if getFFlagUGCValidateAnimPartsRotationOnly() then
	CurveAnimPartsRotateOnlyIfBones.conditionalData = {}
else
	CurveAnimPartsRotateOnlyIfBones.conditionalData = { ValidationEnums.SharedDataMember.curveAnimBoneData }
end

CurveAnimPartsRotateOnlyIfBones.expectedFailures = {}
CurveAnimPartsRotateOnlyIfBones.prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }

function CurveAnimPartsRotateOnlyIfBones.run(object, p)
	local v = getFFlagUGCValidateAnimPartsRotationOnly()
		and p.uploadCategory == ValidationEnums.UploadCategory.ANIMATION

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

			if getFFlagUGCValidateAnimTranslationThreshold() then
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
			elseif CurveAnimTranslationUtils.positionHasKeyframes(folder2) then
				if v then
					object:fail(ErrorSourceStrings.Keys.CurveAnim_BodyPartHasPosition, {
						bodyPartName = folder2.Name
					})
				else
					object:fail(ErrorSourceStrings.Keys.CurveAnim_BodyPartWithBoneHasPosition, {
						bodyPartName = folder2.Name
					})
				end
			end
		end
	end
end

return CurveAnimPartsRotateOnlyIfBones
