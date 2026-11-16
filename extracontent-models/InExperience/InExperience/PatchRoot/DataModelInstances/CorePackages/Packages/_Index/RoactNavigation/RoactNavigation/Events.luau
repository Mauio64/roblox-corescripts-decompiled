local NavigationSymbol = require(script.Parent.NavigationSymbol)

return {
	WillFocus = NavigationSymbol("WILL_FOCUS"),
	DidFocus = NavigationSymbol("DID_FOCUS"),
	WillBlur = NavigationSymbol("WILL_BLUR"),
	DidBlur = NavigationSymbol("DID_BLUR"),
	Action = NavigationSymbol("ACTION"),
	Refocus = NavigationSymbol("REFOCUS")
}
