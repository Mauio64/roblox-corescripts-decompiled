local parent = script.Parent.Parent.Parent.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local Radius = Foundation.Enums.Radius

local function CartPricingLoading(p)
	if p.isLoading then
		return React.createElement(View, {
			LayoutOrder = p.LayoutOrder or 2,
			tag = "size-full-0 auto-y padding-xxsmall"
		}, {
			LoadingSkeleton = React.createElement(Skeleton, {
				Name = "CartPricingLoadingSkeleton",
				Size = UDim2.new(1, 0, 0, 44),
				radius = Radius.Circle
			})
		})
	end

	return nil
end

return CartPricingLoading
