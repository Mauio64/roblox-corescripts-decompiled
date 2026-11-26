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
local YellowBadge = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/YellowBadge")
local RobuxUpsellModalTitle = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/v2/RobuxUpsellModalTitle")
local RobuxUpsellModalFooter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchaseRobuxUpsell/v2/RobuxUpsellModalFooter")

local formatNumber = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatNumber")
local logger = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/logger")
local getAppContext = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/getAppContext")

local default = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/LoggingProtocol").default
local MultiplePackageUpsellCounter = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Events/MultiplePackageUpsellCounter")
local multiplePackageUpsellShownCounter = MultiplePackageUpsellCounter.MultiplePackageUpsellShownCounter
local multiplePackageUpsellSelectedCounter = MultiplePackageUpsellCounter.MultiplePackageUpsellSelectedCounter
local multiplePackageUpsellModalClosedCounter = MultiplePackageUpsellCounter.MultiplePackageUpsellModalClosedCounter
local multiplePackageUpsellModalBuyClickedCounter = MultiplePackageUpsellCounter.MultiplePackageUpsellModalBuyClickedCounter

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Api/PaymentsGateway/GetUpsellSuggestionsTypes")
local BadgeType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/BadgeType")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/VirtualItemBadgeType")

local useDefaultFocusBehavior = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/ReactFocusNavigation").useDefaultFocusBehavior

local FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt")

local function UpsellProductDetails(props)
	local v5 = useLocalization({
		Popular = "IAPExperience.RobuxUpsell.Text.PopularItem",
		LastPurchased = "IAPExperience.RobuxUpsell.Text.LastPurchased"
	})
	local v6

	if props.badgeType == BadgeType.Popular then
		v6 = v5.Popular
	elseif props.badgeType == BadgeType.LastPurchased then
		v6 = v5.LastPurchased
	end

	local v7 = props.badgeType == BadgeType.Popular and "icons/menu/fire_fill" or nil

	local v8 = "size-full-1400 radius-medium padding-x-large row"
	local v9

	if props.selected then
		v9 = v8 .. " bg-surface-200 stroke-system-contrast stroke-thick"
	else
		v9 = v8 .. " bg-surface-300 stroke-emphasis stroke-standard"
	end

	local createElement = React.createElement
	local v11 = {
		LayoutOrder = props.layoutOrder,
		onActivated = props.onSelected,
		tag = v9
	}

	local v12 = {
		LeftSide = React.createElement(
			view,
			{
				LayoutOrder = 1,
				tag = "row gap-small align-y-center align-x-start",
				Size = UDim2.new(0.5, 0, 1, 0)
			},
			{
				RobuxAmount = React.createElement(text, {
					LayoutOrder = 1,
					Text = utf8.char(57346) .. " " .. formatNumber(
						LocalizationService.RobloxLocaleId,
						props.product.robuxAmount
					),
					tag = "auto-xy text-title-large content-emphasis text-align-x-left"
				}),
				RobuxAmountBonus = props.product.robuxAmountBeforeBonus and React.createElement(text, {
					LayoutOrder = 2,
					RichText = true,
					Text = "<s>" .. utf8.char(57346) .. formatNumber(
						LocalizationService.RobloxLocaleId,
						props.product.robuxAmountBeforeBonus
					) .. "</s>",
					tag = "auto-xy text-title-large content-muted text-align-x-left"
				})
			}
		),
		RightSide = 0
	}

	local createElement2 = React.createElement
	local v14 = {
		LayoutOrder = 2,
		tag = "row align-y-center align-x-right gap-large",
		Size = UDim2.new(0.5, 0, 1, 0)
	}

	local v16 = if v6 then React.createElement(YellowBadge, {
		LayoutOrder = 1,
		Text = v6,
		Icon = v7
	}) else nil
	v12.RightSide = createElement2(view, v14, {
		Badge = v16,
		RobuxPrice = React.createElement(text, {
			LayoutOrder = 2,
			Text = props.product.price or "",
			tag = "auto-xy text-title-large content-emphasis text-align-x-right"
		})
	})
	return createElement(view, v11, v12)
end

