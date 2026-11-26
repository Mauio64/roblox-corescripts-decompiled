local AuthAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AuthAnalytics")
local AuthCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AuthCommon")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/LoggingProtocol")

local AccountUpgradeFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeFlow")
local AccountUpgradeSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeSurface")
local FFlagAccountUpgradeOAuthTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FFlagAccountUpgradeOAuthTelemetry")

local userGender = AuthCommon.Enums.UserGender
local eventStreamConstants = AuthAnalytics.EventStreamConstants
local telemetryConfigs = AuthAnalytics.TelemetryConfigs
local authButtonClick = AuthAnalytics.Events.authButtonClick
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local authModalShown = AuthAnalytics.Events.authModalShown
local authPageload = AuthAnalytics.Events.authPageload
local default = LoggingProtocol.default

local actionType = eventStreamConstants.ActionType
local context = eventStreamConstants.Context
local button = eventStreamConstants.Button
local field = eventStreamConstants.Field
local state = eventStreamConstants.State

local v5 = {
	[AccountUpgradeSurface.Dialog] = eventStreamConstants.Origin.AccountUpgradeOAuthDialog,
	[AccountUpgradeSurface.FullPage] = eventStreamConstants.Origin.AccountUpgradeOAuthFullPage
}

local function logCounter(p2, p3, p4, p5)
	default:logRobloxTelemetryCounter(p2, 1, { flow = p3, surface = p4, errorCode = p5 })
end

