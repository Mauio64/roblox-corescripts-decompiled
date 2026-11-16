local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local Constants = require(parent.Constants)
local Foundation = require(parent2.Foundation)
require(parent.Enums.TouchControlsEnum)

local Text = Foundation.Text
local View = Foundation.View
local Icon = Foundation.Icon
local useTokens = Foundation.Hooks.useTokens
local useLocalizedLabels = require(parent.Hooks.useLocalizedLabels)

return function(props)
	local v = useTokens()
	local v2 = useLocalizedLabels({ action = props.action })

	local element = React.createElement(
		View,
		{
			tag = "auto-xy padding-x-large padding-y-xsmall radius-large",
			backgroundStyle = v.Color.Extended.Gray.Gray_600,
			LayoutOrder = 1
		},
		{
			InnerAction = React.createElement(Text, {
				tag = "auto-xy text-title-small text-align-x-center",
				textStyle = v.Color.Extended.White.White_100,
				Text = v2.action
			})
		}
	)

	local name = Constants.HELP_PAGE.TOUCH_ENUM_TO_ICON[props.touchInput]

	local innerIcon = name and React.createElement(Icon, { name = name, size = v.Size.Size_1200 })

	local iconComponent = name
		and React.createElement(View, { tag = "auto-xy", LayoutOrder = 2 }, {
			InnerIcon = innerIcon
		})
		or nil

	return React.createElement(
		View,
		{ tag = "col align-x-center gap-small auto-xy", LayoutOrder = props.layoutOrder },
		{ actionComponent = element, iconComponent = iconComponent }
	)
end
