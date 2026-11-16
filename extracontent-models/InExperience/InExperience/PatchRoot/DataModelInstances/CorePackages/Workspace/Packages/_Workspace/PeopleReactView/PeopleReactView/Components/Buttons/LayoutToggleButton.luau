local parent = script:FindFirstAncestor("PeopleReactView").Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local Icon = Foundation.Icon
local View = Foundation.View

local gameSettings = UserSettings().GameSettings

local function LayoutToggleButton(props)
	local v = React.useCallback(function(peoplePageLayout)
		return function()
			gameSettings.PeoplePageLayout = peoplePageLayout
			props.setLayout(peoplePageLayout)
		end
	end, {})

	return React.createElement(
		View,
		{
			tag = "row auto-xy bg-shift-100 radius-medium gap-xxsmall padding-xsmall",
			LayoutOrder = props.LayoutOrder
		},
		{
			CardLayoutButton = React.createElement(View, {
				tag = {
					["row align-x-center align-y-center size-1000-1000 radius-medium"] = true,
					["bg-shift-300"] = props.layout == Enum.PeoplePageLayout.Card
				},
				LayoutOrder = 1,
				onActivated = v(Enum.PeoplePageLayout.Card)
			}, {
				Icon = React.createElement(Icon, { name = IconName.Grid, size = InputSize.Medium })
			}),
			ListLayoutButton = React.createElement(View, {
				tag = {
					["row align-x-center align-y-center size-1000-1000 radius-medium"] = true,
					["bg-shift-300"] = props.layout == Enum.PeoplePageLayout.List
				},
				LayoutOrder = 2,
				onActivated = v(Enum.PeoplePageLayout.List)
			}, {
				Icon = React.createElement(Icon, {
					name = IconName.ListBulleted,
					size = InputSize.Medium
				})
			})
		}
	)
end

return React.memo(LayoutToggleButton)
