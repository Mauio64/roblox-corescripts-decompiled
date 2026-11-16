local AvatarChatService = game:GetService("AvatarChatService")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local getCamMicPermissions = require(RobloxGui.Modules.Settings.getCamMicPermissions)

local CorePackages = game:GetService("CorePackages")
local PermissionsProtocol = require(CorePackages.Workspace.Packages.PermissionsProtocol)
local default = PermissionsProtocol.PermissionsProtocol.default

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagAvatarChatServiceEnabled = SharedFlags.GetFFlagAvatarChatServiceEnabled

local defineFastFlag = game:DefineFastFlag("DisableCameraOnSelfieViewForLowspecDevices", false)

local fn = not defineFastFlag and function(): boolean
	return true
end or require(RobloxGui.Modules.Settings.isCamEnabledForUserAndPlace)

local FaceAnimatorService = game:GetService("FaceAnimatorService")

local v = nil
local function fn2()
	if v ~= nil then
		return v
	end

	if not GetFFlagAvatarChatServiceEnabled() or _G.__TESTEZ_RUNNING_TEST__ then
		return {
			placeCamEnabled = false,
			placeMicEnabled = false,
			userCamEnabled = false,
			userCamEligible = false,
			userMicEnabled = false,
			userMicEligible = false
		}
	end

	local success, clientFeaturesAsync = pcall(AvatarChatService.GetClientFeaturesAsync, AvatarChatService)

	if not success then
		warn("Unable to get Client Features from AvatarChatService")
		return {
			placeCamEnabled = false,
			placeMicEnabled = false,
			userCamEnabled = false,
			userCamEligible = false,
			userMicEnabled = false,
			userMicEligible = false
		}
	end

	local v2 = {
		placeMicEnabled = AvatarChatService:IsEnabled(clientFeaturesAsync, Enum.AvatarChatServiceFeature.PlaceAudio),
		userMicEnabled = AvatarChatService:IsEnabled(clientFeaturesAsync, Enum.AvatarChatServiceFeature.UserAudio),
		userMicEligible = AvatarChatService:IsEnabled(
			clientFeaturesAsync,
			Enum.AvatarChatServiceFeature.UserAudioEligible
		),
		placeCamEnabled = AvatarChatService:IsEnabled(clientFeaturesAsync, Enum.AvatarChatServiceFeature.PlaceVideo),
		userCamEnabled = AvatarChatService:IsEnabled(clientFeaturesAsync, Enum.AvatarChatServiceFeature.UserVideo),
		userCamEligible = AvatarChatService:IsEnabled(
			clientFeaturesAsync,
			Enum.AvatarChatServiceFeature.UserVideoEligible
		)
	}

	if defineFastFlag and v2.placeCamEnabled and v2.userCamEligible and v2.userCamEnabled and not fn() then
		v2.userCamEnabled = false
	end

	v = v2
	return v2
end

local function getTrackerMode()
	if FaceAnimatorService.AudioAnimationEnabled and not FaceAnimatorService.VideoAnimationEnabled then
		return Enum.TrackerMode.Audio
	end

	if
		FaceAnimatorService.AudioAnimationEnabled
		or not (FaceAnimatorService.VideoAnimationEnabled and FaceAnimatorService:IsStarted())
	then
		if
			FaceAnimatorService.AudioAnimationEnabled
			and FaceAnimatorService.VideoAnimationEnabled
			and FaceAnimatorService:IsStarted()
		then
			return Enum.TrackerMode.AudioVideo
		end

		return Enum.TrackerMode.None
	end

	return Enum.TrackerMode.Video
end

local FaceChatUtils = {}
FaceChatUtils.getPermissions = fn2

function FaceChatUtils.toggleVideoAnimation()
	getCamMicPermissions(function()
		if FaceAnimatorService and FaceAnimatorService:IsStarted() and (not defineFastFlag or fn2().userCamEnabled) then
			FaceAnimatorService.VideoAnimationEnabled = not FaceAnimatorService.VideoAnimationEnabled
		end
	end, { default.Permissions.CAMERA_ACCESS })
end

FaceChatUtils.getTrackerMode = getTrackerMode

function FaceChatUtils.isCameraOn(): boolean
	local trackerMode = getTrackerMode()
	return trackerMode == Enum.TrackerMode.AudioVideo or trackerMode == Enum.TrackerMode.Video
end

return FaceChatUtils
