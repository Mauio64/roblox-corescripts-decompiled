local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local useTextSizeOffset = require(CorePackages.Packages.UIBlox).Core.Style.useTextSizeOffset
local GameTile = require(CorePackages.Workspace.Packages.GameTile)
local GameTileConstants = GameTile.GameTileConstants
local GameCollections = require(CorePackages.Workspace.Packages.GameCollections)
local useGameCollectionLayoutParams = GameCollections.useGameCollectionLayoutParams
local useGetGameTileHeight = GameCollections.useGetGameTileHeight
local useCollectionSizeBindings = require(CorePackages.Workspace.Packages.CollectionViews).useCollectionSizeBindings
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local FIntSearchLandingPageSideMargin = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.Personalization.Search.FIntSearchLandingPageSideMargin
local GAME_CAROUSEL_SIDE_COMPACT_PADDING = DiscoveryTypes.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING

function SearchLandingPageSkeleton(t1: {[any]: any}) -- line: 39
	-- upvalues: React (copy), useTextSizeOffset (copy), useTokens (copy), GameTile (copy), GameTileConstants (copy), useGetGameTileHeight (copy), GAME_CAROUSEL_SIDE_COMPACT_PADDING (copy), FIntSearchLandingPageSideMargin (copy), useGameCollectionLayoutParams (copy), useCollectionSizeBindings (copy), View (copy), Skeleton (copy), EnumsRadius (copy)
	local v19, v20 = React.useState(nil)
	local v21 = useTextSizeOffset()
	local v22 = useTokens()
	local Narrow = GameTile.GameTileTypes.GameTileLayoutType.Narrow
	local v24 = GameTileConstants.TileTextLines[Narrow] and GameTileConstants.TileTextLines[Narrow].titleTextLines
	local v25 = useGetGameTileHeight(true, Narrow, false, false, false, v21, nil, v24)
	local v26 = if not t1.isCompactView then FIntSearchLandingPageSideMargin else GAME_CAROUSEL_SIDE_COMPACT_PADDING
	local v27 = useGameCollectionLayoutParams(Narrow, v19, false, {
		sideMargin = v26
	}, t1.defaultContainerSize)
	local v28, _, v30, v31 = useCollectionSizeBindings(v27.numColumns, v27.columnGap, v27.sideMargin, v27.fractionalItemAmount, v25, nil)
	local v32 = React.useMemo(function() -- line: 74
		-- upvalues: v27 (copy), React (copy), View (copy), v28 (copy), Skeleton (copy), EnumsRadius (copy), v22 (copy)
		local t2 = {}

		for i = 1, v27.numColumns + math.ceil(v27.fractionalItemAmount) do
			t2[`GameTileSkeleton_{ i }`] = React.createElement(View, {
				tag = "col flex-y-between",
				Size = v28:map(function(vector2: Vector2) -- line: 80
					return UDim2.new(0, vector2.X, 0, vector2.Y)
				end),
				LayoutOrder = i
			}, {
				MainView = React.createElement(View, {
					tag = "col align-x-left size-full-0 auto-y",
					LayoutOrder = 1
				}, {
					Icon = React.createElement(View, {
						LayoutOrder = 1,
						Size = v28:map(function(vector2: Vector2) -- line: 90
							return UDim2.fromOffset(vector2.X, vector2.X)
						end)
					}, {
						IconSkeleton = React.createElement(Skeleton, {
							Size = UDim2.fromScale(1, 1),
							radius = EnumsRadius.Medium
						})
					}),
					PaddingBetweenIconAndTitle = React.createElement(View, {
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 0, v22.Padding.Medium)
					}),
					FirstTitleLine = React.createElement(Skeleton, {
						LayoutOrder = 3,
						Size = UDim2.new(1, 0, 0, v22.Typography.BodyMedium.FontSize)
					}),
					PaddingBetweenTitleLines = React.createElement(View, {
						LayoutOrder = 4,
						Size = UDim2.new(1, 0, 0, v22.Typography.BodyMedium.LineHeight)
					}),
					SecondTitleLine = React.createElement(Skeleton, {
						LayoutOrder = 5,
						Size = UDim2.new(0.7, 0, 0, v22.Typography.BodyMedium.FontSize)
					})
				}),
				Rating = React.createElement(Skeleton, {
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, v22.Size.Size_500)
				})
			})
		end

		return t2
	end, {
		v27.numColumns,
		v27.fractionalItemAmount,
		v22.Typography.BodyMedium.FontSize,
		v22.Padding.Small,
		v22.Padding.Medium,
		v22.Size.Size_500,
		v22.Typography.BodyMedium.LineHeight,
		v19
	})

	return React.createElement(View, {
		ClipsDescendants = true,
		ref = function(p1) -- line: 143
			-- upvalues: v20 (copy), v31 (copy)
			v20(p1)
			v31(p1)
		end,
		LayoutOrder = t1.LayoutOrder,
		Size = t1.Size,
		onAbsoluteSizeChanged = v30
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			[React.Change.AbsoluteContentSize] = t1.onAbsoluteContentSizeChanged
		}),
		Padding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v26),
			PaddingRight = UDim.new(0, v26)
		}),
		TopPadding = React.createElement(View, {
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, t1.topPadding or 0)
		}),
		TitleSkeleton = React.createElement(Skeleton, {
			LayoutOrder = 2,
			Size = UDim2.new(0, v22.Size.Size_3000, 0, v22.Typography.HeadingSmall.FontSize)
		}),
		PaddingBetweenHeaderAndItems = React.createElement(View, {
			LayoutOrder = 3,
			Size = UDim2.new(1, 0, 0, v22.Padding.Large)
		}),
		CarouselSkeleton = React.createElement(View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 4
		}, {
			Layout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v27.columnGap)
			})
		}, v32),
		BottomPadding = React.createElement(View, {
			LayoutOrder = 5,
			Size = UDim2.new(1, 0, 0, t1.bottomPadding or 0)
		})
	})
end

return SearchLandingPageSkeleton
