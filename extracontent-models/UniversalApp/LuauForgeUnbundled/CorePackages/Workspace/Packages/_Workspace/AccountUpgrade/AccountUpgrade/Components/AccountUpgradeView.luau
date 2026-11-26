local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Foundation")
local registerAuditContent = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AuthCommon").Components.RegisterAuditContent
local legalTextWithLinks = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AuthCommon").Components.LegalTextWithLinks
local AccountUpgradeFields = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Components/AccountUpgradeFields")
local AccountUpgradeFieldError = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Components/AccountUpgradeFieldError")
local BirthdayPickerSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Components/BirthdayPickerSheet")
local CloseConfirmationDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Components/CloseConfirmationDialog")
local MarketingConsentCheckbox = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Components/MarketingConsentCheckbox")
local AccountUpgradeDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/SuccessModal/AccountUpgradeDialog")
local AccountUpgradeDialogActions = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/SuccessModal/AccountUpgradeDialogActions")
local AccountUpgradeField = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeField")
local FFlagAccountUpgradeOAuthTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FFlagAccountUpgradeOAuthTelemetry")

local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local function noop() end

local function createAuditContent(auditContent)
	local children = {}

	for k, item in auditContent do
		children[item.translationKey] = React.createElement(registerAuditContent, item)
	end

	return React.createElement(React.Fragment, nil, children)
end

local function AccountUpgradeView(props)
	local v5 = not (props.isSaveEnabled or props.isSubmitting)
	local v6 = props.fieldStates[AccountUpgradeField.Birthday] ~= nil

	local onClose = props.onClose
	local v7 = React.useCallback(function(p2)
		if onClose then
			onClose()
		end
	end, { onClose })
	local onSignOut = props.onSignOut

	local createElement = React.createElement
	local v9 = {
		tag = {
			["col size-full-0 auto-y"] = true,
			["padding-top-xsmall"] = props.subtitleText ~= nil
		},
		testId = "AccountUpgradeContent"
	}

	local createElement2 = React.createElement

	local v13 = {
		Fields = React.createElement(AccountUpgradeFields, { form = props, LayoutOrder = 1 }),
		Actions = 0
	}

	local createElement3 = React.createElement

	local v17 = if props.marketingConsentText ~= nil then React.createElement(MarketingConsentCheckbox, {
		text = props.marketingConsentText,
		isChecked = props.isMarketingConsentChecked == true,
		isDisabled = props.isSubmitting or props.isMarketingConsentDisabled == true,
		onToggled = props.onMarketingConsentToggled or noop,
		size = inputSize.Small,
		LayoutOrder = 1
	}) else nil

	local createElement4 = React.createElement

	local createElement5 = React.createElement

	local v23 = {
		text = props.saveText,
		variant = 0,
		onActivated = 0,
		isDisabled = 0,
		isLoading = 0
	}
	local v24 = if v5 then buttonVariant.Standard else buttonVariant.Emphasis
	v23.variant = v24
	v23.onActivated = props.onSaveActivated
	v23.isDisabled = v5
	v23.isLoading = props.isSubmitting
	local children = {
		Buttons = createElement5(AccountUpgradeDialogActions, {
			LayoutOrder = 1,
			buttons = { v23 }
		}),
		Error = React.createElement(AccountUpgradeFieldError, {
			text = props.submitError,
			LayoutOrder = 2,
			testId = "AccountUpgradeSubmitError"
		}),
		LegalText = 0
	}

	local v25 = if props.legalText then React.createElement(legalTextWithLinks, {
		text = props.legalText,
		onLinkActivated = props.onLegalLinkActivated,
		LayoutOrder = 3,
		testId = "AccountUpgradeLegalText"
	}) else nil
	children.LegalText = v25
	v13.Actions = createElement3(view, {
		tag = "col gap-large size-full-0 auto-y",
		LayoutOrder = 2
	}, {
		MarketingConsent = v17,
		Submit = createElement4(
			view,
			{ tag = "col gap-small size-full-0 auto-y", LayoutOrder = 2 },
			children
		)
	})
	local v10 = {
		Body = createElement2(
			view,
			{
				tag = "col gap-xlarge size-full-0 auto-y",
				LayoutOrder = 1,
				testId = "AccountUpgradeBody"
			},
			v13
		),
		AuditContent = 0
	}

	local v26 = if props.auditContent then createAuditContent(props.auditContent) else nil
	v10.AuditContent = v26
	local element = createElement(view, v9, v10)

	local createElement6 = React.createElement
	local v28 = {
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
		v7 = nil
	end

	v28.onClose = v7
	local v29 = if props.confirmsClose then onClose else nil
	v28.onCloseActivated = v29
	v28.hasBackdrop = props.hasBackdrop
	v28.fitsContent = props.fitsDialogToContent
	v28.isFocusable = not (props.isBirthdayPickerOpen or props.isCloseConfirmationOpen)
	local v31

	if v6 then
		local createElement7 = React.createElement
		local v33 = {
			isOpen = props.isBirthdayPickerOpen,
			birthday = props.birthday,
			onClose = props.onBirthdayPickerClosed,
			onConfirm = props.onBirthdayConfirmed,
			onAllPicked = 0
		}
		local v34 = if FFlagAccountUpgradeOAuthTelemetry then props.onBirthdayPickerAllPicked else nil
		v33.onAllPicked = v34
		v31 = createElement7(BirthdayPickerSheet, v33)
	end

	local v32 = if props.isCloseConfirmationOpen and onSignOut then React.createElement(CloseConfirmationDialog, {
		onBack = props.onCloseConfirmationBack,
		onSignOut = onSignOut
	}) else nil
	v28.children = { Content = element, BirthdayPicker = v31, CloseConfirmation = v32 }
	return createElement6(AccountUpgradeDialog, v28)
end

return AccountUpgradeView
