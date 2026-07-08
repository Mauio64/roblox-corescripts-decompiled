local Parent = script:FindFirstAncestor("Songbird").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local Icon = Foundation.Icon
local View = Foundation.View
local FoundationText = Foundation.Text
local withDefaults = Foundation.Utility.withDefaults
local withCommonProps = Foundation.Utility.withCommonProps
local IconSize = Foundation.Enums.IconSize
local IconPosition = Foundation.Enums.IconPosition
local StateLayerMode = Foundation.Enums.StateLayerMode
local CursorType = Foundation.Enums.CursorType
local t1 = {
	isDisabled = false,
	isChecked = false
}

local function Chip(p1, p2) -- line: 50
	-- upvalues: withDefaults (copy), t1 (copy), useTokens (copy), useCursor (copy), CursorType (copy), React (copy), IconPosition (copy), View (copy), withCommonProps (copy), StateLayerMode (copy), Icon (copy), IconSize (copy), FoundationText (copy)
	local v19 = withDefaults(p1, t1)
	local v20 = useTokens()
	local v21 = useCursor(CursorType.SmallPill)
	local v22 = React.useMemo(function() -- line: 56
		-- upvalues: v19 (copy), IconPosition (copy)
		if typeof(v19.icon) == "string" then
			return {
				name = v19.icon,
				position = IconPosition.Left
			}
		end

		return v19.icon
	end, { v19.icon })
	local v23 = if not v19.isChecked then v20.Color.Content.Emphasis else v20.Color.ActionSubEmphasis.Foreground

	return React.createElement(View, withCommonProps(v19, {
		GroupTransparency = if not v19.isDisabled then nil else 0.5,
		selection = {
			Selectable = not v19.isDisabled,
			SelectionImageObject = v21
		},
		onActivated = v19.onActivated,
		isDisabled = v19.isDisabled,
		stateLayer = {
			mode = StateLayerMode.Inverse
		},
		tag = {
			["row gap-xsmall size-0-800 padding-medium auto-x align-y-center align-x-center clip radius-circle"] = true,
			["bg-action-sub-emphasis"] = v19.isChecked,
			["bg-shift-200"] = not v19.isChecked
		},
		ref = p2
	}), {
		Icon = if not v22 then nil else React.createElement(Icon, {
			name = v22.name,
			size = IconSize.Small,
			style = v23,
			LayoutOrder = v22.position ~= IconPosition.Left and 3 or 1
		}),
		Text = if not v19.text or v19.text == "" then nil else React.createElement(FoundationText, {
			LayoutOrder = 2,
			tag = "auto-x size-0-full shrink text-caption-large text-truncate-end",
			Text = v19.text,
			textStyle = v23
		})
	})
end

return React.memo(React.forwardRef(Chip))
