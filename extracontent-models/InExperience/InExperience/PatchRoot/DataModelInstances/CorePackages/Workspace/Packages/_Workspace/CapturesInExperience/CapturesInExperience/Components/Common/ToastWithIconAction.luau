local parent = script.Parent.Parent.Parent.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Button = Foundation.Button
local Image = Foundation.Image
local Text = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local FillBehavior = Foundation.Enums.FillBehavior
local InputSize = Foundation.Enums.InputSize

local function ToastWithIconAction(props)
	local v

	if props.text == nil then
		v = false
	else
		v = props.text ~= ""
	end

	local createElement = React.createElement
	local v2 = {
		Size = UDim2.new(props.width, UDim.new()),
		tag = "col gap-medium auto-y padding-medium radius-medium bg-over-media-0",
		testId = "--captures-toast-with-icon-action"
	}

	local createElement2 = React.createElement

	local v3 = {
		Media = React.createElement(Image, {
			LayoutOrder = 1,
			Image = props.icon,
			tag = "size-1200-1200"
		}),
		Content = 0
	}

	local createElement3 = React.createElement

	local v4 = {
		Header = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.title,
			tag = "size-full-0 auto-y text-title-small text-align-x-left text-truncate-end content-emphasis"
		}),
		Body = 0
	}
	local body

	if v then
		body = React.createElement(Text, {
			LayoutOrder = 2,
			Text = props.text,
			tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-default"
		})
	end

	v4.Body = body
	v3.Content = createElement3(View, {
		LayoutOrder = 2,
		tag = "col fill self-center gap-xxsmall auto-y"
	}, v4)
	return createElement(View, v2, {
		Header = createElement2(View, { LayoutOrder = 1, tag = "row gap-small size-full-0 auto-y" }, v3),
		Actions = React.createElement(
			View,
			{
				LayoutOrder = 2,
				tag = "row gap-small size-full-0 auto-y",
				testId = "--captures-toast-with-icon-action--actions"
			},
			{
				PrimaryAction = React.createElement(Button, {
					LayoutOrder = 1,
					text = props.actionText,
					onActivated = props.onAction,
					variant = ButtonVariant.Emphasis,
					size = InputSize.Medium,
					fillBehavior = FillBehavior.Fill,
					testId = "--captures-toast-with-icon-action--primary"
				}),
				IconAction = React.createElement(Button, {
					LayoutOrder = 2,
					icon = props.iconActionIcon,
					onActivated = props.onIconAction,
					variant = ButtonVariant.Standard,
					size = InputSize.Medium,
					testId = "--captures-toast-with-icon-action--icon"
				})
			}
		)
	})
end

return ToastWithIconAction
