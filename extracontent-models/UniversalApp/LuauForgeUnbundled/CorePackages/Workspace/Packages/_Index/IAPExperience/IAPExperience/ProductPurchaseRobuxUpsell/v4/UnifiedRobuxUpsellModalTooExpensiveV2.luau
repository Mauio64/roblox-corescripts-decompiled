local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local orientation = Foundation.Enums.Orientation

local LocalizationService = game:GetService("LocalizationService")
local localization = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/AppLocales").Localization
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization")
local localizationProvider = Localization.LocalizationProvider
local useLocalization = Localization.Hooks.useLocalization

local UnifiedProductDetails = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/UnifiedProductDetails")
local PriceSummary = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/PriceSummary")

local UnifiedPurchaseModalTypeEnum = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/UnifiedPurchaseModalTypeEnum")

local logger = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/logger")
local getAppContext = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/getAppContext")

local default = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").default
local tooExpensiveUnifiedUpsellShownCounter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Events/TooExpensiveUpsellCounter").TooExpensiveUnifiedUpsellShownCounter

local useFocusNavigationRefs = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Hooks/useFocusNavigationRefs")

local function UnifiedRobuxUpsellModalTooExpensiveV2(props)
	local v5 = useLocalization({
		NeedMoreRobux = "IAPExperience.RobuxUpsell.Text.NeedMoreRobux",
		ButtonCancel = "IAPExperience.InsufficientRobux.Action.Cancel",
		BuyRobux = "IAPExperience.InsufficientRobux.Action.BuyRobux"
	})

	local v6, v7 = useFocusNavigationRefs(props.buttons.cancelPurchaseActivated, nil)

	React.useEffect(function()
		logger.debug({
			message = "Too Expensive Unified Upsell Modal Shown (Dialog)",
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y,
			appContext = getAppContext()
		})

		default:logRobloxTelemetryCounter(tooExpensiveUnifiedUpsellShownCounter, 1, {
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y,
			appContext = getAppContext()
		})
	end, {})

	local createElement = React.createElement
	local root = dialog.Root
	local v8 = {
		size = dialogSize.Medium,
		onClose = props.buttons.cancelPurchaseActivated,
		ref = v6,
		disablePortal = false
	}

	local children = {
		DialogTitle = React.createElement(dialog.Title, { text = v5.NeedMoreRobux }),
		DialogContent = 0,
		DialogActions = 0
	}

	local createElement2 = React.createElement
	local content = dialog.Content
	local createElement3 = React.createElement

	local v14 = if props.purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then React.createElement(PriceSummary, {
		amount = props.product.itemRobuxCost
	}) else React.createElement(UnifiedProductDetails, {
		layoutOrder = 1,
		isPortrait = props.screenSize.X < props.screenSize.Y,
		model = props.product.model,
		itemIcon = props.product.itemIcon,
		itemName = props.product.itemName,
		itemRobuxCost = props.product.itemRobuxCost
	})
	children.DialogContent = createElement2(content, nil, {
		ContentView = createElement3(
			view,
			{
				tag = "col gap-medium auto-y size-full-0 align-x-center align-y-start padding-bottom-medium"
			},
			{ ProductDetails = v14 }
		)
	})

	children.DialogActions = React.createElement(dialog.Actions, {
		LayoutOrder = 3,
		orientation = orientation.Horizontal,
		actions = {
			{
				text = v5.BuyRobux,
				onActivated = props.buttons.buyItemActivated,
				variant = buttonVariant.Emphasis,
				icon = Foundation.Enums.IconName.ArrowUpRightFromSquare,
				isDisabled = false,
				ref = v7
			}
		}
	})
	return createElement(root, v8, children)
end

local function UnifiedRobuxUpsellModalTooExpensiveV2Container(p2)
	return React.createElement(
		localizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			RobuxUpsellModalTooExpensiveV2 = React.createElement(UnifiedRobuxUpsellModalTooExpensiveV2, p2)
		}
	)
end

return UnifiedRobuxUpsellModalTooExpensiveV2Container
