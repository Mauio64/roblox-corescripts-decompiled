local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")

local useCheckoutActionBarProps = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Checkout/useCheckoutActionBarProps")
local CheckoutActionBar = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceCatalog/AvatarExperienceCatalog/Components/Checkout/CheckoutActionBar")

local forwardRef = React.forwardRef(function(p2, p3)
	local v5 = useCheckoutActionBarProps(p2, p3)
	return React.createElement(CheckoutActionBar, v5)
end)

return React.memo(forwardRef)
