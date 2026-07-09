local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local React = require(PeopleReactViewParent.React)
local Foundation = require(PeopleReactViewParent.Foundation)
local useLocalization = require(PeopleReactViewParent.Localization).Hooks.useLocalization
local FoundationText = Foundation.Text
local View = Foundation.View
local LayoutToggleButton = require(PeopleReactView.Components.Buttons.LayoutToggleButton)
local Constants = require(PeopleReactView.Constants)

local function TitleBar(t1: {[any]: any}) -- line: 23
	-- upvalues: useLocalization (copy), Constants (copy), React (copy), View (copy), FoundationText (copy), LayoutToggleButton (copy)
	local v12 = useLocalization({
		header = Constants.PEOPLEPAGE.PEOPLE_LIST.HEADER
	})

	return React.createElement(View, {
		tag = "row size-full-0 auto-y align-y-center flex-x-between",
		LayoutOrder = t1.LayoutOrder
	}, {
		Title = React.createElement(FoundationText, {
			tag = "auto-xy content-default text-heading-small text-align-x-left",
			LayoutOrder = 1,
			Text = v12.header
		}),
		LayoutToggleButton = React.createElement(LayoutToggleButton, {
			LayoutOrder = 2,
			layout = t1.layout,
			setLayout = t1.setLayout
		})
	})
end

return React.memo(TitleBar)
