local Parent = script:FindFirstAncestor("PasskeyUpsell").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local ButtonSize = Foundation.Enums.ButtonSize
local View = Foundation.View
local Button = Foundation.Button
local v9 = game:DefineFastInt("PasskeyUpsellDisableButtonTimer", 1)

local function PasskeyUpsellButtonContainer(t1: {[any]: any}) -- line: 25
	-- upvalues: React (copy), View (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy), FillBehavior (copy), v9 (copy)
	local s1 = "gap-small align-y-center align-x-center col"
	local n1 = 88
	local v14 = t1.localizedCancelText and t1.onCancelButtonPressed

	if not v14 then
		s1 = "align-y-center align-x-center col"
		n1 = 40
	end

	return React.createElement(View, {
		tag = s1,
		Size = UDim2.new(1, 0, 0, n1),
		Position = UDim2.new(0, 0, 1, -n1),
		LayoutOrder = t1.layoutOrder
	}, {
		ContinueButton = React.createElement(Button, {
			variant = ButtonVariant.Emphasis,
			text = t1.localizedContinueText,
			size = ButtonSize.Large,
			fillBehavior = FillBehavior.Fill,
			width = UDim.new(1, 0),
			onActivated = t1.onContinueButtonPressed,
			isDisabled = t1.isDisabled
		}),
		CancelButton = v14 and React.createElement(Button, {
			variant = ButtonVariant.Standard,
			size = ButtonSize.Large,
			fillBehavior = FillBehavior.Fill,
			width = UDim.new(1, 0),
			text = t1.localizedCancelText,
			onActivated = t1.onCancelButtonPressed,
			inputDelay = v9,
			isDisabled = t1.isDisabled
		})
	})
end

return PasskeyUpsellButtonContainer
