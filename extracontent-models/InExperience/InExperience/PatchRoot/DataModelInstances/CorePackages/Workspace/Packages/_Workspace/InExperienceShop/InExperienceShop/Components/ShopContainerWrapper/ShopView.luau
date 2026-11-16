local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local parent = InExperienceShop.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local IAPExperience = require(parent.IAPExperience)
local UnifiedPurchaseCompletionModal = IAPExperience.UnifiedPurchaseCompletionModal
local FFlagShopRobuxPurchaseCompletionModal = require(InExperienceShop.Flags.FFlagShopRobuxPurchaseCompletionModal)
local View = Foundation.View
local Tabs = Foundation.Tabs
local FillBehavior = Foundation.Enums.FillBehavior
local useTokens = Foundation.Hooks.useTokens

local SharedFlags = require(parent.SharedFlags)
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies
local FFlagHideHeaderForBuyRobuxInExperienceShop = SharedFlags.FFlagHideHeaderForBuyRobuxInExperienceShop

local TopBar = require(InExperienceShop.Components.TopBar)
local ShopAbuseReportOverlay

if SharedFlags.FFlagEnableReportingFlowForExperienceShop then
	ShopAbuseReportOverlay = require(InExperienceShop.Components.ShopAbuseReportOverlay)
else
	ShopAbuseReportOverlay = nil
end

local SearchInputContainer = require(InExperienceShop.Components.SearchInput.SearchInputContainer)
local OfferDetailsDialog = require(InExperienceShop.Components.OfferDialogs.OfferDetailsDialog)
local OfferTermsDialog = require(InExperienceShop.Components.OfferDialogs.OfferTermsDialog)

local TrialRedemptionErrorDialogContainer = require(InExperienceShop.Components.TrialRedemptionErrorDialog.TrialRedemptionErrorDialogContainer)
local ShopHomePageContainer = require(InExperienceShop.Components.ShopHomePage.ShopHomePageContainer)
local CategoryPageContainer = require(InExperienceShop.Components.CategoryPage.CategoryPageContainer)
local SearchResultsContainer = require(InExperienceShop.Components.SearchResultsPage.SearchResultsContainer)
local ItemDetailsContainer = require(InExperienceShop.Components.ItemDetails.ItemDetailsContainer)
local CreatorEarlyAccessBanner = require(InExperienceShop.Components.CreatorEarlyAccessBanner)
local DesktopOfferBanner = require(InExperienceShop.Components.DesktopOfferBanner)
require(InExperienceShop.Types)
local findSection = require(InExperienceShop.Utils.findSection)
local OfferDialogState = require(InExperienceShop.Components.OfferDialogs.OfferDialogState)
require(InExperienceShop.Hooks.useShopOfferChip)

local FFlagEnableCreatorEarlyAccessBannerInShop = require(InExperienceShop.Flags.FFlagEnableCreatorEarlyAccessBannerInShop)
local FFlagRemoveBottomPaddingInExperienceShop = require(InExperienceShop.Flags.FFlagRemoveBottomPaddingInExperienceShop)
local FFlagShopBlockClickPassThrough = require(InExperienceShop.Flags.FFlagShopBlockClickPassThrough)
local FFlagShowLargerOfferBannerOnDesktop2 = require(InExperienceShop.Flags.FFlagShowLargerOfferBannerOnDesktop2)
local FFlagLuaAppEnableGamePassFreeTrials = require(InExperienceShop.Flags.FFlagLuaAppEnableGamePassFreeTrials)
require(InExperienceShop.Hooks.useShopReportOverflow)

