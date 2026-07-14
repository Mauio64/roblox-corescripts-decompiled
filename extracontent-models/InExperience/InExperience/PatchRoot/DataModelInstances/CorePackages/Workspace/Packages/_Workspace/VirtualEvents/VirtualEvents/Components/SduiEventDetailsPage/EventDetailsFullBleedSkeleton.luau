local Parent = script:FindFirstAncestor("VirtualEvents").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function EventDetailsFullBleedSkeleton() -- line: 15
	-- upvalues: useTokens (copy), React (copy), View (copy), Skeleton (copy), EnumsRadius (copy)
	local v9 = useTokens()

	return React.createElement(View, {
		ClipsDescendants = true,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}, {
		Skeleton = React.createElement(Skeleton, {
			Size = UDim2.new(1, 0, 1, v9.Radius.Large),
			radius = EnumsRadius.Large
		})
	})
end

return React.memo(EventDetailsFullBleedSkeleton)
