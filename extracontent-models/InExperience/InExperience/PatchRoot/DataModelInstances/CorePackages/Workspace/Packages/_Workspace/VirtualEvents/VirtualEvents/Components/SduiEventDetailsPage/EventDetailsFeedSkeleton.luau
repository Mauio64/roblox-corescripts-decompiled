local parent = script:FindFirstAncestor("VirtualEvents").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local EventDetailsActionBarSkeleton = require(script.Parent.EventDetailsActionBarSkeleton)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiEventDetailsActionBarInFeed = SharedFlags.FFlagLuaAppSduiEventDetailsActionBarInFeed

local function EventDetailsFeedSkeleton()
	local v = useTokens()

	local size_1400 = v.Size.Size_1400
	local v2 = v.Typography.CaptionLarge.LineHeight * v.Typography.CaptionLarge.FontSize
	local v3 = v.Typography.HeadingSmall.LineHeight * v.Typography.HeadingSmall.FontSize
	local v4 = v.Typography.CaptionMedium.LineHeight * v.Typography.CaptionMedium.FontSize * 3

	local createElement = React.createElement

	local v5 = {
		AttributionRow = React.createElement(
			View,
			{ tag = "row align-y-center gap-medium size-full-0 auto-y", LayoutOrder = 1 },
			{
				Icon = React.createElement(Skeleton, {
					Size = UDim2.fromOffset(size_1400, size_1400),
					radius = Radius.Medium,
					LayoutOrder = 1
				}),
				TextColumn = React.createElement(View, {
					tag = "col fill gap-small auto-xy",
					LayoutOrder = 2
				}, {
					Title = React.createElement(Skeleton, {
						Size = UDim2.fromOffset(v.Size.Size_2800 * 2, v2),
						radius = Radius.Small,
						LayoutOrder = 1
					}),
					Host = React.createElement(Skeleton, {
						Size = UDim2.fromOffset(v.Size.Size_2800, v2),
						radius = Radius.Small,
						LayoutOrder = 2
					})
				})
			}
		),
		ActionBar = 0,
		Description = 0
	}
	local actionBar

	if FFlagLuaAppSduiEventDetailsActionBarInFeed then
		actionBar = React.createElement(View, { tag = "size-full-0 auto-y", LayoutOrder = 2 }, {
			Skeleton = React.createElement(EventDetailsActionBarSkeleton)
		})
	end

	v5.ActionBar = actionBar

	v5.Description = React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y",
		LayoutOrder = 3
	}, {
		Header = React.createElement(Skeleton, {
			Size = UDim2.fromOffset(v.Size.Size_2800 * 2, v3),
			radius = Radius.Small,
			LayoutOrder = 1
		}),
		Text = React.createElement(Skeleton, {
			Size = UDim2.new(1, 0, 0, v4),
			radius = Radius.Small,
			LayoutOrder = 2
		})
	})
	return createElement(
		View,
		{
			tag = "col gap-large size-full auto-y padding-top-medium",
			testId = "--event-details-feed-skeleton"
		},
		v5
	)
end

return React.memo(EventDetailsFeedSkeleton)
