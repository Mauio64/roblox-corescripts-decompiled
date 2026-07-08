local Parent = script:FindFirstAncestor("AppComposition").Parent
local FFlagEnableSplitPane = require(Parent.SharedFlags).FFlagEnableSplitPane

return {
	NavigationRegion = if not FFlagEnableSplitPane then nil else {
		Root = "composition-navigation-root"
	},
	ContentRegion = {
		Root = "composition-content-root",
		Header = "composition-content-header",
		Body = "composition-content-body"
	},
	SupportRegion = if not FFlagEnableSplitPane then nil else {
		Root = "composition-support-root"
	},
	Layout = {
		Discovery = "composition-layout-discovery",
		Detail = "composition-layout-detail"
	},
	Utility = {
		ClipAtMaxWidth = "composition-clip-at-max-width"
	}
}
