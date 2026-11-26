local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local FitFrame = require(CorePackages.Packages.FitFrame)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)

local fitFrameVertical = FitFrame.FitFrameVertical

local module = require("@luauforge/bundled/fCe")
local module2 = require("@luauforge/deferred/gRU")
local module3 = require("@luauforge/bundled/dRg")
local module4 = require("@luauforge/bundled/dPN")
local DefaultMetricsGridView = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Grid/DefaultMetricsGridView")

local module6 = require("@luauforge/deferred/gSa")

local fFlagAXScrollTelemetryIntegration2 = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXScrollTelemetryIntegration2
local module7 = require("@luauforge/bundled/egE")

local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View
local text = Foundation.Text
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonSize = Foundation.Enums.ButtonSize
local fillBehavior = Foundation.Enums.FillBehavior

local customMetricsGetter = UIBlox.App.Grid.GridMetrics.makeCustomMetricsGetter(module3.ItemsGridMetrics)

local forwardRef = React.forwardRef(function(props, p2)
	return React.createElement(
		view,
		{
			tag = "size-full-1200 padding-x-large",
			BackgroundTransparency = 1,
			ref = p2,
			LayoutOrder = props.LayoutOrder
		},
		{
			LoadMoreButton = React.createElement(button, {
				onActivated = props.onActivated,
				text = props.localized.loadMore,
				variant = buttonVariant.Standard,
				size = buttonSize.Medium,
				fillBehavior = fillBehavior.Fill
			})
		}
	)
end)

local function OutfitSelectionGrid(props)
	local v5 = useTokens()
	local contentSizeChanged = props.contentSizeChanged
	local onLoadMoreButtonActivated = props.onLoadMoreButtonActivated
	local renderItem = props.renderItem

	local stylePalette = props.stylePalette
	local localized = props.localized
	local v6 = props.hasMoreItems and #props.outfitIds == 0

	local outfitIds = if not v6 then props.outfitIds or nil else nil
	local shimmerCardsToDisplay = module4.ShimmerCardsToDisplay
	local v7 = outfitIds and (#outfitIds or shimmerCardsToDisplay) or shimmerCardsToDisplay
	local v8 = v7 > 0
	local font = stylePalette.Font
	local v9 = font.BaseSize * font.Header2.RelativeSize
	local v10

	if props.showCustomOutfitNames then
		v10 = module.GridItemHeightGetter(module4.ItemTileType.BundleItemTile, v9)
	else
		v10 = module.GridItemHeightGetter(module4.ItemTileType.BundleItemTileNoText)
	end

	local forwardRef2 = props.forwardRef

	local isFetchingMore = props.isFetchingMore
	local enableContinuousLoad = props.enableContinuousLoad
	local v11 = isFetchingMore or v6
	local hasMoreItems = not v11 and props.hasMoreItems
	local loadMoreItems = if hasMoreItems and enableContinuousLoad then props.loadMoreItems else nil
	local v12 = hasMoreItems and not enableContinuousLoad
	local createElement = React.createElement
	local v14 = {
		tag = "size-full",
		BackgroundTransparency = 1,
		onAbsoluteSizeChanged = props.absoluteSizeChanged,
		ref = forwardRef2
	}
	local v16

	if v8 then
		local createElement2 = React.createElement
		local v18 = {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 0),
			Size = UDim2.fromScale(1, 1),
			createEndOfScrollElement = false,
			parentAppPage = props.pageOwner,
			scrollPerformanceIntervalName = 0,
			onThresholdReached = 0,
			Selectable = false
		}

		local v19 = if fFlagAXScrollTelemetryIntegration2 then module2.OutfitGrid else nil
		v18.scrollPerformanceIntervalName = v19

		v18.onThresholdReached = loadMoreItems

		local children = {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				[React.Change.AbsoluteContentSize] = contentSizeChanged
			}),
			ListWrapper = React.createElement(fitFrameVertical, {
				width = UDim.new(1, 0),
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				margin = {
					top = module3.ItemsGridTopPadding,
					bottom = module3.ItemsGridBottomPadding + (props.bottomContentPadding or 0),
					left = module3.ItemsGridSidePadding / 2,
					right = module3.ItemsGridSidePadding / 2
				}
			}, {
				LoadableGridView = React.createElement(DefaultMetricsGridView, {
					getItemMetrics = customMetricsGetter,
					items = outfitIds,
					totalNumItems = v7,
					renderItem = renderItem,
					getItemHeight = v10,
					windowHeight = props.screenSize.Y,
					ref = props.loadableGridViewRef
				})
			}),
			LoadMoreButton = 0,
			LoadingBar = 0
		}

		local v20 = if v12 and forwardRef then React.createElement(forwardRef, {
			onActivated = onLoadMoreButtonActivated,
			LayoutOrder = 2,
			localized = props.localized
		}) else nil
		children.LoadMoreButton = v20

		local v21 = if v11 then React.createElement(
			view,
			{
				tag = "size-full-0 auto-y",
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, v5.Size.Size_1400),
				LayoutOrder = 3
			},
			{ LoadingBar = React.createElement(module7) }
		) else nil
		children.LoadingBar = v21
		v16 = createElement2(module6, v18, children)
	end

	local v17 = not v8

	if v17 then
		v17 = React.createElement("TextButton", {
			Text = "",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			[React.Event.Activated] = props.goBack
		}, {
			Content = React.createElement(
				view,
				{
					tag = "col align-x-center align-y-center size-full",
					BackgroundTransparency = 1
				},
				{
					Label = React.createElement(text, {
						tag = "text-body-medium text-align-x-center text-align-y-center content-default",
						Text = localized.noItemsLabel
					})
				}
			)
		})
	end

	return createElement(view, v14, {
		RefreshScrollingFrameWithLoadMore = v16,
		EmptyState = v17
	})
end

return React.memo(OutfitSelectionGrid)
