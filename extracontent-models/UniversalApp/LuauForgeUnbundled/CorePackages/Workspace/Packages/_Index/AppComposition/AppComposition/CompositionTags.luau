local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/_Workspace/AppComposition/SharedFlags").FFlagEnableSplitPane

return {
	NavigationRegion = fFlagEnableSplitPane and { Root = "composition-navigation-root" } or nil,
	ContentRegion = {
		Root = "composition-content-root",
		Header = "composition-content-header",
		Body = "composition-content-body"
	},
	SupportRegion = fFlagEnableSplitPane and {
		Root = "composition-support-root",
		Collapsed = "composition-support-collapsed"
	} or nil,
	Layout = {
		Discovery = "composition-layout-discovery",
		Detail = "composition-layout-detail"
	},
	Utility = { ClipAtMaxWidth = "composition-clip-at-max-width" }
}
