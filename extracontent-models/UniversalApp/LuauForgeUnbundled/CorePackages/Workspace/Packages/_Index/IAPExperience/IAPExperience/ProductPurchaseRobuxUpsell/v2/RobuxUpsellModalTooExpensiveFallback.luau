local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local view = Foundation.View
local text = Foundation.Text

local LocalizationService = game:GetService("LocalizationService")
local localization = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/AppLocales").Localization
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization")
local localizationProvider = Localization.LocalizationProvider
local useLocalization = Localization.Hooks.useLocalization

local module5 = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/ProductDetails")
local RobuxUpsellModalTitle = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/v2/RobuxUpsellModalTitle")

local formatNumber = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatNumber")
local logger = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/logger")
local getAppContext = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/getAppContext")

local default = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").default
local tooExpensiveUpsellFallbackShownCounter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Events/TooExpensiveUpsellCounter").TooExpensiveUpsellFallbackShownCounter

local function MiddleContent(props)
	local v5 = useLocalization({
		YouNeed = "IAPExperience.InsufficientRobux.Text.YouNeed"
	})

	local v6 = props.product.itemRobuxCost - props.balanceAmount
	local v7 = utf8.char(57346) .. formatNumber(LocalizationService.RobloxLocaleId, v6)
	local v8 = v5.YouNeed:gsub("{robux}", v7)

	return React.createElement(
		view,
		{ tag = "col gap-medium auto-y size-full-0 align-x-center align-y-center" },
		{
			ProductDetails = React.createElement(module5, {
				layoutOrder = 1,
				isPortrait = props.isPortrait,
				model = props.product.model,
				itemIcon = props.product.itemIcon,
				itemName = props.product.itemName,
				itemRobuxCost = props.product.itemRobuxCost
			}),
			BuyRobuxDetails = React.createElement(text, {
				LayoutOrder = 2,
				Text = v8,
				padding = { bottom = UDim.new(0, -12) },
				tag = "auto-xy text-body-medium content-emphasis text-align-x-left size-full-0 text-wrap padding-x-small line-height-"
			})
		}
	)
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

		default:logRobloxTelemetryCounter(tooExpensiveUpsellFallbackShownCounter, 1, {
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y,
			appContext = getAppContext()
		})
	end, {})
	local v5 = useLocalization({ OK = "IAPExperience.PurchaseError.Text.Ok" })

	return React.createElement(interactiveAlert, {
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
					buttonType = buttonType.PrimaryContextual,
					props = {
						onActivated = props.doneActivated,
						text = v5.OK,
						inputIcon = props.doneControllerIcon
					}
				}
			}
		}
	})
end

local function RobuxUpsellModalTooExpensiveFallbackContainer(p2)
	return React.createElement(
		localizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			RobuxUpsellModalTooExpensiveFallback = React.createElement(
				RobuxUpsellModalTooExpensiveFallback,
				p2
			)
		}
	)
end

return RobuxUpsellModalTooExpensiveFallbackContainer
