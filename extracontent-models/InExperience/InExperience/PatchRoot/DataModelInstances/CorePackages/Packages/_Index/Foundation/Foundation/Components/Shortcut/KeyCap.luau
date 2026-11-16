local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Icon = require(Foundation.Components.Icon)
local Text = require(Foundation.Components.Text)
local View = require(Foundation.Components.View)

require(Foundation.Enums.InputPlatform)

local keyDisplay = require(script.Parent.keyDisplay)
require(script.Parent.useShortcutVariants)

local function KeyCap(props)
	local variantProps = props.variantProps
	local key = keyDisplay.resolveKey(props.keyCode, props.platform)

	if key == nil then
		return nil
	end

	if key.kind == "GamepadIcon" then
		return React.createElement(
			View,
			{
				tag = variantProps.capless.tag,
				LayoutOrder = props.LayoutOrder,
				testId = props.testId
			},
			{
				Content = React.createElement(Icon, {
					name = key.icon,
					size = variantProps.gamepadIcon.size,
					style = variantProps.gamepadIcon.style,
					testId = `{props.testId}--icon`
				})
			}
		)
	end

	local v

	if key.kind == "Text" then
		v = (utf8.len(key.text) or 0) > 1
	else
		v = false
	end

	local createElement = React.createElement
	local v2 = {
		tag = variantProps.cap.tag,
		padding = v and {
			left = UDim.new(0, variantProps.capWide.padding),
			right = UDim.new(0, variantProps.capWide.padding)
		} or nil,
		LayoutOrder = props.LayoutOrder,
		testId = props.testId
	}
	local content

	if key.kind == "Icon" then
		content = React.createElement(Icon, {
			name = key.icon,
			size = variantProps.icon.size,
			style = variantProps.icon.style,
			testId = `{props.testId}--icon`
		})
	else
		content = React.createElement(Text, {
			Text = key.text,
			tag = variantProps.text.tag,
			testId = `{props.testId}--text`
		})
	end

	return createElement(View, v2, { Content = content })
end

return KeyCap
