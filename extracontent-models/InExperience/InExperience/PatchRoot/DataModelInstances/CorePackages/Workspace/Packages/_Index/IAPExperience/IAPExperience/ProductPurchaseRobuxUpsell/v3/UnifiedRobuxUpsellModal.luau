local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local SharedFlags = require(ParentParentParent.SharedFlags)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local FoundationImage = Foundation.Image
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local Sheet = Foundation.Sheet
local useScaledValue = Foundation.Hooks.useScaledValue
local Enums = Foundation.Enums
local getIconRichText = Foundation.Utility.getIconRichText
local LocalizationService = game:GetService("LocalizationService")
local Localization = require(ParentParentParent.AppLocales).Localization
local Localization2 = require(ParentParentParent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider
local useLocalization = Localization2.Hooks.useLocalization
local UnifiedProductDetails = require(ParentParent.Generic.UnifiedProductDetails)
local YellowBadge = require(ParentParent.Generic.YellowBadge)
local GrayBadge = require(ParentParent.Generic.GrayBadge)
local PriceSummary = require(ParentParent.Generic.PriceSummary)
local UnifiedPurchaseModalHeader = require(ParentParent.Generic.UnifiedPurchaseModalHeader)
local ProductDetailsContainer = require(ParentParent.Generic.ProductDetailsContainer)
local useInitialButtonDisableDelay = require(ParentParent.Generic.Hooks.useInitialButtonDisableDelay)
local useFocusNavigationRefs = require(ParentParent.Generic.Hooks.useFocusNavigationRefs)
local UnifiedPurchaseModalTypeEnum = require(ParentParent.Enums.UnifiedPurchaseModalTypeEnum)
local formatNumber = require(ParentParent.Utility.formatNumber)
local getUpsellBadgeInfo = require(ParentParent.Utility.getUpsellBadgeInfo)
local Constants = require(ParentParent.Generic.Constants)
local UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_SINGLE_PACKAGE = Constants.UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_SINGLE_PACKAGE
local UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_DEFAULT = Constants.UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_DEFAULT
local UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES = Constants.UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES
local FFlagAXMISWithBlackbird = SharedFlags.FFlagAXMISWithBlackbird
local FFlagUnifiedPurchaseFlowMarketplaceUIImprovements = require(ParentParent.Parent.SharedFlags).FFlagUnifiedPurchaseFlowMarketplaceUIImprovements
local v37 = game:DefineFastInt("CompactUpsellModalBreakpoint", 400)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = require(ParentParent.Parent.SharedFlags).FFlagEnableUnifiedPurchaseFlowForDevSubs
local FFlagShouldApplyDevSubsUpsellFix = require(ParentParent.Flags.FFlagShouldApplyDevSubsUpsellFix)
local FFlagShouldFixDevSubsFlashingTitle = require(ParentParent.Flags.FFlagShouldFixDevSubsFlashingTitle)
local GetFFlagIAPExperienceEnableMultiDisplayUpsell = require(ParentParent.Flags.GetFFlagIAPExperienceEnableMultiDisplayUpsell)
local GetFFlagIAPExperienceUseUpsellBadgeHelper = require(ParentParent.Flags.GetFFlagIAPExperienceUseUpsellBadgeHelper)
local FFlagFixUpsellModalUnevenLayout = require(ParentParent.Flags.FFlagFixUpsellModalUnevenLayout)

require(ParentParent.Api.PaymentsGateway.GetUpsellSuggestionsTypes)

local BadgeType = require(ParentParent.Enums.BadgeType)

require(ParentParent.Enums.VirtualItemBadgeType)
require(ParentParent.ProductPurchase.PricingTypes)

local function UpsellProductDetailsLegacyImpl(t1: {[any]: any}, t2: {[any]: any}) -- line: 100
	-- upvalues: BadgeType (copy), React (copy), View (copy), FoundationText (copy), formatNumber (copy), LocalizationService (copy), YellowBadge (copy)
	local v53 = if t1.badgeType ~= BadgeType.Popular then if t1.badgeType ~= BadgeType.LastPurchased then nil else t2.LastPurchased else t2.Popular
	local v54 = if t1.badgeType ~= BadgeType.Popular then nil else "icons/menu/fire_fill"
	local s1 = "size-full-1400 radius-medium padding-x-large row"
	local v56 = if not t1.selected then s1 .. " bg-surface-300 stroke-emphasis stroke-standard" else s1 .. " bg-surface-200 stroke-system-contrast stroke-thick"
	local v57 = not t1.isCompact and "auto-xy text-title-large content-emphasis text-align-x-left" or "auto-xy text-title-small content-emphasis text-align-x-left"
	local v58 = not t1.isCompact and "auto-xy text-title-large content-muted text-align-x-left" or "auto-xy text-title-small content-muted text-align-x-left"
	local v59 = not t1.isCompact and "auto-xy text-title-large content-emphasis text-align-x-right" or "auto-xy text-title-small content-emphasis text-align-x-right"

	return React.createElement(View, {
		LayoutOrder = t1.layoutOrder,
		onActivated = t1.onSelected,
		tag = v56,
		Size = if not t1.isCompact then nil else UDim2.new(1, 0, 0, 40)
	}, {
		LeftSide = React.createElement(View, {
			LayoutOrder = 1,
			tag = {
				["row align-y-center gap-small"] = true,
				["align-x-start"] = true
			},
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			RobuxAmount = React.createElement(FoundationText, {
				LayoutOrder = 1,
				Text = utf8.char(57346) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, t1.product.robuxAmount),
				tag = v57
			}),
			RobuxAmountBonus = t1.product.robuxAmountBeforeBonus and React.createElement(FoundationText, {
				LayoutOrder = 2,
				RichText = true,
				Text = "<s>" .. utf8.char(57346) .. formatNumber(LocalizationService.RobloxLocaleId, t1.product.robuxAmountBeforeBonus) .. "</s>",
				tag = v58
			})
		}),
		RightSide = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row align-x-right align-y-center gap-large",
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			Badge = if not v53 then nil else React.createElement(YellowBadge, {
				LayoutOrder = 1,
				Text = v53,
				Icon = v54
			}),
			RobuxPrice = React.createElement(FoundationText, {
				LayoutOrder = 2,
				Text = t1.product.price or "",
				tag = v59
			})
		})
	})
