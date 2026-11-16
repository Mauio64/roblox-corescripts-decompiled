local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local UIBlox = require(parent2.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local Foundation = require(parent2.Foundation)
local View = Foundation.View
local Text = Foundation.Text

local LocalizationService = game:GetService("LocalizationService")
local AppLocales = require(parent2.AppLocales)
local Localization = AppLocales.Localization
local Localization2 = require(parent2.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local useLocalization = Localization2.Hooks.useLocalization

local ProductDetails = require(parent.Generic.ProductDetails)
local RobuxUpsellModalTitle = require(script.Parent.RobuxUpsellModalTitle)

local formatNumber = require(parent.Utility.formatNumber)
local logger = require(parent.Utility.logger)
local getAppContext = require(parent.Utility.getAppContext)

local LoggingProtocol = require(parent2.LoggingProtocol)
local default = LoggingProtocol.default
local TooExpensiveUpsellCounter = require(parent.Generic.Events.TooExpensiveUpsellCounter)
local TooExpensiveUpsellFallbackShownCounter = TooExpensiveUpsellCounter.TooExpensiveUpsellFallbackShownCounter

local function MiddleContent(props)
	local v = useLocalization({ YouNeed = "IAPExperience.InsufficientRobux.Text.YouNeed" })

	local v2 = props.product.itemRobuxCost - props.balanceAmount
	local v3 = utf8.char(57346) .. formatNumber(LocalizationService.RobloxLocaleId, v2)
	local text = v.YouNeed:gsub("{robux}", v3)

	return React.createElement(View, {
		tag = "col gap-medium auto-y size-full-0 align-x-center align-y-center"
	}, {
		ProductDetails = React.createElement(ProductDetails, {
			layoutOrder = 1,
			isPortrait = props.isPortrait,
			model = props.product.model,
			itemIcon = props.product.itemIcon,
			itemName = props.product.itemName,
			itemRobuxCost = props.product.itemRobuxCost
		}),
		BuyRobuxDetails = React.createElement(Text, {
			LayoutOrder = 2,
			Text = text,
			padding = { bottom = UDim.new(0, -12) },
			tag = "auto-xy text-body-medium content-emphasis text-align-x-left size-full-0 text-wrap padding-x-small line-height-"
		})
	})
end

local function RobuxUpsellModalTooExpensiveFallback(props)
	React.useEffect(function()
		logger.debug({
			message = "Too Expensive Upsell Fallback Modal Shown",
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y,
			appContext = getAppContext()
		})

		default:logRobloxTelemetryCounter(TooExpensiveUpsellFallbackShownCounter, 1, {
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y,
			appContext = getAppContext()
		})
	end, {})
	local v = useLocalization({ OK = "IAPExperience.PurchaseError.Text.Ok" })

	return React.createElement(InteractiveAlert, {
		screenSize = props.screenSize,
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		title = "",
		titleContent = function()
			return React.createElement(RobuxUpsellModalTitle, {
				balanceAmount = props.balanceAmount,
				cancelPurchaseActivated = props.doneActivated
			})
		end,
		middleContent = function()
			return React.createElement(MiddleContent, {
				product = props.product,
				isQuest = props.isQuest,
				balanceAmount = props.balanceAmount,
				isPortrait = props.screenSize.X < props.screenSize.Y
			})
		end,
		buttonStackInfo = {
			buttons = {
				{
					buttonType = ButtonType.PrimaryContextual,
					props = {
						onActivated = props.doneActivated,
						text = v.OK,
						inputIcon = props.doneControllerIcon
					}
				}
			}
		}
	})
end

local function RobuxUpsellModalTooExpensiveFallbackContainer(p)
	return React.createElement(
		LocalizationProvider,
		{
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			RobuxUpsellModalTooExpensiveFallback = React.createElement(RobuxUpsellModalTooExpensiveFallback, p)
		}
	)
end

return RobuxUpsellModalTooExpensiveFallbackContainer