return {
	getEventOrigin = function(p2, p3)
		if p2 == AccountUpgradeFlow.OAuth then
			return v5[p3]
		end

		return p2
	end,
	reportOpened = function(p2, p3)
		if p2 ~= AccountUpgradeFlow.OAuth then
			return
		end

		local v6 = if FFlagAccountUpgradeOAuthTelemetry then p2 else nil
		local accountUpgrade = context.AccountUpgrade
		local v9 = if p2 == AccountUpgradeFlow.OAuth then v5[p3] else p2

		authPageload(accountUpgrade, v6, nil, v9)
		default:logRobloxTelemetryCounter(telemetryConfigs.AccountUpgradePageMountConfig, 1, {
			flow = p2,
			surface = p3,
			errorCode = nil
		})
	end,
	reportCloseButtonClicked = function(p2, p3)
		if p2 ~= AccountUpgradeFlow.OAuth then
			return
		end

		local v6 = if p2 == AccountUpgradeFlow.OAuth then v5[p3] else p2
		local v7 = if FFlagAccountUpgradeOAuthTelemetry then p2 else nil
		authButtonClick(context.AccountUpgrade, button.DismissCornerX, v7, nil, nil, v6)
		authModalShown(context.AccountUpgradeCloseWarning, v7, nil, v6)
		default:logRobloxTelemetryCounter(telemetryConfigs.AccountUpgradeCloseButtonClickedConfig, 1, {
			flow = p2,
			surface = p3,
			errorCode = nil
		})
	end,
	reportCloseWarningBack = function(p2, p3)
		if p2 ~= AccountUpgradeFlow.OAuth then
			return
		end

		local v6 = if p2 == AccountUpgradeFlow.OAuth then v5[p3] else p2

		authButtonClick(
			context.AccountUpgradeCloseWarning,
			button.Back,
			if FFlagAccountUpgradeOAuthTelemetry then p2 else nil,
			nil,
			nil,
			v6
		)
		default:logRobloxTelemetryCounter(
			telemetryConfigs.AccountUpgradeCloseWarningBackButtonClickedConfig,
			1,
			{ flow = p2, surface = p3, errorCode = nil }
		)
	end,
	reportCloseWarningClose = function(p2, p3)
		if p2 ~= AccountUpgradeFlow.OAuth then
			return
		end

		local v6 = if p2 == AccountUpgradeFlow.OAuth then v5[p3] else p2

		authButtonClick(
			context.AccountUpgradeCloseWarning,
			button.Close,
			if FFlagAccountUpgradeOAuthTelemetry then p2 else nil,
			nil,
			nil,
			v6
		)
		default:logRobloxTelemetryCounter(
			telemetryConfigs.AccountUpgradeCloseWarningCloseButtonClickedConfig,
			1,
			{ flow = p2, surface = p3, errorCode = nil }
		)
	end,
	reportBirthdayActivated = function(p2, p3)
		if p2 ~= AccountUpgradeFlow.OAuth then
			return
		end

		if p2 == AccountUpgradeFlow.OAuth then
			p2 = v5[p3]
		end

		authFormInteraction(context.AccountUpgrade, field.Birthday, actionType.Focus, p2)
		authFormInteraction(context.AccountUpgrade, field.BirthdayPicker, state.BirthdayPickerOpened, p2)
	end,
	reportBirthdayConfirmed = function(p2, p3)
		if p2 ~= AccountUpgradeFlow.OAuth then
			return
		end

		local accountUpgrade = context.AccountUpgrade
		local confirmBirthday = button.ConfirmBirthday
		local v9 = if p2 == AccountUpgradeFlow.OAuth then v5[p3] else p2

		authButtonClick(accountUpgrade, confirmBirthday, p2, nil, nil, v9)
	end,
	reportBirthdayPickerClosed = function(p2, p3)
		if p2 ~= AccountUpgradeFlow.OAuth then
			return
		end

		local accountUpgrade = context.AccountUpgrade
		local birthdayPicker = field.BirthdayPicker
		local birthdayPickerClosedWithoutConfirm = state.BirthdayPickerClosedWithoutConfirm

		if p2 == AccountUpgradeFlow.OAuth then
			p2 = v5[p3]
		end

		authFormInteraction(accountUpgrade, birthdayPicker, birthdayPickerClosedWithoutConfirm, p2)
	end,
	reportBirthdayPickerAllPicked = function(p2, p3)
		if p2 ~= AccountUpgradeFlow.OAuth then
			return
		end

		local accountUpgrade = context.AccountUpgrade
		local birthdayPicker = field.BirthdayPicker
		local birthdayPickerAllPicked = state.BirthdayPickerAllPicked

		if p2 == AccountUpgradeFlow.OAuth then
			p2 = v5[p3]
		end

		authFormInteraction(accountUpgrade, birthdayPicker, birthdayPickerAllPicked, p2)
	end,
	reportUsernameFocused = function(p2, p3)
		if p2 ~= AccountUpgradeFlow.OAuth then
			return
		end

		local accountUpgrade = context.AccountUpgrade
		local username = field.Username
		local focus = actionType.Focus

		if p2 == AccountUpgradeFlow.OAuth then
			p2 = v5[p3]
		end

		authFormInteraction(accountUpgrade, username, focus, p2)
	end,
	reportUsernameSuggestionSelected = function(p2, p3, p4)
		if p2 ~= AccountUpgradeFlow.OAuth then
			return
		end

		local accountUpgrade = context.AccountUpgrade
		local usernameSuggestion = button.UsernameSuggestion

		if p2 == AccountUpgradeFlow.OAuth then
			p2 = v5[p3]
		end

		authButtonClick(accountUpgrade, usernameSuggestion, p4, nil, nil, p2)
	end,
	reportGenderActivated = function(p2, p3, p4)
		if p2 ~= AccountUpgradeFlow.OAuth then
			return
		end

		local v6 = if p4 == userGender.Male then button.GenderMale else button.GenderFemale
		local accountUpgrade = context.AccountUpgrade
		local v10 = if p2 == AccountUpgradeFlow.OAuth then v5[p3] else p2

		authButtonClick(accountUpgrade, v6, p2, nil, nil, v10)
	end,
	reportLegalLinkActivated = function(p2, p3, p4)
		if p2 ~= AccountUpgradeFlow.OAuth then
			return
		end

		local v6 = if p4 == "terms" then field.TermsOfService else field.PrivacyPolicy
		local accountUpgrade = context.AccountUpgrade
		local v8 = if p2 == AccountUpgradeFlow.OAuth then v5[p3] else p2

		authFormInteraction(accountUpgrade, v6, p2, v8)
	end,
	reportSucceeded = function(p2, p3)
		if p2 ~= AccountUpgradeFlow.OAuth then
			return
		end

		local accountUpgrade = context.AccountUpgrade
		local upgradeSuccess = state.UpgradeSuccess
		local v8 = if p2 == AccountUpgradeFlow.OAuth then v5[p3] else p2

		authPageload(accountUpgrade, upgradeSuccess, nil, v8)
		default:logRobloxTelemetryCounter(telemetryConfigs.AccountUpgradeSuccessConfig, 1, {
			flow = p2,
			surface = p3,
			errorCode = nil
		})
	end,
	reportFirstFailure = function(p2, p3, p4)
		if p2 ~= AccountUpgradeFlow.OAuth then
			return
		end

		local accountUpgrade = context.AccountUpgrade
		local upgradeFailure = state.UpgradeFailure
		local v8 = if p2 == AccountUpgradeFlow.OAuth then v5[p3] else p2

		authPageload(accountUpgrade, upgradeFailure, nil, v8)

		local accountUpgradeFailureConfig = telemetryConfigs.AccountUpgradeFailureConfig

		local v9 = if p4 == nil then state.Unknown else tostring(p4)
		default:logRobloxTelemetryCounter(accountUpgradeFailureConfig, 1, {
			flow = p2,
			surface = p3,
			errorCode = v9
		})
	end,
	reportMarketingConsentShown = function(p2, p3, p4)
		if p2 ~= AccountUpgradeFlow.OAuth then
			return
		end

		local accountUpgrade = context.AccountUpgrade
		local marketingEmailConsent = field.MarketingEmailConsent
		local shown = actionType.Shown

		if p2 == AccountUpgradeFlow.OAuth then
			p2 = v5[p3]
		end

		authFormInteraction(accountUpgrade, marketingEmailConsent, shown, p2, p4)
	end,
	reportMarketingConsentToggled = function(p2, p3, p4)
		if p2 ~= AccountUpgradeFlow.OAuth then
			return
		end

		local accountUpgrade = context.AccountUpgrade
		local marketingEmailConsent = field.MarketingEmailConsent
		local click = actionType.Click

		if p2 == AccountUpgradeFlow.OAuth then
			p2 = v5[p3]
		end

		authFormInteraction(accountUpgrade, marketingEmailConsent, click, p2, p4)
	end,
	reportMarketingConsentSubmitted = function(p2, p3, p4)
		if p2 ~= AccountUpgradeFlow.OAuth then
			return
		end

		local accountUpgrade = context.AccountUpgrade
		local marketingEmailConsent = field.MarketingEmailConsent
		local submit = actionType.Submit

		if p2 == AccountUpgradeFlow.OAuth then
			p2 = v5[p3]
		end

		authFormInteraction(accountUpgrade, marketingEmailConsent, submit, p2, p4)
	end,
	reportMarketingConsentAutoOptIn = function(p2, p3)
		if p2 ~= AccountUpgradeFlow.OAuth then
			return
		end

		local accountUpgrade = context.AccountUpgrade
		local marketingEmailAutoOptIn = field.MarketingEmailAutoOptIn
		local submit = actionType.Submit

		if p2 == AccountUpgradeFlow.OAuth then
			p2 = v5[p3]
		end

		authFormInteraction(accountUpgrade, marketingEmailAutoOptIn, submit, p2)
	end,
	reportMarketingConsentWriteSucceeded = function(p2, p3)
		if p2 ~= AccountUpgradeFlow.OAuth then
			return
		end

		default:logRobloxTelemetryCounter(
			telemetryConfigs.AccountUpgradeMarketingConsentWriteSuccessConfig,
			1,
			{ flow = p2, surface = p3, errorCode = nil }
		)
	end,
	reportMarketingConsentWriteFailed = function(p2, p3, p4)
		if p2 ~= AccountUpgradeFlow.OAuth then
			return
		end

		local accountUpgradeMarketingConsentWriteFailureConfig = telemetryConfigs.AccountUpgradeMarketingConsentWriteFailureConfig

		local v6 = if p4 == nil then state.Unknown else tostring(p4)
		default:logRobloxTelemetryCounter(accountUpgradeMarketingConsentWriteFailureConfig, 1, {
			flow = p2,
			surface = p3,
			errorCode = v6
		})
	end
}
