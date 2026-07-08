local Parent = script:FindFirstAncestor("FocusNavigationUtils").Parent
local SharedFlags = require(Parent.SharedFlags)
local FFlagAppIaHomeSubTab = SharedFlags.FFlagAppIaHomeSubTab
local FFlagEnableDrawerFocusNav = SharedFlags.FFlagEnableDrawerFocusNav

return {
	ModerationOverlay = "ModerationOverlay",
	CentralOverlay = "CentralOverlay",
	NavBar = "NavBar",
	RouterView = "RouterView",
	SubRouterView = "SubRouterView",
	SearchBar = "SearchBar",
	ContextualMenu = "ContextualMenu",
	PopUp = "PopUp",
	PeekView = "PeekView",
	Auxiliary = "Auxiliary",
	HeaderView = if not FFlagAppIaHomeSubTab then nil else "HeaderView",
	Drawer = if not FFlagEnableDrawerFocusNav then nil else "Drawer"
}
