local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
require(parent.Configs.ConfigTypes)
local Constants = require(parent.Constants)
require(parent.Components.Common.ActionText)
local ControlActionRow = require(parent.Components.Common.ControlActionRow)

local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local Enums = Foundation.Enums
local useTokens = Foundation.Hooks.useTokens
local ExtraKeysEnum = require(parent.Enums.ExtraKeysEnum)
local FFlagHelpPageCCL = require(parent.Flags.FFlagHelpPageCCL)
local useLocalizedLabels = require(parent.Hooks.useLocalizedLabels)

local memo = React.memo(function(p)
	local v = useLocalizedLabels({ action = p.action })

	return React.createElement(Text, {
		Text = v.action,
		tag = "auto-xy text-title-large text-align-x-center text-align-y-center"
	})
end)

local memo2 = React.memo(function(props)
	local v = useTokens()
	local style = props.isDisabled and {
		Color3 = v.Color.Content.Default.Color3,
		Transparency = 0.5
	} or nil

	local v2 = React.useMemo(function()
		local result = {}

		for _, button in ipairs(props.buttons) do
			if button == ExtraKeysEnum.TouchPad then
				if Constants.HELP_PAGE.GAMEPAD_PLAYSTATION_PLATFORMS[props.platform] then
					if
						props.platform == Enum.Platform.PS5
						and Constants.HELP_PAGE.GAMEPAD_ICON_MAP_PLAYSTATION_5[button] ~= nil
					then
						result[button] = Constants.HELP_PAGE.GAMEPAD_ICON_MAP_PLAYSTATION_5[button]
					else
						result[button] = Constants.HELP_PAGE.GAMEPAD_ICON_MAP_PLAYSTATION[button]
					end
				end
			else
				local v2

				if props.isSpatial then
					v2 = Constants.HELP_PAGE.GAMEPAD_ICON_MAP_SPATIAL[button]
				elseif Constants.HELP_PAGE.GAMEPAD_PLAYSTATION_PLATFORMS[props.platform] then
					if
						props.platform == Enum.Platform.PS5
						and Constants.HELP_PAGE.GAMEPAD_ICON_MAP_PLAYSTATION_5[button] ~= nil
					then
						v2 = Constants.HELP_PAGE.GAMEPAD_ICON_MAP_PLAYSTATION_5[button]
					else
						v2 = Constants.HELP_PAGE.GAMEPAD_ICON_MAP_PLAYSTATION[button]
					end
				else
					v2 = Constants.HELP_PAGE.GAMEPAD_ICON_MAP_XBOX[button]
				end

				result[button] = v2
			end
		end

		return result
	end, { props.buttons, props.isSpatial, props.platform })

	local v3 = React.useMemo(function()
		local children = {}

		if props.addBlankIcon and props.layoutOrderReversed then
			table.insert(
				children,
				React.createElement(View, {
					Size = UDim2.fromOffset(v.Size.Size_600, v.Size.Size_600),
					BackgroundTransparency = 1,
					LayoutOrder = -1,
					key = "BlankIconBefore"
				})
			)
		end

		for k, name in v2 do
			table.insert(
				children,
				React.createElement(
					View,
					{
						tag = "align-x-center align-y-center auto-xy",
						LayoutOrder = Constants.HELP_PAGE.GAMEPAD_LAYOUT_ORDER[k],
						key = Constants.HELP_PAGE.GAMEPAD_LAYOUT_ORDER[k]
					},
					{
						Icon = React.createElement(Icon, {
							name = name,
							size = Enums.IconSize.Large,
							style = style,
							testId = props.testId
						})
					}
				)
			)
		end

		return children
	end, { v2, props.addBlankIcon, props.layoutOrderReversed, style, props.testId, v.Size.Size_600 })

	local v4 = #props.buttons + (props.addBlankIcon and props.layoutOrderReversed and 1 or 0)
	local v5 = v.Size.Size_600 * v4 + v.Gap.XSmall * (v4 - 1)

	local createElement = React.createElement
	local v6 = {
		tag = {
			["row align-x-center align-y-center gap-xsmall auto-xy"] = not FFlagHelpPageCCL,
			["row align-x-right align-y-center gap-xsmall auto-y"] = FFlagHelpPageCCL and not props.layoutOrderReversed,
			["row align-x-left align-y-center gap-xsmall auto-y"] = FFlagHelpPageCCL and props.layoutOrderReversed
		},
		Size = 0,
		LayoutOrder = 0,
		testId = 0
	}
	local size

	if FFlagHelpPageCCL then
		size = UDim2.fromOffset(v5, 0)
	end

	v6.Size = size
	v6.LayoutOrder = props.LayoutOrder
	v6.testId = props.testId .. "Container"
	return createElement(View, v6, v3)
end)