end
local function UpsellProductDetailsMultiDisplayFixedImpl(t3: {[any]: any}, t4: {[any]: any}) -- line: 179
	-- upvalues: GetFFlagIAPExperienceUseUpsellBadgeHelper (copy), getUpsellBadgeInfo (copy), BadgeType (copy), Enums (copy), React (copy), View (copy), FoundationText (copy), getIconRichText (copy), formatNumber (copy), LocalizationService (copy), GrayBadge (copy)
	local text, icon

	if GetFFlagIAPExperienceUseUpsellBadgeHelper() then
		local v62 = getUpsellBadgeInfo(t3.badgeType, t4)

		text = v62.text
		icon = v62.icon
	else
		text = if t3.badgeType ~= BadgeType.Popular then if t3.badgeType ~= BadgeType.LastPurchased then if t3.badgeType ~= BadgeType.ForYou then if t3.badgeType ~= BadgeType.BetterValue then nil else t4.BetterValue else t4.ForYouItem else t4.LastPurchased else t4.Popular
		icon = if t3.badgeType ~= BadgeType.Popular then if t3.badgeType ~= BadgeType.ForYou then if t3.badgeType ~= BadgeType.BetterValue then nil else Enums.IconName.Tag else Enums.IconName.CircleStar else Enums.IconName.Flame
	end

	local v65 = not t3.isCompact and "size-full-1400 radius-medium padding-x-large row" or "size-full-1000 radius-medium padding-small row"
	local v66 = if not t3.selected then v65 .. " bg-surface-300 stroke-default stroke-standard" else v65 .. " bg-surface-200 stroke-system-contrast stroke-thick"
	local v67 = not t3.isCompact and "auto-xy text-heading-small content-emphasis text-align-x-left" or "auto-xy text-title-small content-emphasis text-align-x-left"
	local v68 = not t3.isCompact and "auto-xy text-title-medium content-muted text-align-x-left" or "auto-xy text-title-small content-muted text-align-x-left"
	local v69 = not t3.isCompact and "auto-xy text-title-large content-emphasis text-align-x-right" or "auto-xy text-title-small content-emphasis text-align-x-right"

	return React.createElement(View, {
		LayoutOrder = t3.layoutOrder,
		onActivated = t3.onSelected,
		tag = v66
	}, {
		LeftSide = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row align-x-left align-y-center gap-small",
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			RobuxAmount = React.createElement(FoundationText, {
				LayoutOrder = 1,
				RichText = true,
				Text = getIconRichText(Enums.IconName.Robux) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, t3.product.robuxAmount),
				tag = v67
			}),
			RobuxAmountBonus = t3.product.robuxAmountBeforeBonus and React.createElement(FoundationText, {
				LayoutOrder = 2,
				RichText = true,
				Text = "<s>" .. getIconRichText(Enums.IconName.Robux) .. formatNumber(LocalizationService.RobloxLocaleId, t3.product.robuxAmountBeforeBonus) .. "</s>",
				tag = v68
			}),
			Badge = if not text then nil else React.createElement(GrayBadge, {
				LayoutOrder = 3,
				Text = text,
				iconName = icon
			})
		}),
		RightSide = React.createElement(View, {
			LayoutOrder = 2,
			tag = "row align-x-right align-y-center gap-large",
			Size = UDim2.new(0.5, 0, 1, 0)
		}, {
			RobuxPrice = React.createElement(FoundationText, {
				LayoutOrder = 1,
				Text = t3.product.price or "",
				tag = v69
			})
		})
	})
