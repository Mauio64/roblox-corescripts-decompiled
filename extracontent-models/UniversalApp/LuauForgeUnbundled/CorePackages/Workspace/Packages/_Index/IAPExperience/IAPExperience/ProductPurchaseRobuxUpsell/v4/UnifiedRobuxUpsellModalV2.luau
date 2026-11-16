local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local view = Foundation.View
local text = Foundation.Text
local checkbox = Foundation.Checkbox
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonGroup = Foundation.ButtonGroup
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize
local orientation = Foundation.Enums.Orientation
local enums = Foundation.Enums
local getIconRichText = Foundation.Utility.getIconRichText

local LocalizationService = game:GetService("LocalizationService")
local localization = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/AppLocales").Localization
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Localization")
local localizationProvider = Localization.LocalizationProvider
local useLocalization = Localization.Hooks.useLocalization

local UnifiedProductDetails = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/UnifiedProductDetails")
local YellowBadge = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/YellowBadge")
local GrayBadge = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/GrayBadge")
local PriceSummary = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/PriceSummary")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/ProductDetailsContainer")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/CartPricingLoading")
local buildCartPricingOfferCheckboxes = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/buildCartPricingOfferCheckboxes")
local useCartPricing = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/useCartPricing")

local useFocusNavigationRefs = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/Hooks/useFocusNavigationRefs")

local UnifiedPurchaseModalTypeEnum = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/UnifiedPurchaseModalTypeEnum")

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v4/cartPricingResponseLineItem")

local formatNumber = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/formatNumber")
local getUpsellBadgeInfo = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/getUpsellBadgeInfo")

local fFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird

local FFlagEnableRobuxUpsellPlusButtonExperiment = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagEnableRobuxUpsellPlusButtonExperiment")

local fFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local defineFastInt = game:DefineFastInt("CompactUpsellModalBreakpoint", 400)

local fFlagEnableUnifiedPurchaseFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagShouldFixDevSubsFlashingTitle = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagShouldFixDevSubsFlashingTitle")

local GetFFlagIAPExperienceEnableMultiDisplayUpsell = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/GetFFlagIAPExperienceEnableMultiDisplayUpsell")

local GetFFlagIAPExperienceUseUpsellBadgeHelper = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/GetFFlagIAPExperienceUseUpsellBadgeHelper")

require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Api/PaymentsGateway/GetUpsellSuggestionsTypes")
local BadgeType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/BadgeType")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Enums/VirtualItemBadgeType")
require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/v3/UnifiedProductPurchaseModalTypes")

local function UpsellProductDetailsLegacyImpl(props, p2)
	local v5

	if props.badgeType == BadgeType.Popular then
		v5 = p2.Popular
	elseif props.badgeType == BadgeType.LastPurchased then
		v5 = p2.LastPurchased
	end

	local v6 = props.badgeType == BadgeType.Popular and "icons/menu/fire_fill" or nil

	local v7 = "size-full-1400 radius-medium padding-x-large row"
	local v8

	if props.selected then
		v8 = v7 .. " bg-surface-200 stroke-system-contrast stroke-thick"
	else
		v8 = v7 .. " bg-surface-300 stroke-emphasis stroke-standard"
	end

	local v9 = props.isCompact and "auto-xy text-title-small content-emphasis text-align-x-left"
		or "auto-xy text-title-large content-emphasis text-align-x-left"

	local v10 = props.isCompact and "auto-xy text-title-small content-muted text-align-x-left"
		or "auto-xy text-title-large content-muted text-align-x-left"

	local v11 = props.isCompact and "auto-xy text-title-small content-emphasis text-align-x-right"
		or "auto-xy text-title-large content-emphasis text-align-x-right"

	local createElement = React.createElement
	local v13 = {
		LayoutOrder = props.layoutOrder,
		onActivated = props.onSelected,
		tag = v8,
		Size = 0
	}

	local v14 = if props.isCompact then UDim2.new(1, 0, 0, 40) else nil
	v13.Size = v14
	local v15 = {
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
					tag = v9
				}),
				RobuxAmountBonus = props.product.robuxAmountBeforeBonus and React.createElement(text, {
					LayoutOrder = 2,
					RichText = true,
					Text = "<s>" .. utf8.char(57346) .. formatNumber(
						LocalizationService.RobloxLocaleId,
						props.product.robuxAmountBeforeBonus
					) .. "</s>",
					tag = v10
				})
			}
		),
		RightSide = 0
	}

	local createElement2 = React.createElement
	local v17 = {
		LayoutOrder = 2,
		tag = "row align-y-center align-x-right gap-large",
		Size = UDim2.new(0.5, 0, 1, 0)
	}

	local v19 = if v5 then React.createElement(YellowBadge, {
		LayoutOrder = 1,
		Text = v5,
		Icon = v6
	}) else nil
	v15.RightSide = createElement2(view, v17, {
		Badge = v19,
		RobuxPrice = React.createElement(text, {
			LayoutOrder = 2,
			Text = props.product.price or "",
			tag = v11
		})
	})
	return createElement(view, v13, v15)
