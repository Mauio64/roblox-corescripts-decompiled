local NavigationSymbol = require(script.Parent.Parent.Parent.NavigationSymbol)
local v2 = NavigationSymbol("DEFAULT")
local v3 = NavigationSymbol("MODAL")
local v4 = NavigationSymbol("OVERLAY")

return {
	Default = v2,
	Modal = v3,
	Overlay = v4
}
