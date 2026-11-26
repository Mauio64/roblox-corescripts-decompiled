local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Foundation")

local view = Foundation.View
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function GroupListItemSkeleton(p2)
	local v5 = useTokens()

	return React.createElement(
		view,
		{
			tag = "row gap-large align-y-center padding-small radius-medium",
			Size = UDim2.new(1, 0, 0, 54),
			LayoutOrder = p2.layoutOrder
		},
		{
			ThumbnailContainer = React.createElement(
				view,
				{ LayoutOrder = 1, Size = UDim2.fromOffset(38, 38) },
				{
					ThumbnailSkeleton = React.createElement(skeleton, {
						Size = UDim2.fromScale(1, 1),
						radius = radius.Medium
					})
				}
			),
			Details = React.createElement(
				view,
				{ LayoutOrder = 2, tag = "col size-full-0 auto-y fill gap-small" },
				{
					NameSkeleton = React.createElement(skeleton, {
						Size = UDim2.new(0.7, 0, 0, v5.Size.Size_350),
						radius = radius.Small,
						LayoutOrder = 1
					}),
					MetaSkeleton = React.createElement(skeleton, {
						Size = UDim2.new(0.5, 0, 0, v5.Size.Size_250),
						radius = radius.Small,
						LayoutOrder = 2
					})
				}
			)
		}
	)
end

return GroupListItemSkeleton