end

local function UpsellProductDetailsMultiDisplayImpl(props, props2)
	local v5, v6

	if GetFFlagIAPExperienceUseUpsellBadgeHelper() then
		local v7 = getUpsellBadgeInfo(props.badgeType, props2)
		v5 = v7.text
		v6 = v7.icon
	else
		if props.badgeType == BadgeType.Popular then
			v5 = props2.Popular
		elseif props.badgeType == BadgeType.LastPurchased then
			v5 = props2.LastPurchased
		elseif props.badgeType == BadgeType.ForYou then
			v5 = props2.ForYouItem
		elseif props.badgeType == BadgeType.BetterValue then
			v5 = props2.BetterValue
		end

		if props.badgeType == BadgeType.Popular then
			v6 = enums.IconName.Flame
		elseif props.badgeType == BadgeType.ForYou then
			v6 = enums.IconName.CircleStar
		elseif props.badgeType == BadgeType.BetterValue then
			v6 = enums.IconName.Tag
		end
	end

	local v7 = "size-full-1400 radius-medium padding-x-large row"
	local v8

	if props.selected then
		v8 = v7 .. " bg-surface-200 stroke-system-contrast stroke-thick"
	else
		v8 = v7 .. " bg-surface-300 stroke-emphasis stroke-standard"
	end

	local v9 = props.isCompact and "auto-xy text-title-small content-emphasis text-align-x-left"
		or "auto-xy text-title-large content-emphasis text-align-x-left"

	local v10 = props.isCompact and "auto-xy text-title-small content-muted text-align-x-left"
		or "auto-xy text-title-large content-muted text-align-x-left"

	local v11 = props.isCompact and "auto-xy text-title-small content-emphasis text-align-x-right"
		or "auto-xy text-title-large content-emphasis text-align-x-right"

	local createElement = React.createElement
	local v13 = {
		LayoutOrder = props.layoutOrder,
		onActivated = props.onSelected,
		tag = v8,
		Size = 0
	}

	local v14 = if props.isCompact then UDim2.new(1, 0, 0, 40) else nil
	v13.Size = v14

	local createElement2 = React.createElement
	local v16 = {
		LayoutOrder = 1,
		tag = "row gap-small align-y-center align-x-start",
		Size = UDim2.new(0.5, 0, 1, 0)
	}
	local v17 = {
		RobuxAmount = React.createElement(text, {
			LayoutOrder = 1,
			RichText = true,
			Text = getIconRichText(enums.IconName.Robux) .. " " .. formatNumber(
				LocalizationService.RobloxLocaleId,
				props.product.robuxAmount
			),
			tag = v9
		}),
		RobuxAmountBonus = props.product.robuxAmountBeforeBonus and React.createElement(text, {
			LayoutOrder = 2,
			RichText = true,
			Text = "<s>" .. getIconRichText(enums.IconName.Robux) .. formatNumber(
				LocalizationService.RobloxLocaleId,
				props.product.robuxAmountBeforeBonus
			) .. "</s>",
			tag = v10
		}),
		Badge = 0
	}

	local v18 = if v5 then React.createElement(GrayBadge, {
		LayoutOrder = 3,
		Text = v5,
		iconName = v6
	}) else nil
	v17.Badge = v18
	return createElement(view, v13, {
		LeftSide = createElement2(view, v16, v17),
		RightSide = React.createElement(
			view,
			{
				LayoutOrder = 2,
				tag = "row align-y-center align-x-right gap-large",
				Size = UDim2.new(0.5, 0, 1, 0)
			},
			{
				RobuxPrice = React.createElement(text, {
					LayoutOrder = 2,
					Text = props.product.price or "",
					tag = v11
				})
			}
		)
	})
end

local function UpsellProductDetails(p2)
	local v5 = useLocalization({
		Popular = "IAPExperience.RobuxUpsell.Text.PopularItem",
		LastPurchased = "IAPExperience.RobuxUpsell.Text.LastPurchased",
		ForYouItem = "IAPExperience.RobuxUpsell.Text.ForYou",
		BetterValue = "IAPExperience.RobuxUpsell.Text.BetterValue",
		BestValue = "IAPExperience.RobuxUpsell.Text.BestValue"
	})

	if GetFFlagIAPExperienceEnableMultiDisplayUpsell() then
		return UpsellProductDetailsMultiDisplayImpl(p2, v5)
	end

	return UpsellProductDetailsLegacyImpl(p2, v5)
