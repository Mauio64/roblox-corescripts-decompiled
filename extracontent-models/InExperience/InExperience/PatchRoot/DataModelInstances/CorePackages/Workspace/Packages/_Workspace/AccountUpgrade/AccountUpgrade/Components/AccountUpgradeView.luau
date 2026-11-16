local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AuthCommon = require(parent.AuthCommon)
local RegisterAuditContent = AuthCommon.Components.RegisterAuditContent
local AuthCommon2 = require(parent.AuthCommon)
local LegalTextWithLinks = AuthCommon2.Components.LegalTextWithLinks
local AccountUpgradeFields = require(script.Parent.AccountUpgradeFields)
local AccountUpgradeFieldError = require(script.Parent.AccountUpgradeFieldError)
local BirthdayPickerSheet = require(script.Parent.BirthdayPickerSheet)
local CloseConfirmationDialog = require(script.Parent.CloseConfirmationDialog)
local MarketingConsentCheckbox = require(script.Parent.MarketingConsentCheckbox)
local AccountUpgradeDialog = require(AccountUpgrade.SuccessModal.AccountUpgradeDialog)
local AccountUpgradeDialogActions = require(AccountUpgrade.SuccessModal.AccountUpgradeDialogActions)
local AccountUpgradeField = require(AccountUpgrade.AccountUpgradeField)
local FFlagAccountUpgradeOAuthTelemetry = require(AccountUpgrade.Flags.FFlagAccountUpgradeOAuthTelemetry)

local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function noop() end

local function createAuditContent(auditContent)
	local children = {}

	for _, item in auditContent do
		children[item.translationKey] = React.createElement(RegisterAuditContent, item)
	end

	return React.createElement(React.Fragment, nil, children)
end

local function AccountUpgradeView(props)
	local isDisabled = not (props.isSaveEnabled or props.isSubmitting)
	local v = props.fieldStates[AccountUpgradeField.Birthday] ~= nil

	local onClose = props.onClose
	local onClose2 = React.useCallback(function(_)
		if onClose then
			onClose()
		end
	end, { onClose })
	local onSignOut = props.onSignOut

	local createElement = React.createElement
	local v2 = {
		tag = {
			["col size-full-0 auto-y"] = true,
			["padding-top-xsmall"] = props.subtitleText ~= nil
		},
		testId = "AccountUpgradeContent"
	}

	local createElement2 = React.createElement

	local v3 = {
		Fields = React.createElement(AccountUpgradeFields, { form = props, LayoutOrder = 1 }),
		Actions = 0
	}

	local createElement3 = React.createElement
	local marketingConsent

	if props.marketingConsentText ~= nil then
		marketingConsent = React.createElement(MarketingConsentCheckbox, {
			text = props.marketingConsentText,
			isChecked = props.isMarketingConsentChecked == true,
			isDisabled = props.isSubmitting or props.isMarketingConsentDisabled == true,
			onToggled = props.onMarketingConsentToggled or noop,
			size = InputSize.Small,
			LayoutOrder = 1
		})
	end

	local createElement4 = React.createElement

	local createElement5 = React.createElement

	local v4 = {
		text = props.saveText,
		variant = 0,
		onActivated = 0,
		isDisabled = 0,
		isLoading = 0
	}
	local variant

	if isDisabled then
		variant = ButtonVariant.Standard
	else
		variant = ButtonVariant.Emphasis
	end

	v4.variant = variant
	v4.onActivated = props.onSaveActivated
	v4.isDisabled = isDisabled
	v4.isLoading = props.isSubmitting
	local children = {
		Buttons = createElement5(AccountUpgradeDialogActions, {
			LayoutOrder = 1,
			buttons = { v4 }
		}),
		Error = React.createElement(AccountUpgradeFieldError, {
			text = props.submitError,
			LayoutOrder = 2,
			testId = "AccountUpgradeSubmitError"
		}),
		LegalText = 0
	}
	local legalText

	if props.legalText then
		legalText = React.createElement(LegalTextWithLinks, {
			text = props.legalText,
			onLinkActivated = props.onLegalLinkActivated,
			LayoutOrder = 3,
			testId = "AccountUpgradeLegalText"
		})
	end

	children.LegalText = legalText
	v3.Actions = createElement3(View, { tag = "col gap-large size-full-0 auto-y", LayoutOrder = 2 }, {
		MarketingConsent = marketingConsent,
		Submit = createElement4(View, { tag = "col gap-small size-full-0 auto-y", LayoutOrder = 2 }, children)
	})
	local v5 = {
		Body = createElement2(
			View,
			{
				tag = "col gap-xlarge size-full-0 auto-y",
				LayoutOrder = 1,
				testId = "AccountUpgradeBody"
			},
			v3
		),
		AuditContent = 0
	}
	local auditContent

	if props.auditContent then
		auditContent = createAuditContent(props.auditContent)
	end

	v5.AuditContent = auditContent
	local element = createElement(View, v2, v5)

	local createElement6 = React.createElement
	local v6 = {
		title = props.titleText,
		subtitle = props.subtitleText,
		onClose = 0,
		onCloseActivated = 0,
		hasBackdrop = 0,
		fitsContent = 0,
		isFocusable = 0,
		children = 0
	}

	if not onClose or props.confirmsClose then
		onClose2 = nil
	end

	v6.onClose = onClose2
	local onCloseActivated

	if props.confirmsClose then
		onCloseActivated = onClose
	end

	v6.onCloseActivated = onCloseActivated
	v6.hasBackdrop = props.hasBackdrop
	v6.fitsContent = props.fitsDialogToContent
	v6.isFocusable = not (props.isBirthdayPickerOpen or props.isCloseConfirmationOpen)
	local birthdayPicker

	if v then
		local createElement7 = React.createElement
		local v7 = {
			isOpen = props.isBirthdayPickerOpen,
			birthday = props.birthday,
			onClose = props.onBirthdayPickerClosed,
			onConfirm = props.onBirthdayConfirmed,
			onAllPicked = 0
		}
		local onAllPicked

		if FFlagAccountUpgradeOAuthTelemetry then
			onAllPicked = props.onBirthdayPickerAllPicked
		end

		v7.onAllPicked = onAllPicked
		birthdayPicker = createElement7(BirthdayPickerSheet, v7)
	end

	local closeConfirmation

	if props.isCloseConfirmationOpen and onSignOut then
		closeConfirmation = React.createElement(CloseConfirmationDialog, {
			onBack = props.onCloseConfirmationBack,
			onSignOut = onSignOut
		})
	end

	v6.children = {
		Content = element,
		BirthdayPicker = birthdayPicker,
		CloseConfirmation = closeConfirmation
	}
	return createElement6(AccountUpgradeDialog, v6)
end

return AccountUpgradeView
