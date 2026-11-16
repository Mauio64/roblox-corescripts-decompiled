local parent = script:FindFirstAncestor("Songbird").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local Icon = Foundation.Icon
local View = Foundation.View
local Text = Foundation.Text
local withDefaults = Foundation.Utility.withDefaults
local withCommonProps = Foundation.Utility.withCommonProps

local IconSize = Foundation.Enums.IconSize
local IconPosition = Foundation.Enums.IconPosition
local StateLayerMode = Foundation.Enums.StateLayerMode
local CursorType = Foundation.Enums.CursorType

local v = { isDisabled = false, isChecked = false }

local function Chip(p, ref)
	local v2 = withDefaults(p, v)

	local v3 = useTokens()
	local selectionImageObject = useCursor(CursorType.SmallPill)

	local v4 = React.useMemo(function()
		if typeof(v2.icon) == "string" then
			return { name = v2.icon, position = IconPosition.Left }
		end

		return v2.icon
	end, { v2.icon })
	local v5

	if v2.isChecked then
		v5 = v3.Color.ActionSubEmphasis.Foreground
	else
		v5 = v3.Color.Content.Emphasis
	end

	local createElement = React.createElement

	local v6 = withCommonProps(v2, {
		GroupTransparency = v2.isDisabled and 0.5 or nil,
		selection = {
			Selectable = not v2.isDisabled,
			SelectionImageObject = selectionImageObject
		},
		onActivated = v2.onActivated,
		isDisabled = v2.isDisabled,
		stateLayer = { mode = StateLayerMode.Inverse },
		tag = {
			["row gap-xsmall size-0-800 padding-medium auto-x align-y-center align-x-center clip radius-circle"] = true,
			["bg-action-sub-emphasis"] = v2.isChecked,
			["bg-shift-200"] = not v2.isChecked
		},
		ref = ref
	})
	local icon

	if v4 then
		icon = React.createElement(Icon, {
			name = v4.name,
			size = IconSize.Small,
			style = v5,
			LayoutOrder = v4.position == IconPosition.Left and 1 or 3
		})
	end

	local text

	if v2.text and v2.text ~= "" then
		text = React.createElement(Text, {
			Text = v2.text,
			textStyle = v5,
			LayoutOrder = 2,
			tag = "auto-x size-0-full shrink text-caption-large text-truncate-end"
		})
	end

	return createElement(View, v6, { Icon = icon, Text = text })
end

return React.memo(React.forwardRef(Chip))
