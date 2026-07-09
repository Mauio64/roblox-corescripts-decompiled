local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
local React = require(Parent.React)
local tutils = require(Parent.tutils)
local Foundation = require(Parent.Foundation)

local function CheckoutUnavailableButton(t1: {[any]: any}) -- line: 15
	-- upvalues: React (copy), Foundation (copy)
	return React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y fill",
		LayoutOrder = t1.LayoutOrder
	}, {
		UnavailableButton = React.createElement(Foundation.Button, {
			text = t1.label,
			onActivated = t1.onActivated,
			variant = Foundation.Enums.ButtonVariant.Standard,
			size = Foundation.Enums.ButtonSize.Medium,
			fillBehavior = Foundation.Enums.FillBehavior.Fill
		})
	})
end

return React.memo(CheckoutUnavailableButton, tutils.deepEqual)
