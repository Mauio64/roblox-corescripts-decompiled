local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius
local view = Foundation.View
local useTextSizeOffset = Foundation.Hooks.useTextSizeOffset
local GameCollections = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/GameCollections")
local collectionCarousel = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/CollectionViews").CollectionCarousel
local useGetGameTileHeight = GameCollections.useGetGameTileHeight
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Style").useDesignTokens

local function EventsSkeleton(p2)
	local v5 = useLocalization({ events = TextKeys.EventsListTitle })

	local v6 = useTextSizeOffset()
	local v7 = useDesignTokens()
	local v8 = useGetGameTileHeight(
		false,
		"Event",
		true,
		false,
		false,
		v6,
		v7.Size.Size_700 + v7.Size.Size_200
	)

	local v9 = React.useCallback(function(p3, p4, p5)
		return
			React.createElement(
				view,
				{ tag = "col gap-medium radius-medium", LayoutOrder = p4, Size = p5 },
				{
					ThumbnailSkeleton = React.createElement(skeleton, {
						LayoutOrder = 1,
						Size = UDim2.fromScale(1, 0.6),
						radius = radius.Medium
					}),
					NameSkeleton = React.createElement(skeleton, {
						LayoutOrder = 2,
						Size = UDim2.fromScale(0.8, 0.15),
						radius = radius.Medium
					}),
					ButtonSkeleton = React.createElement(skeleton, {
						LayoutOrder = 3,
						Size = UDim2.fromScale(1, 0.1),
						radius = radius.Medium
					})
				}
			),
			"Skeleton_" .. p4
	end, {})

	local v10 = React.useMemo(function()
		local result = {}

		for i = 1, p2.numSkeletons do
			table.insert(result, i)
		end

		return result
	end, { p2.numSkeletons })

	return React.createElement(collectionCarousel, {
		scrollingFrameRef = nil,
		title = v5.events,
		hideHeaderButton = true,
		items = v10,
		renderItem = v9,
		getItemHeight = v8,
		numColumns = 1,
		columnGap = v7.Size.Size_300,
		fractionalItemAmount = 0.33,
		sideMargin = 0
	})
end

return EventsSkeleton
