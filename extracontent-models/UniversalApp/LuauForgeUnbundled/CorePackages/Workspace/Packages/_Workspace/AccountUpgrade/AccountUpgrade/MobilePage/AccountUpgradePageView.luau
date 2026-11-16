local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/ReactRoblox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/Foundation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/InputHandlers")
local fullscreenPageWithSafeArea = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AppBlox").FullscreenPageWithSafeArea
local legalTextWithLinks = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AuthCommon").Components.LegalTextWithLinks

local AccountUpgradeFields = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Components/AccountUpgradeFields")
local AccountUpgradeFieldError = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Components/AccountUpgradeFieldError")
local CloseConfirmationDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Components/CloseConfirmationDialog")
local MarketingConsentCheckbox = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Components/MarketingConsentCheckbox")
local AccountUpgradeField = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/AccountUpgradeField")
local FFlagAccountUpgradeOAuthDialogFitsContent = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FFlagAccountUpgradeOAuthDialogFitsContent")
local FFlagAccountUpgradeOAuthTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/Flags/FFlagAccountUpgradeOAuthTelemetry")
local BirthdaySheet = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/MobilePage/BirthdaySheet")
local FFlagAccountUpgradeFullPageInOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/AccountUpgrade/AccountUpgrade/MobilePage/FFlagAccountUpgradeFullPageInOverlay")

local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useLastInputMode = FocusNavigationUtils.useLastInputMode

local view = Foundation.View
local text = Foundation.Text
local button = Foundation.Button
local scrollView = Foundation.ScrollView
local headerBar = Foundation.HeaderBar

local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local iconName = Foundation.Enums.IconName
local scrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function noop() end

local function sinkPress() end

local function OverlayPageLayer(p2)
	return ReactRoblox.createPortal(
		React.createElement(
			view,
			{ tag = "size-full", ZIndex = 100, testId = "AccountUpgradePageLayer" },
			{
				Background = React.createElement(view, {
					tag = "position-center-center anchor-center-center bg-surface-0",
					Size = UDim2.fromScale(2, 2),
					ZIndex = 1,
					stateLayer = { affordance = stateLayerAffordance.None },
					selection = { Selectable = false },
					onActivated = sinkPress,
					testId = "AccountUpgradePageBackground"
				}),
				Content = React.createElement(view, { tag = "size-full", ZIndex = 2 }, p2.children)
			}
		),
		p2.overlay
	)
end

