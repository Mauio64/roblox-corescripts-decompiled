local parent = script:FindFirstAncestor("AppComposition").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane

return {
	NavigationRegion = FFlagEnableSplitPane and { Root = "composition-navigation-root" } or nil,
	ContentRegion = {
		Root = "composition-content-root",
		Header = "composition-content-header",
		Body = "composition-content-body"
	},
	SupportRegion = FFlagEnableSplitPane and {
		Root = "composition-support-root",
		Collapsed = "composition-support-collapsed"
	} or nil,
	Layout = { Discovery = "composition-layout-discovery", Detail = "composition-layout-detail" },
	Utility = { ClipAtMaxWidth = "composition-clip-at-max-width" }
}
