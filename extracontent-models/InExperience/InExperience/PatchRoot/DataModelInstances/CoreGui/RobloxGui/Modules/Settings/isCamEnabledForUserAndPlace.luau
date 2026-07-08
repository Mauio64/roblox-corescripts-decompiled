local AvatarChatService = game:GetService("AvatarChatService")
local AppStorageService = game:GetService("AppStorageService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local VideoCaptureService = game:GetService("VideoCaptureService")
local Cryo = require(CorePackages.Packages.Cryo)
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local IXPService = game:GetService("IXPService")
local MemStorageService = game:GetService("MemStorageService")
local GetFFlagAvatarChatServiceEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagAvatarChatServiceEnabled
local getFFlagUseCameraDevicesListener = require(RobloxGui.Modules.Flags.getFFlagUseCameraDevicesListener)
local cameraDevicesHelper = require(RobloxGui.Modules.Settings.cameraDevicesHelper)
local TrackerMenu = require(RobloxGui.Modules.Tracker.TrackerMenu)
local TrackerPromptType = require(RobloxGui.Modules.Tracker.TrackerPromptType)
local v15 = game:DefineFastFlag("DisableCameraOnLowSpecDevices2", false)
local v16 = game:DefineFastString("DisableCameraOnLowSpecDevicesIXPLayer", "AvatarChat.DisableOnLowSpecAndroid")
local v17 = game:DefineFastString("DisableCameraOnLowSpecDevicesIXPField", "DisableOnAndroid")
local v18 = game:DefineFastFlag("OnlyShowToastOnce2", false)
local v19 = game:DefineFastFlag("DebugAlwaysShowDisableCameraToast", false)
local v20 = game:DefineFastFlag("OnlyShowToastOnceInLifetime2", false)
local EngineFeature = game:GetEngineFeature("DisableCameraToastShownStorageKey")

local function ShouldCheckDeviceSpecs() -- line: 28
	-- upvalues: v15 (copy), IXPService (copy), v16 (copy), v17 (copy)
	if v15 then
		local ok, result = pcall(function() -- line: 31
			-- upvalues: IXPService (copy), v16 (copy)
			return IXPService:GetUserLayerVariables(v16)
		end)

		if not ok or not result or result[v17] == nil then
			return false
		end

		IXPService:LogUserLayerExposure(v16)

		return result[v17]
	end

	return false
end

return function() -- line: 46
	-- upvalues: GetFFlagAvatarChatServiceEnabled (copy), AvatarChatService (copy), v15 (copy), ShouldCheckDeviceSpecs (copy), v20 (copy), EngineFeature (copy), AppStorageService (copy), v19 (copy), TrackerMenu (copy), TrackerPromptType (copy), v18 (copy), MemStorageService (copy), getFFlagUseCameraDevicesListener (copy), cameraDevicesHelper (copy), VideoCaptureService (copy), Cryo (copy)
	if not GetFFlagAvatarChatServiceEnabled() or _G.__TESTEZ_RUNNING_TEST__ then
		return false
	end

	local ok, result = pcall(AvatarChatService.GetClientFeaturesAsync, AvatarChatService)

	if not ok then
		warn("Unable to get Client Features from AvatarChatService")

		return false
	end

	local v27 = AvatarChatService:IsEnabled(result, Enum.AvatarChatServiceFeature.PlaceVideo)
	local v28 = AvatarChatService:IsEnabled(result, Enum.AvatarChatServiceFeature.UserVideo)
	local v29 = AvatarChatService:IsEnabled(result, Enum.AvatarChatServiceFeature.UserVideoEligible)

	if v15 and v27 and v28 and v29 and not AvatarChatService:deviceMeetsRequirementsForFeature(Enum.DeviceFeatureType.DeviceCapture) and ShouldCheckDeviceSpecs() then
		if v20 and EngineFeature then
			local ok2, result2 = pcall(function() -- line: 68
				-- upvalues: AppStorageService (copy)
				return AppStorageService:GetItem("DisableCameraToastShown")
			end)

			if not ok2 or (result2 ~= "true" or v19) then
				TrackerMenu:showPrompt(TrackerPromptType.CameraUnavailable)
				pcall(function() -- line: 77
					-- upvalues: AppStorageService (copy)
					AppStorageService:SetItem("DisableCameraToastShown", "true")
					AppStorageService:Flush()
				end)
			end
		elseif v18 then
			if MemStorageService:GetItem("DisableCameraToastShown") ~= "true" or v19 then
				TrackerMenu:showPrompt(TrackerPromptType.CameraUnavailable)
				MemStorageService:SetItem("DisableCameraToastShown", "true")
			end
		else
			TrackerMenu:showPrompt(TrackerPromptType.CameraUnavailable)
		end

		return false
	end

	local v32 = if not getFFlagUseCameraDevicesListener() then VideoCaptureService:GetCameraDevices() else cameraDevicesHelper.GetDevices()
	local v33 = Cryo.isEmpty(v32)

	if v27 then
		v27 = v29

		if v27 then
			v27 = v28

			if v27 then
				v27 = not v33
			end
		end
	end

	return v27
end
