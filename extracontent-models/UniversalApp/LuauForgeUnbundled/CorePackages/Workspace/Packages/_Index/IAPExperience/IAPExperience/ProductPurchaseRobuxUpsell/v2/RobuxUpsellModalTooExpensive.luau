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
local RobuxUpsellModalFooter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/v2/RobuxUpsellModalFooter")

local formatNumber = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatNumber")
local logger = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/logger")
local getAppContext = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/getAppContext")

local default = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").default
local tooExpensiveUpsellShownCounter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Events/TooExpensiveUpsellCounter").TooExpensiveUpsellShownCounter

local function MiddleContent(props)
	local v5 = useLocalization({
		DontHaveEnough = "IAPExperience.InsufficientRobux.Text.BuyRobux"
	})

	local v6 = props.product.itemRobuxCost - props.balanceAmount
	local v7 = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, v6)
	local v8 = v5.DontHaveEnough:gsub("{robux}", v7)

	return React.createElement(
		view,
		{ tag = "col gap-xxlarge auto-y size-full-0 align-x-center align-y-center" },
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
				tag = "auto-xy text-label-medium content-emphasis text-align-x-center size-full-0"
			})
		}
	)
end

local function ButtonStackInfo(p2)
	local v5 = useLocalization({
		RobuxStoreButton = "IAPExperience.InsufficientRobux.Action.RobuxStore",
		ButtonCancel = "IAPExperience.InsufficientRobux.Action.Cancel"
	})

	local v6 = { forcedFillDirection = Enum.FillDirection.Vertical, buttons = 0 }
	local v7 = if p2.isQuest then {
		{
			props = {
				onActivated = p2.buttons.cancelPurchaseActivated,
				text = v5.ButtonCancel,
				inputIcon = p2.buttons.cancelControllerIcon
			}
		}
	} else {
		{
			buttonType = buttonType.PrimaryContextual,
			props = {
				onActivated = p2.buttons.buyItemActivated,
				text = v5.RobuxStoreButton,
				inputIcon = p2.buttons.buyItemControllerIcon
			}
		}
	}
	v6.buttons = v7
	return v6
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

		default:logRobloxTelemetryCounter(tooExpensiveUpsellShownCounter, 1, {
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y,
			appContext = getAppContext()
		})
	end, {})
	return React.createElement(interactiveAlert, {
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
		buttonStackInfo = ButtonStackInfo({
			buttons = props.buttons,
			isQuest = props.isQuest
		}),
		footerContent = function()
			return React.createElement(RobuxUpsellModalFooter)
		end
	})
end

local function RobuxUpsellModalTooExpensiveContainer(p2)
	return React.createElement(
		localizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			RobuxUpsellModalTooExpensive = React.createElement(RobuxUpsellModalTooExpensive, p2)
		}
	)
end

return RobuxUpsellModalTooExpensiveContainer
