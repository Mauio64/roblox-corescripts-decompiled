local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local Foundation = require(parent2.Foundation)
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local Button = Foundation.Button
local Sheet = Foundation.Sheet
local useScaledValue = Foundation.Hooks.useScaledValue

local LocalizationService = game:GetService("LocalizationService")
local AppLocales = require(parent2.AppLocales)
local Localization = AppLocales.Localization
local Localization2 = require(parent2.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local useLocalization = Localization2.Hooks.useLocalization

local UnifiedProductDetails = require(parent.Generic.UnifiedProductDetails)
local PriceSummary = require(parent.Generic.PriceSummary)
local UnifiedPurchaseModalHeader = require(parent.Generic.UnifiedPurchaseModalHeader)

local UnifiedPurchaseModalTypeEnum = require(parent.Enums.UnifiedPurchaseModalTypeEnum)

local logger = require(parent.Utility.logger)
local getAppContext = require(parent.Utility.getAppContext)

local LoggingProtocol = require(parent2.LoggingProtocol)
local default = LoggingProtocol.default
local TooExpensiveUpsellCounter = require(parent.Generic.Events.TooExpensiveUpsellCounter)
local TooExpensiveUnifiedUpsellShownCounter = TooExpensiveUpsellCounter.TooExpensiveUnifiedUpsellShownCounter

local useFocusNavigationRefs = require(parent.Generic.Hooks.useFocusNavigationRefs)
local useInitialButtonDisableDelay = require(parent.Generic.Hooks.useInitialButtonDisableDelay)

local Constants = require(parent.Generic.Constants)

local UNIFIED_ROBUX_UPSELL_MODAL_TOO_EXPENSIVE_MIN_HEIGHT_PIXELS = Constants.UNIFIED_ROBUX_UPSELL_MODAL_TOO_EXPENSIVE_MIN_HEIGHT_PIXELS

local SharedFlags = require(parent.Parent.SharedFlags)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = SharedFlags.FFlagUnifiedPurchaseFlowMarketplaceUIImprovements

local function UnifiedRobuxUpsellModalTooExpensive(props)
	local v = useLocalization({
		NeedMoreRobux = "IAPExperience.RobuxUpsell.Text.NeedMoreRobux",
		ButtonCancel = "IAPExperience.InsufficientRobux.Action.Cancel",
		BuyRobux = "IAPExperience.InsufficientRobux.Action.BuyRobux"
	})

	local ref, ref2 = useFocusNavigationRefs(props.buttons.cancelPurchaseActivated, nil)
	local isDisabled = useInitialButtonDisableDelay()

	React.useEffect(function()
		logger.debug({
			message = "Too Expensive Unified Upsell Modal Shown",
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y,
			appContext = getAppContext()
		})

		default:logRobloxTelemetryCounter(TooExpensiveUnifiedUpsellShownCounter, 1, {
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y,
			appContext = getAppContext()
		})
	end, {})
	local createElement = React.createElement
	local root = Sheet.Root
	local v2 = {
		onClose = props.buttons.cancelPurchaseActivated,
		snapPoints = { useScaledValue(UNIFIED_ROBUX_UPSELL_MODAL_TOO_EXPENSIVE_MIN_HEIGHT_PIXELS), 0.8 },
		preferCenterSheet = true,
		ref = 0
	}

	if isDisabled then
		ref = nil
	end

	v2.ref = ref

	local createElement2 = React.createElement
	local header = Sheet.Header
	local hasCloseAffordance

	if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
		hasCloseAffordance = props.hideUserRobuxBalance and true or nil
	end

	local createElement3 = React.createElement
	local v3 = {
		titleText = v.NeedMoreRobux,
		robuxBalanceAmount = props.balanceAmount,
		hideUserRobuxBalance = 0
	}
	local hideUserRobuxBalance

	if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
		hideUserRobuxBalance = props.hideUserRobuxBalance
	end

	v3.hideUserRobuxBalance = hideUserRobuxBalance
	local children = {
		Header = createElement2(header, { hasCloseAffordance = hasCloseAffordance }, {
			ModalHeader = createElement3(UnifiedPurchaseModalHeader, v3)
		}),
		Content = 0,
		Actions = 0
	}

	local createElement4 = React.createElement
	local content = Sheet.Content

	local createElement5 = React.createElement
	local productDetails

	if props.purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
		productDetails = React.createElement(PriceSummary, { amount = props.product.itemRobuxCost })
	else
		productDetails = React.createElement(UnifiedProductDetails, {
			layoutOrder = 1,
			isPortrait = props.screenSize.X < props.screenSize.Y,
			model = props.product.model,
			itemIcon = props.product.itemIcon,
			itemName = props.product.itemName,
			itemRobuxCost = props.product.itemRobuxCost
		})
	end

	children.Content = createElement4(content, { LayoutOrder = 2 }, {
		SheetContentContainer = createElement5(
			View,
			{
				tag = "col gap-medium auto-y size-full-0 align-x-center align-y-start padding-bottom-medium"
			},
			{ ProductDetails = productDetails }
		)
	})

	local createElement6 = React.createElement
	local actions = Sheet.Actions
	local v4

	if props.isQuest then
		v4 = React.createElement(Button, {
			text = v.ButtonCancel,
			onActivated = props.buttons.cancelPurchaseActivated,
			fillBehavior = FillBehavior.Fill,
			variant = ButtonVariant.Standard
		})
	else
		v4 = React.createElement(Button, {
			text = v.BuyRobux,
			onActivated = props.buttons.buyItemActivated,
			fillBehavior = FillBehavior.Fill,
			variant = ButtonVariant.Emphasis,
			icon = Foundation.Enums.IconName.ArrowUpRightFromSquare,
			isDisabled = isDisabled,
			ref = ref2
		})
	end

	children.Actions = createElement6(actions, { LayoutOrder = 3 }, { v4 })
	return createElement(root, v2, children)
end

local function UnifiedRobuxUpsellModalTooExpensiveContainer(p)
	return React.createElement(
		LocalizationProvider,
		{
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			RobuxUpsellModalTooExpensive = React.createElement(UnifiedRobuxUpsellModalTooExpensive, p)
		}
	)
end

return UnifiedRobuxUpsellModalTooExpensiveContainer
