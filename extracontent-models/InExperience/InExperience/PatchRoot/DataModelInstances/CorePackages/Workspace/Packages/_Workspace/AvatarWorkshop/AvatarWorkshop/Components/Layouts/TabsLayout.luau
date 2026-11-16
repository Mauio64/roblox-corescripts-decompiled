local parent = script:FindFirstAncestor("AvatarWorkshop").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local function TabsLayout(props)
	return React.createElement(Foundation.View, { tag = "col size-full" }, {
		Tabs = React.createElement(Foundation.Tabs, {
			tabs = props.tabs,
			activeTabId = props.activeTabId,
			onActivated = props.onTabActivated,
			testId = props.testId,
			LayoutOrder = 1
		}),
		ContentContainer = React.createElement(Foundation.View, {
			tag = "grow size-full-0",
			LayoutOrder = 2
		}, {
			props.children
		})
	})
end

return TabsLayout
