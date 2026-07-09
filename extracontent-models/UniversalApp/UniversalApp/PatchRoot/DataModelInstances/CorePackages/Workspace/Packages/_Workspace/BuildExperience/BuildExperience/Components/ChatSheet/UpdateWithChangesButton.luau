local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local function UpdateWithChangesButton(t1: {[any]: any}) -- line: 18
	-- upvalues: React (copy), Button (copy), InputSize (copy), ButtonVariant (copy)
	return React.createElement(Button, {
		text = "Update with changes",
		size = InputSize.Medium,
		variant = ButtonVariant.Emphasis,
		width = UDim.new(1, 0),
		onActivated = t1.onActivated,
		LayoutOrder = t1.LayoutOrder
	})
end

return UpdateWithChangesButton