local function MiddleContent(props)
	local createElement = React.createElement

	local v7 = {
		ProductDetails = React.createElement(module5, {
			layoutOrder = 1,
			isPortrait = props.isPortrait and #props.upsellSuggestions == 1,
			model = props.product.model,
			itemIcon = props.product.itemIcon,
			itemName = props.product.itemName,
			itemRobuxCost = props.product.itemRobuxCost,
			badgeType = props.product.badgeType
		}),
		UpsellSuggestions = 0
	}

	local createElement2 = React.createElement

	local v10 = {
		UpsellPackage1 = React.createElement(UpsellProductDetails, {
			layoutOrder = 1,
			product = props.upsellSuggestions[1],
			selected = props.selectedUpsellIndex == 1,
			onSelected = function()
				props.onUpsellSuggestionsSelected(1)
			end
		}),
		UpsellPackage2 = 0
	}
	local v11

	if #props.upsellSuggestions > 1 then
		v11 = React.createElement(UpsellProductDetails, {
			layoutOrder = 2,
			product = props.upsellSuggestions[2],
			selected = props.selectedUpsellIndex == 2,
			onSelected = function()
				props.onUpsellSuggestionsSelected(2)
			end,
			badgeType = props.upsellSuggestions[2].badgeType
		})
	end

	v10.UpsellPackage2 = v11
	v7.UpsellSuggestions = createElement2(
		view,
		{
			LayoutOrder = 2,
			tag = "col gap-medium auto-y size-full-0 align-x-center align-y-center"
		},
		v10
	)
	return createElement(
		view,
		{ tag = "col gap-xxlarge auto-y size-full-0 align-x-center align-y-center" },
		v7
	)
end

local function ButtonStackInfo(p2)
	local v5 = useLocalization({
		BuyRobuxButton = "IAPExperience.RobuxUpsell.Action.BuyRobuxAndItem",
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
			message = "Multiple Package Upsell Modal Shown",
			suggestionCount = #props.upsellSuggestions,
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y
		})

		default:logRobloxTelemetryCounter(multiplePackageUpsellShownCounter, 1, {
			suggestionCount = #props.upsellSuggestions,
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y
		})
	end, { props.upsellSuggestions })

	local function onUpsellSuggestionsSelected(p2)
		logger.debug({
			message = "Multiple Package Upsell Option Selected",
			suggestionCount = #props.upsellSuggestions,
			previousIndex = props.selectedUpsellIndex,
			selectedIndex = p2
		})

		default:logRobloxTelemetryCounter(multiplePackageUpsellSelectedCounter, 1, {
			suggestionCount = #props.upsellSuggestions,
			previousIndex = props.selectedUpsellIndex,
			selectedIndex = p2
		})

		props.onUpsellSuggestionsSelected(p2)
	end

	local function fn()
		logger.debug({
			message = "Multiple Package Upsell Modal Closed",
			suggestionCount = #props.upsellSuggestions
		})

		default:logRobloxTelemetryCounter(multiplePackageUpsellModalClosedCounter, 1, {
			suggestionCount = #props.upsellSuggestions
		})

		props.buttons.cancelPurchaseActivated()
	end

	local buyItemActivated = props.buttons.buyItemActivated
	local function fn2()
		logger.debug({
			message = "Multiple Package Upsell Modal Buy Clicked",
			appContext = getAppContext(),
			suggestionCount = #props.upsellSuggestions,
			selectedIndex = props.selectedUpsellIndex
		})

		default:logRobloxTelemetryCounter(multiplePackageUpsellModalBuyClickedCounter, 1, {
			appContext = getAppContext(),
			suggestionCount = #props.upsellSuggestions,
			selectedIndex = props.selectedUpsellIndex
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
				balanceAmount = props.userBalance,
				cancelPurchaseActivated = fn
			})
		end,
		middleContent = function()
			return React.createElement(MiddleContent, {
				product = props.product,
				upsellSuggestions = props.upsellSuggestions,
				selectedUpsellIndex = props.selectedUpsellIndex,
				onUpsellSuggestionsSelected = onUpsellSuggestionsSelected,
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
