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
local RobuxUpsellModalFooter = require(script.Parent.RobuxUpsellModalFooter)
local formatNumber = require(ParentParent.Utility.formatNumber)
local logger = require(ParentParent.Utility.logger)
local getAppContext = require(ParentParent.Utility.getAppContext)
local default = require(ParentParentParent.LoggingProtocol).default
local TooExpensiveUpsellShownCounter = require(ParentParent.Generic.Events.TooExpensiveUpsellCounter).TooExpensiveUpsellShownCounter

local function MiddleContent(t1: {[any]: any}) -- line: 58
	-- upvalues: useLocalization (copy), formatNumber (copy), LocalizationService (copy), React (copy), View (copy), ProductDetails (copy), FoundationText (copy)
	local v28 = useLocalization({
		DontHaveEnough = "IAPExperience.InsufficientRobux.Text.BuyRobux"
	})
	local v29 = t1.product.itemRobuxCost - t1.balanceAmount
	local v30 = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, v29)
	local v31 = v28.DontHaveEnough:gsub("{robux}", v30)

	return React.createElement(View, {
		tag = "col gap-xxlarge auto-y size-full-0 align-x-center align-y-center"
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
			tag = "auto-xy text-label-medium content-emphasis text-align-x-center size-full-0",
			Text = v31,
			padding = {
				bottom = UDim.new(0, -12)
			}
		})
	})
end
local function ButtonStackInfo(t2: {[any]: any}) -- line: 93
	-- upvalues: useLocalization (copy), ButtonType (copy)
	local v33 = useLocalization({
		RobuxStoreButton = "IAPExperience.InsufficientRobux.Action.RobuxStore",
		ButtonCancel = "IAPExperience.InsufficientRobux.Action.Cancel"
	})

	return {
		forcedFillDirection = Enum.FillDirection.Vertical,
		buttons = if not t2.isQuest then {{
			buttonType = ButtonType.PrimaryContextual,
			props = {
				onActivated = t2.buttons.buyItemActivated,
				text = v33.RobuxStoreButton,
				inputIcon = t2.buttons.buyItemControllerIcon
			}
		}} else {{
			props = {
				onActivated = t2.buttons.cancelPurchaseActivated,
				text = v33.ButtonCancel,
				inputIcon = t2.buttons.cancelControllerIcon
			}
		}}
	}
end
local function RobuxUpsellModalTooExpensive(t3: {[any]: any}) -- line: 130
	-- upvalues: React (copy), logger (copy), getAppContext (copy), default (copy), TooExpensiveUpsellShownCounter (copy), InteractiveAlert (copy), RobuxUpsellModalTitle (copy), MiddleContent (copy), ButtonStackInfo (copy), RobuxUpsellModalFooter (copy)
	React.useEffect(function() -- line: 131
		-- upvalues: logger (copy), t3 (copy), getAppContext (copy), default (copy), TooExpensiveUpsellShownCounter (copy)
		logger.debug({
			message = "Too Expensive Upsell Modal Shown",
			screenHeight = t3.screenSize.Y,
			screenWidth = t3.screenSize.X,
			portrait = t3.screenSize.X < t3.screenSize.Y,
			appContext = getAppContext()
		})
		default:logRobloxTelemetryCounter(TooExpensiveUpsellShownCounter, 1, {
			screenHeight = t3.screenSize.Y,
			screenWidth = t3.screenSize.X,
			portrait = t3.screenSize.X < t3.screenSize.Y,
			appContext = getAppContext()
		})
	end, {})

	return React.createElement(InteractiveAlert, {
		title = "",
		screenSize = t3.screenSize,
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		titleContent = function() -- line: 151
			-- upvalues: React (copy), RobuxUpsellModalTitle (copy), t3 (copy)
			return React.createElement(RobuxUpsellModalTitle, {
				balanceAmount = t3.balanceAmount,
				cancelPurchaseActivated = t3.buttons.cancelPurchaseActivated
			})
		end,
		middleContent = function() -- line: 157
			-- upvalues: React (copy), MiddleContent (copy), t3 (copy)
			return React.createElement(MiddleContent, {
				product = t3.product,
				balanceAmount = t3.balanceAmount,
				isQuest = t3.isQuest,
				isPortrait = t3.screenSize.X < t3.screenSize.Y
			})
		end,
		buttonStackInfo = ButtonStackInfo({
			buttons = t3.buttons,
			isQuest = t3.isQuest
		}),
		footerContent = function() -- line: 169
			-- upvalues: React (copy), RobuxUpsellModalFooter (copy)
			return React.createElement(RobuxUpsellModalFooter)
		end
	})
end
local function RobuxUpsellModalTooExpensiveContainer(t4: {[any]: any}) -- line: 175
	-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), RobuxUpsellModalTooExpensive (copy)
	return React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		RobuxUpsellModalTooExpensive = React.createElement(RobuxUpsellModalTooExpensive, t4)
	})
end

return RobuxUpsellModalTooExpensiveContainer
