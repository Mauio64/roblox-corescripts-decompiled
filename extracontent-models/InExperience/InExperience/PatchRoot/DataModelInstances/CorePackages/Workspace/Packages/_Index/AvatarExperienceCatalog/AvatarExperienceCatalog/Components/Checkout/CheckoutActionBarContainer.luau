local AvatarExperienceCatalog = script:FindFirstAncestor("AvatarExperienceCatalog")

local parent = AvatarExperienceCatalog.Parent
local React = require(parent.React)

local useCheckoutActionBarProps = require(AvatarExperienceCatalog.Components.Checkout.useCheckoutActionBarProps)
local CheckoutActionBar = require(AvatarExperienceCatalog.Components.Checkout.CheckoutActionBar)

local forwardRef = React.forwardRef(function(p, p2)
	local v = useCheckoutActionBarProps(p, p2)
	return React.createElement(CheckoutActionBar, v)
end)

return React.memo(forwardRef)
