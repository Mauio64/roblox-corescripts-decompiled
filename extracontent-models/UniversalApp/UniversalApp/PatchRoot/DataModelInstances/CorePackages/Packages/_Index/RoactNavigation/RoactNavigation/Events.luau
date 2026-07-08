local NavigationSymbol = require(script.Parent.NavigationSymbol)
local v2 = NavigationSymbol("WILL_FOCUS")
local v3 = NavigationSymbol("DID_FOCUS")
local v4 = NavigationSymbol("WILL_BLUR")
local v5 = NavigationSymbol("DID_BLUR")
local v6 = NavigationSymbol("ACTION")
local v7 = NavigationSymbol("REFOCUS")

return {
	WillFocus = v2,
	DidFocus = v3,
	WillBlur = v4,
	DidBlur = v5,
	Action = v6,
	Refocus = v7
}
