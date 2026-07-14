local Parent = script:FindFirstAncestor("VirtualEvents").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function EventDetailsActionBarSkeleton() -- line: 14
	-- upvalues: useTokens (copy), React (copy), View (copy), Skeleton (copy), EnumsRadius (copy)
	local Size_1000 = useTokens().Size.Size_1000

	return React.createElement(View, {
		tag = "row align-y-center gap-small size-full-0 auto-y",
		testId = "--event-details-action-bar-skeleton"
	}, {
		JoinButton = React.createElement(View, {
			tag = "grow auto-y",
			LayoutOrder = 1
		}, {
			Skeleton = React.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, Size_1000),
				radius = EnumsRadius.Medium
			})
		}),
		ShareButton = React.createElement(Skeleton, {
			LayoutOrder = 2,
			Size = UDim2.fromOffset(Size_1000, Size_1000),
			radius = EnumsRadius.Medium
		})
	})
end

return React.memo(EventDetailsActionBarSkeleton)
