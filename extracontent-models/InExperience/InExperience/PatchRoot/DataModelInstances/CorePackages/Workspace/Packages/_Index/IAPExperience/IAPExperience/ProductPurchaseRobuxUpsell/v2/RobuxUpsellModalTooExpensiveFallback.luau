local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local UIBlox = require(ParentParentParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(ParentParentParent.AppLocales).Localization
local Localization2 = require(ParentParentParent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local useLocalization = Localization2.Hooks.useLocalization
local ProductDetails = require(ParentParent.Generic.ProductDetails)
local RobuxUpsellModalTitle = require(script.Parent.RobuxUpsellModalTitle)
local formatNumber = require(ParentParent.Utility.formatNumber)
local logger = require(ParentParent.Utility.logger)
local getAppContext = require(ParentParent.Utility.getAppContext)
local default = require(ParentParentParent.LoggingProtocol).default
local TooExpensiveUpsellFallbackShownCounter = require(ParentParent.Generic.Events.TooExpensiveUpsellCounter).TooExpensiveUpsellFallbackShownCounter

local function MiddleContent(t1: {[any]: any}) -- line: 56
	-- upvalues: useLocalization (copy), formatNumber (copy), LocalizationService (copy), React (copy), View (copy), ProductDetails (copy), FoundationText (copy)
	local v26 = useLocalization({
		YouNeed = "IAPExperience.InsufficientRobux.Text.YouNeed"
	})
	local v27 = t1.product.itemRobuxCost - t1.balanceAmount
	local v28 = utf8.char(57346) .. formatNumber(LocalizationService.RobloxLocaleId, v27)
	local v29 = v26.YouNeed:gsub("{robux}", v28)

	return React.createElement(View, {
		tag = "col gap-medium auto-y size-full-0 align-x-center align-y-center"
	}, {
		ProductDetails = React.createElement(ProductDetails, {
			layoutOrder = 1,
			isPortrait = t1.isPortrait,
			model = t1.product.model,
			itemIcon = t1.product.itemIcon,
			itemName = t1.product.itemName,
			itemRobuxCost = t1.product.itemRobuxCost
		}),
		BuyRobuxDetails = React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "auto-xy text-body-medium content-emphasis text-align-x-left size-full-0 text-wrap padding-x-small line-height-",
			Text = v29,
			padding = {
				bottom = UDim.new(0, -12)
			}
		})
	})
end
local function RobuxUpsellModalTooExpensiveFallback(t2: {[any]: any}) -- line: 95
	-- upvalues: React (copy), logger (copy), getAppContext (copy), default (copy), TooExpensiveUpsellFallbackShownCounter (copy), useLocalization (copy), InteractiveAlert (copy), RobuxUpsellModalTitle (copy), MiddleContent (copy), ButtonType (copy)
	React.useEffect(function() -- line: 96
		-- upvalues: logger (copy), t2 (copy), getAppContext (copy), default (copy), TooExpensiveUpsellFallbackShownCounter (copy)
		logger.debug({
			message = "Too Expensive Upsell Fallback Modal Shown",
			screenHeight = t2.screenSize.Y,
			screenWidth = t2.screenSize.X,
			portrait = t2.screenSize.X < t2.screenSize.Y,
			appContext = getAppContext()
		})
		default:logRobloxTelemetryCounter(TooExpensiveUpsellFallbackShownCounter, 1, {
			screenHeight = t2.screenSize.Y,
			screenWidth = t2.screenSize.X,
			portrait = t2.screenSize.X < t2.screenSize.Y,
			appContext = getAppContext()
		})
	end, {})

	local v31 = useLocalization({
		OK = "IAPExperience.PurchaseError.Text.Ok"
	})

	return React.createElement(InteractiveAlert, {
		title = "",
		screenSize = t2.screenSize,
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		titleContent = function() -- line: 119
			-- upvalues: React (copy), RobuxUpsellModalTitle (copy), t2 (copy)
			return React.createElement(RobuxUpsellModalTitle, {
				balanceAmount = t2.balanceAmount,
				cancelPurchaseActivated = t2.doneActivated
			})
		end,
		middleContent = function() -- line: 125
			-- upvalues: React (copy), MiddleContent (copy), t2 (copy)
			return React.createElement(MiddleContent, {
				product = t2.product,
				isQuest = t2.isQuest,
				balanceAmount = t2.balanceAmount,
				isPortrait = t2.screenSize.X < t2.screenSize.Y
			})
		end,
		buttonStackInfo = {
			buttons = {{
				buttonType = ButtonType.PrimaryContextual,
				props = {
					onActivated = t2.doneActivated,
					text = v31.OK,
					inputIcon = t2.doneControllerIcon
				}
			}}
		}
	})
end
local function RobuxUpsellModalTooExpensiveFallbackContainer(t3: {[any]: any}) -- line: 148
	-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), RobuxUpsellModalTooExpensiveFallback (copy)
	return React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		RobuxUpsellModalTooExpensiveFallback = React.createElement(RobuxUpsellModalTooExpensiveFallback, t3)
	})
end

return RobuxUpsellModalTooExpensiveFallbackContainer
