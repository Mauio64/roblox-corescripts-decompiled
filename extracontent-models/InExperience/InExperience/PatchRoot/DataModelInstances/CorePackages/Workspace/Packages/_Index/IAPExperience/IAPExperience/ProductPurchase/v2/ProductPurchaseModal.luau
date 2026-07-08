local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local TextService = game:GetService("TextService")
local UIBlox = require(ParentParentParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Foundation = require(ParentParentParent.Foundation)
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local useTextSizeOffset = Foundation.Hooks.useTextSizeOffset
local useDefaultFocusBehavior = require(ParentParentParent.ReactFocusNavigation).useDefaultFocusBehavior
local ProductDetails = require(ParentParent.Generic.ProductDetails)
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(ParentParentParent.AppLocales).Localization
local Localization2 = require(ParentParentParent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local useLocalization = Localization2.Hooks.useLocalization
local formatNumber = require(ParentParent.Utility.formatNumber)
local logger = require(ParentParent.Utility.logger)
local getAppContext = require(ParentParent.Utility.getAppContext)
local default = require(ParentParentParent.LoggingProtocol).default
local PurchaseModalV2ShownCounter = require(ParentParent.Generic.Events.PurchaseModalCounter).PurchaseModalV2ShownCounter
local FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt = require(ParentParent.Flags.FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt)

local function ProductPurchaseModal(t1: {[any]: any}) -- line: 67
	-- upvalues: FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt (copy), useDefaultFocusBehavior (copy), React (copy), logger (copy), getAppContext (copy), default (copy), PurchaseModalV2ShownCounter (copy), useLocalization (copy), formatNumber (copy), LocalizationService (copy), useTokens (copy), useTextSizeOffset (copy), TextService (copy), InteractiveAlert (copy), ProductDetails (copy), ButtonType (copy), FoundationText (copy)
	local v28 = nil
	local v29 = nil

	if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
		v28, v29 = useDefaultFocusBehavior()
	end

	React.useEffect(function() -- line: 72
		-- upvalues: logger (copy), t1 (copy), getAppContext (copy), default (copy), PurchaseModalV2ShownCounter (copy)
		logger.debug({
			message = "Purchase Modal V2 Shown",
			screenHeight = t1.screenSize.Y,
			screenWidth = t1.screenSize.X,
			portrait = t1.screenSize.X < t1.screenSize.Y,
			appContext = getAppContext()
		})
		default:logRobloxTelemetryCounter(PurchaseModalV2ShownCounter, 1, {
			screenHeight = t1.screenSize.Y,
			screenWidth = t1.screenSize.X,
			portrait = t1.screenSize.X < t1.screenSize.Y,
			appContext = getAppContext()
		})
	end, {})

	local v30 = useLocalization({
		BuyItem = "IAPExperience.PurchasePrompt.Title.BuyItem",
		RemainingBalance = "IAPExperience.PurchasePrompt.Text.RemainingBalanceV2"
	})
	local v31 = t1.balanceAmount - t1.product.itemRobuxCost
	local v32 = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, v31)
	local v33 = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, t1.product.itemRobuxCost)
	local v34 = useTokens()
	local v35 = useTextSizeOffset()
	local v36, v37 = React.useState(0)
	local u38 = v36
	local u39 = v37
	local CaptionSmall = v34.Typography.CaptionSmall
	local u41 = v30.RemainingBalance:gsub("{robux}", v32)
	local u42 = React.useCallback(function(p1) -- line: 110
		-- upvalues: u38 (ref), u39 (ref)
		if u38 ~= p1.AbsoluteSize.X then
			u39(p1.AbsoluteSize.X)
		end
	end, { t1 })
	local u43 = React.useMemo(function() -- line: 116
		-- upvalues: CaptionSmall (copy), TextService (copy), u41 (ref), u38 (ref)
		return CaptionSmall.LineHeight * TextService:GetTextSize(u41, CaptionSmall.FontSize, CaptionSmall.Font, Vector2.new(u38, 1e999)).Y
	end, {
		u38,
		v35,
		u41
	})

	return React.createElement(InteractiveAlert, {
		bottomMargin = 12,
		defaultChildRef = if not FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then nil else v29,
		screenSize = t1.screenSize,
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		title = v30.BuyItem,
		onCloseClicked = function() -- line: 133
			-- upvalues: t1 (copy)
			if not t1.buttons.isDisabled then
				t1.buttons.cancelActivated()
			end
		end,
		onAbsoluteSizeChanged = u42,
		middleContent = function() -- line: 139
			-- upvalues: React (copy), ProductDetails (copy), t1 (copy)
			return React.createElement(ProductDetails, {
				isPortrait = false,
				layoutOrder = 1,
				itemIcon = t1.product.itemIcon,
				itemName = t1.product.itemName
			})
		end,
		buttonStackInfo = {
			forcedFillDirection = Enum.FillDirection.Vertical,
			disableGamepadRefs = not not FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt or nil,
			buttons = {{
				buttonType = ButtonType.PrimaryContextual,
				props = {
					isDisabled = t1.buttons.isDisabled,
					isDelayedInput = t1.buttons.buyItemIsDelayedInput,
					enableInputDelayed = t1.buttons.buyItemEnableInputDelayed,
					onActivated = t1.buttons.buyItemActivated,
					text = v33,
					inputIcon = t1.buttons.buyItemControllerIcon,
					buttonRef = if not FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then nil else v28
				}
			}}
		},
		footerContent = function() -- line: 167
			-- upvalues: t1 (copy), React (copy), FoundationText (copy), u41 (ref), u43 (ref), u42 (ref)
			if not t1.balanceAmountValid then
				return React.None
			end

			return React.createElement(FoundationText, {
				tag = "content-muted text-caption-small align-x-center text-wrap",
				Text = u41,
				Size = UDim2.new(1, 0, 0, u43),
				onAbsoluteSizeChanged = u42
			})
		end
	})
end
local function ProductPurchaseModalContainer(t2: {[any]: any}) -- line: 182
	-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), ProductPurchaseModal (copy)
	return React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		ProductPurchaseModal = React.createElement(ProductPurchaseModal, t2)
	})
end

return ProductPurchaseModalContainer
