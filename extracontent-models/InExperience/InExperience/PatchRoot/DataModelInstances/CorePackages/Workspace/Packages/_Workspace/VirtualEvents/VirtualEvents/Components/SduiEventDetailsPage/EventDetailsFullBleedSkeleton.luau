local parent = script:FindFirstAncestor("VirtualEvents").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function EventDetailsFullBleedSkeleton()
	local v = useTokens()

	return React.createElement(
		View,
		{ Size = UDim2.fromScale(1, 1), ClipsDescendants = true, BackgroundTransparency = 1 },
		{
			Skeleton = React.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 1, v.Radius.Large),
				radius = Radius.Large
			})
		}
	)
end

return React.memo(EventDetailsFullBleedSkeleton)
