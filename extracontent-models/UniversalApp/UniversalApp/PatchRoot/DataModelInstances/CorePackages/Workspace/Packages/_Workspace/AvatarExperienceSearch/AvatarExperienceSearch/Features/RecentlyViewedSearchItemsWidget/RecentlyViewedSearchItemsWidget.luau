local AvatarExperienceSearch = script:FindFirstAncestor("AvatarExperienceSearch")
local AvatarExperienceSearchParent = AvatarExperienceSearch.Parent
local React = require(AvatarExperienceSearchParent.React)
local AXCommon = require(AvatarExperienceSearchParent.AXCommon)
local IxpUtils = require(AvatarExperienceSearchParent.IxpUtils)
local RoactGamepad = require(AvatarExperienceSearchParent.RoactGamepad)
local AvatarScreen = require(AvatarExperienceSearchParent.AvatarExperienceNavigation).Enums.AvatarScreen
local useTokens = require(AvatarExperienceSearchParent.Foundation).Hooks.useTokens
local useLocalization = require(AvatarExperienceSearchParent.Localization).Hooks.useLocalization
local useNavigation = require(AvatarExperienceSearchParent.Navigation).useNavigation
local CatalogItemCard = AXCommon.Components.CatalogItemCard.CatalogItemCard
local AvatarExperienceUIKit = require(AvatarExperienceSearchParent.AvatarExperienceUIKit)
local ItemCardThumbnail = AvatarExperienceUIKit.ItemCardComponents.ItemCardThumbnail
local WidgetHeader = AvatarExperienceUIKit.WidgetComponents.WidgetHeader
local WidgetLayout = AvatarExperienceUIKit.WidgetComponents.WidgetLayout
local Carousel = require(AvatarExperienceSearch.Components.Carousel.Carousel)
local SearchLandingPageWidgetEnum = require(AvatarExperienceSearch.Enums.SearchLandingPageWidgetEnum)
local getRbxThumbType = AXCommon.Utils.getRbxThumbType

require(AvatarExperienceSearch.Features.RecentlyViewedSearchItemsWidget.useRecentlyViewedSearchItemsWidgetProps)

local AXRecentlyViewedSearchItemsIXPTest = AXCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest
local t1 = {
	widgetTitleSearchItems = "Feature.Avatar.Label.SearchLandingPage.Title.RecentlyViewedSearchItems",
	widgetTitleAllItems = "Feature.Avatar.Label.SearchLandingPage.Title.RecentlyViewedItems"
}

local function RecentlyViewedSearchItemsWidget(t2: {[any]: any}) -- line: 45
	-- upvalues: useNavigation (copy), useTokens (copy), useLocalization (copy), t1 (copy), IxpUtils (copy), AXRecentlyViewedSearchItemsIXPTest (copy), React (copy), getRbxThumbType (copy), CatalogItemCard (copy), RoactGamepad (copy), ItemCardThumbnail (copy), WidgetLayout (copy), WidgetHeader (copy), AvatarScreen (copy), SearchLandingPageWidgetEnum (copy), Carousel (copy)
	local v23 = useNavigation()
	local v24 = useTokens()
	local v25 = t2.items or {}
	local v26 = useLocalization(t1)
	local v27 = IxpUtils.readTestVariable(AXRecentlyViewedSearchItemsIXPTest.EnabledSaveInCatalog)
	local itemWidth = t2.itemWidth

	if t2.itemsPerRow > 0 and #v25 > t2.itemsPerRow then
		itemWidth = math.floor(itemWidth * 0.95)
	end

	local v29 = React.useCallback(function() -- line: 62
		-- upvalues: v25 (copy), getRbxThumbType (copy), React (copy), CatalogItemCard (copy), RoactGamepad (copy), v24 (copy), ItemCardThumbnail (copy), itemWidth (ref), t2 (copy)
		local t3 = {}

		for v31, v32 in v25 do
			local v33 = `RecentlyViewedSearchItemTile-{ v32.id }`
			local v34 = getRbxThumbType(v32.itemType)
			local v35 = v32.lowestPrice or (v32.priceInRobux or nil)

			if v34 ~= nil then
				t3[v33] = React.createElement(CatalogItemCard, {
					onActivated = v32.onActivated,
					presentationSlot = React.createElement(RoactGamepad.Focusable.Frame, {
						ClipsDescendants = true,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.fromScale(1, 1)
					}, {
						CornerRadius = React.createElement("UICorner", {
							CornerRadius = UDim.new(0, v24.Size.Size_600)
						}),
						Thumbnail = React.createElement(ItemCardThumbnail, {
							url = `rbxthumb://type={ v34 }&id={ v32.id }&w=150&h=150`
						})
					}),
					priceLineContent = if not v32.priceStatus then if not v35 then nil else {
						type = "price",
						price = v35 or 0
					} else {
						type = "text",
						text = v32.priceStatus
					},
					title = v32.name,
					Size = UDim2.fromOffset(itemWidth, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					ref = if v31 ~= 1 then nil else t2.firstSuggestedItemRef,
					nextSelectionDown = t2.nextSelectionDown,
					nextSelectionUp = t2.nextSelectionUp,
					LayoutOrder = v31
				})
			end
		end

		return t3
	end, {
		v25,
		t2.firstSuggestedItemRef,
		t2.nextSelectionDown,
		t2.nextSelectionUp,
		itemWidth
	})

	return React.createElement(WidgetLayout, {
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromScale(1, 1),
		LayoutOrder = t2.LayoutOrder,
		padding = {
			left = UDim.new(0, v24.Size.Size_400),
			right = UDim.new(0, v24.Size.Size_400)
		},
		headerSlot = React.createElement(WidgetHeader, {
			titleText = if not v27 then v26.widgetTitleSearchItems else v26.widgetTitleAllItems,
			seeAllCallback = function() -- line: 117
				-- upvalues: v23 (copy), AvatarScreen (copy), SearchLandingPageWidgetEnum (copy)
				v23.navigate(AvatarScreen.SearchLandingFocusedWidgetPage, {
					widgetType = SearchLandingPageWidgetEnum.RecentlyViewedItems
				})
			end,
			NextSelectionDown = t2.firstSuggestedItemRef,
			NextSelectionUp = t2.nextSelectionUp
		}),
		contentSlot = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.fromScale(1, 0)
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, -v24.Size.Size_600),
				PaddingRight = UDim.new(0, -v24.Size.Size_600)
			}),
			RecentlyViewedSearchItemsWidgetContent = React.createElement(Carousel, {
				itemPadding = v24.Size.Size_250,
				carouselMargin = v24.Size.Size_600
			}, (v29()))
		})
	})
end

return RecentlyViewedSearchItemsWidget
