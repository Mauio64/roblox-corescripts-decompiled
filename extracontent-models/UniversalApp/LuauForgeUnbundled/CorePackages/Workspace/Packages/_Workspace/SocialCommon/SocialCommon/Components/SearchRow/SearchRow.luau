local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/React")

local SearchField = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Components/SearchRow/SearchField")

local function SearchRow(props)
	local onExit = props.onExit
	local exitVariant = props.exitVariant or "Cancel"
	local exitTestId = props.exitTestId or "SearchRow"
	local height = props.height
	local paddingHorizontal = props.paddingHorizontal

	local createElement = React.createElement
	local view = Foundation.View
	local v5 = {
		tag = {
			["row align-y-center gap-small"] = true,
			["size-full"] = height == nil
		},
		Size = 0,
		LayoutOrder = 0,
		padding = 0
	}

	local v6 = if height then UDim2.new(1, 0, 0, height) else nil
	v5.Size = v6
	v5.LayoutOrder = props.LayoutOrder
	v5.padding = paddingHorizontal
		and {
			left = UDim.new(0, paddingHorizontal),
			right = UDim.new(0, paddingHorizontal)
		}
		or nil

	local v8 = if onExit and exitVariant == "Chevron" then React.createElement(Foundation.IconButton, {
		icon = Foundation.Enums.IconName.ChevronLargeLeft,
		size = Foundation.Enums.InputSize.Medium,
		LayoutOrder = 1,
		testId = `{exitTestId}Back`,
		onActivated = onExit
	}) else nil
	local v7 = {
		back = v8,
		field = React.createElement(Foundation.View, {
			tag = "grow auto-y",
			LayoutOrder = 2
		}, {
			input = React.createElement(SearchField, {
				text = props.text,
				placeholder = props.placeholder,
				shouldAutoFocus = props.shouldAutoFocus,
				onChanged = props.onChanged,
				onExit = onExit,
				onFocusGained = props.onFocusGained,
				testId = props.testId
			})
		}),
		cancel = 0
	}

	local v9 = if onExit and exitVariant == "Cancel" then React.createElement(Foundation.Button, {
		text = props.cancelText or "",
		variant = Foundation.Enums.ButtonVariant.Utility,
		size = Foundation.Enums.InputSize.Medium,
		LayoutOrder = 3,
		testId = `{exitTestId}Cancel`,
		onActivated = onExit
	}) else nil
	v7.cancel = v9
	return createElement(view, v5, v7)
end

return SearchRow
