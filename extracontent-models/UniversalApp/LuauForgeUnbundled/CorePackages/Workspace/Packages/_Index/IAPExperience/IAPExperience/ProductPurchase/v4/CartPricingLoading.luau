local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Foundation")
local skeleton = Foundation.Skeleton
local view = Foundation.View
local radius = Foundation.Enums.Radius

local function CartPricingLoading(p2)
	if p2.isLoading then
		return React.createElement(view, {
			LayoutOrder = p2.LayoutOrder or 2,
			tag = "size-full-0 auto-y padding-xxsmall"
		}, {
			LoadingSkeleton = React.createElement(skeleton, {
				Name = "CartPricingLoadingSkeleton",
				Size = UDim2.new(1, 0, 0, 44),
				radius = radius.Circle
			})
		})
	end

	return nil
end

return CartPricingLoading
