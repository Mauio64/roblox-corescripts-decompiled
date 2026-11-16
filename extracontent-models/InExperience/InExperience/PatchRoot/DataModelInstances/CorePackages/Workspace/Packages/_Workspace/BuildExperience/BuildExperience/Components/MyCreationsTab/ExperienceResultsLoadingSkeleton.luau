local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Skeleton = Foundation.Skeleton
local View = Foundation.View

local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function ExperienceResultsLoadingSkeleton(props)
	local v = useTokens()
	return React.createElement(
		View,
		{
			LayoutOrder = props.LayoutOrder,
			Size = UDim2.new(1, 0, 0, v.Size.Size_2000),
			tag = "row align-y-center gap-medium",
			testId = `{props.testIdPrefix}.LoadingSkeleton.{props.index}`
		},
		{
			ThumbnailContainer = React.createElement(
				View,
				{
					LayoutOrder = 1,
					Size = UDim2.fromOffset(v.Size.Size_1400, v.Size.Size_1400)
				},
				{
					Thumbnail = React.createElement(Skeleton, {
						Size = UDim2.fromScale(1, 1),
						radius = Radius.Medium
					})
				}
			),
			Details = React.createElement(View, {
				LayoutOrder = 2,
				tag = "col fill gap-small size-full-0 auto-y"
			}, {
				Title = React.createElement(Skeleton, {
					LayoutOrder = 1,
					Size = UDim2.new(0.72, 0, 0, v.Size.Size_400),
					radius = Radius.Small
				}),
				Description = React.createElement(Skeleton, {
					LayoutOrder = 2,
					Size = UDim2.new(0.44, 0, 0, v.Size.Size_250),
					radius = Radius.Small
				})
			})
		}
	)
end

return ExperienceResultsLoadingSkeleton