end
local function UpsellProductDetailsMultiDisplayImpl(t5: {[any]: any}, t6: {[any]: any}) -- line: 271
	-- upvalues: GetFFlagIAPExperienceUseUpsellBadgeHelper (copy), getUpsellBadgeInfo (copy), BadgeType (copy), Enums (copy), React (copy), View (copy), FoundationText (copy), getIconRichText (copy), formatNumber (copy), LocalizationService (copy), GrayBadge (copy)
	local text, icon

	if GetFFlagIAPExperienceUseUpsellBadgeHelper() then
		local v72 = getUpsellBadgeInfo(t5.badgeType, t6)

		text = v72.text
		icon = v72.icon
	else
		text = if t5.badgeType ~= BadgeType.Popular then if t5.badgeType ~= BadgeType.LastPurchased then if t5.badgeType ~= BadgeType.ForYou then if t5.badgeType ~= BadgeType.BetterValue then nil else t6.BetterValue else t6.ForYouItem else t6.LastPurchased else t6.Popular
		icon = if t5.badgeType ~= BadgeType.Popular then if t5.badgeType ~= BadgeType.ForYou then if t5.badgeType ~= BadgeType.BetterValue then nil else Enums.IconName.Tag else Enums.IconName.CircleStar else Enums.IconName.Flame
	end

	local v75 = not t5.isCompact and "col align-x-left gap-medium size-full-0 auto-y padding-medium radius-medium" or "size-full-0 auto-y radius-medium padding-small row"
	local v76 = if not t5.selected then v75 .. " bg-surface-300 stroke-default stroke-standard" else v75 .. " bg-surface-200 stroke-system-contrast stroke-thick"
	local v77 = not t5.isCompact and "auto-xy text-heading-small content-emphasis text-align-x-left" or "auto-xy text-title-small content-emphasis text-align-x-left"
	local v78 = not t5.isCompact and "auto-xy text-title-medium content-muted text-align-x-left" or "auto-xy text-title-small content-muted text-align-x-left"
	local v79 = not t5.isCompact and "auto-xy text-title-large content-emphasis text-align-x-right" or "auto-xy text-title-small content-emphasis text-align-x-right"

	return React.createElement(View, {
		LayoutOrder = t5.layoutOrder,
		onActivated = t5.onSelected,
		tag = v76,
		Size = if not t5.isCompact then nil else UDim2.new(1, 0, 0, 40)
	}, {
		LeftSide = React.createElement(View, {
			LayoutOrder = 1,
			tag = {
				["row align-x-left align-y-center gap-small"] = true,
				["size-full-0 auto-y"] = not t5.isCompact
			},
			Size = if not t5.isCompact then nil else UDim2.new(0.65, 0, 1, 0)
		}, {
			RobuxAmount = React.createElement(FoundationText, {
				LayoutOrder = 1,
				RichText = true,
				Text = getIconRichText(Enums.IconName.Robux) .. " " .. formatNumber(LocalizationService.RobloxLocaleId, t5.product.robuxAmount),
				tag = v77
			}),
			RobuxAmountBonus = t5.product.robuxAmountBeforeBonus and React.createElement(FoundationText, {
				LayoutOrder = 2,
				RichText = true,
				Text = "<s>" .. getIconRichText(Enums.IconName.Robux) .. formatNumber(LocalizationService.RobloxLocaleId, t5.product.robuxAmountBeforeBonus) .. "</s>",
				tag = v78
			}),
			Badge = if not text then nil else React.createElement(GrayBadge, {
				LayoutOrder = 3,
				Text = text,
				iconName = icon
			})
		}),
		RightSide = React.createElement(View, {
			LayoutOrder = 2,
			tag = {
				["row align-x-right align-y-center gap-large"] = true,
				["size-full-0 auto-y"] = not t5.isCompact
			},
			Size = if not t5.isCompact then nil else UDim2.new(0.35, 0, 1, 0)
		}, {
			RobuxPrice = React.createElement(FoundationText, {
				LayoutOrder = 1,
				Text = t5.product.price or "",
				tag = v79
			})
		})
	})
