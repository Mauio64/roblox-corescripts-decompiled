local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local SharedFlags = require(parent2.SharedFlags)

local Foundation = require(parent2.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local Checkbox = Foundation.Checkbox
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonGroup = Foundation.ButtonGroup
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local Orientation = Foundation.Enums.Orientation
local Enums = Foundation.Enums
local getIconRichText = Foundation.Utility.getIconRichText

local LocalizationService = game:GetService("LocalizationService")
local AppLocales = require(parent2.AppLocales)
local Localization = AppLocales.Localization
local Localization2 = require(parent2.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local useLocalization = Localization2.Hooks.useLocalization

local UnifiedProductDetails = require(parent.Generic.UnifiedProductDetails)
local YellowBadge = require(parent.Generic.YellowBadge)
local GrayBadge = require(parent.Generic.GrayBadge)
local PriceSummary = require(parent.Generic.PriceSummary)
local ProductDetailsContainer = require(parent.Generic.ProductDetailsContainer)
local CartPricingLoading = require(parent.ProductPurchase.v4.CartPricingLoading)
local buildCartPricingOfferCheckboxes = require(parent.ProductPurchase.v4.buildCartPricingOfferCheckboxes)
local useCartPricing = require(parent.ProductPurchase.v4.useCartPricing)

local useFocusNavigationRefs = require(parent.Generic.Hooks.useFocusNavigationRefs)

local UnifiedPurchaseModalTypeEnum = require(parent.Enums.UnifiedPurchaseModalTypeEnum)

require(parent.ProductPurchase.v4.cartPricingResponseLineItem)

local formatNumber = require(parent.Utility.formatNumber)
local getUpsellBadgeInfo = require(parent.Utility.getUpsellBadgeInfo)

local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird

local FFlagEnableRobuxUpsellPlusButtonExperiment = require(parent.Flags.FFlagEnableRobuxUpsellPlusButtonExperiment)

local SharedFlags2 = require(parent.Parent.SharedFlags)
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = SharedFlags2.FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local defineFastInt = game:DefineFastInt("CompactUpsellModalBreakpoint", 400)

local SharedFlags3 = require(parent.Parent.SharedFlags)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = SharedFlags3.FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagShouldFixDevSubsFlashingTitle = require(parent.Flags.FFlagShouldFixDevSubsFlashingTitle)

local GetFFlagIAPExperienceEnableMultiDisplayUpsell = require(parent.Flags.GetFFlagIAPExperienceEnableMultiDisplayUpsell)

local GetFFlagIAPExperienceUseUpsellBadgeHelper = require(parent.Flags.GetFFlagIAPExperienceUseUpsellBadgeHelper)

require(parent.Api.PaymentsGateway.GetUpsellSuggestionsTypes)
local BadgeType = require(parent.Enums.BadgeType)
require(parent.Enums.VirtualItemBadgeType)
require(parent.ProductPurchase.v3.UnifiedProductPurchaseModalTypes)

local function UpsellProductDetailsLegacyImpl(props, p)
	local text

	if props.badgeType == BadgeType.Popular then
		text = p.Popular
	elseif props.badgeType == BadgeType.LastPurchased then
		text = p.LastPurchased
	end

	local icon = props.badgeType == BadgeType.Popular and "icons/menu/fire_fill" or nil

	local v = "size-full-1400 radius-medium padding-x-large row"
	local tag

	if props.selected then
		tag = v .. " bg-surface-200 stroke-system-contrast stroke-thick"
	else
		tag = v .. " bg-surface-300 stroke-emphasis stroke-standard"
	end

	local tag2 = props.isCompact and "auto-xy text-title-small content-emphasis text-align-x-left"
		or "auto-xy text-title-large content-emphasis text-align-x-left"

	local tag3 = props.isCompact and "auto-xy text-title-small content-muted text-align-x-left"
		or "auto-xy text-title-large content-muted text-align-x-left"

	local tag4 = props.isCompact and "auto-xy text-title-small content-emphasis text-align-x-right"
		or "auto-xy text-title-large content-emphasis text-align-x-right"

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.layoutOrder,
		onActivated = props.onSelected,
		tag = tag,
		Size = 0
	}
	local size

	if props.isCompact then
		size = UDim2.new(1, 0, 0, 40)
	end

	v2.Size = size
	local v3 = {
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
					tag = tag2
				}),
				RobuxAmountBonus = props.product.robuxAmountBeforeBonus and React.createElement(Text, {
					LayoutOrder = 2,
					RichText = true,
					Text = "<s>" .. utf8.char(57346) .. formatNumber(
						LocalizationService.RobloxLocaleId,
						props.product.robuxAmountBeforeBonus
					) .. "</s>",
					tag = tag3
				})
			}
		),
		RightSide = 0
	}

	local createElement2 = React.createElement
	local v4 = {
		LayoutOrder = 2,
		tag = "row align-y-center align-x-right gap-large",
		Size = UDim2.new(0.5, 0, 1, 0)
	}
	local badge

	if text then
		badge = React.createElement(YellowBadge, { LayoutOrder = 1, Text = text, Icon = icon })
	end

	v3.RightSide = createElement2(View, v4, {
		Badge = badge,
		RobuxPrice = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.product.price or "",
			tag = tag4
		})
	})
	return createElement(View, v2, v3)
