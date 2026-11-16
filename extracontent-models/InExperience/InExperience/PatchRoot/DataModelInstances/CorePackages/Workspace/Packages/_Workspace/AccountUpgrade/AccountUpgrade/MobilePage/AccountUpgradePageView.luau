local AccountUpgrade = script:FindFirstAncestor("AccountUpgrade")
local parent = AccountUpgrade.Parent

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local Foundation = require(parent.Foundation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local AppBlox = require(parent.AppBlox)
local FullscreenPageWithSafeArea = AppBlox.FullscreenPageWithSafeArea
local AuthCommon = require(parent.AuthCommon)
local LegalTextWithLinks = AuthCommon.Components.LegalTextWithLinks

local AccountUpgradeFields = require(AccountUpgrade.Components.AccountUpgradeFields)
local AccountUpgradeFieldError = require(AccountUpgrade.Components.AccountUpgradeFieldError)
local CloseConfirmationDialog = require(AccountUpgrade.Components.CloseConfirmationDialog)
local MarketingConsentCheckbox = require(AccountUpgrade.Components.MarketingConsentCheckbox)
local AccountUpgradeField = require(AccountUpgrade.AccountUpgradeField)
local FFlagAccountUpgradeOAuthDialogFitsContent = require(AccountUpgrade.Flags.FFlagAccountUpgradeOAuthDialogFitsContent)
local FFlagAccountUpgradeOAuthTelemetry = require(AccountUpgrade.Flags.FFlagAccountUpgradeOAuthTelemetry)
local BirthdaySheet = require(script.Parent.BirthdaySheet)
local FFlagAccountUpgradeFullPageInOverlay = require(script.Parent.FFlagAccountUpgradeFullPageInOverlay)

local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useLastInputMode = FocusNavigationUtils.useLastInputMode

local View = Foundation.View
local Text = Foundation.Text
local Button = Foundation.Button
local ScrollView = Foundation.ScrollView
local HeaderBar = Foundation.HeaderBar

local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local IconName = Foundation.Enums.IconName
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function noop() end

local function sinkPress() end

local function OverlayPageLayer(p)
	return ReactRoblox.createPortal(
		React.createElement(View, {
			tag = "size-full",
			ZIndex = 100,
			testId = "AccountUpgradePageLayer"
		}, {
			Background = React.createElement(View, {
				tag = "position-center-center anchor-center-center bg-surface-0",
				Size = UDim2.fromScale(2, 2),
				ZIndex = 1,
				stateLayer = { affordance = StateLayerAffordance.None },
				selection = { Selectable = false },
				onActivated = sinkPress,
				testId = "AccountUpgradePageBackground"
			}),
			Content = React.createElement(View, { tag = "size-full", ZIndex = 2 }, p.children)
		}),
		p.overlay
	)
end

local function AccountUpgradePageView(props)
	local v = Foundation.Hooks.useTokens()

	local isDisabled = not (props.isSaveEnabled or props.isSubmitting)
	local onClose = props.onClose
	local onSignOut = props.onSignOut
	local v2 = useLastInputMode() == "Focus"
	local eventHandlers = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					if onClose then
						onClose()
					end

					object:cancel()
				end)
			}
		}
	end, { onClose })

	local ref = useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isFocusable = not (props.isBirthdayPickerOpen or props.isCloseConfirmationOpen),
		isAutoFocusRoot = true,
		eventMap = navigateBacks,
		eventHandlers = eventHandlers
	})
	local overlay

	if FFlagAccountUpgradeFullPageInOverlay then
		overlay = Foundation.Hooks.useOverlay()
	end

	local v3 = FullscreenPageWithSafeArea

	local v4 = {
		includeStatusBar = true,
		BackgroundTransparency = 0,
		BackgroundColor3 = v.Color.Surface.Surface_0.Color3
	}

	if overlay ~= nil then
		v3 = OverlayPageLayer
		v4 = { overlay = overlay }
	end

	local createElement = React.createElement
	local createElement2 = React.createElement
	local v5 = {
		ref = ref,
		tag = "col size-full bg-surface-0",
		selectionGroup = {
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
			SelectionBehaviorRight = Enum.SelectionBehavior.Stop
		},
		testId = "AccountUpgradePage"
	}

	local createElement3 = React.createElement
	local root = HeaderBar.Root
	local v6 = {
		Leading = React.createElement(HeaderBar.Leading),
		Content = React.createElement(HeaderBar.Content, nil, {
			Title = React.createElement(Text, {
				Text = props.titleText,
				tag = "auto-xy text-heading-medium content-emphasis",
				testId = "AccountUpgradePageTitle"
			})
		}),
		Trailing = 0
	}

	local createElement4 = React.createElement
	local trailing = HeaderBar.Trailing
	local actions

	if onClose and not v2 then
		actions = React.createElement(HeaderBar.Actions, {
			actions = {
				{ id = "close", icon = IconName.X, onActivated = onClose }
			}
		})
	end

	v6.Trailing = createElement4(trailing, nil, { Actions = actions })
	local children = {
		Header = createElement3(root, { LayoutOrder = 1, testId = "AccountUpgradePageHeader" }, v6),
		Scroll = 0,
		BirthdayPicker = 0,
		CloseConfirmation = 0
	}

	local createElement5 = React.createElement
	local v7 = {
		tag = "fill size-full-0",
		LayoutOrder = 2,
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(1, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			scrollBarVisibility = ScrollBarVisibility.Auto
		},
		testId = "AccountUpgradePageScroll"
	}

	local createElement6 = React.createElement

	local v8 = {
		Subtitle = React.createElement(Text, {
			Text = props.subtitleText,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
			LayoutOrder = 1,
			testId = "AccountUpgradeSubtitle"
		}),
		Fields = React.createElement(AccountUpgradeFields, {
			form = props,
			size = InputSize.Large,
			boldLabels = true,
			LayoutOrder = 2
		}),
		MarketingConsent = 0,
		Actions = 0
	}
	local marketingConsent

	if props.marketingConsentText ~= nil then
		marketingConsent = React.createElement(MarketingConsentCheckbox, {
			text = props.marketingConsentText,
			isChecked = props.isMarketingConsentChecked == true,
			isDisabled = props.isSubmitting or props.isMarketingConsentDisabled == true,
			onToggled = props.onMarketingConsentToggled or noop,
			size = InputSize.Small,
			smallGap = true,
			LayoutOrder = 3
		})
	end

	v8.MarketingConsent = marketingConsent

	local createElement7 = React.createElement

	local createElement8 = React.createElement
	local v9 = {
		text = props.saveText,
		variant = 0,
		size = 0,
		width = 0,
		onActivated = 0,
		isDisabled = 0,
		isLoading = 0,
		LayoutOrder = 1,
		testId = "AccountUpgradePageSaveButton"
	}
	local variant

	if isDisabled then
		variant = ButtonVariant.Standard
	else
		variant = ButtonVariant.Emphasis
	end

	v9.variant = variant
	v9.size = InputSize.Large
	v9.width = UDim.new(1, 0)
	v9.onActivated = props.onSaveActivated
	v9.isDisabled = isDisabled
	v9.isLoading = props.isSubmitting
	local children2 = {
		Save = createElement8(Button, v9),
		Error = React.createElement(AccountUpgradeFieldError, {
			text = props.submitError,
			LayoutOrder = 2,
			testId = "AccountUpgradeSubmitError"
		}),
		LegalText = 0
	}
	local legalText

	if FFlagAccountUpgradeOAuthDialogFitsContent and props.legalText then
		legalText = React.createElement(LegalTextWithLinks, {
			text = props.legalText,
			onLinkActivated = props.onLegalLinkActivated,
			LayoutOrder = 3,
			testId = "AccountUpgradeLegalText"
		})
	end

	children2.LegalText = legalText
	v8.Actions = createElement7(
		View,
		{
			tag = "col gap-small size-full-0 auto-y",
			LayoutOrder = 4,
			testId = "AccountUpgradePageActions"
		},
		children2
	)
	children.Scroll = createElement5(ScrollView, v7, {
		Content = createElement6(
			View,
			{ tag = "col gap-xxlarge size-full-0 auto-y padding-x-large padding-y-medium" },
			v8
		)
	})
	local birthdayPicker

	if props.fieldStates[AccountUpgradeField.Birthday] ~= nil then
		local createElement9 = React.createElement
		local v10 = {
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

		v10.onAllPicked = onAllPicked
		birthdayPicker = createElement9(BirthdaySheet, v10)
	end

	children.BirthdayPicker = birthdayPicker
	local closeConfirmation

	if props.isCloseConfirmationOpen and onSignOut then
		closeConfirmation = React.createElement(CloseConfirmationDialog, {
			onBack = props.onCloseConfirmationBack,
			onSignOut = onSignOut
		})
	end

	children.CloseConfirmation = closeConfirmation
	return createElement(v3, v4, {
		Page = createElement2(View, v5, children)
	})
end

return AccountUpgradePageView
