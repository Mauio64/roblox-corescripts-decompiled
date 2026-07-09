local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local v5 = React.forwardRef(function(t1: {[any]: any}, p1) -- line: 15
	-- upvalues: Foundation (copy), useLocalization (copy), React (copy)
	local v8 = Foundation.Hooks.useTokens()
	local uDim2 = UDim2.fromScale(1, 0)
	local uDim2_2 = UDim2.fromScale(0, 1)
	local v11 = useLocalization({
		manageInCustomize = "Feature.Catalog.Action.Checkout.ManageInCustomize"
	})

	return React.createElement(Foundation.View, {
		tag = "row items-center auto-y size-full-0 padding-y-large padding-x-xlarge bg-surface-0 anchor-bottom-left",
		ZIndex = 3,
		ref = p1,
		backgroundStyle = {
			Color3 = v8.Color.Surface.Surface_0.Color3,
			Transparency = v8.Color.Surface.Surface_0.Transparency
		},
		Size = uDim2,
		Position = uDim2_2
	}, {
		ActionButton = React.createElement(Foundation.Button, {
			text = v11.manageInCustomize,
			onActivated = t1.onActivated,
			variant = Foundation.Enums.ButtonVariant.Standard,
			size = Foundation.Enums.ButtonSize.Medium,
			fillBehavior = Foundation.Enums.FillBehavior.Fill
		})
	})
end)

return React.memo(v5)
