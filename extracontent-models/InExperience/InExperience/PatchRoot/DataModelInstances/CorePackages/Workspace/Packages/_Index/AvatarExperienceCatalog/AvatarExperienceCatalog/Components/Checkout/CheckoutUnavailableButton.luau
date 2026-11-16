local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
local tutils = require(parent.tutils)
local Foundation = require(parent.Foundation)

local function CheckoutUnavailableButton(props)
	return React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y fill",
		LayoutOrder = props.LayoutOrder
	}, {
		UnavailableButton = React.createElement(Foundation.Button, {
			text = props.label,
			onActivated = props.onActivated,
			variant = Foundation.Enums.ButtonVariant.Standard,
			size = Foundation.Enums.ButtonSize.Medium,
			fillBehavior = Foundation.Enums.FillBehavior.Fill
		})
	})
end

return React.memo(CheckoutUnavailableButton, tutils.deepEqual)
