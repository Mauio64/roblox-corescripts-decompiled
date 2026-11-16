local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local skeleton = Foundation.Skeleton
local view = Foundation.View

local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function ExperienceResultsLoadingSkeleton(props)
	local v5 = useTokens()
	return React.createElement(
		view,
		{
			LayoutOrder = props.LayoutOrder,
			Size = UDim2.new(1, 0, 0, v5.Size.Size_2000),
			tag = "row align-y-center gap-medium",
			testId = `{props.testIdPrefix}.LoadingSkeleton.{props.index}`
		},
		{
			ThumbnailContainer = React.createElement(
				view,
				{
					LayoutOrder = 1,
					Size = UDim2.fromOffset(v5.Size.Size_1400, v5.Size.Size_1400)
				},
				{
					Thumbnail = React.createElement(skeleton, {
						Size = UDim2.fromScale(1, 1),
						radius = radius.Medium
					})
				}
			),
			Details = React.createElement(
				view,
				{ LayoutOrder = 2, tag = "col fill gap-small size-full-0 auto-y" },
				{
					Title = React.createElement(skeleton, {
						LayoutOrder = 1,
						Size = UDim2.new(0.72, 0, 0, v5.Size.Size_400),
						radius = radius.Small
					}),
					Description = React.createElement(skeleton, {
						LayoutOrder = 2,
						Size = UDim2.new(0.44, 0, 0, v5.Size.Size_250),
						radius = radius.Small
					})
				}
			)
		}
	)
end

return ExperienceResultsLoadingSkeleton