local memo3 = React.memo(function(props)
	local v = useTokens()
	local layoutOrder = props.layoutOrderReversed and 1 or 2
	local v2 = #props.buttons + (props.addBlankIcon and props.layoutOrderReversed and 1 or 0)
	local iconWidth = v.Size.Size_600 * v2 + v.Gap.XSmall * (v2 - 1)
	local isDisabled = true

	for _, actionLabel in ipairs(props.actionLabels) do
		if not actionLabel.disabled then
			isDisabled = false
			break
		end
	end

	return React.createElement(ControlActionRow, {
		actionLabels = props.actionLabels,
		layoutOrderReversed = props.layoutOrderReversed,
		layoutOrder = props.layoutOrder,
		iconWidth = iconWidth,
		testId = "GamepadActionText-" .. props.testId,
		icon = React.createElement(memo2, {
			buttons = props.buttons,
			platform = props.platform,
			addBlankIcon = props.addBlankIcon,
			layoutOrderReversed = props.layoutOrderReversed,
			isSpatial = props.isSpatial,
			isDisabled = isDisabled,
			testId = "GamepadActionIcon-" .. props.testId,
			LayoutOrder = layoutOrder
		})
	})
end)

local memo4 = React.memo(function(props)
	local v, v2, v3 = React.useMemo(function()
		local children = {}
		local children2 = {}
		local children3 = {}

		for k, control in props.controls do
			if not control.gamepadInput then
				continue
			end

			local gamepadInput = control.gamepadInput
			local buttons = gamepadInput.input

			if buttons == nil then
				if props.isSpatial then
					buttons = gamepadInput.spatialGamepadInput
				elseif Constants.HELP_PAGE.GAMEPAD_PLAYSTATION_PLATFORMS[props.platform] then
					buttons = gamepadInput.playstationInput
				else
					buttons = gamepadInput.xboxInput
				end
			end

			if not (buttons ~= nil and #buttons > 0) then
				continue
			end

			local layoutOrder = Constants.HELP_PAGE.GAMEPAD_LAYOUT_ORDER[buttons[1]]

			if props.layoutOrderReversed then
				layoutOrder = -layoutOrder
			end

			if FFlagHelpPageCCL then
				table.insert(children, React.createElement(memo3, {
					actionLabels = control.actionLabels or {
						{ label = control.label }
					},
					buttons = buttons,
					platform = props.platform,
					layoutOrder = layoutOrder,
					layoutOrderReversed = props.layoutOrderReversed,
					addBlankIcon = props.addBlankIcon,
					isSpatial = props.isSpatial,
					testId = k,
					key = "ActionRow-" .. k
				}))
			else
				table.insert(children2, React.createElement(View, {
					tag = "col align-y-center size-0-1000 auto-x",
					LayoutOrder = layoutOrder,
					key = "Text-" .. k
				}, {
					ActionText = React.createElement(memo, {
						action = control.label,
						testId = "GamepadActionText-" .. k
					})
				}))

				table.insert(children3, React.createElement(View, {
					tag = "col align-y-center size-0-1000 auto-x",
					LayoutOrder = layoutOrder,
					key = "Icon-" .. k
				}, {
					IconContainer = React.createElement(memo2, {
						buttons = buttons,
						platform = props.platform,
						addBlankIcon = props.addBlankIcon,
						layoutOrderReversed = props.layoutOrderReversed,
						isSpatial = props.isSpatial,
						testId = "GamepadActionIcon-" .. k
					})
				}))
			end
		end

		return children2, children3, children
	end, {
		props.controls,
		props.platform,
		props.addBlankIcon,
		props.layoutOrderReversed,
		props.isSpatial
	})

	if FFlagHelpPageCCL then
		return React.createElement(View, { tag = "col gap-small size-full-0 auto-y" }, v3)
	end

	return React.createElement(View, { tag = "row gap-small auto-xy" }, {
		TextCol = React.createElement(View, {
			tag = {
				["col align-x-right auto-xy"] = not props.layoutOrderReversed,
				["col align-x-left auto-xy"] = props.layoutOrderReversed
			},
			LayoutOrder = props.layoutOrderReversed and 3 or 1
		}, v),
		IconCol = React.createElement(View, { tag = "col auto-xy", LayoutOrder = 2 }, v2)
	})
end)

return React.memo(memo4)
