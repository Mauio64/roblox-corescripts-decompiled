local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local React = require(CorePackages.Packages.React)
local FitFrame = require(CorePackages.Packages.FitFrame)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local FitFrameVertical = FitFrame.FitFrameVertical
local Modules = CoreGui.RobloxGui.Modules
local Utils = require(Modules.AvatarExperience.Common.Utils)
local Constants = require(Modules.AvatarExperience.AvatarEditor.Constants)
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local LoadableGridView = require(Modules.AvatarExperience.Common.Components.LoadableGridView)
local AXRefreshScrollingFrameWithLoadMore = require(Modules.AvatarExperience.Common.Components.AXRefreshScrollingFrameWithLoadMore)
local LoadingBarWithTheme = require(Modules.LuaApp.Components.LoadingBarWithTheme)
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local FoundationText = Foundation.Text
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local FillBehavior = Foundation.Enums.FillBehavior
local v22 = UIBlox.App.Grid.GridMetrics.makeCustomMetricsGetter(Constants.ItemsGridMetrics)
local v23 = React.forwardRef(function(t1: {[any]: any}, p1) -- line: 43
	-- upvalues: React (copy), View (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy), FillBehavior (copy)
	return React.createElement(View, {
		tag = "size-full-1200 padding-x-large",
		BackgroundTransparency = 1,
		ref = p1,
		LayoutOrder = t1.LayoutOrder
	}, {
		LoadMoreButton = React.createElement(Button, {
			onActivated = t1.onActivated,
			text = t1.localized.loadMore,
			variant = ButtonVariant.Standard,
			size = ButtonSize.Medium,
			fillBehavior = FillBehavior.Fill
		})
	})
end)

local function OutfitSelectionGrid(t2: {[any]: any}) -- line: 87
	-- upvalues: useTokens (copy), Constants2 (copy), Utils (copy), React (copy), View (copy), AXRefreshScrollingFrameWithLoadMore (copy), FitFrameVertical (copy), Constants (copy), LoadableGridView (copy), v22 (copy), v23 (copy), LoadingBarWithTheme (copy), FoundationText (copy)
	local v28 = useTokens()
	local contentSizeChanged = t2.contentSizeChanged
	local onLoadMoreButtonActivated = t2.onLoadMoreButtonActivated
	local renderItem = t2.renderItem
	local stylePalette = t2.stylePalette
	local localized = t2.localized
	local v34 = t2.hasMoreItems and #t2.outfitIds == 0
	local v35 = not v34 and t2.outfitIds or nil
	local ShimmerCardsToDisplay = Constants2.ShimmerCardsToDisplay
	local v37 = v35 and #v35 or ShimmerCardsToDisplay
	local v38 = v37 > 0
	local stylePaletteFont = stylePalette.Font
	local v40 = stylePaletteFont.BaseSize * stylePaletteFont.Header2.RelativeSize
	local v41 = if not t2.showCustomOutfitNames then Utils.GridItemHeightGetter(Constants2.ItemTileType.BundleItemTileNoText) else Utils.GridItemHeightGetter(Constants2.ItemTileType.BundleItemTile, v40)
	local forwardRef = t2.forwardRef
	local isFetchingMore = t2.isFetchingMore
	local enableContinuousLoad = t2.enableContinuousLoad
	local v45 = isFetchingMore or v34
	local v46 = not v45 and t2.hasMoreItems
	local v47 = if not v46 or not enableContinuousLoad then nil else t2.loadMoreItems
	local v48 = v46 and not enableContinuousLoad

	return React.createElement(View, {
		tag = "size-full",
		BackgroundTransparency = 1,
		onAbsoluteSizeChanged = t2.absoluteSizeChanged,
		ref = forwardRef
	}, {
		RefreshScrollingFrameWithLoadMore = if not v38 then nil else React.createElement(AXRefreshScrollingFrameWithLoadMore, {
			BackgroundTransparency = 1,
			createEndOfScrollElement = false,
			Selectable = false,
			Position = UDim2.fromOffset(0, 0),
			Size = UDim2.fromScale(1, 1),
			parentAppPage = t2.pageOwner,
			onThresholdReached = v47
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				[React.Change.AbsoluteContentSize] = contentSizeChanged
			}),
			ListWrapper = React.createElement(FitFrameVertical, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				width = UDim.new(1, 0),
				margin = {
					top = Constants.ItemsGridTopPadding,
					bottom = Constants.ItemsGridBottomPadding,
					left = Constants.ItemsGridSidePadding / 2,
					right = Constants.ItemsGridSidePadding / 2
				}
			}, {
				LoadableGridView = React.createElement(LoadableGridView, {
					getItemMetrics = v22,
					items = v35,
					totalNumItems = v37,
					renderItem = renderItem,
					getItemHeight = v41,
					windowHeight = t2.screenSize.Y,
					ref = t2.loadableGridViewRef
				})
			}),
			LoadMoreButton = if not v48 or not v23 then nil else React.createElement(v23, {
				LayoutOrder = 2,
				onActivated = onLoadMoreButtonActivated,
				localized = t2.localized
			}),
			LoadingBar = if not v45 then nil else React.createElement(View, {
				tag = "size-full-0 auto-y",
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, v28.Size.Size_1400)
			}, {
				LoadingBar = React.createElement(LoadingBarWithTheme)
			})
		}),
		EmptyState = not v38 and React.createElement("TextButton", {
			Text = "",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			[React.Event.Activated] = t2.goBack
		}, {
			Content = React.createElement(View, {
				tag = "col align-x-center align-y-center size-full",
				BackgroundTransparency = 1
			}, {
				Label = React.createElement(FoundationText, {
					tag = "text-body-medium text-align-x-center text-align-y-center content-default",
					Text = localized.noItemsLabel
				})
			})
		})
	})
end

return React.memo(OutfitSelectionGrid)
