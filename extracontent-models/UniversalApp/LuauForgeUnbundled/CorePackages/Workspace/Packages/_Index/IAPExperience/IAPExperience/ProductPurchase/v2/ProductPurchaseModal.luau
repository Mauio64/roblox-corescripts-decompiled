local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")
local getTextSize = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Style").GetTextSize

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local useTextSizeOffset = Foundation.Hooks.useTextSizeOffset

local useDefaultFocusBehavior = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/ReactFocusNavigation").useDefaultFocusBehavior

local ProductDetails = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/ProductDetails")

local LocalizationService = game:GetService("LocalizationService")
local localization = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/AppLocales").Localization
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization")
local localizationProvider = Localization.LocalizationProvider
local useLocalization = Localization.Hooks.useLocalization

local formatNumber = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatNumber")
local logger = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/logger")
local getAppContext = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/getAppContext")

local default = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").default
local purchaseModalV2ShownCounter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Events/PurchaseModalCounter").PurchaseModalV2ShownCounter

local FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt")

local function ProductPurchaseModal(props)
	local v5, v6

	if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
		v5, v6 = useDefaultFocusBehavior()
	end

	React.useEffect(function()
		logger.debug({
			message = "Purchase Modal V2 Shown",
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y,
			appContext = getAppContext()
		})

		default:logRobloxTelemetryCounter(purchaseModalV2ShownCounter, 1, {
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y,
			appContext = getAppContext()
		})
	end, {})

	local v7 = useLocalization({
		BuyItem = "IAPExperience.PurchasePrompt.Title.BuyItem",
		RemainingBalance = "IAPExperience.PurchasePrompt.Text.RemainingBalanceV2"
	})

	local v8 = props.balanceAmount - props.product.itemRobuxCost
	local v9 = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, v8)

	local v10 = utf8.char(57346) .. " " .. formatNumber(
		LocalizationService.RobloxLocaleId,
		props.product.itemRobuxCost
	)

	local v11 = useTokens()
	local v12 = useTextSizeOffset()
	local state, setState = React.useState(0)
	local captionSmall = v11.Typography.CaptionSmall

	local v15 = v7.RemainingBalance:gsub("{robux}", v9)

	local v16 = React.useCallback(function(p2)
		if state ~= p2.AbsoluteSize.X then
			setState(p2.AbsoluteSize.X)
		end
	end, { props })

	local v17 = React.useMemo(function()
		return captionSmall.LineHeight * getTextSize(
			v15,
			captionSmall.FontSize,
			captionSmall.Font,
			Vector2.new(state, 1e999),
			{ addTemporaryPadding = false }
		).Y
	end, { state, v12, v15 })

	local createElement = React.createElement

	if not FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
		v6 = nil
	end

	local v19 = {
		defaultChildRef = v6,
		screenSize = props.screenSize,
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		bottomMargin = 12,
		title = v7.BuyItem,
		onCloseClicked = function()
			if not props.buttons.isDisabled then
				props.buttons.cancelActivated()
			end
		end,
		onAbsoluteSizeChanged = v16,
		middleContent = function()
			return React.createElement(ProductDetails, {
				isPortrait = false,
				layoutOrder = 1,
				itemIcon = props.product.itemIcon,
				itemName = props.product.itemName
			})
		end,
		buttonStackInfo = 0,
		footerContent = 0
	}

	local v20 = {
		forcedFillDirection = Enum.FillDirection.Vertical,
		disableGamepadRefs = FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt and true or nil,
		buttons = 0
	}

	local v22 = { buttonType = buttonType.PrimaryContextual, props = 0 }
	local v23 = {
		isDisabled = props.buttons.isDisabled,
		isDelayedInput = props.buttons.buyItemIsDelayedInput,
		enableInputDelayed = props.buttons.buyItemEnableInputDelayed,
		onActivated = props.buttons.buyItemActivated,
		text = v10,
		inputIcon = props.buttons.buyItemControllerIcon,
		buttonRef = 0
	}

	if not FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
		v5 = nil
	end

	v23.buttonRef = v5
	v22.props = v23
	v20.buttons = { v22 }
	v19.buttonStackInfo = v20

	function v19.footerContent()
		if props.balanceAmountValid then
			return React.createElement(text, {
				Text = v15,
				Size = UDim2.new(1, 0, 0, v17),
				onAbsoluteSizeChanged = v16,
				tag = "content-muted text-caption-small align-x-center text-wrap"
			})
		end

		return React.None
	end

	return createElement(interactiveAlert, v19)
end

local function ProductPurchaseModalContainer(p2)
	return React.createElement(
		localizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			ProductPurchaseModal = React.createElement(ProductPurchaseModal, p2)
		}
	)
end

return ProductPurchaseModalContainer
