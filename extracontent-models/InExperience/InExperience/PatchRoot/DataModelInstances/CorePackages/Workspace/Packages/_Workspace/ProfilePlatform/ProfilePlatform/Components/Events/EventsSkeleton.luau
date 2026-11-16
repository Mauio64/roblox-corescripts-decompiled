local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Foundation = require(parent.Foundation)
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius
local View = Foundation.View
local useTextSizeOffset = Foundation.Hooks.useTextSizeOffset
local GameCollections = require(parent.GameCollections)
local CollectionViews = require(parent.CollectionViews)
local CollectionCarousel = CollectionViews.CollectionCarousel
local useGetGameTileHeight = GameCollections.useGetGameTileHeight
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens

local function EventsSkeleton(p)
	local v = useLocalization({ events = TextKeys.EventsListTitle })

	local v2 = useTextSizeOffset()
	local v3 = useDesignTokens()
	local getItemHeight = useGetGameTileHeight(
		false,
		"Event",
		true,
		false,
		false,
		v2,
		v3.Size.Size_700 + v3.Size.Size_200
	)

	local renderItem = React.useCallback(function(_, layoutOrder: number, size)
		return
			React.createElement(
				View,
				{ tag = "col gap-medium radius-medium", LayoutOrder = layoutOrder, Size = size },
				{
					ThumbnailSkeleton = React.createElement(Skeleton, {
						LayoutOrder = 1,
						Size = UDim2.fromScale(1, 0.6),
						radius = Radius.Medium
					}),
					NameSkeleton = React.createElement(Skeleton, {
						LayoutOrder = 2,
						Size = UDim2.fromScale(0.8, 0.15),
						radius = Radius.Medium
					}),
					ButtonSkeleton = React.createElement(Skeleton, {
						LayoutOrder = 3,
						Size = UDim2.fromScale(1, 0.1),
						radius = Radius.Medium
					})
				}
			),
			"Skeleton_" .. layoutOrder
	end, {})

	local items = React.useMemo(function()
		local result = {}

		for i = 1, p.numSkeletons do
			table.insert(result, i)
		end

		return result
	end, { p.numSkeletons })

	return React.createElement(CollectionCarousel, {
		scrollingFrameRef = nil,
		title = v.events,
		hideHeaderButton = true,
		items = items,
		renderItem = renderItem,
		getItemHeight = getItemHeight,
		numColumns = 1,
		columnGap = v3.Size.Size_300,
		fractionalItemAmount = 0.33,
		sideMargin = 0
	})
end

return EventsSkeleton
