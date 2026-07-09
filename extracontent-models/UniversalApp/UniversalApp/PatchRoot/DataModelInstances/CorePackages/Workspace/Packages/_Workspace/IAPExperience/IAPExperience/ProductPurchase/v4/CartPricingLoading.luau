local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local EnumsRadius = Foundation.Enums.Radius

local function CartPricingLoading(t1: {[any]: any}) -- line: 16
	-- upvalues: React (copy), View (copy), Skeleton (copy), EnumsRadius (copy)
	if not t1.isLoading then
		return nil
	end

	return React.createElement(View, {
		tag = "size-full-0 auto-y padding-xxsmall",
		LayoutOrder = t1.LayoutOrder or 2
	}, {
		LoadingSkeleton = React.createElement(Skeleton, {
			Name = "CartPricingLoadingSkeleton",
			Size = UDim2.new(1, 0, 0, 44),
			radius = EnumsRadius.Circle
		})
	})
end

return CartPricingLoading
