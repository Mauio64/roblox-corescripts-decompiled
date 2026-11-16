local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local icon = Foundation.Icon
local inputLabel = Foundation.InputLabel
local view = Foundation.View
local iconSize = Foundation.Enums.IconSize
local controlState = Foundation.Enums.ControlState
local inputLabelSize = Foundation.Enums.InputLabelSize
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Localization").Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

local function createButtons(items, p2, onSelected, setDescription, defaultValue)
	local v5 = useTokens()

	local state, setState = React.useState(defaultValue or "")
	local children = {}

	for k, item in pairs(items) do
		local state2, setState2 = React.useState(false)

		local v6 = React.useCallback(function()
			setState(item.value)
			onSelected(item.value, item.text)

			if setDescription then
				setDescription(p2[item.value])
			end

			setState2(true)
		end, { onSelected, setDescription, setState2 })

		local v7 = React.useCallback(function(p3)
			if p3 == controlState.Hover or p3 == controlState.Pressed then
				setState2(true)
			else
				setState2(false)
			end
		end, { setState2, v6 })

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
		local v13 = {
			Text = item.text,
			textStyle = 0,
			onActivated = 0,
			onHover = 0,
			size = 0
		}
		local v14 = if state2 then v5.Color.Content.Emphasis else v5.Color.Content.Default
		v13.textStyle = v14
		v13.onActivated = v6
		v13.onHover = setState2
		v13.size = inputLabelSize.Medium
		children3.Button = createElement3(inputLabel, v13)

		local v15 = if item.value == state then React.createElement(icon, {
			name = "icons/status/success_small",
			size = iconSize.Small
		}) else nil
		children3.Icon = v15
		local children2 = {
			ButtonContainer = createElement2(
				view,
				{
					tag = "size-full-0 auto-y radius-medium row flex-between",
					onStateChanged = v7,
					onActivated = v6
				},
				children3
			),
			Divider = React.createElement(view, {
				tag = "size-full-0 auto-y",
				stroke = {
					Thickness = 0.5,
					Color = v5.Color.Content.Default.Color3,
					Transparency = next(items, k) == nil and 1 or v5.Color.Content.Default.Transparency or 1
				}
			})
		}
		table.insert(
			children,
			createElement(view, { tag = "auto-xy col gap-xsmall padding-bottom-xsmall" }, children2)
		)
	end

	return children
end

local function ButtonList(props)
	local v5 = React.useMemo(function()
		return Cryo.Dictionary.map(props.options, function(p2)
			return p2.localizationKey, p2.value
		end)
	end)

	local v6 = React.useMemo(function()
		return Cryo.Dictionary.map(props.options, function(p2)
			return p2.descriptionLocalizationKey, p2.value
		end)
	end)

	local v7 = useLocalization(v5)
	local v8 = useLocalization(v6)

	local v10 = { createButtons(React.useMemo(function()
			return Cryo.List.map(props.options, function(p2)
				return {
					text = v7[p2.value] or "",
					value = p2.value
				}
			end)
		end, { props.options, v7 }), v8, props.onSelected, props.setDescription, props.defaultValue) }
	return React.createElement(view, { tag = "size-full col" }, v10)
end

return ButtonList
