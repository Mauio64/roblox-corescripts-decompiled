local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local AuthAnalytics = require(parent.AuthAnalytics)
local AuthCommon = require(parent.AuthCommon)
local LoggingProtocol = require(parent.LoggingProtocol)

local AccountUpgradeFlow = require(AccountUpgrade.AccountUpgradeFlow)
local AccountUpgradeSurface = require(AccountUpgrade.AccountUpgradeSurface)
local FFlagAccountUpgradeOAuthTelemetry = require(AccountUpgrade.Flags.FFlagAccountUpgradeOAuthTelemetry)

local UserGender = AuthCommon.Enums.UserGender
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local TelemetryConfigs = AuthAnalytics.TelemetryConfigs
local authButtonClick = AuthAnalytics.Events.authButtonClick
local authFormInteraction = AuthAnalytics.Events.authFormInteraction
local authModalShown = AuthAnalytics.Events.authModalShown
local authPageload = AuthAnalytics.Events.authPageload
local default = LoggingProtocol.default

local ActionType = EventStreamConstants.ActionType
local Context = EventStreamConstants.Context
local Button = EventStreamConstants.Button
local Field = EventStreamConstants.Field
local State = EventStreamConstants.State

local v = {
	[AccountUpgradeSurface.Dialog] = EventStreamConstants.Origin.AccountUpgradeOAuthDialog,
	[AccountUpgradeSurface.FullPage] = EventStreamConstants.Origin.AccountUpgradeOAuthFullPage
}

local function getEventOrigin(p, p2) -- 18 equivalent calls inferred from this helper
	if p == AccountUpgradeFlow.OAuth then
		return v[p2]
	end

	return p
end

local function logCounter(p, flow, surface, errorCode: string?) -- 8 equivalent calls inferred from this helper
	default:logRobloxTelemetryCounter(p, 1, {
		flow = flow,
		surface = surface,
		errorCode = errorCode
	})
end

local AccountUpgradeAnalytics = {}
AccountUpgradeAnalytics.getEventOrigin = getEventOrigin

function AccountUpgradeAnalytics.reportOpened(p, p2)
	if p ~= AccountUpgradeFlow.OAuth then
		return
	end

	local v2

	if FFlagAccountUpgradeOAuthTelemetry then
		v2 = p
	end

	authPageload(Context.AccountUpgrade, v2, nil, getEventOrigin(p, p2)) -- inferred equivalent call
	logCounter(TelemetryConfigs.AccountUpgradePageMountConfig, p, p2) -- inferred equivalent call
end

function AccountUpgradeAnalytics.reportCloseButtonClicked(p, p2)
	if p ~= AccountUpgradeFlow.OAuth then
		return
	end

	local eventOrigin = getEventOrigin(p, p2) -- inferred equivalent call
	local v2

	if FFlagAccountUpgradeOAuthTelemetry then
		v2 = p
	end

	authButtonClick(Context.AccountUpgrade, Button.DismissCornerX, v2, nil, nil, eventOrigin)
	authModalShown(Context.AccountUpgradeCloseWarning, v2, nil, eventOrigin)
	logCounter(TelemetryConfigs.AccountUpgradeCloseButtonClickedConfig, p, p2) -- inferred equivalent call
end

function AccountUpgradeAnalytics.reportCloseWarningBack(p, p2)
	if p ~= AccountUpgradeFlow.OAuth then
		return
	end

	local eventOrigin = getEventOrigin(p, p2) -- inferred equivalent call
	local v2

	if FFlagAccountUpgradeOAuthTelemetry then
		v2 = p
	end

	authButtonClick(Context.AccountUpgradeCloseWarning, Button.Back, v2, nil, nil, eventOrigin)
	logCounter(TelemetryConfigs.AccountUpgradeCloseWarningBackButtonClickedConfig, p, p2) -- inferred equivalent call
end

