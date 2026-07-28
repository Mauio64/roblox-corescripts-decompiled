local Parent = script:FindFirstAncestor("ShareSheet").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local Button = Foundation.Button
local TextInput = Foundation.TextInput
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize

local function ShareSendRow(t1: {[any]: any}) -- line: 22
	-- upvalues: React (copy), View (copy), TextInput (copy), InputSize (copy), Button (copy), ButtonVariant (copy), FillBehavior (copy)
	local v12, v13 = React.useState("")
	local v14 = React.useCallback(function() -- line: 24
		-- upvalues: t1 (copy), v12 (copy)
		t1.onActivated(v12)
	end, {
		v12,
		t1.onActivated
	})

	return React.createElement(View, {
		tag = "col gap-medium size-full-0 auto-y padding-x-xlarge padding-bottom-medium",
		testId = "share-send-row",
		LayoutOrder = t1.LayoutOrder
	}, {
		MessageInput = React.createElement(TextInput, {
			label = "",
			LayoutOrder = 1,
			testId = "share-message-input",
			isDisabled = t1.isLoading,
			onChanged = v13,
			placeholder = t1.messagePlaceholder,
			size = InputSize.Medium,
			text = v12,
			width = UDim.new(1, 0)
		}),
		SendButton = React.createElement(Button, {
			LayoutOrder = 2,
			testId = "share-send-button",
			text = t1.label,
			variant = ButtonVariant.Emphasis,
			fillBehavior = FillBehavior.Fill,
			isLoading = t1.isLoading,
			size = InputSize.Medium,
			onActivated = v14,
			width = UDim.new(1, 0)
		})
	})
end

return ShareSendRow
