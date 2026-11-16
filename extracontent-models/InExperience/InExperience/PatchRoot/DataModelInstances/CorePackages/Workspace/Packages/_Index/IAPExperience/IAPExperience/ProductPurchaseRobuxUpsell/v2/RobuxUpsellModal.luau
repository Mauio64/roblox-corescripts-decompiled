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
local RobuxUpsellModalUpsellDetailsWithBonus = require(script.Parent.RobuxUpsellModalUpsellDetailsWithBonus)

local formatNumber = require(parent.Utility.formatNumber)
local logger = require(parent.Utility.logger)
local getAppContext = require(parent.Utility.getAppContext)

local LoggingProtocol = require(parent2.LoggingProtocol)
local default = LoggingProtocol.default
local SinglePackageUpsellCounter = require(parent.Generic.Events.SinglePackageUpsellCounter)
local SinglePackageUpsellShownCounter = SinglePackageUpsellCounter.SinglePackageUpsellShownCounter
local SinglePackageUpsellModalClosedCounter = SinglePackageUpsellCounter.SinglePackageUpsellModalClosedCounter
local SinglePackageUpsellModalBuyClickedCounter = SinglePackageUpsellCounter.SinglePackageUpsellModalBuyClickedCounter

require(parent.Enums.VirtualItemBadgeType)

local ReactFocusNavigation = require(parent2.ReactFocusNavigation)
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior

local FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt = require(parent.Flags.FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt)

local function MiddleContent(props)
	local createElement = React.createElement

	local v = {
		ProductDetails = React.createElement(ProductDetails, {
			layoutOrder = 1,
			isPortrait = props.isPortrait,
			model = props.product.model,
			itemIcon = props.product.itemIcon,
			itemName = props.product.itemName,
			itemRobuxCost = props.product.itemRobuxCost,
			badgeType = props.product.badgeType
		}),
		UpsellPackageDetails = 0
	}
	local upsellPackageDetails

	if props.upsell.robuxPurchaseAmountBeforeBonus then
		upsellPackageDetails = React.createElement(RobuxUpsellModalUpsellDetailsWithBonus, {
			layoutOrder = 2,
			priceString = props.upsell.robuxPurchaseCost or "",
			robuxAmount = props.upsell.robuxPurchaseAmountBeforeBonus,
			bonusAmount = props.upsell.robuxPurchaseAmount - props.upsell.robuxPurchaseAmountBeforeBonus
		})
	else
		upsellPackageDetails = React.createElement(
			View,
			{
				LayoutOrder = 2,
				tag = "row flex-between size-full-1400 align-y-center bg-surface-300 radius-medium padding-large stroke-system-contrast stroke-thick"
			},
			{
				RobuxAmountContainer = React.createElement(View, { tag = "auto-xy row gap-small" }, {
					RobuxAmount = React.createElement(Text, {
						LayoutOrder = 1,
						Text = utf8.char(57346) .. " " .. formatNumber(
							LocalizationService.RobloxLocaleId,
							props.upsell.robuxPurchaseAmount
						),
						tag = "auto-xy text-title-large content-emphasis text-align-x-left"
					})
				}),
				RobuxPrice = React.createElement(Text, {
					LayoutOrder = 2,
					Text = props.upsell.robuxPurchaseCost or "",
					tag = "auto-xy text-title-large content-emphasis text-align-x-right"
				})
			}
		)
	end

	v.UpsellPackageDetails = upsellPackageDetails
	return createElement(View, {
		tag = "col gap-xxlarge auto-y size-full-0 align-x-center align-y-center"
	}, v)
end

local function ButtonStackInfo(p)
	local v = useLocalization({
		BuyRobuxButton = p.buttons.opensBuyRobuxPage and "IAPExperience.RobuxUpsell.Action.BuyRobux" or "IAPExperience.RobuxUpsell.Action.BuyRobuxAndItem",
		ButtonCancel = "IAPExperience.RobuxUpsell.Action.Cancel",
		LoadingText = "IAPExperience.RobuxUpsell.Text.Loading"
	})

	local v2 = {
		forcedFillDirection = Enum.FillDirection.Vertical,
		disableGamepadRefs = FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt and true or nil,
		buttons = 0
	}
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
		buttons = { nil }
		local v3 = { buttonType = ButtonType.PrimaryContextual, props = 0 }
		local props = {
			isDisabled = p.buttons.buyItemDisabled,
			isDelayedInput = p.buttons.buyItemisDelayedInput,
			enableInputDelayed = p.buttons.buyItemEnableInputDelayed,
			onActivated = p.buttons.buyItemActivated,
			text = v.BuyRobuxButton,
			inputIcon = p.buttons.buyItemControllerIcon,
			buttonRef = 0
		}
		local buttonRef

		if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
			buttonRef = p.buttons.buttonRef
		end

		props.buttonRef = buttonRef
		v3.props = props
		buttons[1] = v3
	end

	v2.buttons = buttons
	return v2
end

local function RobuxUpsellModal(props)
	local buttonRef, defaultChildRef

	if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
		buttonRef, defaultChildRef = useDefaultFocusBehavior()
	end

	React.useEffect(function()
		logger.debug({
			message = "Single Package Upsell Modal Shown",
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y,
			appContext = getAppContext(),
			buyRobuxVariant = props.buttons.opensBuyRobuxPage == nil and 0 or props.buttons.opensBuyRobuxPage and 1 or 2
		})

		default:logRobloxTelemetryCounter(SinglePackageUpsellShownCounter, 1, {
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y,
			appContext = getAppContext(),
			buyRobuxVariant = props.buttons.opensBuyRobuxPage == nil and 0 or props.buttons.opensBuyRobuxPage and 1 or 2
		})
	end, {})

	local function fn()
		logger.debug({ message = "Single Package Upsell Modal Closed" })

		default:logRobloxTelemetryCounter(SinglePackageUpsellModalClosedCounter, 1, {
			appContext = getAppContext()
		})
		props.buttons.cancelPurchaseActivated()
	end

	local buyItemActivated = props.buttons.buyItemActivated
	local function fn2()
		logger.debug({ message = "Single Package Upsell Modal Buy Clicked" })

		default:logRobloxTelemetryCounter(SinglePackageUpsellModalBuyClickedCounter, 1, {
			appContext = getAppContext()
		})
		buyItemActivated()
	end
	props.buttons.buyItemActivated = fn2

	if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
		props.buttons.buttonRef = buttonRef
	end

	local createElement = React.createElement

	if not FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
		defaultChildRef = nil
	end

	return createElement(InteractiveAlert, {
		defaultChildRef = defaultChildRef,
		screenSize = props.screenSize,
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		title = "",
		titleContent = function()
			return React.createElement(RobuxUpsellModalTitle, {
				balanceAmount = props.upsell.balanceAmount,
				cancelPurchaseActivated = fn
			})
		end,
		middleContent = function()
			return React.createElement(MiddleContent, {
				product = props.product,
				upsell = props.upsell,
				isPortrait = props.screenSize.X < props.screenSize.Y
			})
		end,
		buttonStackInfo = ButtonStackInfo({ buttons = props.buttons, isQuest = props.isQuest }),
		footerContent = function()
			return React.createElement(RobuxUpsellModalFooter)
		end
	})
end

local function RobuxUpsellModalContainer(p)
	return React.createElement(
		LocalizationProvider,
		{
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			RobuxUpsellModal = React.createElement(RobuxUpsellModal, p)
		}
	)
end

return RobuxUpsellModalContainer
