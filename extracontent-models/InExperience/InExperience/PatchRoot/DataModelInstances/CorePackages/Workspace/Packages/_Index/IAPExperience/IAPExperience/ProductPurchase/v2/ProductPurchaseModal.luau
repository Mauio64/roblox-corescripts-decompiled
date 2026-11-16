local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local TextService = game:GetService("TextService")
local Style = require(parent2.Style)
local GetTextSize = Style.GetTextSize

local UIBlox = require(parent2.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local Foundation = require(parent2.Foundation)
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local useTextSizeOffset = Foundation.Hooks.useTextSizeOffset

local ReactFocusNavigation = require(parent2.ReactFocusNavigation)
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior

local ProductDetails = require(parent.Generic.ProductDetails)

local LocalizationService = game:GetService("LocalizationService")
local AppLocales = require(parent2.AppLocales)
local Localization = AppLocales.Localization
local Localization2 = require(parent2.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local useLocalization = Localization2.Hooks.useLocalization

local formatNumber = require(parent.Utility.formatNumber)
local logger = require(parent.Utility.logger)
local getAppContext = require(parent.Utility.getAppContext)

local LoggingProtocol = require(parent2.LoggingProtocol)
local default = LoggingProtocol.default
local PurchaseModalCounter = require(parent.Generic.Events.PurchaseModalCounter)
local PurchaseModalV2ShownCounter = PurchaseModalCounter.PurchaseModalV2ShownCounter

local FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt = require(parent.Flags.FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt)

local function ProductPurchaseModal(props)
	local buttonRef, defaultChildRef

	if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
		buttonRef, defaultChildRef = useDefaultFocusBehavior()
	end

	React.useEffect(function()
		logger.debug({
			message = "Purchase Modal V2 Shown",
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y,
			appContext = getAppContext()
		})

		default:logRobloxTelemetryCounter(PurchaseModalV2ShownCounter, 1, {
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y,
			appContext = getAppContext()
		})
	end, {})

	local v = useLocalization({
		BuyItem = "IAPExperience.PurchasePrompt.Title.BuyItem",
		RemainingBalance = "IAPExperience.PurchasePrompt.Text.RemainingBalanceV2"
	})

	local v2 = props.balanceAmount - props.product.itemRobuxCost
	local v3 = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, v2)

	local text = utf8.char(57346) .. " " .. formatNumber(
		LocalizationService.RobloxLocaleId,
		props.product.itemRobuxCost
	)

	local v4 = useTokens()
	local v5 = useTextSizeOffset()
	local state, setState = React.useState(0)
	local captionSmall = v4.Typography.CaptionSmall

	local text2 = v.RemainingBalance:gsub("{robux}", v3)

	local onAbsoluteSizeChanged = React.useCallback(function(p)
		if state ~= p.AbsoluteSize.X then
			setState(p.AbsoluteSize.X)
		end
	end, { props })

	local v6 = React.useMemo(function()
		local lineHeight = captionSmall.LineHeight
		local v6

		if FoundationFontFaceMigration then
			v6 = GetTextSize(text2, captionSmall.FontSize, captionSmall.Font, Vector2.new(state, 1e999), {
				addTemporaryPadding = false
			}).Y
		else
			v6 = TextService:GetTextSize(text2, captionSmall.FontSize, captionSmall.Font, Vector2.new(state, 1e999)).Y
		end

		return lineHeight * v6
	end, { state, v5, text2 })

	local createElement = React.createElement

	if not FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
		defaultChildRef = nil
	end

	local v7 = {
		defaultChildRef = defaultChildRef,
		screenSize = props.screenSize,
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		bottomMargin = 12,
		title = v.BuyItem,
		onCloseClicked = function()
			if not props.buttons.isDisabled then
				props.buttons.cancelActivated()
			end
		end,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
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

	local buttonStackInfo = {
		forcedFillDirection = Enum.FillDirection.Vertical,
		disableGamepadRefs = FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt and true or nil,
		buttons = 0
	}

	local v8 = { buttonType = ButtonType.PrimaryContextual, props = 0 }
	local props2 = {
		isDisabled = props.buttons.isDisabled,
		isDelayedInput = props.buttons.buyItemIsDelayedInput,
		enableInputDelayed = props.buttons.buyItemEnableInputDelayed,
		onActivated = props.buttons.buyItemActivated,
		text = text,
		inputIcon = props.buttons.buyItemControllerIcon,
		buttonRef = 0
	}

	if not FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
		buttonRef = nil
	end

	props2.buttonRef = buttonRef
	v8.props = props2
	buttonStackInfo.buttons = { v8 }
	v7.buttonStackInfo = buttonStackInfo

	function v7.footerContent()
		if props.balanceAmountValid then
			return React.createElement(Text, {
				Text = text2,
				Size = UDim2.new(1, 0, 0, v6),
				onAbsoluteSizeChanged = onAbsoluteSizeChanged,
				tag = "content-muted text-caption-small align-x-center text-wrap"
			})
		end

		return React.None
	end

	return createElement(InteractiveAlert, v7)
end

local function ProductPurchaseModalContainer(p)
	return React.createElement(
		LocalizationProvider,
		{
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			ProductPurchaseModal = React.createElement(ProductPurchaseModal, p)
		}
	)
end

return ProductPurchaseModalContainer
