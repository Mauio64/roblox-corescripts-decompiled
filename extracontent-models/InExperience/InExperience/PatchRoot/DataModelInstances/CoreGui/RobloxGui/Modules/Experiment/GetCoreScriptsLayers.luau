local CorePackages = game:GetService("CorePackages")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FStringSocialCaptureIXPLayer = SharedFlags.FStringSocialCaptureIXPLayer

local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FStringSocialCaptureTakenIXPLayer = SharedFlags2.FStringSocialCaptureTakenIXPLayer
require(script.Parent.Parent.Flags.GetFFlagEnableNewInviteMenuIXP)

local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFStringLargerRobuxUpsellIxpLayer = SharedFlags3.GetFStringLargerRobuxUpsellIxpLayer

local SharedFlags4 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFStringLuaAppExperienceMenuLayer = SharedFlags4.GetFStringLuaAppExperienceMenuLayer

local GetFStringLuaAppConsoleExperienceMenuLayer = require(script.Parent.Parent.Flags.GetFStringLuaAppConsoleExperienceMenuLayer)

local SharedFlags5 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagReportAnythingAnnotationIXP = SharedFlags5.GetFFlagReportAnythingAnnotationIXP

local SharedFlags6 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFStringReportAnythingAnnotationIXPLayerName = SharedFlags6.GetFStringReportAnythingAnnotationIXPLayerName
local GetFStringChatTranslationLayerName = require(script.Parent.Parent.Flags.GetFStringChatTranslationLayerName)
local GetFFlagChatTranslationSettingEnabled = require(script.Parent.Parent.Flags.GetFFlagChatTranslationSettingEnabled)
local GetFFlagVoiceUserAgencyEnableIXP = require(script.Parent.Parent.Flags.GetFFlagVoiceUserAgencyEnableIXP)
local GetFStringVoiceUserAgencyIXPLayerName = require(script.Parent.Parent.Flags.GetFStringVoiceUserAgencyIXPLayerName)

local SharedFlags7 = require(CorePackages.Workspace.Packages.SharedFlags)
local getFStringDesktopToastNotificationLayer = SharedFlags7.getFStringDesktopToastNotificationLayer

local GetFFlagUXForCameraPerformanceIXPEnabled = require(script.Parent.Parent.Flags.GetFFlagUXForCameraPerformanceIXPEnabled)

local GetFStringUXForCameraPerformanceIXPLayerName = require(script.Parent.Parent.Flags.GetFStringUXForCameraPerformanceIXPLayerName)
local GetFStringVoiceExposureIXPLayerName = require(script.Parent.Parent.Flags.GetFStringVoiceExposureIXPLayerName)

local SharedFlags8 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFStringAndroidPhoneVerificationLayer = SharedFlags8.GetFStringAndroidPhoneVerificationLayer

local SharedFlags9 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFStringIOSPhoneVerificationLayer = SharedFlags9.GetFStringIOSPhoneVerificationLayer

local SharedFlags10 = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagEnableAppChatInExperience = SharedFlags10.GetFFlagEnableAppChatInExperience

local SharedFlags11 = require(CorePackages.Workspace.Packages.SharedFlags)
local getFStringAppChatInExperienceIXPLayer = SharedFlags11.getFStringAppChatInExperienceIXPLayer
local SharedFlags12 = require(CorePackages.Workspace.Packages.SharedFlags)
local FStringReportMenuIXPLayer = SharedFlags12.FStringReportMenuIXPLayer
local SharedFlags13 = require(CorePackages.Workspace.Packages.SharedFlags)
local FStringReportingIXPLayer = SharedFlags13.FStringReportingIXPLayer

local FFlagEnableShopExposureLogging = require(CorePackages.Workspace.Packages.InExperienceShop.FFlagEnableShopExposureLogging)

local FStringExperienceShopLayer1 = require(CorePackages.Workspace.Packages.InExperienceShop.FStringExperienceShopLayer1)

local FStringExperienceShopLayer2 = require(CorePackages.Workspace.Packages.InExperienceShop.FStringExperienceShopLayer2)

return function()
	local v = {
		"AbuseReports",
		getFStringDesktopToastNotificationLayer(),
		FStringReportMenuIXPLayer,
		FStringReportingIXPLayer,
		FStringSocialCaptureIXPLayer,
		FStringSocialCaptureTakenIXPLayer
	}

	table.insert(v, GetFStringLuaAppExperienceMenuLayer())
	table.insert(v, GetFStringLuaAppConsoleExperienceMenuLayer())

	if GetFStringLargerRobuxUpsellIxpLayer() then
		table.insert(v, GetFStringLargerRobuxUpsellIxpLayer())
	end

	if GetFFlagReportAnythingAnnotationIXP() then
		table.insert(v, GetFStringReportAnythingAnnotationIXPLayerName())
	end

	if GetFFlagChatTranslationSettingEnabled() and #GetFStringChatTranslationLayerName() > 0 then
		table.insert(v, GetFStringChatTranslationLayerName())
	end

	if GetFFlagVoiceUserAgencyEnableIXP() then
		table.insert(v, GetFStringVoiceUserAgencyIXPLayerName())
	end

	if GetFFlagUXForCameraPerformanceIXPEnabled() then
		table.insert(v, GetFStringUXForCameraPerformanceIXPLayerName())
	end

	table.insert(v, GetFStringVoiceExposureIXPLayerName())

	if GetFStringAndroidPhoneVerificationLayer() then
		table.insert(v, GetFStringAndroidPhoneVerificationLayer())
	end

	if GetFStringIOSPhoneVerificationLayer() then
		table.insert(v, GetFStringIOSPhoneVerificationLayer())
	end

	if GetFFlagEnableAppChatInExperience() then
		table.insert(v, getFStringAppChatInExperienceIXPLayer())
	end

	if FFlagEnableShopExposureLogging then
		table.insert(v, FStringExperienceShopLayer1)
		table.insert(v, FStringExperienceShopLayer2)
	end

	return v
end
