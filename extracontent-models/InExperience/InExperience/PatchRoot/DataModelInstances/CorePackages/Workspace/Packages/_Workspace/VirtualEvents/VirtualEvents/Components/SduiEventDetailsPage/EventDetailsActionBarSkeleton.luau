local parent = script:FindFirstAncestor("VirtualEvents").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function EventDetailsActionBarSkeleton()
	local size_1000 = useTokens().Size.Size_1000

	return React.createElement(
		View,
		{
			tag = "row align-y-center gap-small size-full-0 auto-y",
			testId = "--event-details-action-bar-skeleton"
		},
		{
			JoinButton = React.createElement(View, { tag = "grow auto-y", LayoutOrder = 1 }, {
				Skeleton = React.createElement(Skeleton, {
					Size = UDim2.new(1, 0, 0, size_1000),
					radius = Radius.Medium
				})
			}),
			ShareButton = React.createElement(Skeleton, {
				Size = UDim2.fromOffset(size_1000, size_1000),
				radius = Radius.Medium,
				LayoutOrder = 2
			})
		}
	)
end

return React.memo(EventDetailsActionBarSkeleton)
