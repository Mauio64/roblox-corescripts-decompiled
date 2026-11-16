local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local Foundation = require(parent2.Foundation)
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local Orientation = Foundation.Enums.Orientation

local LocalizationService = game:GetService("LocalizationService")
local AppLocales = require(parent2.AppLocales)
local Localization = AppLocales.Localization
local Localization2 = require(parent2.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local useLocalization = Localization2.Hooks.useLocalization

local UnifiedProductDetails = require(parent.Generic.UnifiedProductDetails)
local PriceSummary = require(parent.Generic.PriceSummary)

local UnifiedPurchaseModalTypeEnum = require(parent.Enums.UnifiedPurchaseModalTypeEnum)

local logger = require(parent.Utility.logger)
local getAppContext = require(parent.Utility.getAppContext)

local LoggingProtocol = require(parent2.LoggingProtocol)
local default = LoggingProtocol.default
local TooExpensiveUpsellCounter = require(parent.Generic.Events.TooExpensiveUpsellCounter)
local TooExpensiveUnifiedUpsellShownCounter = TooExpensiveUpsellCounter.TooExpensiveUnifiedUpsellShownCounter

local useFocusNavigationRefs = require(parent.Generic.Hooks.useFocusNavigationRefs)

local function UnifiedRobuxUpsellModalTooExpensiveV2(props)
	local v = useLocalization({
		NeedMoreRobux = "IAPExperience.RobuxUpsell.Text.NeedMoreRobux",
		ButtonCancel = "IAPExperience.InsufficientRobux.Action.Cancel",
		BuyRobux = "IAPExperience.InsufficientRobux.Action.BuyRobux"
	})

	local ref, ref2 = useFocusNavigationRefs(props.buttons.cancelPurchaseActivated, nil)

	React.useEffect(function()
		logger.debug({
			message = "Too Expensive Unified Upsell Modal Shown (Dialog)",
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
	local root = Dialog.Root
	local v2 = {
		size = DialogSize.Medium,
		onClose = props.buttons.cancelPurchaseActivated,
		ref = ref,
		disablePortal = false
	}

	local children = {
		DialogTitle = React.createElement(Dialog.Title, { text = v.NeedMoreRobux }),
		DialogContent = 0,
		DialogActions = 0
	}

	local createElement2 = React.createElement
	local content = Dialog.Content
	local createElement3 = React.createElement
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

	children.DialogContent = createElement2(content, nil, {
		ContentView = createElement3(
			View,
			{
				tag = "col gap-medium auto-y size-full-0 align-x-center align-y-start padding-bottom-medium"
			},
			{ ProductDetails = productDetails }
		)
	})

	children.DialogActions = React.createElement(Dialog.Actions, {
		LayoutOrder = 3,
		orientation = Orientation.Horizontal,
		actions = {
			{
				text = v.BuyRobux,
				onActivated = props.buttons.buyItemActivated,
				variant = ButtonVariant.Emphasis,
				icon = Foundation.Enums.IconName.ArrowUpRightFromSquare,
				isDisabled = false,
				ref = ref2
			}
		}
	})
	return createElement(root, v2, children)
end

local function UnifiedRobuxUpsellModalTooExpensiveV2Container(p)
	return React.createElement(
		LocalizationProvider,
		{
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			RobuxUpsellModalTooExpensiveV2 = React.createElement(UnifiedRobuxUpsellModalTooExpensiveV2, p)
		}
	)
end

return UnifiedRobuxUpsellModalTooExpensiveV2Container
