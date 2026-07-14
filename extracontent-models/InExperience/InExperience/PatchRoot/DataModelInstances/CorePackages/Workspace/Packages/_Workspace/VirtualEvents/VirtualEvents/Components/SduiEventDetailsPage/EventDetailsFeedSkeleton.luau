local Parent = script:FindFirstAncestor("VirtualEvents").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local EventDetailsActionBarSkeleton = require(script.Parent.EventDetailsActionBarSkeleton)
local FFlagLuaAppSduiEventDetailsActionBarInFeed = require(Parent.SharedFlags).FFlagLuaAppSduiEventDetailsActionBarInFeed

local function EventDetailsFeedSkeleton() -- line: 19
	-- upvalues: useTokens (copy), React (copy), View (copy), Skeleton (copy), EnumsRadius (copy), FFlagLuaAppSduiEventDetailsActionBarInFeed (copy), EventDetailsActionBarSkeleton (copy)
	local v11 = useTokens()
	local Size_1400 = v11.Size.Size_1400
	local v13 = v11.Typography.CaptionLarge.LineHeight * v11.Typography.CaptionLarge.FontSize
	local v14 = v11.Typography.HeadingSmall.LineHeight * v11.Typography.HeadingSmall.FontSize
	local v15 = v11.Typography.CaptionMedium.LineHeight * v11.Typography.CaptionMedium.FontSize * 3

	return React.createElement(View, {
		tag = "col gap-large size-full auto-y padding-top-medium",
		testId = "--event-details-feed-skeleton"
	}, {
		AttributionRow = React.createElement(View, {
			tag = "row align-y-center gap-medium size-full-0 auto-y",
			LayoutOrder = 1
		}, {
			Icon = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(Size_1400, Size_1400),
				radius = EnumsRadius.Medium
			}),
			TextColumn = React.createElement(View, {
				tag = "col fill gap-small auto-xy",
				LayoutOrder = 2
			}, {
				Title = React.createElement(Skeleton, {
					LayoutOrder = 1,
					Size = UDim2.fromOffset(v11.Size.Size_2800 * 2, v13),
					radius = EnumsRadius.Small
				}),
				Host = React.createElement(Skeleton, {
					LayoutOrder = 2,
					Size = UDim2.fromOffset(v11.Size.Size_2800, v13),
					radius = EnumsRadius.Small
				})
			})
		}),
		ActionBar = if not FFlagLuaAppSduiEventDetailsActionBarInFeed then nil else React.createElement(View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 2
		}, {
			Skeleton = React.createElement(EventDetailsActionBarSkeleton)
		}),
		Description = React.createElement(View, {
			tag = "col gap-medium size-full-0 auto-y",
			LayoutOrder = 3
		}, {
			Header = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(v11.Size.Size_2800 * 2, v14),
				radius = EnumsRadius.Small
			}),
			Text = React.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, v15),
				radius = EnumsRadius.Small
			})
		})
	})
end

return React.memo(EventDetailsFeedSkeleton)
