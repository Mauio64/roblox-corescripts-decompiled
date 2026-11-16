local parent = script.Parent.Parent
local parent2 = parent.Parent

local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

local CaptureService = require(parent.Services.CaptureService)
local CapturesToastType = require(parent.Enums.CapturesToastType)
local Constants = require(parent.Constants)
local getAvatarAssets = require(parent.Utils.getAvatarAssets)
local getScreenshotHud = require(parent.Utils.getScreenshotHud)
local getUserMetadata = require(parent.Utils.getUserMetadata)
local isEligibleForMoments = require(parent.Utils.isEligibleForMoments)
local IXPServiceWrapper = require(parent2.IXPServiceWrapper)
local ixpServiceWrapper = IXPServiceWrapper.IXPServiceWrapper
local logCaptureEndLayerExposure = require(parent.Utils.logCaptureEndLayerExposure)
local OverlayActivated = require(parent.Actions.OverlayActivated)
local OverlayDeactivated = require(parent.Actions.OverlayDeactivated)
local OverlayFlashActivated = require(parent.Actions.OverlayFlashActivated)
local OverlayFlashDeactivated = require(parent.Actions.OverlayFlashDeactivated)
local pendingCaptureToastAction = require(parent.Utils.pendingCaptureToastAction)
local removeCoreUI = require(parent.Utils.removeCoreUI)
local ToastTriggered = require(parent.Actions.ToastTriggered)
require(parent.Types)

local SharedFlags = require(parent2.SharedFlags)
local FStringSocialCaptureTakenIXPLayer = SharedFlags.FStringSocialCaptureTakenIXPLayer
local SharedFlags2 = require(parent2.SharedFlags)
local FFlagBuildExperienceInGameCaptureToChat = SharedFlags2.FFlagBuildExperienceInGameCaptureToChat
local FFlagMomentsCaptureEndIxpEnabled = require(parent.Flags.FFlagMomentsCaptureEndIxpEnabled)

local defineFastFlag = game:DefineFastFlag("DebugAPPEXP4747B", false)

local function hideGui(p) -- 2 equivalent calls inferred from this helper
	if GuiService:GetGuiIsVisible(p) then
		GuiService:ToggleGuiIsVisibleForCaptures(p)
	end
end

local function showGui(p) -- 2 equivalent calls inferred from this helper
	if not GuiService:GetGuiIsVisible(p) then
		GuiService:ToggleGuiIsVisibleForCaptures(p)
	end
end

local function hidePlayerGui() -- 1 equivalent call inferred from this helper
	if GuiService:GetGuiIsVisible(Enum.GuiType.Custom) then
		GuiService:ToggleGuiIsVisibleForCaptures(Enum.GuiType.Custom)
	end
end

local function showPlayerGui() -- 1 equivalent call inferred from this helper
	if not GuiService:GetGuiIsVisible(Enum.GuiType.Custom) then
		GuiService:ToggleGuiIsVisibleForCaptures(Enum.GuiType.Custom)
	end
end

return function(p)
	return function(object)
		local flag = false
		local flag2 = false

		if FFlagBuildExperienceInGameCaptureToChat then
			local set = pendingCaptureToastAction.set
			local v

			if p then
				v = p.toastAction
			end

			set(v)
		end

		object:dispatch(ToastTriggered(CapturesToastType.None))

		local overrideMouseIconBehavior = UserInputService.OverrideMouseIconBehavior
		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide

		local screenshotHud = getScreenshotHud()

		if not defineFastFlag and (not screenshotHud or screenshotHud.HidePlayerGuiForCaptures) then
			hidePlayerGui() -- inferred equivalent call
			flag2 = true
		end

		local v = nil

		if not defineFastFlag then
			if not screenshotHud or screenshotHud.HideCoreGuiForCaptures then
				v = removeCoreUI()
				flag = true
			end

			hideGui(Enum.GuiType.CustomBillboards) -- inferred equivalent call
			hideGui(Enum.GuiType.PlayerNameplates) -- inferred equivalent call
		end

		object:dispatch(OverlayActivated())

		CaptureService:OnCaptureBegan()

		task.wait(0.1)

		local avatarAssets = getAvatarAssets()
		local userMetadata = getUserMetadata()

		if next(avatarAssets) == nil and next(userMetadata) == nil then
			CaptureService:SaveScreenshotCapture()
		else
			if next(avatarAssets) == nil then
				avatarAssets = nil
			end

			if next(userMetadata) == nil then
				userMetadata = nil
			end

			CaptureService:SaveScreenshotCapture(HttpService:JSONEncode({
				avatarItems = avatarAssets,
				userMetadata = userMetadata
			}))
		end

		task.wait()

		object:dispatch(OverlayFlashActivated())

		task.wait(0.5)

		CaptureService:OnCaptureEnded()

		object:dispatch(OverlayFlashDeactivated())
		object:dispatch(OverlayDeactivated())

		UserInputService.OverrideMouseIconBehavior = overrideMouseIconBehavior

		if flag2 then
			showPlayerGui() -- inferred equivalent call
		end

		if flag then
			v()
		end

		showGui(Enum.GuiType.CustomBillboards) -- inferred equivalent call
		showGui(Enum.GuiType.PlayerNameplates) -- inferred equivalent call

		ixpServiceWrapper:LogUserLayerExposure(FStringSocialCaptureTakenIXPLayer)

		if
			FFlagMomentsCaptureEndIxpEnabled
			and isEligibleForMoments(object:getState()[Constants.RoduxKey].MomentsEligibility)
		then
			logCaptureEndLayerExposure()
		end
	end
end
