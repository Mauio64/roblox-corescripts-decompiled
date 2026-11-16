local parent = script:FindFirstAncestor("FocusNavigationUtils").Parent

local SharedFlags = require(parent.SharedFlags)
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
	HeaderView = SharedFlags.FFlagAppIaHomeSubTab and "HeaderView" or nil,
	Drawer = SharedFlags.FFlagEnableDrawerFocusNav and "Drawer" or nil
}
