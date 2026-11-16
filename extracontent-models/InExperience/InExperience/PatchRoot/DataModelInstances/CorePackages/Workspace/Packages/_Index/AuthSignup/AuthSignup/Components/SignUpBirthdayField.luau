local parent = script:FindFirstAncestor("AuthSignup").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local AuthCommon = require(parent.AuthCommon)
local formatBoldRichText = AuthCommon.Utils.formatBoldRichText

local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local InputLabel = Foundation.InputLabel
local InputLabelSize = Foundation.Enums.InputLabelSize
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local function SignUpBirthdayField(props)
	local v = useTokens()
	local contentemphasis

	if props.text == nil then
		contentemphasis = false
	else
		contentemphasis = props.text ~= ""
	end

	local createElement = React.createElement
	local v2 = {
		tag = "col gap-small size-full-0 auto-y",
		LayoutOrder = props.LayoutOrder,
		ref = props.containerRef
	}

	local createElement2 = React.createElement
	local text

	if props.isLabelBold then
		text = formatBoldRichText(props.label)
	else
		text = props.label
	end

	local children = {
		Label = createElement2(InputLabel, {
			Text = text,
			RichText = props.isLabelBold,
			isRequired = true,
			size = InputLabelSize.Medium,
			LayoutOrder = 1
		}),
		Field = 0
	}

	local createElement3 = React.createElement
	local v3 = {
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
	local text2

	if contentemphasis then
		text2 = props.text
	else
		text2 = props.placeholder
	end

	children.Field = createElement3(View, v3, {
		Text = createElement4(Text, {
			Text = text2,
			tag = {
				["grow auto-xy text-body-large text-align-x-left"] = true,
				["content-emphasis"] = contentemphasis,
				["content-default"] = not contentemphasis
			},
			LayoutOrder = 1
		}),
		CalendarIcon = React.createElement(Icon, {
			name = IconName.Calendar,
			size = IconSize.Large,
			style = v.Color.Content.Emphasis,
			LayoutOrder = 2
		})
	})
	return createElement(View, v2, children)
end

return SignUpBirthdayField
