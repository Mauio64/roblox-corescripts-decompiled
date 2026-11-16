local AvatarChatService = game:GetService("AvatarChatService")
local AppStorageService = game:GetService("AppStorageService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local VideoCaptureService = game:GetService("VideoCaptureService")
local Cryo = require(CorePackages.Packages.Cryo)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local IXPService = game:GetService("IXPService")
local MemStorageService = game:GetService("MemStorageService")

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagAvatarChatServiceEnabled = SharedFlags.GetFFlagAvatarChatServiceEnabled
local getFFlagUseCameraDevicesListener = require(RobloxGui.Modules.Flags.getFFlagUseCameraDevicesListener)
local cameraDevicesHelper = require(RobloxGui.Modules.Settings.cameraDevicesHelper)

local TrackerMenu = require(RobloxGui.Modules.Tracker.TrackerMenu)
local TrackerPromptType = require(RobloxGui.Modules.Tracker.TrackerPromptType)

local defineFastFlag = game:DefineFastFlag("DisableCameraOnLowSpecDevices2", false)
local defineFastString = game:DefineFastString(
	"DisableCameraOnLowSpecDevicesIXPLayer",
	"AvatarChat.DisableOnLowSpecAndroid"
)
local defineFastString2 = game:DefineFastString("DisableCameraOnLowSpecDevicesIXPField", "DisableOnAndroid")
local defineFastFlag2 = game:DefineFastFlag("OnlyShowToastOnce2", false)
local defineFastFlag3 = game:DefineFastFlag("DebugAlwaysShowDisableCameraToast", false)
local defineFastFlag4 = game:DefineFastFlag("OnlyShowToastOnceInLifetime2", false)
local engineFeature = game:GetEngineFeature("DisableCameraToastShownStorageKey")

local function ShouldCheckDeviceSpecs()
	if not defineFastFlag then
		return false
	end

	local success, result = pcall(function()
		return IXPService:GetUserLayerVariables(defineFastString)
	end)

	if not success or not result or result[defineFastString2] == nil then
		return false
	end

	IXPService:LogUserLayerExposure(defineFastString)
	return result[defineFastString2]
end

return function()
	if not GetFFlagAvatarChatServiceEnabled() or _G.__TESTEZ_RUNNING_TEST__ then
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

	if
		defineFastFlag
		and isEnabled
		and isEnabled2
		and isEnabled3
		and not AvatarChatService:deviceMeetsRequirementsForFeature(Enum.DeviceFeatureType.DeviceCapture)
		and ShouldCheckDeviceSpecs()
	then
		if defineFastFlag4 and engineFeature then
			local success2, result = pcall(function()
				return AppStorageService:GetItem("DisableCameraToastShown")
			end)

			if not success2 or result ~= "true" or defineFastFlag3 then
				TrackerMenu:showPrompt(TrackerPromptType.CameraUnavailable)
				pcall(function()
					AppStorageService:SetItem("DisableCameraToastShown", "true")
					AppStorageService:Flush()
				end)
			end
		elseif defineFastFlag2 then
			if MemStorageService:GetItem("DisableCameraToastShown") ~= "true" or defineFastFlag3 then
				TrackerMenu:showPrompt(TrackerPromptType.CameraUnavailable)
				MemStorageService:SetItem("DisableCameraToastShown", "true")
			end
		else
			TrackerMenu:showPrompt(TrackerPromptType.CameraUnavailable)
		end

		return false
	else
		local v

		if getFFlagUseCameraDevicesListener() then
			v = cameraDevicesHelper.GetDevices()
		else
			v = VideoCaptureService:GetCameraDevices()
		end

		local v2 = not Cryo.isEmpty(v)
		return isEnabled and isEnabled3 and isEnabled2 and v2
	end
end
