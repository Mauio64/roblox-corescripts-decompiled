local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local button = Foundation.Button
local sheet = Foundation.Sheet
local useScaledValue = Foundation.Hooks.useScaledValue

local LocalizationService = game:GetService("LocalizationService")
local localization = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/AppLocales").Localization
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization")
local localizationProvider = Localization.LocalizationProvider
local useLocalization = Localization.Hooks.useLocalization

local UnifiedProductDetails = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/UnifiedProductDetails")
local PriceSummary = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/PriceSummary")
local UnifiedPurchaseModalHeader = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/UnifiedPurchaseModalHeader")

local UnifiedPurchaseModalTypeEnum = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/UnifiedPurchaseModalTypeEnum")

local logger = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/logger")
local getAppContext = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/getAppContext")

local default = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").default
local tooExpensiveUnifiedUpsellShownCounter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Events/TooExpensiveUpsellCounter").TooExpensiveUnifiedUpsellShownCounter

local useFocusNavigationRefs = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Hooks/useFocusNavigationRefs")
local useInitialButtonDisableDelay = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Hooks/useInitialButtonDisableDelay")

local UNIFIED_ROBUX_UPSELL_MODAL_TOO_EXPENSIVE_MIN_HEIGHT_PIXELS = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Constants").UNIFIED_ROBUX_UPSELL_MODAL_TOO_EXPENSIVE_MIN_HEIGHT_PIXELS

local fFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagUnifiedPurchaseFlowMarketplaceUIImprovements

local function UnifiedRobuxUpsellModalTooExpensive(props)
	local v5 = useLocalization({
		NeedMoreRobux = "IAPExperience.RobuxUpsell.Text.NeedMoreRobux",
		ButtonCancel = "IAPExperience.InsufficientRobux.Action.Cancel",
		BuyRobux = "IAPExperience.InsufficientRobux.Action.BuyRobux"
	})

	local v6, v7 = useFocusNavigationRefs(props.buttons.cancelPurchaseActivated, nil)
	local v8 = useInitialButtonDisableDelay()

	React.useEffect(function()
		logger.debug({
			message = "Too Expensive Unified Upsell Modal Shown",
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
	local root = sheet.Root
	local v9 = {
		onClose = props.buttons.cancelPurchaseActivated,
		snapPoints = { useScaledValue(UNIFIED_ROBUX_UPSELL_MODAL_TOO_EXPENSIVE_MIN_HEIGHT_PIXELS), 0.8 },
		preferCenterSheet = true,
		ref = 0
	}

	if v8 then
		v6 = nil
	end

	v9.ref = v6

	local createElement2 = React.createElement
	local header = sheet.Header

	local v11 = if fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then props.hideUserRobuxBalance and true or nil else nil

	local createElement3 = React.createElement
	local v14 = {
		titleText = v5.NeedMoreRobux,
		robuxBalanceAmount = props.balanceAmount,
		hideUserRobuxBalance = 0
	}

	local v15 = if fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then props.hideUserRobuxBalance else nil
	v14.hideUserRobuxBalance = v15
	local children = {
		Header = createElement2(header, { hasCloseAffordance = v11 }, {
			ModalHeader = createElement3(UnifiedPurchaseModalHeader, v14)
		}),
		Content = 0,
		Actions = 0
	}

	local createElement4 = React.createElement
	local content = sheet.Content

	local createElement5 = React.createElement

	local v21 = if props.purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then React.createElement(PriceSummary, {
		amount = props.product.itemRobuxCost
	}) else React.createElement(UnifiedProductDetails, {
		layoutOrder = 1,
		isPortrait = props.screenSize.X < props.screenSize.Y,
		model = props.product.model,
		itemIcon = props.product.itemIcon,
		itemName = props.product.itemName,
		itemRobuxCost = props.product.itemRobuxCost
	})
	children.Content = createElement4(content, { LayoutOrder = 2 }, {
		SheetContentContainer = createElement5(
			view,
			{
				tag = "col gap-medium auto-y size-full-0 align-x-center align-y-start padding-bottom-medium"
			},
			{ ProductDetails = v21 }
		)
	})

	children.Actions = React.createElement(sheet.Actions, { LayoutOrder = 3 }, {
		if props.isQuest then React.createElement(button, {
			text = v5.ButtonCancel,
			onActivated = props.buttons.cancelPurchaseActivated,
			fillBehavior = fillBehavior.Fill,
			variant = buttonVariant.Standard
		}) else React.createElement(button, {
			text = v5.BuyRobux,
			onActivated = props.buttons.buyItemActivated,
			fillBehavior = fillBehavior.Fill,
			variant = buttonVariant.Emphasis,
			icon = Foundation.Enums.IconName.ArrowUpRightFromSquare,
			isDisabled = v8,
			ref = v7
		})
	})
	return createElement(root, v9, children)
end

local function UnifiedRobuxUpsellModalTooExpensiveContainer(p2)
	return React.createElement(
		localizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			RobuxUpsellModalTooExpensive = React.createElement(UnifiedRobuxUpsellModalTooExpensive, p2)
		}
	)
end

return UnifiedRobuxUpsellModalTooExpensiveContainer
