local CorePackages = game:GetService("CorePackages")
local FStringSocialCaptureIXPLayer = require(CorePackages.Workspace.Packages.SharedFlags).FStringSocialCaptureIXPLayer
local FStringSocialCaptureTakenIXPLayer = require(CorePackages.Workspace.Packages.SharedFlags).FStringSocialCaptureTakenIXPLayer

require(script.Parent.Parent.Flags.GetFFlagEnableNewInviteMenuIXP)

local GetFStringLargerRobuxUpsellIxpLayer = require(CorePackages.Workspace.Packages.SharedFlags).GetFStringLargerRobuxUpsellIxpLayer
local GetFStringLuaAppExperienceMenuLayer = require(CorePackages.Workspace.Packages.SharedFlags).GetFStringLuaAppExperienceMenuLayer
local GetFStringLuaAppConsoleExperienceMenuLayer = require(script.Parent.Parent.Flags.GetFStringLuaAppConsoleExperienceMenuLayer)
local GetFFlagReportAnythingAnnotationIXP = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagReportAnythingAnnotationIXP
local GetFStringReportAnythingAnnotationIXPLayerName = require(CorePackages.Workspace.Packages.SharedFlags).GetFStringReportAnythingAnnotationIXPLayerName
local _ = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagReportTabShareIXPLayerWithMenu
local GetFStringChatTranslationLayerName = require(script.Parent.Parent.Flags.GetFStringChatTranslationLayerName)
local GetFFlagChatTranslationSettingEnabled = require(script.Parent.Parent.Flags.GetFFlagChatTranslationSettingEnabled)
local GetFFlagVoiceUserAgencyEnableIXP = require(script.Parent.Parent.Flags.GetFFlagVoiceUserAgencyEnableIXP)
local GetFStringVoiceUserAgencyIXPLayerName = require(script.Parent.Parent.Flags.GetFStringVoiceUserAgencyIXPLayerName)
local GetFFlagLuaInExperienceCoreScriptsGameInviteUnification = require(script.Parent.Parent.Flags.GetFFlagLuaInExperienceCoreScriptsGameInviteUnification)
local getFStringDesktopToastNotificationLayer = require(CorePackages.Workspace.Packages.SharedFlags).getFStringDesktopToastNotificationLayer
local GetFStringGameInviteMenuLayer = require(CorePackages.Workspace.Packages.SharedFlags).GetFStringGameInviteMenuLayer
local GetFFlagUXForCameraPerformanceIXPEnabled = require(script.Parent.Parent.Flags.GetFFlagUXForCameraPerformanceIXPEnabled)
local GetFStringUXForCameraPerformanceIXPLayerName = require(script.Parent.Parent.Flags.GetFStringUXForCameraPerformanceIXPLayerName)
local GetFStringVoiceExposureIXPLayerName = require(script.Parent.Parent.Flags.GetFStringVoiceExposureIXPLayerName)
local GetFStringAndroidPhoneVerificationLayer = require(CorePackages.Workspace.Packages.SharedFlags).GetFStringAndroidPhoneVerificationLayer
local GetFStringIOSPhoneVerificationLayer = require(CorePackages.Workspace.Packages.SharedFlags).GetFStringIOSPhoneVerificationLayer
local GetFFlagEnableAppChatInExperience = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAppChatInExperience
local getFStringAppChatInExperienceIXPLayer = require(CorePackages.Workspace.Packages.SharedFlags).getFStringAppChatInExperienceIXPLayer
local FStringReportMenuIXPLayer = require(CorePackages.Workspace.Packages.SharedFlags).FStringReportMenuIXPLayer
local FStringReportingIXPLayer = require(CorePackages.Workspace.Packages.SharedFlags).FStringReportingIXPLayer
local FStringEARReportMenuIXPLayer = require(CorePackages.Workspace.Packages.SharedFlags).FStringEARReportMenuIXPLayer

return function() -- line: 44
	-- upvalues: getFStringDesktopToastNotificationLayer (copy), FStringReportMenuIXPLayer (copy), FStringReportingIXPLayer (copy), FStringEARReportMenuIXPLayer (copy), FStringSocialCaptureIXPLayer (copy), FStringSocialCaptureTakenIXPLayer (copy), GetFStringLuaAppExperienceMenuLayer (copy), GetFStringLuaAppConsoleExperienceMenuLayer (copy), GetFStringLargerRobuxUpsellIxpLayer (copy), GetFFlagReportAnythingAnnotationIXP (copy), GetFStringReportAnythingAnnotationIXPLayerName (copy), GetFFlagChatTranslationSettingEnabled (copy), GetFStringChatTranslationLayerName (copy), GetFFlagVoiceUserAgencyEnableIXP (copy), GetFStringVoiceUserAgencyIXPLayerName (copy), GetFFlagLuaInExperienceCoreScriptsGameInviteUnification (copy), GetFStringGameInviteMenuLayer (copy), GetFFlagUXForCameraPerformanceIXPEnabled (copy), GetFStringUXForCameraPerformanceIXPLayerName (copy), GetFStringVoiceExposureIXPLayerName (copy), GetFStringAndroidPhoneVerificationLayer (copy), GetFStringIOSPhoneVerificationLayer (copy), GetFFlagEnableAppChatInExperience (copy), getFStringAppChatInExperienceIXPLayer (copy)
	local t1 = {
		"AbuseReports",
		getFStringDesktopToastNotificationLayer(),
		FStringReportMenuIXPLayer,
		FStringReportingIXPLayer,
		FStringEARReportMenuIXPLayer,
		FStringSocialCaptureIXPLayer,
		FStringSocialCaptureTakenIXPLayer
	}

	table.insert(t1, GetFStringLuaAppExperienceMenuLayer())
	table.insert(t1, GetFStringLuaAppConsoleExperienceMenuLayer())

	if GetFStringLargerRobuxUpsellIxpLayer() then
		table.insert(t1, GetFStringLargerRobuxUpsellIxpLayer())
	end

	if GetFFlagReportAnythingAnnotationIXP() then
		table.insert(t1, GetFStringReportAnythingAnnotationIXPLayerName())
	end

	if GetFFlagChatTranslationSettingEnabled() and #GetFStringChatTranslationLayerName() > 0 then
		table.insert(t1, GetFStringChatTranslationLayerName())
	end

	if GetFFlagVoiceUserAgencyEnableIXP() then
		table.insert(t1, GetFStringVoiceUserAgencyIXPLayerName())
	end

	if GetFFlagLuaInExperienceCoreScriptsGameInviteUnification() then
		table.insert(t1, GetFStringGameInviteMenuLayer())
	end

	if GetFFlagUXForCameraPerformanceIXPEnabled() then
		table.insert(t1, GetFStringUXForCameraPerformanceIXPLayerName())
	end

	table.insert(t1, GetFStringVoiceExposureIXPLayerName())

	if GetFStringAndroidPhoneVerificationLayer() then
		table.insert(t1, GetFStringAndroidPhoneVerificationLayer())
	end

	if GetFStringIOSPhoneVerificationLayer() then
		table.insert(t1, GetFStringIOSPhoneVerificationLayer())
	end

	if GetFFlagEnableAppChatInExperience() then
		table.insert(t1, getFStringAppChatInExperienceIXPLayer())
	end

	return t1
end
