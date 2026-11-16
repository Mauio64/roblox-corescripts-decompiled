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
local RobuxUpsellModalFooter = require(script.Parent.RobuxUpsellModalFooter)

local formatNumber = require(parent.Utility.formatNumber)
local logger = require(parent.Utility.logger)
local getAppContext = require(parent.Utility.getAppContext)

local LoggingProtocol = require(parent2.LoggingProtocol)
local default = LoggingProtocol.default
local TooExpensiveUpsellCounter = require(parent.Generic.Events.TooExpensiveUpsellCounter)
local TooExpensiveUpsellShownCounter = TooExpensiveUpsellCounter.TooExpensiveUpsellShownCounter

local function MiddleContent(props)
	local v = useLocalization({ DontHaveEnough = "IAPExperience.InsufficientRobux.Text.BuyRobux" })

	local v2 = props.product.itemRobuxCost - props.balanceAmount
	local v3 = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, v2)
	local text = v.DontHaveEnough:gsub("{robux}", v3)

	return React.createElement(View, {
		tag = "col gap-xxlarge auto-y size-full-0 align-x-center align-y-center"
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
			tag = "auto-xy text-label-medium content-emphasis text-align-x-center size-full-0"
		})
	})
end

local function ButtonStackInfo(p)
	local v = useLocalization({
		RobuxStoreButton = "IAPExperience.InsufficientRobux.Action.RobuxStore",
		ButtonCancel = "IAPExperience.InsufficientRobux.Action.Cancel"
	})

	local v2 = { forcedFillDirection = Enum.FillDirection.Vertical, buttons = 0 }
	local buttons

	if p.isQuest then
		buttons = {
			{
				props = {
					onActivated = p.buttons.cancelPurchaseActivated,
					text = v.ButtonCancel,
					inputIcon = p.buttons.cancelControllerIcon
				}
			}
		}
	else
		buttons = {
			{
				buttonType = ButtonType.PrimaryContextual,
				props = {
					onActivated = p.buttons.buyItemActivated,
					text = v.RobuxStoreButton,
					inputIcon = p.buttons.buyItemControllerIcon
				}
			}
		}
	end

	v2.buttons = buttons
	return v2
end

local function RobuxUpsellModalTooExpensive(props)
	React.useEffect(function()
		logger.debug({
			message = "Too Expensive Upsell Modal Shown",
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y,
			appContext = getAppContext()
		})

		default:logRobloxTelemetryCounter(TooExpensiveUpsellShownCounter, 1, {
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y,
			appContext = getAppContext()
		})
	end, {})
	return React.createElement(InteractiveAlert, {
		screenSize = props.screenSize,
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		title = "",
		titleContent = function()
			return React.createElement(RobuxUpsellModalTitle, {
				balanceAmount = props.balanceAmount,
				cancelPurchaseActivated = props.buttons.cancelPurchaseActivated
			})
		end,
		middleContent = function()
			return React.createElement(MiddleContent, {
				product = props.product,
				balanceAmount = props.balanceAmount,
				isQuest = props.isQuest,
				isPortrait = props.screenSize.X < props.screenSize.Y
			})
		end,
		buttonStackInfo = ButtonStackInfo({ buttons = props.buttons, isQuest = props.isQuest }),
		footerContent = function()
			return React.createElement(RobuxUpsellModalFooter)
		end
	})
end

local function RobuxUpsellModalTooExpensiveContainer(p)
	return React.createElement(
		LocalizationProvider,
		{
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			RobuxUpsellModalTooExpensive = React.createElement(RobuxUpsellModalTooExpensive, p)
		}
	)
end

return RobuxUpsellModalTooExpensiveContainer
