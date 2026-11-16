local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local Foundation = require(CorePackages.Packages.Foundation)
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local UIBlox = require(CorePackages.Packages.UIBlox)
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset

local module = require("@luauforge/bundled/fYU")
local gameTileConstants = module.GameTileConstants
local module2 = require("@luauforge/deferred/gao")
local useGameCollectionLayoutParams = module2.useGameCollectionLayoutParams
local useGetGameTileHeight = module2.useGetGameTileHeight
local useCollectionSizeBindings = require("@luauforge/bundled/edJ").useCollectionSizeBindings
local module3 = require("@luauforge/bundled/cyO")

local fIntSearchLandingPageSideMargin = require("@luauforge/bundled/dpZ").Modules.Personalization.Search.FIntSearchLandingPageSideMargin

local GAME_CAROUSEL_SIDE_COMPACT_PADDING = module3.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING

function LUAUFORGE_MODULE_GLOBALS_hOc_SearchLandingPageSkeleton(props)
	local state, setState = React.useState(nil)
	local v5 = useTextSizeOffset()
	local v6 = useTokens()

	local narrow = module.GameTileTypes.GameTileLayoutType.Narrow
	local v7 = useGetGameTileHeight(
		true,
		narrow,
		false,
		false,
		false,
		v5,
		nil,
		gameTileConstants.TileTextLines[narrow] and gameTileConstants.TileTextLines[narrow].titleTextLines
	)
	local v8

	if props.isCompactView then
		v8 = GAME_CAROUSEL_SIDE_COMPACT_PADDING
	else
		v8 = fIntSearchLandingPageSideMargin
	end

	local v9 = useGameCollectionLayoutParams(
		narrow,
		state,
		false,
		{ sideMargin = v8 },
		props.defaultContainerSize
	)

	local v10, v11, v12, v13 = useCollectionSizeBindings(
		v9.numColumns,
		v9.columnGap,
		v9.sideMargin,
		v9.fractionalItemAmount,
		v7,
		nil
	)

	local v14 = React.useMemo(function()
		local children = {}

		for i = 1, v9.numColumns + math.ceil(v9.fractionalItemAmount) do
			children[`GameTileSkeleton_{i}`] = React.createElement(view, {
				tag = "col flex-y-between",
				Size = v10:map(function(p2)
					return UDim2.new(0, p2.X, 0, p2.Y)
				end),
				LayoutOrder = i
			}, {
				MainView = React.createElement(
					view,
					{ tag = "col align-x-left size-full-0 auto-y", LayoutOrder = 1 },
					{
						Icon = React.createElement(view, {
							Size = v10:map(function(p2)
								return UDim2.fromOffset(p2.X, p2.X)
							end),
							LayoutOrder = 1
						}, {
							IconSkeleton = React.createElement(skeleton, {
								Size = UDim2.fromScale(1, 1),
								radius = radius.Medium
							})
						}),
						PaddingBetweenIconAndTitle = React.createElement(view, {
							Size = UDim2.new(1, 0, 0, v6.Padding.Medium),
							LayoutOrder = 2
						}),
						FirstTitleLine = React.createElement(skeleton, {
							Size = UDim2.new(1, 0, 0, v6.Typography.BodyMedium.FontSize),
							LayoutOrder = 3
						}),
						PaddingBetweenTitleLines = React.createElement(view, {
							Size = UDim2.new(1, 0, 0, v6.Typography.BodyMedium.LineHeight),
							LayoutOrder = 4
						}),
						SecondTitleLine = React.createElement(skeleton, {
							Size = UDim2.new(0.7, 0, 0, v6.Typography.BodyMedium.FontSize),
							LayoutOrder = 5
						})
					}
				),
				Rating = React.createElement(skeleton, {
					Size = UDim2.new(1, 0, 0, v6.Size.Size_500),
					LayoutOrder = 2
				})
			})
		end

		return children
	end, {
		v9.numColumns,
		v9.fractionalItemAmount,
		v6.Typography.BodyMedium.FontSize,
		v6.Padding.Small,
		v6.Padding.Medium,
		v6.Size.Size_500,
		v6.Typography.BodyMedium.LineHeight,
		state
	})

	return React.createElement(view, {
		ref = function(p2)
			setState(p2)
			v13(p2)
		end,
		LayoutOrder = props.LayoutOrder,
		Size = props.Size,
		ClipsDescendants = true,
		onAbsoluteSizeChanged = v12
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			[React.Change.AbsoluteContentSize] = props.onAbsoluteContentSizeChanged
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v8),
			PaddingRight = UDim.new(0, v8)
		}),
		TopPadding = React.createElement(view, {
			Size = UDim2.new(1, 0, 0, props.topPadding or 0),
			LayoutOrder = 1
		}),
		TitleSkeleton = React.createElement(skeleton, {
			Size = UDim2.new(0, v6.Size.Size_3000, 0, v6.Typography.HeadingSmall.FontSize),
			LayoutOrder = 2
		}),
		PaddingBetweenHeaderAndItems = React.createElement(view, {
			Size = UDim2.new(1, 0, 0, v6.Padding.Large),
			LayoutOrder = 3
		}),
		CarouselSkeleton = React.createElement(view, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 4
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v9.columnGap)
			})
		}, v14),
		BottomPadding = React.createElement(view, {
			Size = UDim2.new(1, 0, 0, props.bottomPadding or 0),
			LayoutOrder = 5
		})
	})
end

return LUAUFORGE_MODULE_GLOBALS_hOc_SearchLandingPageSkeleton
