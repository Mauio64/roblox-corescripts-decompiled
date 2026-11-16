local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local Promise = require(parent.Promise)
local LegallySensitiveContent = require(parent.LegallySensitiveContent)

local AccountUpgradeAnalytics = require(AccountUpgrade.Analytics.AccountUpgradeAnalytics)
require(AccountUpgrade.AccountUpgradeFlow)
require(AccountUpgrade.AccountUpgradeSurface)

local FIntAccountUpgradeMarketingConsentWriteDelayMs = require(AccountUpgrade.Flags.FIntAccountUpgradeMarketingConsentWriteDelayMs)

local UserSetting = LegallySensitiveContent.UserSetting

local v = {
	channelSettings = {
		{ channelName = "Email", setting = "Enabled" }
	}
}

local function noop() end

local function getStatusCode(p) -- 1 equivalent call inferred from this helper
	return if type(p) == "table" then p.statusCode else nil
end

local function getErrorMessage(p) -- 1 equivalent call inferred from this helper
	if type(p) == "table" and type(p.message) == "string" then
		return p.message
	end

	return (tostring(p))
end

local function waitForWriteDelay() -- 1 equivalent call inferred from this helper
	if FIntAccountUpgradeMarketingConsentWriteDelayMs <= 0 then
		return Promise.resolve()
	end

	return Promise.delay(FIntAccountUpgradeMarketingConsentWriteDelayMs / 1000)
end

local function sendMarketingConsent(callback, p, p2)
	Promise.try(function()
		local v2 = callback()
		return waitForWriteDelay():andThen(function() -- inferred equivalent call
			return LegallySensitiveContent.updateUserSettingV2(UserSetting.allowPromotionalOffersNotifications, v, v2)
		end)
	end):andThen(function()
		AccountUpgradeAnalytics.reportMarketingConsentWriteSucceeded(p, p2)
	end, function(p3)
		warn(`AccountUpgrade: marketing consent write failed, {getErrorMessage(p3)}`) -- inferred equivalent call
		AccountUpgradeAnalytics.reportMarketingConsentWriteFailed(p, p2, getStatusCode(p3)) -- inferred equivalent call
	end):catch(noop)
end

return sendMarketingConsent
