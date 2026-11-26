local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Foundation")
local view = Foundation.View
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function EventDetailsFullBleedSkeleton()
	local v5 = useTokens()

	return React.createElement(
		view,
		{
			Size = UDim2.fromScale(1, 1),
			ClipsDescendants = true,
			BackgroundTransparency = 1
		},
		{
			Skeleton = React.createElement(skeleton, {
				Size = UDim2.new(1, 0, 1, v5.Radius.Large),
				radius = radius.Large
			})
		}
	)
end

return React.memo(EventDetailsFullBleedSkeleton)