end

local function UpsellProductDetailsMultiDisplayImpl(props, props2)
	local text, iconName

	if GetFFlagIAPExperienceUseUpsellBadgeHelper() then
		local upsellBadgeInfo = getUpsellBadgeInfo(props.badgeType, props2)
		text = upsellBadgeInfo.text
		iconName = upsellBadgeInfo.icon
	else
		if props.badgeType == BadgeType.Popular then
			text = props2.Popular
		elseif props.badgeType == BadgeType.LastPurchased then
			text = props2.LastPurchased
		elseif props.badgeType == BadgeType.ForYou then
			text = props2.ForYouItem
		elseif props.badgeType == BadgeType.BetterValue then
			text = props2.BetterValue
		end

		if props.badgeType == BadgeType.Popular then
			iconName = Enums.IconName.Flame
		elseif props.badgeType == BadgeType.ForYou then
			iconName = Enums.IconName.CircleStar
		elseif props.badgeType == BadgeType.BetterValue then
			iconName = Enums.IconName.Tag
		end
	end

	local v = "size-full-1400 radius-medium padding-x-large row"
	local tag

	if props.selected then
		tag = v .. " bg-surface-200 stroke-system-contrast stroke-thick"
	else
		tag = v .. " bg-surface-300 stroke-emphasis stroke-standard"
	end

	local tag2 = props.isCompact and "auto-xy text-title-small content-emphasis text-align-x-left"
		or "auto-xy text-title-large content-emphasis text-align-x-left"

	local tag3 = props.isCompact and "auto-xy text-title-small content-muted text-align-x-left"
		or "auto-xy text-title-large content-muted text-align-x-left"

	local tag4 = props.isCompact and "auto-xy text-title-small content-emphasis text-align-x-right"
		or "auto-xy text-title-large content-emphasis text-align-x-right"

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = props.layoutOrder,
		onActivated = props.onSelected,
		tag = tag,
		Size = 0
	}
	local size

	if props.isCompact then
		size = UDim2.new(1, 0, 0, 40)
	end

	v2.Size = size

	local createElement2 = React.createElement
	local v3 = {
		LayoutOrder = 1,
		tag = "row gap-small align-y-center align-x-start",
		Size = UDim2.new(0.5, 0, 1, 0)
	}
	local v4 = {
		RobuxAmount = React.createElement(Text, {
			LayoutOrder = 1,
			RichText = true,
			Text = getIconRichText(Enums.IconName.Robux) .. " " .. formatNumber(
				LocalizationService.RobloxLocaleId,
				props.product.robuxAmount
			),
			tag = tag2
		}),
		RobuxAmountBonus = props.product.robuxAmountBeforeBonus and React.createElement(Text, {
			LayoutOrder = 2,
			RichText = true,
			Text = "<s>" .. getIconRichText(Enums.IconName.Robux) .. formatNumber(
				LocalizationService.RobloxLocaleId,
				props.product.robuxAmountBeforeBonus
			) .. "</s>",
			tag = tag3
		}),
		Badge = 0
	}
	local badge

	if text then
		badge = React.createElement(GrayBadge, { LayoutOrder = 3, Text = text, iconName = iconName })
	end

	v4.Badge = badge
	return createElement(View, v2, {
		LeftSide = createElement2(View, v3, v4),
		RightSide = React.createElement(
			View,
			{
				LayoutOrder = 2,
				tag = "row align-y-center align-x-right gap-large",
				Size = UDim2.new(0.5, 0, 1, 0)
			},
			{
				RobuxPrice = React.createElement(Text, {
					LayoutOrder = 2,
					Text = props.product.price or "",
					tag = tag4
				})
			}
		)
	})
