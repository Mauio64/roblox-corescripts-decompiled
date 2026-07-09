local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local Button = Foundation.Button
local Sheet = Foundation.Sheet
local useScaledValue = Foundation.Hooks.useScaledValue
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(ParentParentParent.AppLocales).Localization
local Localization2 = require(ParentParentParent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local useLocalization = Localization2.Hooks.useLocalization
local UnifiedProductDetails = require(ParentParent.Generic.UnifiedProductDetails)
local PriceSummary = require(ParentParent.Generic.PriceSummary)
local UnifiedPurchaseModalHeader = require(ParentParent.Generic.UnifiedPurchaseModalHeader)
local UnifiedPurchaseModalTypeEnum = require(ParentParent.Enums.UnifiedPurchaseModalTypeEnum)
local logger = require(ParentParent.Utility.logger)
local getAppContext = require(ParentParent.Utility.getAppContext)
local default = require(ParentParentParent.LoggingProtocol).default
local TooExpensiveUnifiedUpsellShownCounter = require(ParentParent.Generic.Events.TooExpensiveUpsellCounter).TooExpensiveUnifiedUpsellShownCounter
local useFocusNavigationRefs = require(ParentParent.Generic.Hooks.useFocusNavigationRefs)
local useInitialButtonDisableDelay = require(ParentParent.Generic.Hooks.useInitialButtonDisableDelay)
local UNIFIED_ROBUX_UPSELL_MODAL_TOO_EXPENSIVE_MIN_HEIGHT_PIXELS = require(ParentParent.Generic.Constants).UNIFIED_ROBUX_UPSELL_MODAL_TOO_EXPENSIVE_MIN_HEIGHT_PIXELS
local FFlagUnifiedPurchaseModalUiImprovements = require(ParentParent.Flags.FFlagUnifiedPurchaseModalUiImprovements)
local FFlagAddFocusNavigationToUnifiedPurchase = require(ParentParent.Flags.FFlagAddFocusNavigationToUnifiedPurchase)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require(ParentParent.Parent.SharedFlags).FFlagUnifiedPurchaseFlowMarketplaceUIImprovements

local function UnifiedRobuxUpsellModalTooExpensive(t1: {[any]: any}) -- line: 79
	-- upvalues: useLocalization (copy), FFlagAddFocusNavigationToUnifiedPurchase (copy), useFocusNavigationRefs (copy), useInitialButtonDisableDelay (copy), React (copy), logger (copy), getAppContext (copy), default (copy), TooExpensiveUnifiedUpsellShownCounter (copy), Sheet (copy), FFlagUnifiedPurchaseModalUiImprovements (copy), useScaledValue (copy), UNIFIED_ROBUX_UPSELL_MODAL_TOO_EXPENSIVE_MIN_HEIGHT_PIXELS (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), UnifiedPurchaseModalHeader (copy), View (copy), UnifiedPurchaseModalTypeEnum (copy), PriceSummary (copy), UnifiedProductDetails (copy), Button (copy), FillBehavior (copy), ButtonVariant (copy), Foundation (copy)
	local v33 = useLocalization({
		NeedMoreRobux = "IAPExperience.RobuxUpsell.Text.NeedMoreRobux",
		ButtonCancel = "IAPExperience.InsufficientRobux.Action.Cancel",
		BuyRobux = "IAPExperience.InsufficientRobux.Action.BuyRobux"
	})
	local v34 = nil
	local v35 = nil
	local v36 = false

	if FFlagAddFocusNavigationToUnifiedPurchase then
		v34, v35 = useFocusNavigationRefs(t1.buttons.cancelPurchaseActivated, nil)
		v36 = useInitialButtonDisableDelay()
	end

	React.useEffect(function() -- line: 92
		-- upvalues: logger (copy), t1 (copy), getAppContext (copy), default (copy), TooExpensiveUnifiedUpsellShownCounter (copy)
		logger.debug({
			message = "Too Expensive Unified Upsell Modal Shown",
			screenHeight = t1.screenSize.Y,
			screenWidth = t1.screenSize.X,
			portrait = t1.screenSize.X < t1.screenSize.Y,
			appContext = getAppContext()
		})
		default:logRobloxTelemetryCounter(TooExpensiveUnifiedUpsellShownCounter, 1, {
			screenHeight = t1.screenSize.Y,
			screenWidth = t1.screenSize.X,
			portrait = t1.screenSize.X < t1.screenSize.Y,
			appContext = getAppContext()
		})
	end, {})

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		onClose = t1.buttons.cancelPurchaseActivated,
		snapPoints = if not FFlagUnifiedPurchaseModalUiImprovements then {
			0.4,
			0.8
		} else {
			useScaledValue(UNIFIED_ROBUX_UPSELL_MODAL_TOO_EXPENSIVE_MIN_HEIGHT_PIXELS),
			0.8
		},
		ref = if not FFlagAddFocusNavigationToUnifiedPurchase then nil else if not v36 then v34 else nil
	}, {
		Header = React.createElement(Sheet.Header, {
			hasCloseAffordance = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else not not t1.hideUserRobuxBalance or nil
		}, {
			ModalHeader = React.createElement(UnifiedPurchaseModalHeader, {
				titleText = v33.NeedMoreRobux,
				robuxBalanceAmount = t1.balanceAmount,
				hideUserRobuxBalance = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else t1.hideUserRobuxBalance
			})
		}),
		Content = React.createElement(Sheet.Content, {
			LayoutOrder = 2
		}, {
			SheetContentContainer = React.createElement(View, {
				tag = "col gap-medium auto-y size-full-0 align-x-center align-y-start padding-bottom-medium"
			}, {
				ProductDetails = if t1.purchaseModalType ~= UnifiedPurchaseModalTypeEnum.MultiItem then React.createElement(UnifiedProductDetails, {
					layoutOrder = 1,
					isPortrait = t1.screenSize.X < t1.screenSize.Y,
					model = t1.product.model,
					itemIcon = t1.product.itemIcon,
					itemName = t1.product.itemName,
					itemRobuxCost = t1.product.itemRobuxCost
				}) else React.createElement(PriceSummary, {
					amount = t1.product.itemRobuxCost
				})
			})
		}),
		Actions = React.createElement(Sheet.Actions, {
			LayoutOrder = 3
		}, { if not t1.isQuest then React.createElement(Button, {
			text = v33.BuyRobux,
			onActivated = t1.buttons.buyItemActivated,
			fillBehavior = FillBehavior.Fill,
			variant = ButtonVariant.Emphasis,
			icon = Foundation.Enums.IconName.ArrowUpRightFromSquare,
			isDisabled = not not FFlagAddFocusNavigationToUnifiedPurchase and v36,
			ref = if not FFlagAddFocusNavigationToUnifiedPurchase then nil else v35
		}) else React.createElement(Button, {
			text = v33.ButtonCancel,
			onActivated = t1.buttons.cancelPurchaseActivated,
			fillBehavior = FillBehavior.Fill,
			variant = ButtonVariant.Standard
		}) })
	})
end
local function UnifiedRobuxUpsellModalTooExpensiveContainer(t2: {[any]: any}) -- line: 173
	-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), UnifiedRobuxUpsellModalTooExpensive (copy)
	return React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		RobuxUpsellModalTooExpensive = React.createElement(UnifiedRobuxUpsellModalTooExpensive, t2)
	})
end

return UnifiedRobuxUpsellModalTooExpensiveContainer
