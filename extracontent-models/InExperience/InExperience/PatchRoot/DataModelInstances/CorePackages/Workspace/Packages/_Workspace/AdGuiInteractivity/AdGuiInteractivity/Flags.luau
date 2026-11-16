game:DefineFastString("AdsVolumeOffImageLua", "rbxassetid://14986179621")
game:DefineFastString("AdsVolumeOnImageLua", "rbxassetid://14986178697")
game:DefineFastString("AdsEnterFullscreenImageLua", "rbxassetid://14986182327")
game:DefineFastString("AdsExitFullscreenImageLua", "rbxassetid://14986181606")
game:DefineFastString("AdsEudsaPromptActiveImageLua", "rbxassetid://16017622465")
game:DefineFastString("AdsEudsaPromptInactiveImageLua", "rbxassetid://16040129720")
game:DefineFastString("AdGuiPlayButtonImageLua", "rbxassetid://16639542545")
game:DefineFastString("AdGuiPauseButtonImageLua", "rbxassetid://16639540538")
game:DefineFastString("AdGuiCloseButtonImageLua", "rbxassetid://16639540023")
game:DefineFastString("AdGuiLivePreviewWatermark", "rbxassetid://18539441909")
game:DefineFastString("AdGuiLivePreviewWatermarkV2", "rbxassetid://18641531344")
game:DefineFastString("LivePreviewPlaceId", "-1")
game:DefineFastFlag("UseV2LivePreviewWatermark", false)
game:DefineFastFlag("EnableReportAdDropdown5", false)
game:DefineFastInt("UniversalAppPolicyFailureTelemetryThrottleHundredthsPercent", 10000)
game:DefineFastFlag("EnableHideReportAdModalDuringScreenshot2", false)
game:DefineFastInt("AdGuiInteractivityPixelsPerStud", 50)
local Flags = {}

function Flags.GetFStringAdsVolumeOffImageLua()
	return game:GetFastString("AdsVolumeOffImageLua")
end

function Flags.GetFStringAdsVolumeOnImageLua()
	return game:GetFastString("AdsVolumeOnImageLua")
end

function Flags.GetFStringAdsEnterFullscreenImageLua()
	return game:GetFastString("AdsEnterFullscreenImageLua")
end

function Flags.GetFStringAdsExitFullscreenImageLua()
	return game:GetFastString("AdsExitFullscreenImageLua")
end

function Flags.GetFStringAdsEudsaPromptActiveImageLua()
	return game:GetFastString("AdsEudsaPromptActiveImageLua")
end

function Flags.GetFStringAdsEudsaPromptInactiveImageLua()
	return game:GetFastString("AdsEudsaPromptInactiveImageLua")
end

function Flags.GetFStringAdGuiPlayButtonImageLua()
	return game:GetFastString("AdGuiPlayButtonImageLua")
end

function Flags.GetFStringAdGuiPauseButtonImageLua()
	return game:GetFastString("AdGuiPauseButtonImageLua")
end

function Flags.GetFStringAdGuiCloseButtonImageLua()
	return game:GetFastString("AdGuiCloseButtonImageLua")
end

function Flags.GetFStringAdGuiLivePreviewWatermark()
	return game:GetFastString("AdGuiLivePreviewWatermark")
end

function Flags.GetFStringLivePreviewPlaceId()
	return game:GetFastString("LivePreviewPlaceId")
end

function Flags.GetFFlagUseV2LivePreviewWatermark()
	return game:GetFastFlag("UseV2LivePreviewWatermark")
end

function Flags.GetFStringAdGuiLivePreviewWatermarkV2()
	return game:GetFastString("AdGuiLivePreviewWatermarkV2")
end

function Flags.GetFFlagEnableReportAdDropdown()
	return game:GetFastFlag("EnableReportAdDropdown5")
end

Flags.FFlagFixReportAdInfoDuringRotation = game:DefineFastFlag("FixReportAdInfoDuringRotation", false)
function Flags.GetFIntUniversalAppPolicyFailureTelemetryThrottleHundredthsPercent()
	return game:GetFastInt("UniversalAppPolicyFailureTelemetryThrottleHundredthsPercent")
end

function Flags.GetEnableHideReportAdModalDuringScreenshot()
	return game:GetFastFlag("EnableHideReportAdModalDuringScreenshot2")
end

function Flags.GetAdGuiInteractivityPixelsPerStud()
	return game:GetFastInt("AdGuiInteractivityPixelsPerStud")
end

return Flags