function AccountUpgradeAnalytics.reportCloseWarningClose(p, p2)
	if p ~= AccountUpgradeFlow.OAuth then
		return
	end

	local eventOrigin = getEventOrigin(p, p2) -- inferred equivalent call
	local v2

	if FFlagAccountUpgradeOAuthTelemetry then
		v2 = p
	end

	authButtonClick(Context.AccountUpgradeCloseWarning, Button.Close, v2, nil, nil, eventOrigin)
	logCounter(TelemetryConfigs.AccountUpgradeCloseWarningCloseButtonClickedConfig, p, p2) -- inferred equivalent call
end

function AccountUpgradeAnalytics.reportBirthdayActivated(p, p2)
	if p ~= AccountUpgradeFlow.OAuth then
		return
	end

	p = getEventOrigin(p, p2) -- inferred equivalent call
	authFormInteraction(Context.AccountUpgrade, Field.Birthday, ActionType.Focus, p)
	authFormInteraction(Context.AccountUpgrade, Field.BirthdayPicker, State.BirthdayPickerOpened, p)
end

function AccountUpgradeAnalytics.reportBirthdayConfirmed(p, p2)
	if p ~= AccountUpgradeFlow.OAuth then
		return
	end

	authButtonClick(Context.AccountUpgrade, Button.ConfirmBirthday, p, nil, nil, getEventOrigin(p, p2)) -- inferred equivalent call
end

function AccountUpgradeAnalytics.reportBirthdayPickerClosed(p, p2)
	if p ~= AccountUpgradeFlow.OAuth then
		return
	end

	local accountUpgrade = Context.AccountUpgrade
	local birthdayPicker = Field.BirthdayPicker
	local birthdayPickerClosedWithoutConfirm = State.BirthdayPickerClosedWithoutConfirm
	p = getEventOrigin(p, p2) -- inferred equivalent call
	authFormInteraction(accountUpgrade, birthdayPicker, birthdayPickerClosedWithoutConfirm, p)
end

function AccountUpgradeAnalytics.reportBirthdayPickerAllPicked(p, p2)
	if p ~= AccountUpgradeFlow.OAuth then
		return
	end

	local accountUpgrade = Context.AccountUpgrade
	local birthdayPicker = Field.BirthdayPicker
	local birthdayPickerAllPicked = State.BirthdayPickerAllPicked
	p = getEventOrigin(p, p2) -- inferred equivalent call
	authFormInteraction(accountUpgrade, birthdayPicker, birthdayPickerAllPicked, p)
end

function AccountUpgradeAnalytics.reportUsernameFocused(p, p2)
	if p ~= AccountUpgradeFlow.OAuth then
		return
	end

	local accountUpgrade = Context.AccountUpgrade
	local username = Field.Username
	local focus = ActionType.Focus
	p = getEventOrigin(p, p2) -- inferred equivalent call
	authFormInteraction(accountUpgrade, username, focus, p)
end

function AccountUpgradeAnalytics.reportUsernameSuggestionSelected(p, p2, p3: string)
	if p ~= AccountUpgradeFlow.OAuth then
		return
	end

	local accountUpgrade = Context.AccountUpgrade
	local usernameSuggestion = Button.UsernameSuggestion
	p = getEventOrigin(p, p2) -- inferred equivalent call
	authButtonClick(accountUpgrade, usernameSuggestion, p3, nil, nil, p)
end

function AccountUpgradeAnalytics.reportGenderActivated(p, p2, p3: string)
	if p ~= AccountUpgradeFlow.OAuth then
		return
	end

	local v2

	if p3 == UserGender.Male then
		v2 = Button.GenderMale
	else
		v2 = Button.GenderFemale
	end

	authButtonClick(Context.AccountUpgrade, v2, p, nil, nil, getEventOrigin(p, p2)) -- inferred equivalent call
end

function AccountUpgradeAnalytics.reportLegalLinkActivated(p, p2, p3: string)
	if p ~= AccountUpgradeFlow.OAuth then
		return
	end

	local v2

	if p3 == "terms" then
		v2 = Field.TermsOfService
	else
		v2 = Field.PrivacyPolicy
	end

	authFormInteraction(Context.AccountUpgrade, v2, p, getEventOrigin(p, p2)) -- inferred equivalent call
