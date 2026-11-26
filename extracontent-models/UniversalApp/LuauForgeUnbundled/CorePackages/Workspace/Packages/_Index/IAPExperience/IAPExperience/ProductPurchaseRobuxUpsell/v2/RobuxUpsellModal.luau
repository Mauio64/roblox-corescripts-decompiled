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
local RobuxUpsellModalUpsellDetailsWithBonus = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/v2/RobuxUpsellModalUpsellDetailsWithBonus")

local formatNumber = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatNumber")
local logger = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/logger")
local getAppContext = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/getAppContext")

local default = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").default
local SinglePackageUpsellCounter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Events/SinglePackageUpsellCounter")
local singlePackageUpsellShownCounter = SinglePackageUpsellCounter.SinglePackageUpsellShownCounter
local singlePackageUpsellModalClosedCounter = SinglePackageUpsellCounter.SinglePackageUpsellModalClosedCounter
local singlePackageUpsellModalBuyClickedCounter = SinglePackageUpsellCounter.SinglePackageUpsellModalBuyClickedCounter

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/VirtualItemBadgeType")

local useDefaultFocusBehavior = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/ReactFocusNavigation").useDefaultFocusBehavior

local FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt")

local function MiddleContent(props)
	local createElement = React.createElement

	local v7 = {
		ProductDetails = React.createElement(module5, {
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
	local v8

	if props.upsell.robuxPurchaseAmountBeforeBonus then
		v8 = React.createElement(RobuxUpsellModalUpsellDetailsWithBonus, {
			layoutOrder = 2,
			priceString = props.upsell.robuxPurchaseCost or "",
			robuxAmount = props.upsell.robuxPurchaseAmountBeforeBonus,
			bonusAmount = props.upsell.robuxPurchaseAmount - props.upsell.robuxPurchaseAmountBeforeBonus
		})
	else
		v8 = React.createElement(
			view,
			{
				LayoutOrder = 2,
				tag = "row flex-between size-full-1400 align-y-center bg-surface-300 radius-medium padding-large stroke-system-contrast stroke-thick"
			},
			{
				RobuxAmountContainer = React.createElement(view, {
					tag = "auto-xy row gap-small"
				}, {
					RobuxAmount = React.createElement(text, {
						LayoutOrder = 1,
						Text = utf8.char(57346) .. " " .. formatNumber(
							LocalizationService.RobloxLocaleId,
							props.upsell.robuxPurchaseAmount
						),
						tag = "auto-xy text-title-large content-emphasis text-align-x-left"
					})
				}),
				RobuxPrice = React.createElement(text, {
					LayoutOrder = 2,
					Text = props.upsell.robuxPurchaseCost or "",
					tag = "auto-xy text-title-large content-emphasis text-align-x-right"
				})
			}
		)
	end

	v7.UpsellPackageDetails = v8
	return createElement(
		view,
		{ tag = "col gap-xxlarge auto-y size-full-0 align-x-center align-y-center" },
		v7
	)
end

local function ButtonStackInfo(p2)
	local v5 = useLocalization({
		BuyRobuxButton = p2.buttons.opensBuyRobuxPage and "IAPExperience.RobuxUpsell.Action.BuyRobux" or "IAPExperience.RobuxUpsell.Action.BuyRobuxAndItem",
		ButtonCancel = "IAPExperience.RobuxUpsell.Action.Cancel",
		LoadingText = "IAPExperience.RobuxUpsell.Text.Loading"
	})

	local v6 = {
		forcedFillDirection = Enum.FillDirection.Vertical,
		disableGamepadRefs = FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt and true or nil,
		buttons = 0
	}
	local v7

	if p2.isQuest then
		v7 = {
			{
				props = {
					onActivated = p2.buttons.cancelPurchaseActivated,
					text = v5.ButtonCancel,
					inputIcon = p2.buttons.cancelControllerIcon
				}
			}
		}
	else
		v7 = { nil }
		local v8 = { buttonType = buttonType.PrimaryContextual, props = 0 }
		local v9 = {
			isDisabled = p2.buttons.buyItemDisabled,
			isDelayedInput = p2.buttons.buyItemisDelayedInput,
			enableInputDelayed = p2.buttons.buyItemEnableInputDelayed,
			onActivated = p2.buttons.buyItemActivated,
			text = v5.BuyRobuxButton,
			inputIcon = p2.buttons.buyItemControllerIcon,
			buttonRef = 0
		}

		local v10 = if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then p2.buttons.buttonRef else nil
		v9.buttonRef = v10
		v8.props = v9
		v7[1] = v8
	end

	v6.buttons = v7
	return v6
end

local function RobuxUpsellModal(props)
	local v5, v6

	if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
		v5, v6 = useDefaultFocusBehavior()
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

		default:logRobloxTelemetryCounter(singlePackageUpsellShownCounter, 1, {
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y,
			appContext = getAppContext(),
			buyRobuxVariant = props.buttons.opensBuyRobuxPage == nil and 0 or props.buttons.opensBuyRobuxPage and 1 or 2
		})
	end, {})

	local function fn()
		logger.debug({ message = "Single Package Upsell Modal Closed" })

		default:logRobloxTelemetryCounter(singlePackageUpsellModalClosedCounter, 1, {
			appContext = getAppContext()
		})
		props.buttons.cancelPurchaseActivated()
	end

	local buyItemActivated = props.buttons.buyItemActivated
	local function fn2()
		logger.debug({ message = "Single Package Upsell Modal Buy Clicked" })

		default:logRobloxTelemetryCounter(singlePackageUpsellModalBuyClickedCounter, 1, {
			appContext = getAppContext()
		})
		buyItemActivated()
	end
	props.buttons.buyItemActivated = fn2

	if FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
		props.buttons.buttonRef = v5
	end

	local createElement = React.createElement

	if not FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt then
		v6 = nil
	end

	return createElement(interactiveAlert, {
		defaultChildRef = v6,
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
		buttonStackInfo = ButtonStackInfo({
			buttons = props.buttons,
			isQuest = props.isQuest
		}),
		footerContent = function()
			return React.createElement(RobuxUpsellModalFooter)
		end
	})
end

local function RobuxUpsellModalContainer(p2)
	return React.createElement(
		localizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			RobuxUpsellModal = React.createElement(RobuxUpsellModal, p2)
		}
	)
end

return RobuxUpsellModalContainer
