local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/Foundation")
local formatBoldRichText = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthSignup/AuthCommon").Utils.formatBoldRichText

local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local inputLabel = Foundation.InputLabel
local inputLabelSize = Foundation.Enums.InputLabelSize
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local function SignUpBirthdayField(props)
	local v5 = useTokens()
	local v6 = not (props.text == nil) and props.text ~= ""

	local createElement = React.createElement
	local v8 = {
		tag = "col gap-small size-full-0 auto-y",
		LayoutOrder = props.LayoutOrder,
		ref = props.containerRef
	}

	local createElement2 = React.createElement
	local v11 = if props.isLabelBold then formatBoldRichText(props.label) else props.label
	local children = {
		Label = createElement2(inputLabel, {
			Text = v11,
			RichText = props.isLabelBold,
			isRequired = true,
			size = inputLabelSize.Medium,
			LayoutOrder = 1
		}),
		Field = 0
	}

	local createElement3 = React.createElement
	local v13 = {
		tag = {
			["row align-y-center gap-small size-full-1200 padding-x-medium stroke-standard radius-medium"] = true,
			["stroke-system-emphasis"] = props.isFocused == true,
			["stroke-emphasis"] = props.isFocused ~= true
		},
		onActivated = props.onActivated,
		ref = props.buttonRef,
		LayoutOrder = 2,
		testId = "--auth-signup-birthday-field"
	}

	local createElement4 = React.createElement
	local v16 = if v6 then props.text else props.placeholder
	children.Field = createElement3(view, v13, {
		Text = createElement4(text, {
			Text = v16,
			tag = {
				["grow auto-xy text-body-large text-align-x-left"] = true,
				["content-emphasis"] = v6,
				["content-default"] = not v6
			},
			LayoutOrder = 1
		}),
		CalendarIcon = React.createElement(icon, {
			name = iconName.Calendar,
			size = iconSize.Large,
			style = v5.Color.Content.Emphasis,
			LayoutOrder = 2
		})
	})
	return createElement(view, v8, children)
end

return SignUpBirthdayField