end

local function UnifiedRobuxUpsellModalV2(props)
	local robloxPlusDiscountPercentage

	if FFlagEnableRobuxUpsellPlusButtonExperiment and type(props.robloxPlusDiscountPercentage) == "number" then
		robloxPlusDiscountPercentage = props.robloxPlusDiscountPercentage
	end

	local onRobloxPlusButtonActivated = if robloxPlusDiscountPercentage ~= nil then props.onRobloxPlusButtonActivated else nil

	local v5 = useCartPricing({
		product = props.product,
		purchaseModalType = props.purchaseModalType,
		cartPricingResponse = props.cartPricingResponse,
		onCartOfferAppliedChanged = props.onCartOfferAppliedChanged
	})

	local state, setState = React.useState(props.postPurchaseActions or {})

	local v6 = React.useCallback(function()
		if state and props.setPostPurchaseActions then
			props.setPostPurchaseActions(state)
		end

		props.buttons.buyItemActivated()
	end, { props.buttons.buyItemActivated, props.setPostPurchaseActions, state })

	local v7 = React.useMemo(function()
		if v5.showCartOfferUi then
			return v5.mergedProductForDetails
		end

		return props.product
	end, { props.product, v5.showCartOfferUi, v5.mergedProductForDetails })

	local v8 = useLocalization({
		Buy = "IAPExperience.PurchasePrompt.Action.Buy",
		GetTenPercentOff = robloxPlusDiscountPercentage ~= nil and {
			"IAPExperience.RobuxUpsell.Action.GetPercentOff",
			discountPercentage = robloxPlusDiscountPercentage
		} or nil,
		Subscribe = fFlagEnableUnifiedPurchaseFlowForDevSubs and "Feature.Subscription.Action.Subscribe" or nil,
		DisclosurePayment = "IAPExperience.RobuxUpsell.Text.DisclosurePayment",
		DisclosureTermsURL = "IAPExperience.RobuxUpsell.Text.DisclosureTermsURL",
		TermsOfUse = "IAPExperience.RobuxUpsell.Text.TermsOfUse",
		BuyRobuxAndExperience = "IAPExperience.PurchasePrompt.BuyRobuxAndExperience",
		BuyRobuxAndItem = "IAPExperience.PurchasePrompt.Title.BuyRobuxAndItem",
		BuyRobuxAndItems = "IAPExperience.PurchasePrompt.Title.BuyRobuxAndItems",
		BuyRobuxOnly = fFlagAXMISWithBlackbird and "IAPExperience.PurchasePrompt.Title.BuyRobuxOnly" or nil,
		BuyRobuxAndAvatar = fFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "IAPExperience.PurchasePrompt.Header.BuyRobuxAndAvatar" or nil,
		BuyRobuxAndSubscription = fFlagEnableUnifiedPurchaseFlowForDevSubs and "IAPExperience.PurchasePrompt.BuyRobuxAndSubscription" or nil,
		PerMonth = fFlagEnableUnifiedPurchaseFlowForDevSubs and "Feature.Subscription.Text.PerMonth" or nil
	})
	local v9

	if
		fFlagEnableUnifiedPurchaseFlowForDevSubs
		and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	then
		v9 = props.screenSize.Y > 0 and props.screenSize.Y < defineFastInt
	else
		v9 = props.screenSize.Y < defineFastInt
	end

	local state2, setState2 = React.useState(v8.BuyRobuxAndItem)
	local useEffect = React.useEffect
	local function fn()
		local purchaseModalType = props.purchaseModalType

		if
			fFlagEnableUnifiedPurchaseFlowForDevSubs
			and purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
		then
			local v10 = v8.BuyRobuxAndItem

			if FFlagShouldFixDevSubsFlashingTitle and v8.BuyRobuxAndSubscription and v8.BuyRobuxAndSubscription ~= "" then
				v10 = v8.BuyRobuxAndSubscription
			end

			setState2(v10)
		elseif purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
			if fFlagAXMISWithBlackbird then
				if
					fFlagUnifiedPurchaseFlowMarketplaceUIImprovements
					and props.product.itemName ~= "RobuxUpsell"
				then
					setState2(v8.BuyRobuxAndAvatar)
				else
					setState2(v8.BuyRobuxOnly)
				end
			elseif fFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
				setState2(v8.BuyRobuxAndAvatar)
			else
				setState2(v8.BuyRobuxAndItems)
			end
		elseif purchaseModalType == UnifiedPurchaseModalTypeEnum.Experience then
			setState2(v8.BuyRobuxAndExperience)
		else
			setState2(v8.BuyRobuxAndItem)
		end
	end

	local purchaseModalType = props.purchaseModalType
	local buyRobuxAndAvatar = v8.BuyRobuxAndAvatar
	local buyRobuxAndExperience = v8.BuyRobuxAndExperience
	local buyRobuxAndItem = v8.BuyRobuxAndItem
	local buyRobuxAndItems = v8.BuyRobuxAndItems
	local buyRobuxAndSubscription = v8.BuyRobuxAndSubscription
	local itemName = if fFlagAXMISWithBlackbird then props.product.itemName else nil
	local v11 = if fFlagAXMISWithBlackbird then v8.BuyRobuxOnly else nil
	useEffect(fn, {
		purchaseModalType,
		buyRobuxAndAvatar,
		buyRobuxAndExperience,
		buyRobuxAndItem,
		buyRobuxAndItems,
		buyRobuxAndSubscription,
		itemName,
		v11
	})

	local v12, v13 = useFocusNavigationRefs(props.buttons.cancelPurchaseActivated, props.onBuyItemButtonMounted)

	React.useEffect(function() end, { props.upsellSuggestions })

	local v14 = string.split(v8.DisclosureTermsURL, " {termsofuse} ")
	local v15 = v8.TermsOfUse

	if props.termsOfUseActivated then
		v15 = "<u>" .. v15 .. "</u>"
	end

	local v16 = fFlagEnableUnifiedPurchaseFlowForDevSubs
		and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription

	local perMonth = if v16 then v8.PerMonth else nil
	local v17 = if v16 then v8.Subscribe else v8.Buy

	local v18 = props.buttons.buyItemDisabled == true or props.isCartPricingLoading == true

	local v19 = buildCartPricingOfferCheckboxes({ cartPricing = v5, isDisabled = v18 })

	local v20 = {
		text = v17,
		variant = buttonVariant.Emphasis,
		onActivated = v6,
		isDisabled = v18,
		ref = v13,
		inputDelay = props.buttons.buyItemEnableInputDelayed and not v18 and 2.5 or 0
	}

	local v21 = v5.showCartOfferUi and #v5.cartPricingOffers or 0

	local v22 = React.useMemo(function()
		local children = {}

		for k, v23 in state do
			children[v23.actionKey] = React.createElement(checkbox, {
				LayoutOrder = v21 + k,
				size = "XSmall",
				label = v23.label,
				isChecked = v23.isActionSelected,
				isDisabled = v18,
				onActivated = function()
					setState(function(p2)
						local clone = table.clone(p2)
						clone[k] = {
							label = v23.label,
							isActionSelected = not v23.isActionSelected,
							actionKey = v23.actionKey
						}

						return clone
					end)
				end
			})
		end

		return children
	end, { state, v18, v21 })

	local clone = table.clone(v19)

	for k, v24 in pairs(v22) do
		clone[k] = v24
	end

	local v24

	if next(clone) then
		v24 = React.createElement(
			view,
			{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = 3 },
			clone
		)
	end

	local v25 = v5.cartPricingSavingsSummary

	if props.product.itemPrice and props.product.itemPrice.savingsSummaryOverride then
		v25 = props.product.itemPrice.savingsSummaryOverride
	end

	local v26 = React.createElement(module9, {
		purchaseModalType = props.purchaseModalType,
		product = v7,
		isCompact = v9,
		model = v7.model,
		priceSuffix = perMonth,
		hideProductDetails = props.purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem,
		hideDiscountSummary = props.isCartPricingLoading,
		savingsSummary = v25
	})

	local createElement = React.createElement
	local root = dialog.Root
	local v27 = {
		size = dialogSize.Medium,
		onClose = props.buttons.cancelPurchaseActivated,
		ref = v12,
		disablePortal = false
	}

	local children = {
		DialogTitle = React.createElement(dialog.Title, { text = state2 }),
		DialogContent = 0,
		DialogActions = 0,
		DisclosureTerms = 0
	}

	local createElement2 = React.createElement
	local content = dialog.Content
	local v29 = { ContentView = 0 }
	local createElement3 = React.createElement

	if not v26 then
		local createElement4 = React.createElement

		local v35 = if props.purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then React.createElement(PriceSummary, {
			amount = v7.itemRobuxCost,
			itemPrice = v7.itemPrice
		}) else React.createElement(UnifiedProductDetails, {
			isPortrait = false,
			isCompact = v9,
			itemIcon = v7.itemIcon,
			itemName = v7.itemName,
			itemRobuxCost = v7.itemRobuxCost,
			itemPrice = v7.itemPrice,
			model = v7.model,
			priceSuffix = perMonth
		})
		v26 = createElement4(
			view,
			{
				tag = "col align-x-center align-y-center gap-medium size-full-0",
				LayoutOrder = 1
			},
			{ ProductDetails = v35 }
		)
	end

	local children2 = {
		ProductDetailsContainer = v26,
		CartPricingLoading = React.createElement(module10, {
			isLoading = props.isCartPricingLoading
		}),
		PostPurchaseActions = v24,
		UpsellSuggestions = 0
	}

	local createElement4 = React.createElement
	local children3

	if GetFFlagIAPExperienceEnableMultiDisplayUpsell() then
		children3 = {}

		for i, upsellSuggestion in ipairs(props.upsellSuggestions) do
			children3["UpsellPackage" .. tostring(i)] = React.createElement(UpsellProductDetails, {
				layoutOrder = i,
				product = upsellSuggestion,
				selected = props.selectedUpsellIndex == i,
				isCompact = v9,
				onSelected = function()
					local v34 = i
					props.onUpsellSuggestionsSelected(v34)
				end,
				badgeType = upsellSuggestion.badgeType
			})
		end
	else
		children3 = {
			UpsellPackage1 = React.createElement(UpsellProductDetails, {
				layoutOrder = 1,
				product = props.upsellSuggestions[1],
				selected = props.selectedUpsellIndex == 1,
				isCompact = v9,
				onSelected = function()
					props.onUpsellSuggestionsSelected(1)
				end
			}),
			UpsellPackage2 = 0
		}
		local v34

		if #props.upsellSuggestions > 1 then
			v34 = React.createElement(UpsellProductDetails, {
				layoutOrder = 2,
				product = props.upsellSuggestions[2],
				selected = props.selectedUpsellIndex == 2,
				isCompact = v9,
				onSelected = function()
					props.onUpsellSuggestionsSelected(2)
				end,
				badgeType = props.upsellSuggestions[2].badgeType
			})
		end

		children3.UpsellPackage2 = v34
	end

	children2.UpsellSuggestions = createElement4(
		view,
		{
			LayoutOrder = 3,
			tag = "col align-x-center align-y-center gap-medium size-full-0 auto-y padding-x-xsmall padding-bottom-xxlarge padding-top-small"
		},
		children3
	)
	v29.ContentView = createElement3(
		view,
		{ tag = "col align-x-center align-y-top gap-medium size-full-0 auto-y" },
		children2
	)
	children.DialogContent = createElement2(content, nil, v29)
	local v34 = if onRobloxPlusButtonActivated then React.createElement(buttonGroup, {
		LayoutOrder = 4,
		orientation = orientation.Vertical,
		buttons = {
			v20,
			{
				text = v8.GetTenPercentOff,
				variant = buttonVariant.Standard,
				onActivated = onRobloxPlusButtonActivated,
				isDisabled = v20.isDisabled,
				icon = enums.IconName.RobloxPlus
			}
		}
	}) else React.createElement(dialog.Actions, {
		LayoutOrder = 4,
		orientation = orientation.Horizontal,
		actions = { v20 }
	})
	children.DialogActions = v34

	children.DisclosureTerms = React.createElement(
		view,
		{
			LayoutOrder = 5,
			tag = "row wrap align-x-center align-y-center gap-xxsmall size-full-0 auto-y"
		},
		{
			DisclosurePayment = React.createElement(text, {
				LayoutOrder = 1,
				Text = v8.DisclosurePayment,
				tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small"
			}),
			BeforeText = React.createElement(text, {
				LayoutOrder = 2,
				Text = v14[1],
				tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small"
			}),
			TextLink = React.createElement(text, {
				LayoutOrder = 3,
				RichText = true,
				Text = v15,
				tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small",
				onActivated = props.termsOfUseActivated
			}),
			AfterText = React.createElement(text, {
				LayoutOrder = 4,
				Text = v14[2],
				tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small"
			})
		}
	)
	return createElement(root, v27, children)
end

local function UnifiedRobuxUpsellModalV2Container(p2)
	return React.createElement(
		localizationProvider,
		{
			localization = localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			UnifiedRobuxUpsellModalV2 = React.createElement(UnifiedRobuxUpsellModalV2, p2)
		}
	)
end

return UnifiedRobuxUpsellModalV2Container
