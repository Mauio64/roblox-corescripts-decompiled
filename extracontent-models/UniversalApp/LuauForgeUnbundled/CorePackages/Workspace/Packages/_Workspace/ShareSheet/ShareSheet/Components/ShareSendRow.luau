local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")

local button = Foundation.Button
local textInput = Foundation.TextInput
local view = Foundation.View
local buttonVariant = Foundation.Enums.ButtonVariant
local fillBehavior = Foundation.Enums.FillBehavior
local inputSize = Foundation.Enums.InputSize

local FFlagShareSheetPeoplePickerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Flags/FFlagShareSheetPeoplePickerEnabled")

local function ShareSendRow(props)
	local state, setState = React.useState("")
	local v5 = React.useCallback(function()
		props.onActivated(state)
	end, { state, props.onActivated })

	local createElement = React.createElement
	local v7 = {
		tag = {
			["col gap-medium size-full-0 auto-y"] = true,
			["padding-x-xlarge padding-bottom-medium"] = not FFlagShareSheetPeoplePickerEnabled
		},
		LayoutOrder = props.LayoutOrder,
		testId = "share-send-row"
	}

	local v8 = {
		MessageInput = React.createElement(textInput, {
			isDisabled = props.isLoading,
			label = "",
			LayoutOrder = 1,
			onChanged = setState,
			onFocusGained = props.onFocusGained,
			placeholder = props.messagePlaceholder,
			size = inputSize.Medium,
			testId = "share-message-input",
			text = state,
			width = UDim.new(1, 0)
		}),
		SendButton = 0
	}

	local createElement2 = React.createElement
	local v10 = {
		text = props.label,
		variant = buttonVariant.Emphasis,
		fillBehavior = 0,
		isLoading = 0,
		LayoutOrder = 2,
		size = 0,
		onActivated = 0,
		testId = "share-send-button",
		width = 0
	}
	local v11 = if not FFlagShareSheetPeoplePickerEnabled or props.shouldFillButton ~= false then fillBehavior.Fill else nil
	v10.fillBehavior = v11

	v10.isLoading = props.isLoading

	v10.size = inputSize.Medium
	v10.onActivated = v5

	v10.width = UDim.new(1, 0)
	v8.SendButton = createElement2(button, v10)
	return createElement(view, v7, v8)
end

return ShareSendRow
