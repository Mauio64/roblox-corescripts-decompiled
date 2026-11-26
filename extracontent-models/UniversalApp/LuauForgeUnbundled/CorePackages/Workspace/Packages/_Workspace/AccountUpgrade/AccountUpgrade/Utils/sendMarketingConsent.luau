local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Promise")
local LegallySensitiveContent = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/LegallySensitiveContent")

local AccountUpgradeAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Analytics/AccountUpgradeAnalytics")
require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeFlow")
require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeSurface")

local FIntAccountUpgradeMarketingConsentWriteDelayMs = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FIntAccountUpgradeMarketingConsentWriteDelayMs")

local userSetting = LegallySensitiveContent.UserSetting

local v5 = {
	channelSettings = {
		{ channelName = "Email", setting = "Enabled" }
	}
}

local function noop() end

local function getStatusCode(p2)
	if type(p2) == "table" then
		return p2.statusCode
	end

	return nil
end

local function getErrorMessage(p2)
	if type(p2) == "table" and type(p2.message) == "string" then
		return p2.message
	end

	return (tostring(p2))
end

local function waitForWriteDelay()
	if FIntAccountUpgradeMarketingConsentWriteDelayMs <= 0 then
		return Promise.resolve()
	end

	return Promise.delay(FIntAccountUpgradeMarketingConsentWriteDelayMs / 1000)
end

local function sendMarketingConsent(callback, p2, p3)
	Promise.try(function()
		local v6 = callback()
		local v7 = if FIntAccountUpgradeMarketingConsentWriteDelayMs <= 0 then Promise.resolve() else Promise.delay(FIntAccountUpgradeMarketingConsentWriteDelayMs / 1000)

		return v7:andThen(function()
			return LegallySensitiveContent.updateUserSettingV2(userSetting.allowPromotionalOffersNotifications, v5, v6)
		end)
	end):andThen(function()
		AccountUpgradeAnalytics.reportMarketingConsentWriteSucceeded(p2, p3)
	end, function(p4)
		local warn2 = warn
		local v7 = if type(p4) == "table" and type(p4.message) == "string" then p4.message else tostring(p4)
		warn2(`AccountUpgrade: marketing consent write failed, {v7}`)
		local reportMarketingConsentWriteFailed = AccountUpgradeAnalytics.reportMarketingConsentWriteFailed
		local v10 = if type(p4) == "table" then p4.statusCode else nil

		reportMarketingConsentWriteFailed(p2, p3, v10)
	end):catch(noop)
end

return sendMarketingConsent
