local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Foundation")
local view = Foundation.View
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function EventDetailsActionBarSkeleton()
	local size_1000 = useTokens().Size.Size_1000

	return React.createElement(
		view,
		{
			tag = "row align-y-center gap-small size-full-0 auto-y",
			testId = "--event-details-action-bar-skeleton"
		},
		{
			JoinButton = React.createElement(view, {
				tag = "grow auto-y",
				LayoutOrder = 1
			}, {
				Skeleton = React.createElement(skeleton, {
					Size = UDim2.new(1, 0, 0, size_1000),
					radius = radius.Medium
				})
			}),
			ShareButton = React.createElement(skeleton, {
				Size = UDim2.fromOffset(size_1000, size_1000),
				radius = radius.Medium,
				LayoutOrder = 2
			})
		}
	)
end

return React.memo(EventDetailsActionBarSkeleton)
