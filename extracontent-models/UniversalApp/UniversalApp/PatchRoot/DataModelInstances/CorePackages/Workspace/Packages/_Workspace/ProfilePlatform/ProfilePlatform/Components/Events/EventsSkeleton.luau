local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Foundation = require(ProfilePlatformParent.Foundation)
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local View = Foundation.View
local useTextSizeOffset = Foundation.Hooks.useTextSizeOffset
local GameCollections = require(ProfilePlatformParent.GameCollections)
local CollectionCarousel = require(ProfilePlatformParent.CollectionViews).CollectionCarousel
local useGetGameTileHeight = GameCollections.useGetGameTileHeight
local useDesignTokens = require(ProfilePlatformParent.Style).useDesignTokens

local function EventsSkeleton(t1: {[any]: any}) -- line: 21
	-- upvalues: useLocalization (copy), TextKeys (copy), useTextSizeOffset (copy), useDesignTokens (copy), useGetGameTileHeight (copy), React (copy), View (copy), Skeleton (copy), EnumsRadius (copy), CollectionCarousel (copy)
	local v17 = useLocalization({
		events = TextKeys.EventsListTitle
	})
	local v18 = useTextSizeOffset()
	local v19 = useDesignTokens()
	local v20 = useGetGameTileHeight(false, "Event", true, false, false, v18, v19.Size.Size_700 + v19.Size.Size_200)
	local v21 = React.useCallback(function(_, n1: number, p2) -- line: 38
		-- upvalues: React (copy), View (copy), Skeleton (copy), EnumsRadius (copy)
		return React.createElement(View, {
			tag = "col gap-medium radius-medium",
			LayoutOrder = n1,
			Size = p2
		}, {
			ThumbnailSkeleton = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.fromScale(1, 0.6),
				radius = EnumsRadius.Medium
			}),
			NameSkeleton = React.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.fromScale(0.8, 0.15),
				radius = EnumsRadius.Medium
			}),
			ButtonSkeleton = React.createElement(Skeleton, {
				LayoutOrder = 3,
				Size = UDim2.fromScale(1, 0.1),
				radius = EnumsRadius.Medium
			})
		}), "Skeleton_" .. n1
	end, {})
	local v22 = React.useMemo(function() -- line: 63
		-- upvalues: t1 (copy)
		local t2 = {}

		for i = 1, t1.numSkeletons do
			table.insert(t2, i)
		end

		return t2
	end, { t1.numSkeletons })

	return React.createElement(CollectionCarousel, {
		scrollingFrameRef = nil,
		hideHeaderButton = true,
		numColumns = 1,
		fractionalItemAmount = 0.33,
		sideMargin = 0,
		title = v17.events,
		items = v22,
		renderItem = v21,
		getItemHeight = v20,
		columnGap = v19.Size.Size_300
	})
end

return EventsSkeleton
