local module = require("@luauforge/deferred/eaj")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/React")
local module3 = require("@luauforge/deferred/eal")

local icon = module.Icon
local radius = module.Enums.Radius
local skeleton = module.Skeleton
local view = module.View

local module4 = require("@luauforge/deferred/eaz")
local useScreenSize = module3.useScreenSize

return function(p2)
	local v5 = module4()
	local v6 = useScreenSize()

	return React.createElement(
		view,
		{
			BackgroundTransparency = 1,
			LayoutOrder = p2.layoutOrder,
			Size = UDim2.new(1, 0, 0, v6.Y)
		},
		{
			ContentFeedImage = React.createElement(skeleton, {
				Size = UDim2.fromScale(1, 1),
				ZIndex = 1
			}),
			FeedPlayerActions = React.createElement(
				view,
				{
					tag = "auto-y anchor-bottom-center position-bottom-center bg-action-subtle size-full-0 col align-x-left align-y-bottom",
					ZIndex = 2
				},
				{
					InfoFrame = React.createElement(
						view,
						{
							tag = "align-x-left align-y-bottom padding-xlarge row position-bottom-center size-full-0 items-end bg-action-subtle anchor-bottom-center auto-y gap-medium items-center",
							LayoutOrder = 1
						},
						{
							CreatorThumbnail = React.createElement(skeleton, {
								radius = radius.Circle,
								LayoutOrder = 1,
								Size = UDim2.fromOffset(30, 30)
							}),
							CreatorName = React.createElement(skeleton, {
								LayoutOrder = 2,
								Size = UDim2.fromOffset(160, 16)
							})
						}
					),
					ExperienceInfo = React.createElement(
						view,
						{
							tag = "bg-surface-100 auto-y size-full-0 row align-x-left align-y-center gap-small",
							LayoutOrder = 2
						},
						{
							UIPadding = React.createElement("UIPadding", {
								PaddingLeft = UDim.new(0, 20),
								PaddingRight = UDim.new(0, 20),
								PaddingTop = UDim.new(0, 20),
								PaddingBottom = UDim.new(0, 20 + v5.bottom)
							}),
							ExperienceThumbnail = React.createElement(skeleton, {
								radius = radius.Medium,
								LayoutOrder = 1,
								Size = UDim2.fromOffset(40, 40)
							}),
							ExperienceMetadata = React.createElement(
								view,
								{
									LayoutOrder = 2,
									tag = "auto-y bg-action-subtle grow col align-x-left align-y-center gap-xsmall"
								},
								{
									ExperienceNameShimmerPanel = React.createElement(skeleton, {
										LayoutOrder = 1,
										Size = UDim2.fromOffset(160, 16)
									}),
									ExperienceRatingShimmerPanel = React.createElement(skeleton, {
										LayoutOrder = 2,
										Size = UDim2.fromOffset(160, 16)
									})
								}
							),
							JoinCTAContainer = React.createElement(
								view,
								{
									LayoutOrder = 3,
									tag = "bg-action-emphasis size-2000-1000 radius-medium",
									isDisabled = true
								},
								{
									PlayIcon = React.createElement(icon, {
										AnchorPoint = Vector2.new(0.5, 0.5),
										name = "icons/common/play",
										Position = UDim2.fromScale(0.5, 0.5)
									})
								}
							)
						}
					)
				}
			)
		}
	)
end