local function ShopView(props)
	local isSearchOpen = props.isSearchOpen
	local v = not isSearchOpen and #props.tabs > 0

	if FFlagHideHeaderForBuyRobuxInExperienceShop then
		v = v and not props.hideTabs
	end

	local selectedItem = props.selectedItem

	local visible = props.selectedCategoryId == "home" or findSection(props.sections, props.selectedCategoryId) == nil

	local offerModal = props.offer.offerModal
	local v2 = FFlagShowLargerOfferBannerOnDesktop2 and isSubjectToDesktopPolicies()

	local v3 = v2 and not isSearchOpen and visible and props.offer.showOfferChip and offerModal ~= nil

	local createElement = React.createElement
	local search

	if isSearchOpen then
		search = React.createElement(SearchInputContainer, {
			text = props.searchQuery,
			onTextChanged = props.onSearchQueryChanged,
			onSearchSubmit = props.onSearchSubmit,
			onBack = props.onSearchCancel
		})
	end

	local topBar

	if not isSearchOpen then
		topBar = React.createElement(TopBar, {
			onClose = props.onClose,
			onSearchOpen = props.onSearchOpen,
			isReportingEnabled = props.isReportingEnabled,
			isOverflowMenuOpen = props.isOverflowMenuOpen,
			onOverflowActivated = props.onOverflowActivated,
			onOverflowMenuClosed = props.onOverflowMenuClosed,
			onMenuItemActivated = props.onMenuItemActivated,
			showOfferChip = props.offer.showOfferChip and not v2,
			offerChipText = props.offer.offerChipText,
			offerChipIcon = props.offer.offerChipIcon,
			onOfferChipActivated = props.offer.onOfferChipActivated
		})
	end

	local element = createElement(View, {
		tag = "row align-y-center size-full-1200",
		LayoutOrder = 1
	}, {
		Search = search,
		TopBar = topBar
	})
	local offerBanner

	if v3 and offerModal ~= nil then
		offerBanner = React.createElement(
			View,
			{ tag = "size-full-0 auto-y padding-x-xlarge padding-top-medium", LayoutOrder = 4 },
			{
				Banner = React.createElement(DesktopOfferBanner, {
					text = props.offer.offerBodyText,
					icon = props.offer.offerChipIcon,
					link = offerModal.termsAndConditions ~= nil and {
						text = props.offer.offerViewTermsText,
						onActivated = props.offer.onOfferViewTerms
					} or nil,
					testId = "DesktopOfferBanner"
				})
			}
		)
	end

	local fFlagRemoveBottomPaddingInExperienceShop = FFlagRemoveBottomPaddingInExperienceShop()
	local fFlagShopBlockClickPassThrough = FFlagShopBlockClickPassThrough()
	local v4

	if fFlagShopBlockClickPassThrough then
		v4 = useTokens()
	end

	local createElement2 = React.createElement
	local v5 = {
		tag = {
			["data-testid=ShopView"] = true,
			["size-full"] = true,
			["padding-x-large padding-top-medium"] = props.fullScreen and fFlagRemoveBottomPaddingInExperienceShop,
			["padding-x-large padding-bottom-xlarge padding-top-medium"] = props.fullScreen and not fFlagRemoveBottomPaddingInExperienceShop
		}
	}

	local createElement3 = React.createElement
	local v6

	if fFlagShopBlockClickPassThrough then
		v6 = {
			Active = true,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = props.overMediaColor,
			BackgroundTransparency = props.overMediaTransparency,
			ClipsDescendants = true
		}
	else
		v6 = {
			tag = "size-full radius-medium clip",
			backgroundStyle = {
				Color3 = props.overMediaColor,
				Transparency = props.overMediaTransparency
			}
		}
	end

	local corner

	if fFlagShopBlockClickPassThrough then
		corner = React.createElement("UICorner", { CornerRadius = UDim.new(0, v4.Radius.Medium) })
	end

	local createElement4 = React.createElement
	local v7 = {
		tag = "col size-full",
		Visible = selectedItem == nil
	}
	local earlyAccessBanner

	if FFlagEnableCreatorEarlyAccessBannerInShop() and not isSearchOpen then
		earlyAccessBanner = React.createElement(
			View,
			{ tag = "size-full-0 auto-y padding-x-xlarge", LayoutOrder = 2 },
			{
				Banner = React.createElement(CreatorEarlyAccessBanner)
			}
		)
	end

	local categories

	if v then
		categories = React.createElement(View, {
			tag = "size-full-0 auto-y padding-x-xlarge",
			LayoutOrder = 3
		}, {
			Tabs = React.createElement(Tabs, {
				activeTabId = props.selectedCategoryId,
				onActivated = props.onCategorySelected,
				fillBehavior = FillBehavior.Fit,
				tabs = props.tabs
			})
		})
	end

	local createElement5 = React.createElement
	local v8 = {
		tag = "col fill size-full-0 padding-top-medium",
		LayoutOrder = FFlagShowLargerOfferBannerOnDesktop2 and 5 or 4,
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged
	}
	local search2

	if isSearchOpen then
		search2 = React.createElement(SearchResultsContainer, {
			sections = props.sections,
			committedQuery = props.committedQuery,
			itemsPerRow = props.itemsPerRow,
			onItemActivated = props.onItemActivated
		})
	end

	local home

	if not isSearchOpen then
		home = React.createElement(ShopHomePageContainer, {
			sections = props.sections,
			itemsPerRow = props.itemsPerRow,
			onCategoryActivated = props.onCategorySelected,
			onItemActivated = props.onItemActivated,
			Visible = visible
		})
	end

	local category

	if not (isSearchOpen or visible) then
		category = React.createElement(CategoryPageContainer, {
			sections = props.sections,
			sectionId = props.selectedCategoryId,
			itemsPerRow = props.itemsPerRow,
			onItemActivated = props.onItemActivated
		})
	end

	local v9 = {
		Corner = corner,
		ShopLayer = createElement4(View, v7, {
			TopRow = element,
			EarlyAccessBanner = earlyAccessBanner,
			Categories = categories,
			OfferBanner = offerBanner,
			PageSlot = createElement5(View, v8, {
				Search = search2,
				Home = home,
				Category = category
			})
		}),
		Details = 0
	}
	local details

	if selectedItem ~= nil then
		details = React.createElement(ItemDetailsContainer, {
			item = selectedItem,
			disableBuy = props.selectedItemDisableBuy,
			onClose = props.onDetailsClose
		})
	end

	v9.Details = details
	local v10 = {
		Content = createElement3(fFlagShopBlockClickPassThrough and "Frame" or View, v6, v9),
		RobuxPurchaseSuccess = 0,
		ReportOverlay = 0,
		OfferDetails = 0,
		OfferTerms = 0,
		TrialRedemptionError = 0
	}
	local robuxPurchaseSuccess

	if FFlagShopRobuxPurchaseCompletionModal and props.robuxPurchaseSuccess ~= nil then
		robuxPurchaseSuccess = React.createElement(UnifiedPurchaseCompletionModal, {
			bodyText = props.robuxPurchaseSuccess.bodyText,
			buttons = {
				onActivated = props.robuxPurchaseSuccess.onClose,
				onClose = props.robuxPurchaseSuccess.onClose
			}
		})
	end

	v10.RobuxPurchaseSuccess = robuxPurchaseSuccess
	local reportOverlay

	if props.topBarReportSession and ShopAbuseReportOverlay then
		reportOverlay = React.createElement(ShopAbuseReportOverlay, {
			abuseVector = props.topBarReportSession.abuseVector,
			targetId = props.topBarReportSession.targetId,
			onClose = props.onTopBarReportClose
		})
	end

	v10.ReportOverlay = reportOverlay
	local offerDetails

	if props.offer.offerDialog == OfferDialogState.Details and props.offer.offerModal ~= nil then
		offerDetails = React.createElement(OfferDetailsDialog, {
			modal = props.offer.offerModal,
			expirationTimeInUTC = props.offer.offerExpirationTimeInUTC,
			onShopNow = props.offer.onOfferShopNow,
			onViewTerms = props.offer.onOfferViewTerms,
			onClose = props.offer.onOfferDetailsClose
		})
	end

	v10.OfferDetails = offerDetails
	local offerTerms

	if
		props.offer.offerDialog == OfferDialogState.Terms
		and props.offer.offerModal ~= nil
		and props.offer.offerModal.termsAndConditions ~= nil
	then
		offerTerms = React.createElement(OfferTermsDialog, {
			terms = props.offer.offerModal.termsAndConditions,
			onClose = props.offer.onOfferTermsClose
		})
	end

	v10.OfferTerms = offerTerms
	local trialRedemptionError

	if FFlagLuaAppEnableGamePassFreeTrials then
		trialRedemptionError = React.createElement(TrialRedemptionErrorDialogContainer)
	end

	v10.TrialRedemptionError = trialRedemptionError
	return createElement2(View, v5, v10)
end

return ShopView
