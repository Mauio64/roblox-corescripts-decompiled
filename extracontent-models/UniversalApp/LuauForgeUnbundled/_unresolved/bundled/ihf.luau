local CorePackages = game:GetService("CorePackages")

local Thumbnailing = require(CorePackages.Packages.Thumbnailing)
local emoteUtility = Thumbnailing.EmoteUtility

local module = require("@luauforge/bundled/dTh")
local module2 = require("@luauforge/bundled/ihg")
local module3 = require("@luauforge/bundled/fuD")
require("@luauforge/bundled/gqt")
local module4 = require("@luauforge/bundled/dTe")
local module5 = require("@luauforge/bundled/dTf")

local module6 = require("@luauforge/bundled/dTd")
local module7 = require("@luauforge/bundled/gqq")

require("@luauforge/bundled/dHK")

local function avatarIsHoldingTool(object): boolean
	if object then
		return object:getEquippedToolModel() ~= nil
	end

	return false
end

local v5 = {}

function v5.getDidSomethingRequiringPPEPoseAdjustment(p2, p3, object): boolean
	if p2.AvatarExperience.AvatarScene.Character.CharacterModelVersion ~= p3.AvatarExperience.AvatarScene.Character.CharacterModelVersion then
		return true
	end

	local finalPageViewMode = p2.AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode
	local finalPageViewMode2 = p3.AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode

	if finalPageViewMode == finalPageViewMode2 then
		return false
	end

	if finalPageViewMode == module.Closeup and finalPageViewMode2 == module.FullBody then
		if not module2(p3) then
			return true
		end

		local v6 = if object then object:getEquippedToolModel() ~= nil else false

		if not v6 then
			return false
		end

		return true
	elseif finalPageViewMode == module.FullBody and finalPageViewMode2 == module.Closeup then
		if not module2(p3) then
			return true
		end

		local v6 = if object then object:getEquippedToolModel() ~= nil else false

		if v6 then
			return false
		end

		return true
	end

	return false
end

function v5.getAssetIdsToLoad(p2, p3)
	local v6 = {}
	v6.ppeEmoteAssetId = module3.getAssetIdForPPEPose(p2)

	if p3 then
		v6.moodAssetId = module3.getEquippedMoodAssetId(p2)
	end

	return v6
end

local flag = false

function v5.makeLoadedAssets(object, p2, p3)
	local v6 = {}

	local currentCharacter = object:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

	if not (currentCharacter and currentCharacter:FindFirstChildOfClass("Humanoid")) then
		return v6
	end

	assert(flag == false, "promiseHasOutstandingPPELoading should be false")

	object:dispatch(module5())
	flag = true

	local moodAssetId = nil
	local ppeEmoteAssetId = if p3.ppeEmoteAssetId then tonumber(p3.ppeEmoteAssetId) else nil

	if p3.moodAssetId then
		moodAssetId = tonumber(p3.moodAssetId)
	end

	local v7 = not p2.ppeFinalPageFullView

	v6.keyframesForPose = emoteUtility.LoadKeyframesForPose(
		currentCharacter,
		ppeEmoteAssetId,
		moodAssetId,
		true,
		v7
	)

	object:dispatch(module4())

	flag = false

	return v6
end

function v5.maybeNoteLoadingFinished(object)
	if flag then
		object:dispatch(module4())
	end

	flag = false
end

function v5.applyNewProfilePictureEditorPose(object, p2, p3, p4)
	assert(p2, "currentCharacter is non-nil.")
	assert(p3, "humanoid is non-nil..")

	if p4 then
		emoteUtility.ApplyKeyframesForPose(p2, p4)
	else
		emoteUtility.SetPlayerCharacterNeutralPose(p2)

		if Enum.HumanoidRigType.R6 == p3.RigType then
			emoteUtility.AdjustArmOnR6ForTool(p2)
		end
	end

	local v6

	if p4 then
		local finalAnimationAssetIdOrUrl = p4.finalAnimationAssetIdOrUrl

		v6 = finalAnimationAssetIdOrUrl and tostring(finalAnimationAssetIdOrUrl)
	else
		v6 = nil
	end

	module7.waitForAnimationAndPosingToResolve(function()
		object:dispatch(module6(v6))
	end)
end

function v5.undoOldProfilePictureEditorPose(object, p2, p3)
	if p3 and p2 then
		emoteUtility.SetPlayerCharacterNeutralPose(p2)
		object:dispatch(module6(nil))
	end
end

return v5
