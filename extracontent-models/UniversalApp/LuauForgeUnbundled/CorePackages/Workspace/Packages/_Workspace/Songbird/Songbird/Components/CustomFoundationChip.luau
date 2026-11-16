local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Foundation")

local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local icon = Foundation.Icon
local view = Foundation.View
local text = Foundation.Text
local withDefaults = Foundation.Utility.withDefaults
local withCommonProps = Foundation.Utility.withCommonProps

local iconSize = Foundation.Enums.IconSize
local iconPosition = Foundation.Enums.IconPosition
local stateLayerMode = Foundation.Enums.StateLayerMode
local cursorType = Foundation.Enums.CursorType

local v5 = { isDisabled = false, isChecked = false }

local function Chip(p2, p3)
	local v6 = withDefaults(p2, v5)

	local v7 = useTokens()
	local v8 = useCursor(cursorType.SmallPill)

	local v9 = React.useMemo(function()
		if typeof(v6.icon) == "string" then
			return { name = v6.icon, position = iconPosition.Left }
		end

		return v6.icon
	end, { v6.icon })

	local v10 = if v6.isChecked then v7.Color.ActionSubEmphasis.Foreground else v7.Color.Content.Emphasis

	local createElement = React.createElement

	local v12 = withCommonProps(v6, {
		GroupTransparency = v6.isDisabled and 0.5 or nil,
		selection = {
			Selectable = not v6.isDisabled,
			SelectionImageObject = v8
		},
		onActivated = v6.onActivated,
		isDisabled = v6.isDisabled,
		stateLayer = { mode = stateLayerMode.Inverse },
		tag = {
			["row gap-xsmall size-0-800 padding-medium auto-x align-y-center align-x-center clip radius-circle"] = true,
			["bg-action-sub-emphasis"] = v6.isChecked,
			["bg-shift-200"] = not v6.isChecked
		},
		ref = p3
	})

	local v14 = if v9 then React.createElement(icon, {
		name = v9.name,
		size = iconSize.Small,
		style = v10,
		LayoutOrder = v9.position == iconPosition.Left and 1 or 3
	}) else nil

	local v15 = if v6.text and v6.text ~= "" then React.createElement(text, {
		Text = v6.text,
		textStyle = v10,
		LayoutOrder = 2,
		tag = "auto-x size-0-full shrink text-caption-large text-truncate-end"
	}) else nil
	return createElement(view, v12, { Icon = v14, Text = v15 })
end

return React.memo(React.forwardRef(Chip))
