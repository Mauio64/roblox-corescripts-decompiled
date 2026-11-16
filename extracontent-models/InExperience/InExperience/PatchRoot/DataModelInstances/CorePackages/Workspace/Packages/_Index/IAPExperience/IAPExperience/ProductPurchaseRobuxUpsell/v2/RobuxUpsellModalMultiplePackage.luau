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
local YellowBadge = require(parent.Generic.YellowBadge)
local RobuxUpsellModalTitle = require(script.Parent.RobuxUpsellModalTitle)
local RobuxUpsellModalFooter = require(script.Parent.RobuxUpsellModalFooter)

local formatNumber = require(parent.Utility.formatNumber)
local logger = require(parent.Utility.logger)
local getAppContext = require(parent.Utility.getAppContext)

local LoggingProtocol = require(parent2.LoggingProtocol)
local default = LoggingProtocol.default
local MultiplePackageUpsellCounter = require(parent.Generic.Events.MultiplePackageUpsellCounter)
local MultiplePackageUpsellShownCounter = MultiplePackageUpsellCounter.MultiplePackageUpsellShownCounter
local MultiplePackageUpsellSelectedCounter = MultiplePackageUpsellCounter.MultiplePackageUpsellSelectedCounter
local MultiplePackageUpsellModalClosedCounter = MultiplePackageUpsellCounter.MultiplePackageUpsellModalClosedCounter
local MultiplePackageUpsellModalBuyClickedCounter = MultiplePackageUpsellCounter.MultiplePackageUpsellModalBuyClickedCounter

require(parent.Api.PaymentsGateway.GetUpsellSuggestionsTypes)
local BadgeType = require(parent.Enums.BadgeType)
require(parent.Enums.VirtualItemBadgeType)

local ReactFocusNavigation = require(parent2.ReactFocusNavigation)
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior

local FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt = require(parent.Flags.FFlagAddDefaultFocusNavSelectorsOnBuyPurchasePrompt)

local function UpsellProductDetails(props)
	local v = useLocalization({
		Popular = "IAPExperience.RobuxUpsell.Text.PopularItem",
		LastPurchased = "IAPExperience.RobuxUpsell.Text.LastPurchased"
	})
	local text

	if props.badgeType == BadgeType.Popular then
		text = v.Popular
	elseif props.badgeType == BadgeType.LastPurchased then
		text = v.LastPurchased
	end

	local icon = props.badgeType == BadgeType.Popular and "icons/menu/fire_fill" or nil

	local v2 = "size-full-1400 radius-medium padding-x-large row"
	local tag

	if props.selected then
		tag = v2 .. " bg-surface-200 stroke-system-contrast stroke-thick"
	else
		tag = v2 .. " bg-surface-300 stroke-emphasis stroke-standard"
	end

	local createElement = React.createElement
	local v3 = { LayoutOrder = props.layoutOrder, onActivated = props.onSelected, tag = tag }

	local v4 = {
		LeftSide = React.createElement(
			View,
			{
				LayoutOrder = 1,
				tag = "row gap-small align-y-center align-x-start",
				Size = UDim2.new(0.5, 0, 1, 0)
			},
			{
				RobuxAmount = React.createElement(Text, {
					LayoutOrder = 1,
					Text = utf8.char(57346) .. " " .. formatNumber(
						LocalizationService.RobloxLocaleId,
						props.product.robuxAmount
					),
					tag = "auto-xy text-title-large content-emphasis text-align-x-left"
				}),
				RobuxAmountBonus = props.product.robuxAmountBeforeBonus and React.createElement(Text, {
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
	local v5 = {
		LayoutOrder = 2,
		tag = "row align-y-center align-x-right gap-large",
		Size = UDim2.new(0.5, 0, 1, 0)
	}
	local badge

	if text then
		badge = React.createElement(YellowBadge, { LayoutOrder = 1, Text = text, Icon = icon })
	end

	v4.RightSide = createElement2(View, v5, {
		Badge = badge,
		RobuxPrice = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.product.price or "",
			tag = "auto-xy text-title-large content-emphasis text-align-x-right"
		})
	})
	return createElement(View, v3, v4)
end

local function MiddleContent(props)
	local createElement = React.createElement

	local v = {
		ProductDetails = React.createElement(ProductDetails, {
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

	local v2 = {
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
	local upsellPackage

	if #props.upsellSuggestions > 1 then
		upsellPackage = React.createElement(UpsellProductDetails, {
			layoutOrder = 2,
			product = props.upsellSuggestions[2],
			selected = props.selectedUpsellIndex == 2,
			onSelected = function()
				props.onUpsellSuggestionsSelected(2)
			end,
			badgeType = props.upsellSuggestions[2].badgeType
		})
	end

	v2.UpsellPackage2 = upsellPackage
	v.UpsellSuggestions = createElement2(
		View,
		{ LayoutOrder = 2, tag = "col gap-medium auto-y size-full-0 align-x-center align-y-center" },
		v2
	)
	return createElement(View, {
		tag = "col gap-xxlarge auto-y size-full-0 align-x-center align-y-center"
	}, v)
end

local function ButtonStackInfo(p)
	local v = useLocalization({
		BuyRobuxButton = "IAPExperience.RobuxUpsell.Action.BuyRobuxAndItem",
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
			message = "Multiple Package Upsell Modal Shown",
			suggestionCount = #props.upsellSuggestions,
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y
		})

		default:logRobloxTelemetryCounter(MultiplePackageUpsellShownCounter, 1, {
			suggestionCount = #props.upsellSuggestions,
			screenHeight = props.screenSize.Y,
			screenWidth = props.screenSize.X,
			portrait = props.screenSize.X < props.screenSize.Y
		})
	end, { props.upsellSuggestions })

	local function onUpsellSuggestionsSelected(selectedIndex: number)
		logger.debug({
			message = "Multiple Package Upsell Option Selected",
			suggestionCount = #props.upsellSuggestions,
			previousIndex = props.selectedUpsellIndex,
			selectedIndex = selectedIndex
		})

		default:logRobloxTelemetryCounter(MultiplePackageUpsellSelectedCounter, 1, {
			suggestionCount = #props.upsellSuggestions,
			previousIndex = props.selectedUpsellIndex,
			selectedIndex = selectedIndex
		})

		props.onUpsellSuggestionsSelected(selectedIndex)
	end

	local function fn()
		logger.debug({
			message = "Multiple Package Upsell Modal Closed",
			suggestionCount = #props.upsellSuggestions
		})

		default:logRobloxTelemetryCounter(MultiplePackageUpsellModalClosedCounter, 1, {
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

		default:logRobloxTelemetryCounter(MultiplePackageUpsellModalBuyClickedCounter, 1, {
			appContext = getAppContext(),
			suggestionCount = #props.upsellSuggestions,
			selectedIndex = props.selectedUpsellIndex
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
