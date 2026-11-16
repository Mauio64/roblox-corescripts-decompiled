local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Button = Foundation.Button
local TextInput = Foundation.TextInput
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize

local FFlagShareSheetPeoplePickerEnabled = require(ShareSheet.Flags.FFlagShareSheetPeoplePickerEnabled)

local function ShareSendRow(props)
	local state, setState = React.useState("")
	local onActivated = React.useCallback(function()
		props.onActivated(state)
	end, { state, props.onActivated })

	local createElement = React.createElement
	local v = {
		tag = {
			["col gap-medium size-full-0 auto-y"] = true,
			["padding-x-xlarge padding-bottom-medium"] = not FFlagShareSheetPeoplePickerEnabled
		},
		LayoutOrder = props.LayoutOrder,
		testId = "share-send-row"
	}

	local v2 = {
		MessageInput = React.createElement(TextInput, {
			isDisabled = props.isLoading,
			label = "",
			LayoutOrder = 1,
			onChanged = setState,
			onFocusGained = props.onFocusGained,
			placeholder = props.messagePlaceholder,
			size = InputSize.Medium,
			testId = "share-message-input",
			text = state,
			width = UDim.new(1, 0)
		}),
		SendButton = 0
	}

	local createElement2 = React.createElement
	local v3 = {
		text = props.label,
		variant = ButtonVariant.Emphasis,
		fillBehavior = 0,
		isLoading = 0,
		LayoutOrder = 2,
		size = 0,
		onActivated = 0,
		testId = "share-send-button",
		width = 0
	}
	local fillBehavior

	if not (FFlagShareSheetPeoplePickerEnabled and props.shouldFillButton == false) then
		fillBehavior = FillBehavior.Fill
	end

	v3.fillBehavior = fillBehavior

	v3.isLoading = props.isLoading

	v3.size = InputSize.Medium
	v3.onActivated = onActivated

	v3.width = UDim.new(1, 0)
	v2.SendButton = createElement2(Button, v3)
	return createElement(View, v, v2)
end

return ShareSendRow
