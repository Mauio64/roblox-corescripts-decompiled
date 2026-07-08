local AvatarChatService = game:GetService("AvatarChatService")
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local getCamMicPermissions = require(RobloxGui.Modules.Settings.getCamMicPermissions)
local CorePackages = game:GetService("CorePackages")
local default = require(CorePackages.Workspace.Packages.PermissionsProtocol).PermissionsProtocol.default
local GetFFlagAvatarChatServiceEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagAvatarChatServiceEnabled
local v7 = game:DefineFastFlag("DisableCameraOnSelfieViewForLowspecDevices", false)

local function u8() -- line: 14
	return true
end

if v7 then
	u8 = require(RobloxGui.Modules.Settings.isCamEnabledForUserAndPlace)
end

local FaceAnimatorService = game:GetService("FaceAnimatorService")
local u10 = nil

local function v11() -- line: 34
	-- upvalues: u10 (ref), GetFFlagAvatarChatServiceEnabled (copy), AvatarChatService (copy), v7 (copy), u8 (ref)
	if u10 ~= nil then
		return u10
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

	local ok, result = pcall(AvatarChatService.GetClientFeaturesAsync, AvatarChatService)

	if not ok then
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

	local t1 = {
		placeMicEnabled = AvatarChatService:IsEnabled(result, Enum.AvatarChatServiceFeature.PlaceAudio),
		userMicEnabled = AvatarChatService:IsEnabled(result, Enum.AvatarChatServiceFeature.UserAudio),
		userMicEligible = AvatarChatService:IsEnabled(result, Enum.AvatarChatServiceFeature.UserAudioEligible),
		placeCamEnabled = AvatarChatService:IsEnabled(result, Enum.AvatarChatServiceFeature.PlaceVideo),
		userCamEnabled = AvatarChatService:IsEnabled(result, Enum.AvatarChatServiceFeature.UserVideo),
		userCamEligible = AvatarChatService:IsEnabled(result, Enum.AvatarChatServiceFeature.UserVideoEligible)
	}

	if v7 and t1.placeCamEnabled and t1.userCamEligible and t1.userCamEnabled and not u8() then
		t1.userCamEnabled = false
	end

	u10 = t1

	return t1
end
local function getTrackerMode() -- line: 101
	-- upvalues: FaceAnimatorService (copy)
	if FaceAnimatorService.AudioAnimationEnabled and not FaceAnimatorService.VideoAnimationEnabled then
		return Enum.TrackerMode.Audio
	end

	if not FaceAnimatorService.AudioAnimationEnabled and FaceAnimatorService.VideoAnimationEnabled and FaceAnimatorService:IsStarted() then
		return Enum.TrackerMode.Video
	end

	if FaceAnimatorService.AudioAnimationEnabled and FaceAnimatorService.VideoAnimationEnabled and FaceAnimatorService:IsStarted() then
		return Enum.TrackerMode.AudioVideo
	end

	return Enum.TrackerMode.None
end

return {
	getPermissions = v11,
	toggleVideoAnimation = function() -- line: 87
		-- upvalues: FaceAnimatorService (copy), v7 (copy), v11 (copy), getCamMicPermissions (copy), default (copy)
		getCamMicPermissions(function() -- line: 88
			-- upvalues: FaceAnimatorService (copy), v7 (copy), v11 (copy)
			if not FaceAnimatorService or not FaceAnimatorService:IsStarted() then
				return
			end

			if not v7 or v11().userCamEnabled then
				FaceAnimatorService.VideoAnimationEnabled = not FaceAnimatorService.VideoAnimationEnabled
			end
		end, { default.Permissions.CAMERA_ACCESS })
	end,
	getTrackerMode = getTrackerMode,
	isCameraOn = function() -- line: 121
		-- upvalues: getTrackerMode (copy)
		local v16 = getTrackerMode()

		return v16 == Enum.TrackerMode.AudioVideo or v16 == Enum.TrackerMode.Video
	end
}
