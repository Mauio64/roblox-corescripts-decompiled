local parent = script:FindFirstAncestor("GenericAbuseReporting").Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Icon = Foundation.Icon
local InputLabel = Foundation.InputLabel
local View = Foundation.View
local IconSize = Foundation.Enums.IconSize
local ControlState = Foundation.Enums.ControlState
local InputLabelSize = Foundation.Enums.InputLabelSize
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

local function createButtons(items, p, onSelected, setDescription, defaultValue: string?)
	local v = useTokens()

	local state, setState = React.useState(defaultValue or "")
	local children = {}

	for k, item in pairs(items) do
		local state2, setState2 = React.useState(false)

		local onActivated = React.useCallback(function()
			setState(item.value)
			onSelected(item.value, item.text)

			if setDescription then
				setDescription(p[item.value])
			end

			setState2(true)
		end, { onSelected, setDescription, setState2 })

		local onStateChanged = React.useCallback(function(p2)
			if p2 == ControlState.Hover or p2 == ControlState.Pressed then
				setState2(true)
			else
				setState2(false)
			end
		end, { setState2, onActivated })

		local createElement = React.createElement

		local createElement2 = React.createElement

		local children3 = {
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 4),
				PaddingRight = UDim.new(0, 4),
				PaddingTop = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 10)
			}),
			Button = 0,
			Icon = 0
		}

		local createElement3 = React.createElement
		local v2 = {
			Text = item.text,
			textStyle = 0,
			onActivated = 0,
			onHover = 0,
			size = 0
		}
		local textStyle

		if state2 then
			textStyle = v.Color.Content.Emphasis
		else
			textStyle = v.Color.Content.Default
		end

		v2.textStyle = textStyle
		v2.onActivated = onActivated
		v2.onHover = setState2
		v2.size = InputLabelSize.Medium
		children3.Button = createElement3(InputLabel, v2)
		local icon

		if item.value == state then
			icon = React.createElement(Icon, {
				name = "icons/status/success_small",
				size = IconSize.Small
			})
		end

		children3.Icon = icon
		local children2 = {
			ButtonContainer = createElement2(
				View,
				{
					tag = "size-full-0 auto-y radius-medium row flex-between",
					onStateChanged = onStateChanged,
					onActivated = onActivated
				},
				children3
			),
			Divider = React.createElement(View, {
				tag = "size-full-0 auto-y",
				stroke = {
					Thickness = 0.5,
					Color = v.Color.Content.Default.Color3,
					Transparency = next(items, k) == nil and 1 or v.Color.Content.Default.Transparency or 1
				}
			})
		}
		table.insert(children, createElement(View, {
			tag = "auto-xy col gap-xsmall padding-bottom-xsmall"
		}, children2))
	end

	return children
end

local function ButtonList(props)
	local v = React.useMemo(function()
		return Cryo.Dictionary.map(props.options, function(p)
			return p.localizationKey, p.value
		end)
	end)

	local v2 = React.useMemo(function()
		return Cryo.Dictionary.map(props.options, function(p)
			return p.descriptionLocalizationKey, p.value
		end)
	end)

	local v3 = useLocalization(v)
	local v4 = useLocalization(v2)

	local v5 = { createButtons(React.useMemo(function()
			return Cryo.List.map(props.options, function(p)
				return {
					text = v3[p.value] or "",
					value = p.value
				}
			end)
		end, { props.options, v3 }), v4, props.onSelected, props.setDescription, props.defaultValue) }
	return React.createElement(View, { tag = "size-full col" }, v5)
end

return ButtonList