end

local function UpsellProductDetails(p)
	local v = useLocalization({
		Popular = "IAPExperience.RobuxUpsell.Text.PopularItem",
		LastPurchased = "IAPExperience.RobuxUpsell.Text.LastPurchased",
		ForYouItem = "IAPExperience.RobuxUpsell.Text.ForYou",
		BetterValue = "IAPExperience.RobuxUpsell.Text.BetterValue",
		BestValue = "IAPExperience.RobuxUpsell.Text.BestValue"
	})

	if GetFFlagIAPExperienceEnableMultiDisplayUpsell() then
		return UpsellProductDetailsMultiDisplayImpl(p, v)
	end

	return UpsellProductDetailsLegacyImpl(p, v)
end

local function UnifiedRobuxUpsellModalV2(props)
	local robloxPlusDiscountPercentage

	if FFlagEnableRobuxUpsellPlusButtonExperiment and type(props.robloxPlusDiscountPercentage) == "number" then
		robloxPlusDiscountPercentage = props.robloxPlusDiscountPercentage
	end

	local onRobloxPlusButtonActivated

	if robloxPlusDiscountPercentage ~= nil then
		onRobloxPlusButtonActivated = props.onRobloxPlusButtonActivated
	end

	local cartPricing = useCartPricing({
		product = props.product,
		purchaseModalType = props.purchaseModalType,
		cartPricingResponse = props.cartPricingResponse,
		onCartOfferAppliedChanged = props.onCartOfferAppliedChanged
	})

	local state, setState = React.useState(props.postPurchaseActions or {})

	local onActivated = React.useCallback(function()
		if state and props.setPostPurchaseActions then
			props.setPostPurchaseActions(state)
		end

		props.buttons.buyItemActivated()
	end, { props.buttons.buyItemActivated, props.setPostPurchaseActions, state })

	local product = React.useMemo(function()
		if cartPricing.showCartOfferUi then
			return cartPricing.mergedProductForDetails
		end

		return props.product
	end, { props.product, cartPricing.showCartOfferUi, cartPricing.mergedProductForDetails })

	local v = useLocalization({
		Buy = "IAPExperience.PurchasePrompt.Action.Buy",
		GetTenPercentOff = robloxPlusDiscountPercentage ~= nil and {
			"IAPExperience.RobuxUpsell.Action.GetPercentOff",
			discountPercentage = robloxPlusDiscountPercentage
		} or nil,
		Subscribe = FFlagEnableUnifiedPurchaseFlowForDevSubs and "Feature.Subscription.Action.Subscribe" or nil,
		DisclosurePayment = "IAPExperience.RobuxUpsell.Text.DisclosurePayment",
		DisclosureTermsURL = "IAPExperience.RobuxUpsell.Text.DisclosureTermsURL",
		TermsOfUse = "IAPExperience.RobuxUpsell.Text.TermsOfUse",
		BuyRobuxAndExperience = "IAPExperience.PurchasePrompt.BuyRobuxAndExperience",
		BuyRobuxAndItem = "IAPExperience.PurchasePrompt.Title.BuyRobuxAndItem",
		BuyRobuxAndItems = "IAPExperience.PurchasePrompt.Title.BuyRobuxAndItems",
		BuyRobuxOnly = FFlagAXMISWithBlackbird and "IAPExperience.PurchasePrompt.Title.BuyRobuxOnly" or nil,
		BuyRobuxAndAvatar = FFlagUnifiedPurchaseFlowMarketplaceUIImprovements and "IAPExperience.PurchasePrompt.Header.BuyRobuxAndAvatar" or nil,
		BuyRobuxAndSubscription = FFlagEnableUnifiedPurchaseFlowForDevSubs and "IAPExperience.PurchasePrompt.BuyRobuxAndSubscription" or nil,
		PerMonth = FFlagEnableUnifiedPurchaseFlowForDevSubs and "Feature.Subscription.Text.PerMonth" or nil
	})
	local isCompact

	if
		FFlagEnableUnifiedPurchaseFlowForDevSubs
		and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	then
		if props.screenSize.Y > 0 then
			isCompact = props.screenSize.Y < defineFastInt
		else
			isCompact = false
		end
	else
		isCompact = props.screenSize.Y < defineFastInt
	end

	local state2, setState2 = React.useState(v.BuyRobuxAndItem)
	local useEffect = React.useEffect
	local function fn()
		local purchaseModalType = props.purchaseModalType

		if
			FFlagEnableUnifiedPurchaseFlowForDevSubs
			and purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
		then
			local v2 = v.BuyRobuxAndItem

			if FFlagShouldFixDevSubsFlashingTitle and v.BuyRobuxAndSubscription and v.BuyRobuxAndSubscription ~= "" then
				v2 = v.BuyRobuxAndSubscription
			end

			setState2(v2)
		elseif purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
			if FFlagAXMISWithBlackbird then
				if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements and props.product.itemName ~= "RobuxUpsell" then
					setState2(v.BuyRobuxAndAvatar)
				else
					setState2(v.BuyRobuxOnly)
				end
			elseif FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
				setState2(v.BuyRobuxAndAvatar)
			else
				setState2(v.BuyRobuxAndItems)
			end
		elseif purchaseModalType == UnifiedPurchaseModalTypeEnum.Experience then
			setState2(v.BuyRobuxAndExperience)
		else
			setState2(v.BuyRobuxAndItem)
		end
	end

	local purchaseModalType = props.purchaseModalType
	local buyRobuxAndAvatar = v.BuyRobuxAndAvatar
	local buyRobuxAndExperience = v.BuyRobuxAndExperience
	local buyRobuxAndItem = v.BuyRobuxAndItem
	local buyRobuxAndItems = v.BuyRobuxAndItems
	local buyRobuxAndSubscription = v.BuyRobuxAndSubscription
	local itemName

	if FFlagAXMISWithBlackbird then
		itemName = props.product.itemName
	end

	local v2

	if FFlagAXMISWithBlackbird then
		v2 = v.BuyRobuxOnly
	end

	useEffect(fn, {
		purchaseModalType,
		buyRobuxAndAvatar,
		buyRobuxAndExperience,
		buyRobuxAndItem,
		buyRobuxAndItems,
		buyRobuxAndSubscription,
		itemName,
		v2
	})

	local ref, ref2 = useFocusNavigationRefs(props.buttons.cancelPurchaseActivated, props.onBuyItemButtonMounted)

	React.useEffect(function() end, { props.upsellSuggestions })

	local v3 = string.split(v.DisclosureTermsURL, " {termsofuse} ")
	local text = v.TermsOfUse

	if props.termsOfUseActivated then
		text = "<u>" .. text .. "</u>"
	end

	local v4 = FFlagEnableUnifiedPurchaseFlowForDevSubs
		and props.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	local perMonth

	if v4 then
		perMonth = v.PerMonth
	end

	local text2 = if v4 then v.Subscribe else v.Buy

	local isDisabled = props.buttons.buyItemDisabled == true or props.isCartPricingLoading == true

	local cartPricingOfferCheckboxes = buildCartPricingOfferCheckboxes({
		cartPricing = cartPricing,
		isDisabled = isDisabled
	})

	local v5 = {
		text = text2,
		variant = ButtonVariant.Emphasis,
		onActivated = onActivated,
		isDisabled = isDisabled,
		ref = ref2,
		inputDelay = props.buttons.buyItemEnableInputDelayed and not isDisabled and 2.5 or 0
	}

	local v6 = cartPricing.showCartOfferUi and #cartPricing.cartPricingOffers or 0

	local v7 = React.useMemo(function()
		local children = {}

		for k, v7 in state do
			children[v7.actionKey] = React.createElement(Checkbox, {
				LayoutOrder = v6 + k,
				size = "XSmall",
				label = v7.label,
				isChecked = v7.isActionSelected,
				isDisabled = isDisabled,
				onActivated = function()
					setState(function(p)
						local clone = table.clone(p)
						clone[k] = {
							label = v7.label,
							isActionSelected = not v7.isActionSelected,
							actionKey = v7.actionKey
						}

						return clone
					end)
				end
			})
		end

		return children
	end, { state, isDisabled, v6 })

	local clone = table.clone(cartPricingOfferCheckboxes)
	local actions = { v5 }

	for k, v8 in pairs(v7) do
		clone[k] = v8
	end

	local postPurchaseActions

	if next(clone) then
		postPurchaseActions = React.createElement(
			View,
			{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = 3 },
			clone
		)
	end

	local savingsSummary = cartPricing.cartPricingSavingsSummary

	if props.product.itemPrice and props.product.itemPrice.savingsSummaryOverride then
		savingsSummary = props.product.itemPrice.savingsSummaryOverride
	end

	local productDetailsContainer = React.createElement(ProductDetailsContainer, {
		purchaseModalType = props.purchaseModalType,
		product = product,
		isCompact = isCompact,
		model = product.model,
		priceSuffix = perMonth,
		hideProductDetails = props.purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem,
		hideDiscountSummary = props.isCartPricingLoading,
		savingsSummary = savingsSummary
	})

	local createElement = React.createElement
	local root = Dialog.Root
	local v8 = {
		size = DialogSize.Medium,
		onClose = props.buttons.cancelPurchaseActivated,
		ref = ref,
		disablePortal = false
	}

	local children = {
		DialogTitle = React.createElement(Dialog.Title, { text = state2 }),
		DialogContent = 0,
		DialogActions = 0,
		DisclosureTerms = 0
	}

	local createElement2 = React.createElement
	local content = Dialog.Content
	local v9 = { ContentView = 0 }
	local createElement3 = React.createElement

	if not productDetailsContainer then
		local createElement4 = React.createElement
		local productDetails

		if props.purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
			productDetails = React.createElement(PriceSummary, {
				amount = product.itemRobuxCost,
				itemPrice = product.itemPrice
			})
		else
			productDetails = React.createElement(UnifiedProductDetails, {
				isPortrait = false,
				isCompact = isCompact,
				itemIcon = product.itemIcon,
				itemName = product.itemName,
				itemRobuxCost = product.itemRobuxCost,
				itemPrice = product.itemPrice,
				model = product.model,
				priceSuffix = perMonth
			})
		end

		productDetailsContainer = createElement4(
			View,
			{ tag = "col align-x-center align-y-center gap-medium size-full-0", LayoutOrder = 1 },
			{ ProductDetails = productDetails }
		)
	end

	local children2 = {
		ProductDetailsContainer = productDetailsContainer,
		CartPricingLoading = React.createElement(CartPricingLoading, {
			isLoading = props.isCartPricingLoading
		}),
		PostPurchaseActions = postPurchaseActions,
		UpsellSuggestions = 0
	}

	local createElement4 = React.createElement
	local children3

	local function fn2(i: number) -- 3 equivalent calls inferred from this helper
		props.onUpsellSuggestionsSelected(i)
	end

	if GetFFlagIAPExperienceEnableMultiDisplayUpsell() then
		children3 = {}

		for i, upsellSuggestion in ipairs(props.upsellSuggestions) do
			children3["UpsellPackage" .. tostring(i)] = React.createElement(UpsellProductDetails, {
				layoutOrder = i,
				product = upsellSuggestion,
				selected = props.selectedUpsellIndex == i,
				isCompact = isCompact,
				onSelected = function()
					fn2(i) -- inferred equivalent call
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
				isCompact = isCompact,
				onSelected = function()
					fn2(1) -- inferred equivalent call
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
				isCompact = isCompact,
				onSelected = function()
					fn2(2) -- inferred equivalent call
				end,
				badgeType = props.upsellSuggestions[2].badgeType
			})
		end

		children3.UpsellPackage2 = upsellPackage
	end

	children2.UpsellSuggestions = createElement4(
		View,
		{
			LayoutOrder = 3,
			tag = "col align-x-center align-y-center gap-medium size-full-0 auto-y padding-x-xsmall padding-bottom-xxlarge padding-top-small"
		},
		children3
	)
	v9.ContentView = createElement3(
		View,
		{ tag = "col align-x-center align-y-top gap-medium size-full-0 auto-y" },
		children2
	)
	children.DialogContent = createElement2(content, nil, v9)
	local dialogActions

	if onRobloxPlusButtonActivated then
		dialogActions = React.createElement(ButtonGroup, {
			LayoutOrder = 4,
			orientation = Orientation.Vertical,
			buttons = {
				v5,
				{
					text = v.GetTenPercentOff,
					variant = ButtonVariant.Standard,
					onActivated = onRobloxPlusButtonActivated,
					isDisabled = v5.isDisabled,
					icon = Enums.IconName.RobloxPlus
				}
			}
		})
	else
		dialogActions = React.createElement(Dialog.Actions, {
			LayoutOrder = 4,
			orientation = Orientation.Horizontal,
			actions = actions
		})
	end

	children.DialogActions = dialogActions

	children.DisclosureTerms = React.createElement(
		View,
		{
			LayoutOrder = 5,
			tag = "row wrap align-x-center align-y-center gap-xxsmall size-full-0 auto-y"
		},
		{
			DisclosurePayment = React.createElement(Text, {
				LayoutOrder = 1,
				Text = v.DisclosurePayment,
				tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small"
			}),
			BeforeText = React.createElement(Text, {
				LayoutOrder = 2,
				Text = v3[1],
				tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small"
			}),
			TextLink = React.createElement(Text, {
				LayoutOrder = 3,
				RichText = true,
				Text = text,
				tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small",
				onActivated = props.termsOfUseActivated
			}),
			AfterText = React.createElement(Text, {
				LayoutOrder = 4,
				Text = v3[2],
				tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small"
			})
		}
	)
	return createElement(root, v8, children)
end

local function UnifiedRobuxUpsellModalV2Container(p)
	return React.createElement(
		LocalizationProvider,
		{
			localization = Localization.new(LocalizationService.RobloxLocaleId)
		},
		{
			UnifiedRobuxUpsellModalV2 = React.createElement(UnifiedRobuxUpsellModalV2, p)
		}
	)
end

return UnifiedRobuxUpsellModalV2Container
