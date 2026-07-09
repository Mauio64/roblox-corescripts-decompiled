local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local EmoteUtility = require(CorePackages.Packages.Thumbnailing).EmoteUtility
local PPEThumbnailType = require(Modules.AvatarExperience.ProfilePictureEditor.PPEThumbnailType)
local SelectIsToolEquipped = require(Modules.AvatarExperience.Common.Selectors.SelectIsToolEquipped)
local Utils = require(Modules.AvatarExperience.Common.Utils)

require(Modules.AvatarExperience.Common.Managers.AnimationManagerTypes)

local CompletePPEEmoteLoading = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.CompletePPEEmoteLoading)
local StartPPEEmoteLoading = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.StartPPEEmoteLoading)
local SetLastSuccessfulPoseEmoteAssetId = require(Modules.AvatarExperience.ProfilePictureEditor.Actions.SetLastSuccessfulPoseEmoteAssetId)
local AnimationUtils = require(Modules.AvatarExperience.Common.Managers.AnimationUtils)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local t1 = {}

local function avatarIsHoldingTool(p1) -- line: 32
	if p1 then
		return p1:getEquippedToolModel() ~= nil
	end

	return false
end

function t1.getDidSomethingRequiringPPEPoseAdjustment(p2, p3, p4) -- line: 46
	-- upvalues: PPEThumbnailType (copy), SelectIsToolEquipped (copy)
	if p2.AvatarExperience.AvatarScene.Character.CharacterModelVersion ~= p3.AvatarExperience.AvatarScene.Character.CharacterModelVersion then
		return true
	end

	local finalPageViewMode = p2.AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode
	local finalPageViewMode2 = p3.AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode

	if finalPageViewMode ~= finalPageViewMode2 then
		if finalPageViewMode == PPEThumbnailType.Closeup and finalPageViewMode2 == PPEThumbnailType.FullBody then
			if SelectIsToolEquipped(p3) and (not p4 or p4:getEquippedToolModel() == nil) then
				return false
			end

			return true
		end

		if finalPageViewMode == PPEThumbnailType.FullBody and finalPageViewMode2 == PPEThumbnailType.Closeup then
			if SelectIsToolEquipped(p3) and (not not p4 and p4:getEquippedToolModel() ~= nil) then
				return false
			end

			return true
		end
	end

	return false
end
function t1.getAssetIdsToLoad(p5, b1: boolean) -- line: 100
	-- upvalues: Utils (copy)
	local t2 = {
		ppeEmoteAssetId = Utils.getAssetIdForPPEPose(p5)
	}

	if b1 then
		t2.moodAssetId = Utils.getEquippedMoodAssetId(p5)
	end

	return t2
end

local u14 = false

function t1.makeLoadedAssets(p6, p7, p8) -- line: 117
	-- upvalues: u14 (ref), StartPPEEmoteLoading (copy), EmoteUtility (copy), CompletePPEEmoteLoading (copy)
	local t3 = {}
	local CurrentCharacter = p6:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

	if not CurrentCharacter then
		return t3
	end

	if not CurrentCharacter:FindFirstChildOfClass("Humanoid") then
		return t3
	end

	assert(u14 == false, "promiseHasOutstandingPPELoading should be false")
	p6:dispatch(StartPPEEmoteLoading())
	u14 = true

	local num = nil
	local num2 = nil

	if p8.ppeEmoteAssetId then
		num = tonumber(p8.ppeEmoteAssetId)
	end

	if p8.moodAssetId then
		num2 = tonumber(p8.moodAssetId)
	end

	local ppeFinalPageFullView = p7.ppeFinalPageFullView

	t3.keyframesForPose = EmoteUtility.LoadKeyframesForPose(CurrentCharacter, num, num2, true, not ppeFinalPageFullView)
	p6:dispatch(CompletePPEEmoteLoading())
	u14 = false

	return t3
end
function t1.maybeNoteLoadingFinished(p9) -- line: 182
	-- upvalues: u14 (ref), CompletePPEEmoteLoading (copy)
	if u14 then
		p9:dispatch(CompletePPEEmoteLoading())
	end

	u14 = false
end
function t1.applyNewProfilePictureEditorPose(p10, p11, p12, p13) -- line: 189
	-- upvalues: EmoteUtility (copy), AnimationUtils (copy), SetLastSuccessfulPoseEmoteAssetId (copy)
	assert(p11, "currentCharacter is non-nil.")
	assert(p12, "humanoid is non-nil..")

	if not p13 then
		EmoteUtility.SetPlayerCharacterNeutralPose(p11)

		if Enum.HumanoidRigType.R6 == p12.RigType then
			EmoteUtility.AdjustArmOnR6ForTool(p11)
		end
	else
		EmoteUtility.ApplyKeyframesForPose(p11, p13)
	end

	local finalAnimationAssetIdOrUrl = nil

	if p13 then
		finalAnimationAssetIdOrUrl = p13.finalAnimationAssetIdOrUrl

		if finalAnimationAssetIdOrUrl then
			finalAnimationAssetIdOrUrl = tostring(finalAnimationAssetIdOrUrl)
		end
	end

	AnimationUtils.waitForAnimationAndPosingToResolve(function() -- line: 218
		-- upvalues: p10 (copy), SetLastSuccessfulPoseEmoteAssetId (copy), finalAnimationAssetIdOrUrl (ref)
		p10:dispatch(SetLastSuccessfulPoseEmoteAssetId(finalAnimationAssetIdOrUrl))
	end)
end
function t1.undoOldProfilePictureEditorPose(p14, p15, p16) -- line: 223
	-- upvalues: EmoteUtility (copy), SetLastSuccessfulPoseEmoteAssetId (copy)
	if p16 and p15 then
		EmoteUtility.SetPlayerCharacterNeutralPose(p15)
		p14:dispatch(SetLastSuccessfulPoseEmoteAssetId(nil))
	end
end

return t1
