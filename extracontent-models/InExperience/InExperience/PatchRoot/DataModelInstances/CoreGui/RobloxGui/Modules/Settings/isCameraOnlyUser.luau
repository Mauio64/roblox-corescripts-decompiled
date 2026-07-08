local AvatarChatService = game:GetService("AvatarChatService")
local CoreGui = game:GetService("CoreGui")
local VideoCaptureService = game:GetService("VideoCaptureService")
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local GetFFlagAvatarChatServiceEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagAvatarChatServiceEnabled
local getFFlagUseCameraDevicesListener = require(RobloxGui.Modules.Flags.getFFlagUseCameraDevicesListener)
local cameraDevicesHelper = require(RobloxGui.Modules.Settings.cameraDevicesHelper)

return function() -- line: 14
	-- upvalues: GetFFlagAvatarChatServiceEnabled (copy), AvatarChatService (copy), getFFlagUseCameraDevicesListener (copy), cameraDevicesHelper (copy), VideoCaptureService (copy), Cryo (copy)
	if not GetFFlagAvatarChatServiceEnabled() then
		return false
	end

	local ok, result = pcall(AvatarChatService.GetClientFeaturesAsync, AvatarChatService)

	if not ok then
		warn("Unable to get Client Features from AvatarChatService")

		return false
	end

	local v12 = AvatarChatService:IsEnabled(result, Enum.AvatarChatServiceFeature.PlaceVideo)
	local v13 = AvatarChatService:IsEnabled(result, Enum.AvatarChatServiceFeature.UserVideo)
	local v14 = AvatarChatService:IsEnabled(result, Enum.AvatarChatServiceFeature.UserVideoEligible)
	local v15 = AvatarChatService:IsEnabled(result, Enum.AvatarChatServiceFeature.PlaceAudio)
	local v16 = AvatarChatService:IsEnabled(result, Enum.AvatarChatServiceFeature.UserAudio)
	local v17 = AvatarChatService:IsEnabled(result, Enum.AvatarChatServiceFeature.UserAudioEligible)
	local v18 = if not getFFlagUseCameraDevicesListener() then VideoCaptureService:GetCameraDevices() else cameraDevicesHelper.GetDevices()

	if Cryo.isEmpty(v18) then
		return false
	end

	local v19 = v16 and v17
	local v20 = v13 and v14

	if not v12 then
		return false
	end

	if v15 and v19 then
		return false
	end

	if v20 then
		return true
	end

	return false
end
