local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local CaptureService = game:GetService("CaptureService")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local CapturesToastType = require(ParentParent.Enums.CapturesToastType)
local getAvatarAssets = require(ParentParent.Utils.getAvatarAssets)
local getScreenshotHud = require(ParentParent.Utils.getScreenshotHud)
local getUserMetadata = require(ParentParent.Utils.getUserMetadata)
local IXPServiceWrapper = require(ParentParentParent.IXPServiceWrapper).IXPServiceWrapper
local OverlayActivated = require(ParentParent.Actions.OverlayActivated)
local OverlayDeactivated = require(ParentParent.Actions.OverlayDeactivated)
local OverlayFlashActivated = require(ParentParent.Actions.OverlayFlashActivated)
local OverlayFlashDeactivated = require(ParentParent.Actions.OverlayFlashDeactivated)
local removeCoreUI = require(ParentParent.Utils.removeCoreUI)
local ToastTriggered = require(ParentParent.Actions.ToastTriggered)
local FStringSocialCaptureTakenIXPLayer = require(ParentParentParent.SharedFlags).FStringSocialCaptureTakenIXPLayer
local v19 = game:DefineFastFlag("DebugAPPEXP4747B", false)

local function hideGui(p1) -- line: 25
	-- upvalues: GuiService (copy)
	if GuiService:GetGuiIsVisible(p1) then
		GuiService:ToggleGuiIsVisibleForCaptures(p1)
	end
end
local function showGui(p2) -- line: 31
	-- upvalues: GuiService (copy)
	if not GuiService:GetGuiIsVisible(p2) then
		GuiService:ToggleGuiIsVisibleForCaptures(p2)
	end
end
local function hidePlayerGui() -- line: 37
	-- upvalues: GuiService (copy)
	if GuiService:GetGuiIsVisible(Enum.GuiType.Custom) then
		GuiService:ToggleGuiIsVisibleForCaptures(Enum.GuiType.Custom)
	end
end
local function showPlayerGui() -- line: 43
	-- upvalues: GuiService (copy)
	if not GuiService:GetGuiIsVisible(Enum.GuiType.Custom) then
		GuiService:ToggleGuiIsVisibleForCaptures(Enum.GuiType.Custom)
	end
end

return function() -- line: 49
	-- upvalues: ToastTriggered (copy), CapturesToastType (copy), UserInputService (copy), getScreenshotHud (copy), v19 (copy), GuiService (copy), removeCoreUI (copy), OverlayActivated (copy), CaptureService (copy), getAvatarAssets (copy), getUserMetadata (copy), HttpService (copy), OverlayFlashActivated (copy), OverlayFlashDeactivated (copy), OverlayDeactivated (copy), IXPServiceWrapper (copy), FStringSocialCaptureTakenIXPLayer (copy)
	return function(p3) -- line: 50
		-- upvalues: ToastTriggered (copy), CapturesToastType (copy), UserInputService (copy), getScreenshotHud (copy), v19 (copy), GuiService (copy), removeCoreUI (copy), OverlayActivated (copy), CaptureService (copy), getAvatarAssets (copy), getUserMetadata (copy), HttpService (copy), OverlayFlashActivated (copy), OverlayFlashDeactivated (copy), OverlayDeactivated (copy), IXPServiceWrapper (copy), FStringSocialCaptureTakenIXPLayer (copy)
		local v27 = false
		local v28 = false

		p3:dispatch(ToastTriggered(CapturesToastType.None))

		local OverrideMouseIconBehavior = UserInputService.OverrideMouseIconBehavior

		UserInputService.OverrideMouseIconBehavior = Enum.OverrideMouseIconBehavior.ForceHide

		local v30 = getScreenshotHud()

		if not v19 and (not v30 or v30.HidePlayerGuiForCaptures) then
			if GuiService:GetGuiIsVisible(Enum.GuiType.Custom) then
				GuiService:ToggleGuiIsVisibleForCaptures(Enum.GuiType.Custom)
			end

			v28 = true
		end

		local v31 = nil

		if not v19 then
			if not v30 or v30.HideCoreGuiForCaptures then
				v31 = removeCoreUI()
				v27 = true
			end

			local CustomBillboards = Enum.GuiType.CustomBillboards

			if GuiService:GetGuiIsVisible(CustomBillboards) then
				GuiService:ToggleGuiIsVisibleForCaptures(CustomBillboards)
			end

			local PlayerNameplates = Enum.GuiType.PlayerNameplates

			if GuiService:GetGuiIsVisible(PlayerNameplates) then
				GuiService:ToggleGuiIsVisibleForCaptures(PlayerNameplates)
			end
		end

		p3:dispatch(OverlayActivated())
		CaptureService:OnCaptureBegan()
		task.wait(0.1)

		local v34 = getAvatarAssets()
		local v35 = getUserMetadata()

		if next(v34) == nil and next(v35) == nil then
			CaptureService:SaveScreenshotCapture()
		else
			local t1 = {
				avatarItems = if next(v34) == nil then nil else v34,
				userMetadata = if next(v35) == nil then nil else v35
			}

			CaptureService:SaveScreenshotCapture(HttpService:JSONEncode(t1))
		end

		task.wait()
		p3:dispatch(OverlayFlashActivated())
		task.wait(0.5)
		CaptureService:OnCaptureEnded()
		p3:dispatch(OverlayFlashDeactivated())
		p3:dispatch(OverlayDeactivated())
		UserInputService.OverrideMouseIconBehavior = OverrideMouseIconBehavior

		if v28 and not GuiService:GetGuiIsVisible(Enum.GuiType.Custom) then
			GuiService:ToggleGuiIsVisibleForCaptures(Enum.GuiType.Custom)
		end

		if v27 then
			v31()
		end

		local CustomBillboards = Enum.GuiType.CustomBillboards

		if not GuiService:GetGuiIsVisible(CustomBillboards) then
			GuiService:ToggleGuiIsVisibleForCaptures(CustomBillboards)
		end

		local PlayerNameplates = Enum.GuiType.PlayerNameplates

		if not GuiService:GetGuiIsVisible(PlayerNameplates) then
			GuiService:ToggleGuiIsVisibleForCaptures(PlayerNameplates)
		end

		IXPServiceWrapper:LogUserLayerExposure(FStringSocialCaptureTakenIXPLayer)
	end
end
