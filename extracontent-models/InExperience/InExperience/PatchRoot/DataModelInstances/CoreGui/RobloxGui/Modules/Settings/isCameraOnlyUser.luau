local AvatarChatService = game:GetService("AvatarChatService")
local CoreGui = game:GetService("CoreGui")
local VideoCaptureService = game:GetService("VideoCaptureService")
local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagAvatarChatServiceEnabled = SharedFlags.GetFFlagAvatarChatServiceEnabled
local getFFlagUseCameraDevicesListener = require(RobloxGui.Modules.Flags.getFFlagUseCameraDevicesListener)
local cameraDevicesHelper = require(RobloxGui.Modules.Settings.cameraDevicesHelper)

return function(): boolean
	if not GetFFlagAvatarChatServiceEnabled() then
		return false
	end

	local success, clientFeaturesAsync = pcall(AvatarChatService.GetClientFeaturesAsync, AvatarChatService)

	if not success then
		warn("Unable to get Client Features from AvatarChatService")
		return false
	end

	local isEnabled = AvatarChatService:IsEnabled(clientFeaturesAsync, Enum.AvatarChatServiceFeature.PlaceVideo)
	local isEnabled2 = AvatarChatService:IsEnabled(clientFeaturesAsync, Enum.AvatarChatServiceFeature.UserVideo)
	local isEnabled3 = AvatarChatService:IsEnabled(clientFeaturesAsync, Enum.AvatarChatServiceFeature.UserVideoEligible)
	local isEnabled4 = AvatarChatService:IsEnabled(clientFeaturesAsync, Enum.AvatarChatServiceFeature.PlaceAudio)
	local isEnabled5 = AvatarChatService:IsEnabled(clientFeaturesAsync, Enum.AvatarChatServiceFeature.UserAudio)
	local isEnabled6 = AvatarChatService:IsEnabled(clientFeaturesAsync, Enum.AvatarChatServiceFeature.UserAudioEligible)
	local v

	if getFFlagUseCameraDevicesListener() then
		v = cameraDevicesHelper.GetDevices()
	else
		v = VideoCaptureService:GetCameraDevices()
	end

	if Cryo.isEmpty(v) or not isEnabled or isEnabled4 and isEnabled5 and isEnabled6 then
		return false
	end

	return if isEnabled2 and isEnabled3 then true else false
end