end

function AccountUpgradeAnalytics.reportSucceeded(p, p2)
	if p ~= AccountUpgradeFlow.OAuth then
		return
	end

	authPageload(Context.AccountUpgrade, State.UpgradeSuccess, nil, getEventOrigin(p, p2)) -- inferred equivalent call
	logCounter(TelemetryConfigs.AccountUpgradeSuccessConfig, p, p2) -- inferred equivalent call
end

function AccountUpgradeAnalytics.reportFirstFailure(flow, surface, p: number?)
	if flow ~= AccountUpgradeFlow.OAuth then
		return
	end

	authPageload(Context.AccountUpgrade, State.UpgradeFailure, nil, getEventOrigin(flow, surface)) -- inferred equivalent call

	local accountUpgradeFailureConfig = TelemetryConfigs.AccountUpgradeFailureConfig
	local v2

	if p == nil then
		v2 = State.Unknown
	else
		v2 = tostring(p)
	end

	logCounter(accountUpgradeFailureConfig, flow, surface, v2) -- inferred equivalent call
end

function AccountUpgradeAnalytics.reportMarketingConsentShown(p, p2, flag: boolean)
	if p ~= AccountUpgradeFlow.OAuth then
		return
	end

	local accountUpgrade = Context.AccountUpgrade
	local marketingEmailConsent = Field.MarketingEmailConsent
	local shown = ActionType.Shown
	p = getEventOrigin(p, p2) -- inferred equivalent call
	authFormInteraction(accountUpgrade, marketingEmailConsent, shown, p, flag)
end

function AccountUpgradeAnalytics.reportMarketingConsentToggled(p, p2, flag: boolean)
	if p ~= AccountUpgradeFlow.OAuth then
		return
	end

	local accountUpgrade = Context.AccountUpgrade
	local marketingEmailConsent = Field.MarketingEmailConsent
	local click = ActionType.Click
	p = getEventOrigin(p, p2) -- inferred equivalent call
	authFormInteraction(accountUpgrade, marketingEmailConsent, click, p, flag)
end

function AccountUpgradeAnalytics.reportMarketingConsentSubmitted(p, p2, flag: boolean)
	if p ~= AccountUpgradeFlow.OAuth then
		return
	end

	local accountUpgrade = Context.AccountUpgrade
	local marketingEmailConsent = Field.MarketingEmailConsent
	local submit = ActionType.Submit
	p = getEventOrigin(p, p2) -- inferred equivalent call
	authFormInteraction(accountUpgrade, marketingEmailConsent, submit, p, flag)
end

function AccountUpgradeAnalytics.reportMarketingConsentAutoOptIn(p, p2)
	if p ~= AccountUpgradeFlow.OAuth then
		return
	end

	local accountUpgrade = Context.AccountUpgrade
	local marketingEmailAutoOptIn = Field.MarketingEmailAutoOptIn
	local submit = ActionType.Submit
	p = getEventOrigin(p, p2) -- inferred equivalent call
	authFormInteraction(accountUpgrade, marketingEmailAutoOptIn, submit, p)
end

function AccountUpgradeAnalytics.reportMarketingConsentWriteSucceeded(p, p2)
	if p ~= AccountUpgradeFlow.OAuth then
		return
	end

	logCounter(TelemetryConfigs.AccountUpgradeMarketingConsentWriteSuccessConfig, p, p2) -- inferred equivalent call
end

function AccountUpgradeAnalytics.reportMarketingConsentWriteFailed(flow, surface, p: number?)
	if flow ~= AccountUpgradeFlow.OAuth then
		return
	end

	local accountUpgradeMarketingConsentWriteFailureConfig = TelemetryConfigs.AccountUpgradeMarketingConsentWriteFailureConfig
	local v2

	if p == nil then
		v2 = State.Unknown
	else
		v2 = tostring(p)
	end

	logCounter(accountUpgradeMarketingConsentWriteFailureConfig, flow, surface, v2) -- inferred equivalent call
end

return AccountUpgradeAnalytics
