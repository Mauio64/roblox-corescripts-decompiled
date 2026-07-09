local Parent = script:FindFirstAncestor("Groups").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function GroupListItemSkeleton(t1: {[any]: any}) -- line: 19
	-- upvalues: useTokens (copy), React (copy), View (copy), Skeleton (copy), EnumsRadius (copy)
	local v10 = useTokens()

	return React.createElement(View, {
		tag = "row gap-large align-y-center padding-small radius-medium",
		Size = UDim2.new(1, 0, 0, 54),
		LayoutOrder = t1.layoutOrder
	}, {
		ThumbnailContainer = React.createElement(View, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(38, 38)
		}, {
			ThumbnailSkeleton = React.createElement(Skeleton, {
				Size = UDim2.fromScale(1, 1),
				radius = EnumsRadius.Medium
			})
		}),
		Details = React.createElement(View, {
			LayoutOrder = 2,
			tag = "col size-full-0 auto-y fill gap-small"
		}, {
			NameSkeleton = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.new(0.7, 0, 0, v10.Size.Size_350),
				radius = EnumsRadius.Small
			}),
			MetaSkeleton = React.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.new(0.5, 0, 0, v10.Size.Size_250),
				radius = EnumsRadius.Small
			})
		})
	})
end

return GroupListItemSkeleton