end
local function UpsellProductDetails(t7: {[any]: any}) -- line: 370
	-- upvalues: useLocalization (copy), GetFFlagIAPExperienceEnableMultiDisplayUpsell (copy), FFlagFixUpsellModalUnevenLayout (copy), UpsellProductDetailsMultiDisplayFixedImpl (copy), UpsellProductDetailsMultiDisplayImpl (copy), UpsellProductDetailsLegacyImpl (copy)
	local v81 = useLocalization({
		Popular = "IAPExperience.RobuxUpsell.Text.PopularItem",
		LastPurchased = "IAPExperience.RobuxUpsell.Text.LastPurchased",
		ForYouItem = "IAPExperience.RobuxUpsell.Text.ForYou",
		BetterValue = "IAPExperience.RobuxUpsell.Text.BetterValue",
		BestValue = "IAPExperience.RobuxUpsell.Text.BestValue"
	})

	if GetFFlagIAPExperienceEnableMultiDisplayUpsell() then
		if FFlagFixUpsellModalUnevenLayout then
			return UpsellProductDetailsMultiDisplayFixedImpl(t7, v81)
		end

		return UpsellProductDetailsMultiDisplayImpl(t7, v81)
	end

	return UpsellProductDetailsLegacyImpl(t7, v81)
end
local function UnifiedRobuxUpsellModal(t8: {[any]: any}) -- line: 414
	-- upvalues: useLocalization (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), FFlagAXMISWithBlackbird (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy), UnifiedPurchaseModalTypeEnum (copy), v37 (copy), useInitialButtonDisableDelay (copy), React (copy), UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_DEFAULT (copy), GetFFlagIAPExperienceEnableMultiDisplayUpsell (copy), FFlagFixUpsellModalUnevenLayout (copy), UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES (copy), UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_SINGLE_PACKAGE (copy), useScaledValue (copy), FFlagShouldFixDevSubsFlashingTitle (copy), useFocusNavigationRefs (copy), FFlagShouldApplyDevSubsUpsellFix (copy), View (copy), FoundationImage (copy), FoundationText (copy), ProductDetailsContainer (copy), Sheet (copy), UnifiedPurchaseModalHeader (copy), PriceSummary (copy), UnifiedProductDetails (copy), UpsellProductDetails (copy), Foundation (copy), FillBehavior (copy), ButtonVariant (copy)
	local v83 = useLocalization({
		Buy = "IAPExperience.PurchasePrompt.Action.Buy",
		DisclosurePayment = "IAPExperience.RobuxUpsell.Text.DisclosurePayment",
		DisclosureTermsURL = "IAPExperience.RobuxUpsell.Text.DisclosureTermsURL",
		TermsOfUse = "IAPExperience.RobuxUpsell.Text.TermsOfUse",
		BuyRobuxAndExperience = "IAPExperience.PurchasePrompt.BuyRobuxAndExperience",
		BuyRobuxAndItem = "IAPExperience.PurchasePrompt.Title.BuyRobuxAndItem",
		BuyRobuxAndItems = "IAPExperience.PurchasePrompt.Title.BuyRobuxAndItems",
		Subscribe = if not FFlagEnableUnifiedPurchaseFlowForDevSubs then nil else "Feature.Subscription.Action.Subscribe",
		BuyRobuxOnly = if not FFlagAXMISWithBlackbird then nil else "IAPExperience.PurchasePrompt.Title.BuyRobuxOnly",
		BuyRobuxAndAvatar = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else "IAPExperience.PurchasePrompt.Header.BuyRobuxAndAvatar",
		BuyRobuxAndSubscription = if not FFlagEnableUnifiedPurchaseFlowForDevSubs then nil else "IAPExperience.PurchasePrompt.BuyRobuxAndSubscription",
		PerMonth = if not FFlagEnableUnifiedPurchaseFlowForDevSubs then nil else "Feature.Subscription.Text.PerMonth"
	})
	local u84 = if not FFlagEnableUnifiedPurchaseFlowForDevSubs or t8.purchaseModalType ~= UnifiedPurchaseModalTypeEnum.DeveloperSubscription then t8.screenSize.Y < v37 else t8.screenSize.Y > 0 and t8.screenSize.Y < v37
	local v85 = useInitialButtonDisableDelay(false)
	local v86, v87 = React.useState(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_DEFAULT)

	React.useEffect(function() -- line: 453
		-- upvalues: GetFFlagIAPExperienceEnableMultiDisplayUpsell (copy), FFlagFixUpsellModalUnevenLayout (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), t8 (copy), UnifiedPurchaseModalTypeEnum (copy), v87 (copy), UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES (copy), UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_SINGLE_PACKAGE (copy), UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_DEFAULT (copy)
		if GetFFlagIAPExperienceEnableMultiDisplayUpsell() and not FFlagFixUpsellModalUnevenLayout then
			if FFlagEnableUnifiedPurchaseFlowForDevSubs and t8.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription then
				v87(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES)

				return
			end

			local v107 = #t8.upsellSuggestions

			if v107 == 1 then
				v87(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_SINGLE_PACKAGE)

				return
			end

			if v107 == 2 then
				v87(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_DEFAULT)

				return
			end

			v87(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES)

			return
		end

		if #t8.upsellSuggestions > 1 then
			v87(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES)
		end

		if FFlagEnableUnifiedPurchaseFlowForDevSubs and t8.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription then
			v87(UNIFIED_ROBUX_UPSELL_MODAL_MIN_HEIGHT_PIXELS_WITH_MULTIPLE_PACKAGES)
		end
	end, {
		t8.upsellSuggestions,
		t8.purchaseModalType
	})

	local v88 = useScaledValue(v86 or 0)
	local v89, v90 = React.useState(v83.BuyRobuxAndItem)

	React.useEffect(function() -- line: 486
		-- upvalues: t8 (copy), FFlagEnableUnifiedPurchaseFlowForDevSubs (copy), UnifiedPurchaseModalTypeEnum (copy), v83 (copy), FFlagShouldFixDevSubsFlashingTitle (copy), v90 (copy), FFlagAXMISWithBlackbird (copy), FFlagUnifiedPurchaseFlowMarketplaceUIImprovements (copy)
		local purchaseModalType = t8.purchaseModalType

		if FFlagEnableUnifiedPurchaseFlowForDevSubs and purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription then
			local BuyRobuxAndItem = v83.BuyRobuxAndItem

			if FFlagShouldFixDevSubsFlashingTitle and v83.BuyRobuxAndSubscription and v83.BuyRobuxAndSubscription ~= "" then
				BuyRobuxAndItem = v83.BuyRobuxAndSubscription
			end

			v90(BuyRobuxAndItem)

			return
		end

		if purchaseModalType == UnifiedPurchaseModalTypeEnum.MultiItem then
			if FFlagAXMISWithBlackbird then
				if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements and t8.product.itemName ~= "RobuxUpsell" then
					v90(v83.BuyRobuxAndAvatar)

					return
				end

				v90(v83.BuyRobuxOnly)

				return
			end

			if FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then
				v90(v83.BuyRobuxAndAvatar)

				return
			end

			v90(v83.BuyRobuxAndItems)

			return
		end

		if purchaseModalType == UnifiedPurchaseModalTypeEnum.Experience then
			v90(v83.BuyRobuxAndExperience)

			return
		end

		v90(v83.BuyRobuxAndItem)
	end, {
		t8.purchaseModalType,
		v83.BuyRobuxAndAvatar,
		v83.BuyRobuxAndExperience,
		v83.BuyRobuxAndItem,
		v83.BuyRobuxAndItems,
		v83.BuyRobuxAndSubscription,
		if not FFlagAXMISWithBlackbird then nil else t8.product.itemName,
		if not FFlagAXMISWithBlackbird then nil else v83.BuyRobuxOnly
	})

	local v91, v92 = useFocusNavigationRefs(t8.buttons.cancelPurchaseActivated, t8.onBuyItemButtonMounted)

	React.useEffect(function() -- line: 539
	end, { t8.upsellSuggestions })

	local parts = string.split(v83.DisclosureTermsURL, " {termsofuse} ")
	local TermsOfUse = v83.TermsOfUse

	if t8.termsOfUseActivated then
		TermsOfUse = "<u>" .. TermsOfUse .. "</u>"
	end

	local v95 = FFlagEnableUnifiedPurchaseFlowForDevSubs and t8.purchaseModalType == UnifiedPurchaseModalTypeEnum.DeveloperSubscription
	local v96 = if not v95 then nil else v83.PerMonth
	local v97 = if not v95 then v83.Buy else v83.Subscribe
	local v98 = if not v95 or not FFlagShouldApplyDevSubsUpsellFix then React.createElement(ProductDetailsContainer, {
		purchaseModalType = t8.purchaseModalType,
		product = t8.product,
		isCompact = u84,
		model = t8.product.model,
		priceSuffix = v96
	}) else React.createElement(View, {
		LayoutOrder = 1,
		tag = "row align-y-center gap-medium size-full-0 auto-y"
	}, {
		ItemIcon = React.createElement(FoundationImage, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(72, 72),
			ScaleType = Enum.ScaleType.Fit,
			Image = t8.product.itemIcon
		}),
		ItemInfo = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col gap-xxsmall auto-y",
			Size = UDim2.new(1, -84, 0, 0)
		}, {
			ItemName = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "auto-y text-title-medium text-wrap text-align-x-left content-emphasis",
				Size = UDim2.new(1, 0, 0, 0),
				Text = t8.product.itemName or ""
			}),
			ItemPrice = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-y text-title-medium text-align-x-left content-emphasis",
				RichText = true,
				Size = UDim2.new(1, 0, 0, 0),
				Text = utf8.char(57346) .. " " .. tostring(t8.product.itemRobuxCost or 0) .. (v96 or "")
			})
		})
	})
	local v99 = GetFFlagIAPExperienceEnableMultiDisplayUpsell()
	local v100 = not v99 and "col gap-medium auto-y size-full-0 align-x-center align-y-start" or "col align-x-center align-y-start gap-medium size-full-0 auto-y"
	local v101 = not v99 and "col gap-medium auto-y size-full-0 align-x-center align-y-center padding-x-xsmall padding-y-small padding-bottom-xxlarge" or "col align-x-center align-y-start gap-medium size-full-0 auto-y padding-x-xsmall"
	local v102 = not v99 and "row wrap auto-xy align-y-center align-x-center size-full-0 gap-medium" or "row wrap align-x-center align-y-center gap-medium size-full-0 auto-y"
	local v103 = not v99 and "row wrap auto-y align-y-center align-x-center size-full-0 gap-xxsmall" or "row wrap align-x-left align-y-center gap-xxsmall size-full-0 auto-y"
	local v104 = if not u84 then if not v99 then nil else "Medium" else "Small"
	local v105 = not v99 and "col gap-medium auto-y size-full-0 align-x-center align-y-center" or "col align-x-center align-y-center gap-medium size-full-0 auto-y"

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		onClose = t8.buttons.cancelPurchaseActivated,
		snapPoints = {
			v88,
			0.8
		},
		centerSheetHeight = if not FFlagFixUpsellModalUnevenLayout then if not v99 then nil else v88 else nil,
		ref = if not v85 then v91 else nil
	}, {
		Header = React.createElement(Sheet.Header, {
			hasCloseAffordance = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else not not t8.hideUserRobuxBalance or nil
		}, {
			ModalHeader = React.createElement(UnifiedPurchaseModalHeader, {
				titleText = v89,
				robuxBalanceAmount = t8.userBalance,
				hideUserRobuxBalance = if not FFlagUnifiedPurchaseFlowMarketplaceUIImprovements then nil else t8.hideUserRobuxBalance
			})
		}),
		Content = React.createElement(Sheet.Content, {
			LayoutOrder = 2
		}, {
			SheetContentContainer = React.createElement(View, {
				tag = v100
			}, {
				ProductDetailsContainer = v98 or React.createElement(View, {
					LayoutOrder = 1,
					tag = v105
				}, {
					ProductDetails = if t8.purchaseModalType ~= UnifiedPurchaseModalTypeEnum.MultiItem then React.createElement(UnifiedProductDetails, {
						isPortrait = false,
						isCompact = u84,
						itemIcon = t8.product.itemIcon,
						itemName = t8.product.itemName,
						itemRobuxCost = t8.product.itemRobuxCost,
						model = t8.product.model,
						priceSuffix = v96
					}) else React.createElement(PriceSummary, {
						amount = t8.product.itemRobuxCost
					})
				}),
				UpsellSuggestions = React.createElement(View, {
					LayoutOrder = 2,
					tag = v101
				}, if not v99 then {
					UpsellPackage1 = React.createElement(UpsellProductDetails, {
						layoutOrder = 1,
						product = t8.upsellSuggestions[1],
						selected = t8.selectedUpsellIndex == 1,
						isCompact = u84,
						onSelected = function() -- line: 706
							-- upvalues: t8 (copy)
							t8.onUpsellSuggestionsSelected(1)
						end
					}),
					UpsellPackage2 = if not (#t8.upsellSuggestions > 1) then nil else React.createElement(UpsellProductDetails, {
						layoutOrder = 2,
						product = t8.upsellSuggestions[2],
						selected = t8.selectedUpsellIndex == 2,
						isCompact = u84,
						onSelected = function() -- line: 716
							-- upvalues: t8 (copy)
							t8.onUpsellSuggestionsSelected(2)
						end,
						badgeType = t8.upsellSuggestions[2].badgeType
					})
				} else (function() -- line: 683
					-- upvalues: t8 (copy), React (copy), UpsellProductDetails (copy), u84 (ref)
					local t9 = {}

					for i, v in ipairs(t8.upsellSuggestions) do
						t9["UpsellPackage" .. tostring(i)] = React.createElement(UpsellProductDetails, {
							layoutOrder = i,
							product = v,
							selected = i == t8.selectedUpsellIndex,
							isCompact = u84,
							onSelected = function() -- line: 692
								-- upvalues: i (copy), t8 (copy)
								local v114 = i

								t8.onUpsellSuggestionsSelected(v114)
							end,
							badgeType = v.badgeType
						})
					end

					return t9
				end)())
			})
		}),
		Actions = React.createElement(Sheet.Actions, {
			LayoutOrder = 3
		}, { React.createElement(View, {
			LayoutOrder = 1,
			tag = v102
		}, {
			React.createElement(Foundation.Button, {
				LayoutOrder = 1,
				text = v97,
				onActivated = t8.buttons.buyItemActivated,
				inputDelay = (not t8.buttons.buyItemEnableInputDelayed or v85) and 0 or 2.5,
				isDisabled = v85,
				ref = v92,
				fillBehavior = FillBehavior.Fill,
				variant = ButtonVariant.Emphasis,
				size = v104
			}),
			DisclosureTerms = React.createElement(View, {
				LayoutOrder = 2,
				tag = v103
			}, {
				DisclosurePayment = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small",
					Text = v83.DisclosurePayment
				}),
				BeforeText = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small",
					Text = parts[1]
				}),
				TextLink = React.createElement(FoundationText, {
					LayoutOrder = 3,
					RichText = true,
					tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small",
					Text = TermsOfUse,
					onActivated = t8.termsOfUseActivated
				}),
				AfterText = React.createElement(FoundationText, {
					LayoutOrder = 4,
					tag = "auto-xy text-body content-default text-align-x-left content-muted text-caption-small",
					Text = parts[2]
				})
			})
		}) })
	})
end
local function UnifiedRobuxUpsellModalContainer(t10: {[any]: any}) -- line: 777
	-- upvalues: React (copy), LocalizationProvider (copy), Localization (copy), LocalizationService (copy), UnifiedRobuxUpsellModal (copy)
	return React.createElement(LocalizationProvider, {
		localization = Localization.new(LocalizationService.RobloxLocaleId)
	}, {
		UnifiedRobuxUpsellModal = React.createElement(UnifiedRobuxUpsellModal, t10)
	})
end

return UnifiedRobuxUpsellModalContainer
