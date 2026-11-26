local peekViewState = require("@luauforge/bundled/dCI").PeekViewState

local function shouldShowPeekViewShadow(p2): boolean
	return p2 ~= peekViewState.Hidden and p2 ~= peekViewState.Closed and p2 ~= peekViewState.SuperBrief
end

return shouldShowPeekViewShadow
