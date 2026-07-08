local InExperienceShop = script:FindFirstAncestor("InExperienceShop")
local InExperienceShopParent = InExperienceShop.Parent
local React = require(InExperienceShopParent.React)
local Foundation = require(InExperienceShopParent.Foundation)
local View = Foundation.View
local Tabs = Foundation.Tabs
local FillBehavior = Foundation.Enums.FillBehavior
local SharedFlags = require(InExperienceShopParent.SharedFlags)
local TopBar = require(InExperienceShop.Components.TopBar)
local v10 = if not SharedFlags.FFlagEnableReportingFlowForExperienceShop then nil else require(InExperienceShop.Components.ShopAbuseReportOverlay)
local SearchInputContainer = require(InExperienceShop.Components.SearchInput.SearchInputContainer)
local ShopHomePageContainer = require(InExperienceShop.Components.ShopHomePage.ShopHomePageContainer)
local CategoryPageContainer = require(InExperienceShop.Components.CategoryPage.CategoryPageContainer)
local SearchResultsContainer = require(InExperienceShop.Components.SearchResultsPage.SearchResultsContainer)
local ItemDetailsContainer = require(InExperienceShop.Components.ItemDetails.ItemDetailsContainer)
local CreatorEarlyAccessBanner = require(InExperienceShop.Components.CreatorEarlyAccessBanner)

require(InExperienceShop.Types)

local findSection = require(InExperienceShop.Utils.findSection)
local FFlagEnableCreatorEarlyAccessBannerInShop = require(InExperienceShop.Flags.FFlagEnableCreatorEarlyAccessBannerInShop)
local FFlagRemoveBottomPaddingInExperienceShop = require(InExperienceShop.Flags.FFlagRemoveBottomPaddingInExperienceShop)

require(InExperienceShop.Hooks.useShopReportOverflow)

local function ShopView(t1: {[any]: any}) -- line: 101
	-- upvalues: findSection (copy), React (copy), View (copy), SearchInputContainer (copy), TopBar (copy), FFlagRemoveBottomPaddingInExperienceShop (copy), FFlagEnableCreatorEarlyAccessBannerInShop (copy), CreatorEarlyAccessBanner (copy), Tabs (copy), FillBehavior (copy), SearchResultsContainer (copy), ShopHomePageContainer (copy), CategoryPageContainer (copy), ItemDetailsContainer (copy), v10 (copy)
	local isSearchOpen = t1.isSearchOpen
	local v23 = not isSearchOpen and #t1.tabs > 0
	local selectedItem = t1.selectedItem
	local v25 = t1.selectedCategoryId == "home" or findSection(t1.sections, t1.selectedCategoryId) == nil
	local v26 = React.createElement(View, {
		tag = "row align-y-center size-full-1200",
		LayoutOrder = 1
	}, {
		Search = if not isSearchOpen then nil else React.createElement(SearchInputContainer, {
			text = t1.searchQuery,
			onTextChanged = t1.onSearchQueryChanged,
			onSearchSubmit = t1.onSearchSubmit,
			onBack = t1.onSearchCancel
		}),
		TopBar = if isSearchOpen then nil else React.createElement(TopBar, {
			onClose = t1.onClose,
			onSearchOpen = t1.onSearchOpen,
			isReportingEnabled = t1.isReportingEnabled,
			isOverflowMenuOpen = t1.isOverflowMenuOpen,
			onOverflowActivated = t1.onOverflowActivated,
			onOverflowMenuClosed = t1.onOverflowMenuClosed,
			onMenuItemActivated = t1.onMenuItemActivated
		})
	})
	local v27 = FFlagRemoveBottomPaddingInExperienceShop()

	return React.createElement(View, {
		tag = {
			["data-testid=ShopView"] = true,
			["size-full"] = true,
			["padding-x-large padding-top-medium"] = t1.fullScreen and v27,
			["padding-x-large padding-bottom-xlarge padding-top-medium"] = t1.fullScreen and not v27
		}
	}, {
		Content = React.createElement(View, {
			tag = "size-full radius-medium clip",
			backgroundStyle = {
				Color3 = t1.overMediaColor,
				Transparency = t1.overMediaTransparency
			}
		}, {
			ShopLayer = React.createElement(View, {
				tag = "col size-full",
				Visible = selectedItem == nil
			}, {
				TopRow = v26,
				EarlyAccessBanner = if not FFlagEnableCreatorEarlyAccessBannerInShop() or isSearchOpen then nil else React.createElement(View, {
					tag = "size-full-0 auto-y padding-x-xlarge",
					LayoutOrder = 2
				}, {
					Banner = React.createElement(CreatorEarlyAccessBanner)
				}),
				Categories = if not v23 then nil else React.createElement(View, {
					tag = "size-full-0 auto-y padding-x-xlarge",
					LayoutOrder = 3
				}, {
					Tabs = React.createElement(Tabs, {
						activeTabId = t1.selectedCategoryId,
						onActivated = t1.onCategorySelected,
						fillBehavior = FillBehavior.Fit,
						tabs = t1.tabs
					})
				}),
				PageSlot = React.createElement(View, {
					tag = "col fill size-full-0 padding-top-medium",
					LayoutOrder = 4,
					onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged
				}, {
					Search = if not isSearchOpen then nil else React.createElement(SearchResultsContainer, {
						sections = t1.sections,
						committedQuery = t1.committedQuery,
						itemsPerRow = t1.itemsPerRow,
						onItemActivated = t1.onItemActivated
					}),
					Home = if isSearchOpen then nil else React.createElement(ShopHomePageContainer, {
						sections = t1.sections,
						itemsPerRow = t1.itemsPerRow,
						onCategoryActivated = t1.onCategorySelected,
						onItemActivated = t1.onItemActivated,
						Visible = v25
					}),
					Category = if isSearchOpen or v25 then nil else React.createElement(CategoryPageContainer, {
						sections = t1.sections,
						sectionId = t1.selectedCategoryId,
						itemsPerRow = t1.itemsPerRow,
						onItemActivated = t1.onItemActivated
					})
				})
			}),
			Details = if selectedItem == nil then nil else React.createElement(ItemDetailsContainer, {
				item = selectedItem,
				disableBuy = t1.selectedItemDisableBuy,
				onClose = t1.onDetailsClose
			})
		}),
		ReportOverlay = if not t1.topBarReportSession or not v10 then nil else React.createElement(v10, {
			abuseVector = t1.topBarReportSession.abuseVector,
			targetId = t1.topBarReportSession.targetId,
			onClose = t1.onTopBarReportClose
		})
	})
end

return ShopView