local function AccountUpgradePageView(props)
	local v5 = Foundation.Hooks.useTokens()

	local v6 = not (props.isSaveEnabled or props.isSubmitting)
	local onClose = props.onClose
	local onSignOut = props.onSignOut
	local v7 = useLastInputMode() == "Focus"
	local v8 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					if onClose then
						onClose()
					end

					object:cancel()
				end)
			}
		}
	end, { onClose })

	local v9 = useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isFocusable = not (props.isBirthdayPickerOpen or props.isCloseConfirmationOpen),
		isAutoFocusRoot = true,
		eventMap = navigateBacks,
		eventHandlers = v8
	})

	local v10 = if FFlagAccountUpgradeFullPageInOverlay then Foundation.Hooks.useOverlay() else nil

	local v11 = fullscreenPageWithSafeArea

	local v12 = {
		includeStatusBar = true,
		BackgroundTransparency = 0,
		BackgroundColor3 = v5.Color.Surface.Surface_0.Color3
	}

	if v10 ~= nil then
		v11 = OverlayPageLayer
		v12 = { overlay = v10 }
	end

	local createElement = React.createElement
	local createElement2 = React.createElement
	local v15 = {
		ref = v9,
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
	local root = headerBar.Root
	local v17 = {
		Leading = React.createElement(headerBar.Leading),
		Content = React.createElement(headerBar.Content, nil, {
			Title = React.createElement(text, {
				Text = props.titleText,
				tag = "auto-xy text-heading-medium content-emphasis",
				testId = "AccountUpgradePageTitle"
			})
		}),
		Trailing = 0
	}

	local createElement4 = React.createElement
	local trailing = headerBar.Trailing

	local v20 = if onClose and not v7 then React.createElement(headerBar.Actions, {
		actions = {
			{ id = "close", icon = iconName.X, onActivated = onClose }
		}
	}) else nil
	v17.Trailing = createElement4(trailing, nil, { Actions = v20 })
	local children = {
		Header = createElement3(root, {
			LayoutOrder = 1,
			testId = "AccountUpgradePageHeader"
		}, v17),
		Scroll = 0,
		BirthdayPicker = 0,
		CloseConfirmation = 0
	}

	local createElement5 = React.createElement
	local v22 = {
		tag = "fill size-full-0",
		LayoutOrder = 2,
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromScale(1, 0),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			scrollBarVisibility = scrollBarVisibility.Auto
		},
		testId = "AccountUpgradePageScroll"
	}

	local createElement6 = React.createElement

	local v26 = {
		Subtitle = React.createElement(text, {
			Text = props.subtitleText,
			tag = "size-full-0 auto-y text-body-medium text-wrap text-align-x-left content-default",
			LayoutOrder = 1,
			testId = "AccountUpgradeSubtitle"
		}),
		Fields = React.createElement(AccountUpgradeFields, {
			form = props,
			size = inputSize.Large,
			boldLabels = true,
			LayoutOrder = 2
		}),
		MarketingConsent = 0,
		Actions = 0
	}

	local v27 = if props.marketingConsentText ~= nil then React.createElement(MarketingConsentCheckbox, {
		text = props.marketingConsentText,
		isChecked = props.isMarketingConsentChecked == true,
		isDisabled = props.isSubmitting or props.isMarketingConsentDisabled == true,
		onToggled = props.onMarketingConsentToggled or noop,
		size = inputSize.Small,
		smallGap = true,
		LayoutOrder = 3
	}) else nil
	v26.MarketingConsent = v27

	local createElement7 = React.createElement

	local createElement8 = React.createElement
	local v31 = {
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
	local v32 = if v6 then buttonVariant.Standard else buttonVariant.Emphasis
	v31.variant = v32
	v31.size = inputSize.Large
	v31.width = UDim.new(1, 0)
	v31.onActivated = props.onSaveActivated
	v31.isDisabled = v6
	v31.isLoading = props.isSubmitting
	local children2 = {
		Save = createElement8(button, v31),
		Error = React.createElement(AccountUpgradeFieldError, {
			text = props.submitError,
			LayoutOrder = 2,
			testId = "AccountUpgradeSubmitError"
		}),
		LegalText = 0
	}

	local v33 = if FFlagAccountUpgradeOAuthDialogFitsContent and props.legalText then React.createElement(legalTextWithLinks, {
		text = props.legalText,
		onLinkActivated = props.onLegalLinkActivated,
		LayoutOrder = 3,
		testId = "AccountUpgradeLegalText"
	}) else nil
	children2.LegalText = v33
	v26.Actions = createElement7(
		view,
		{
			tag = "col gap-small size-full-0 auto-y",
			LayoutOrder = 4,
			testId = "AccountUpgradePageActions"
		},
		children2
	)
	children.Scroll = createElement5(scrollView, v22, {
		Content = createElement6(
			view,
			{
				tag = "col gap-xxlarge size-full-0 auto-y padding-x-large padding-y-medium"
			},
			v26
		)
	})
	local v34

	if props.fieldStates[AccountUpgradeField.Birthday] ~= nil then
		local createElement9 = React.createElement
		local v36 = {
			isOpen = props.isBirthdayPickerOpen,
			birthday = props.birthday,
			onClose = props.onBirthdayPickerClosed,
			onConfirm = props.onBirthdayConfirmed,
			onAllPicked = 0
		}
		local v37 = if FFlagAccountUpgradeOAuthTelemetry then props.onBirthdayPickerAllPicked else nil
		v36.onAllPicked = v37
		v34 = createElement9(BirthdaySheet, v36)
	end

	children.BirthdayPicker = v34

	local v35 = if props.isCloseConfirmationOpen and onSignOut then React.createElement(CloseConfirmationDialog, {
		onBack = props.onCloseConfirmationBack,
		onSignOut = onSignOut
	}) else nil
	children.CloseConfirmation = v35
	return createElement(v11, v12, {
		Page = createElement2(view, v15, children)
	})
end

return AccountUpgradePageView
