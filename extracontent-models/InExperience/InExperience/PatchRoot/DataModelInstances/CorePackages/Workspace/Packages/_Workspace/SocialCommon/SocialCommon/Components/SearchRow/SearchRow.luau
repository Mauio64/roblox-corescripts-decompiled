local parent = script:FindFirstAncestor("SocialCommon").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local SearchField = require(script.Parent.SearchField)

local function SearchRow(props)
	local onExit = props.onExit
	local exitVariant = props.exitVariant or "Cancel"
	local exitTestId = props.exitTestId or "SearchRow"
	local height = props.height
	local paddingHorizontal = props.paddingHorizontal

	local createElement = React.createElement
	local view = Foundation.View
	local v = {
		tag = {
			["row align-y-center gap-small"] = true,
			["size-full"] = height == nil
		},
		Size = 0,
		LayoutOrder = 0,
		padding = 0
	}
	local size

	if height then
		size = UDim2.new(1, 0, 0, height)
	end

	v.Size = size
	v.LayoutOrder = props.LayoutOrder
	v.padding = paddingHorizontal
		and { left = UDim.new(0, paddingHorizontal), right = UDim.new(0, paddingHorizontal) }
		or nil
	local back

	if onExit and exitVariant == "Chevron" then
		back = React.createElement(Foundation.IconButton, {
			icon = Foundation.Enums.IconName.ChevronLargeLeft,
			size = Foundation.Enums.InputSize.Medium,
			LayoutOrder = 1,
			testId = `{exitTestId}Back`,
			onActivated = onExit
		})
	end

	local v2 = {
		back = back,
		field = React.createElement(Foundation.View, { tag = "grow auto-y", LayoutOrder = 2 }, {
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
	local cancel

	if onExit and exitVariant == "Cancel" then
		cancel = React.createElement(Foundation.Button, {
			text = props.cancelText or "",
			variant = Foundation.Enums.ButtonVariant.Utility,
			size = Foundation.Enums.InputSize.Medium,
			LayoutOrder = 3,
			testId = `{exitTestId}Cancel`,
			onActivated = onExit
		})
	end

	v2.cancel = cancel
	return createElement(view, v, v2)
end

return SearchRow
