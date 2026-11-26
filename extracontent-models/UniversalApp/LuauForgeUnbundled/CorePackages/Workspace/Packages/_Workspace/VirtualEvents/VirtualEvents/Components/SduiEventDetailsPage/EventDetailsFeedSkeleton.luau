local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Foundation")
local view = Foundation.View
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local EventDetailsActionBarSkeleton = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/SduiEventDetailsPage/EventDetailsActionBarSkeleton")

local fFlagLuaAppSduiEventDetailsActionBarInFeed = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/SharedFlags").FFlagLuaAppSduiEventDetailsActionBarInFeed

local function EventDetailsFeedSkeleton()
	local v5 = useTokens()

	local size_1400 = v5.Size.Size_1400
	local v6 = v5.Typography.CaptionLarge.LineHeight * v5.Typography.CaptionLarge.FontSize
	local v7 = v5.Typography.HeadingSmall.LineHeight * v5.Typography.HeadingSmall.FontSize
	local v8 = v5.Typography.CaptionMedium.LineHeight * v5.Typography.CaptionMedium.FontSize * 3

	local createElement = React.createElement

	local v11 = {
		AttributionRow = React.createElement(
			view,
			{
				tag = "row align-y-center gap-medium size-full-0 auto-y",
				LayoutOrder = 1
			},
			{
				Icon = React.createElement(skeleton, {
					Size = UDim2.fromOffset(size_1400, size_1400),
					radius = radius.Medium,
					LayoutOrder = 1
				}),
				TextColumn = React.createElement(
					view,
					{ tag = "col fill gap-small auto-xy", LayoutOrder = 2 },
					{
						Title = React.createElement(skeleton, {
							Size = UDim2.fromOffset(v5.Size.Size_2800 * 2, v6),
							radius = radius.Small,
							LayoutOrder = 1
						}),
						Host = React.createElement(skeleton, {
							Size = UDim2.fromOffset(v5.Size.Size_2800, v6),
							radius = radius.Small,
							LayoutOrder = 2
						})
					}
				)
			}
		),
		ActionBar = 0,
		Description = 0
	}

	local v12 = if fFlagLuaAppSduiEventDetailsActionBarInFeed then React.createElement(
		view,
		{ tag = "size-full-0 auto-y", LayoutOrder = 2 },
		{ Skeleton = React.createElement(EventDetailsActionBarSkeleton) }
	) else nil
	v11.ActionBar = v12

	v11.Description = React.createElement(
		view,
		{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = 3 },
		{
			Header = React.createElement(skeleton, {
				Size = UDim2.fromOffset(v5.Size.Size_2800 * 2, v7),
				radius = radius.Small,
				LayoutOrder = 1
			}),
			Text = React.createElement(skeleton, {
				Size = UDim2.new(1, 0, 0, v8),
				radius = radius.Small,
				LayoutOrder = 2
			})
		}
	)
	return createElement(
		view,
		{
			tag = "col gap-large size-full auto-y padding-top-medium",
			testId = "--event-details-feed-skeleton"
		},
		v11
	)
end

return React.memo(EventDetailsFeedSkeleton)
