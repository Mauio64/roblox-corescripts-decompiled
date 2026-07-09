local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local EnumsOrientation = Foundation.Enums.Orientation
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(ParentParentParent.AppLocales).Localization
local Localization2 = require(ParentParentParent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local useLocalization = Localization2.Hooks.useLocalization
local UnifiedProductDetails = require(ParentParent.Generic.UnifiedProductDetails)
local PriceSummary = require(ParentParent.Generic.PriceSummary)
local UnifiedPurchaseModalTypeEnum = require(ParentParent.Enums.UnifiedPurchaseModalTypeEnum)
local logger = require(ParentParent.Utility.logger)
local getAppContext = require(ParentParent.Utility.getAppContext)
local default = require(ParentParentParent.LoggingProtocol).default
local TooExpensiveUnifiedUpsellShownCounter = require(ParentParent.Generic.Events.TooExpensiveUpsellCounter).TooExpensiveUnifiedUpsellShownCounter
local useFocusNavigationRefs = require(ParentParent.Generic.Hooks.useFocusNavigationRefs)

local function UnifiedRobuxUpsellModalTooExpensiveV2(t1: {[any]: any}) -- line: 63
	-- upvalues: useLocalization (copy), useFocusNavigationRefs (copy), React (copy), logger (copy), getAppContext (copy), default (copy), TooExpensiveUnifiedUpsellShownCounter (copy), Dialog (copy), DialogSize (copy), View (copy), UnifiedPurchaseModalTypeEnum (copy), PriceSummary (copy), UnifiedProductDetails (copy), EnumsOrientation (copy), ButtonVariant (copy), Foundation (copy)
	local v26 = useLocalization({
		NeedMoreRobux = "IAPExperience.RobuxUpsell.Text.NeedMoreRobux",
		ButtonCancel = "IAPExperience.InsufficientRobux.Action.Cancel",
		BuyRobux = "IAPExperience.InsufficientRobux.Action.BuyRobux"
	})
	local v27, v28 = useFocusNavigationRefs(t1.buttons.cancelPurchaseActivated, nil)

	React.useEffect(function() -- line: 73
		-- upvalues: logger (copy), t1 (copy), getAppContext (copy), default (copy), TooExpensiveUnifiedUpsellShownCounter (copy)
		logger.debug({
			message = "Too Expensive Unified Upsell Modal Shown (Dialog)",
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

	return React.createElement(Dialog.Root, {
		disablePortal = false,
		size = DialogSize.Medium,
		onClose = t1.buttons.cancelPurchaseActivated,
		ref = v27
	}, {
		DialogTitle = React.createElement(Dialog.Title, {
			text = v26.NeedMoreRobux
		}),
		DialogContent = React.createElement(Dialog.Content, nil, {
			ContentView = React.createElement(View, {
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
		DialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			orientation = EnumsOrientation.Horizontal,
			actions = {{
				isDisabled = false,
				text = v26.BuyRobux,
				onActivated = t1.buttons.buyItemActivated,
				variant = ButtonVariant.Emphasis,
				icon = Foundation.Enums.IconName.ArrowUpRightFromSquare,
				ref = v28
			}}
		})
	})
end
local function UnifiedRobuxUpsellModalTooExpensiveV2Container(t2: {[any]: any}) -- line: 133
	-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), UnifiedRobuxUpsellModalTooExpensiveV2 (copy)
	return React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		RobuxUpsellModalTooExpensiveV2 = React.createElement(UnifiedRobuxUpsellModalTooExpensiveV2, t2)
	})
end

return UnifiedRobuxUpsellModalTooExpensiveV2Container
