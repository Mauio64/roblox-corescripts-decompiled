local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local Text = Foundation.Text
local View = Foundation.View

local LayoutToggleButton = require(PeopleReactView.Components.Buttons.LayoutToggleButton)

local Constants = require(PeopleReactView.Constants)

local function TitleBar(props)
	local v = useLocalization({ header = Constants.PEOPLEPAGE.PEOPLE_LIST.HEADER })

	return React.createElement(
		View,
		{
			tag = "row size-full-0 auto-y align-y-center flex-x-between",
			LayoutOrder = props.LayoutOrder
		},
		{
			Title = React.createElement(Text, {
				tag = "auto-xy content-default text-heading-small text-align-x-left",
				Text = v.header,
				LayoutOrder = 1
			}),
			LayoutToggleButton = React.createElement(LayoutToggleButton, {
				layout = props.layout,
				setLayout = props.setLayout,
				LayoutOrder = 2
			})
		}
	)
end

return React.memo(TitleBar)
