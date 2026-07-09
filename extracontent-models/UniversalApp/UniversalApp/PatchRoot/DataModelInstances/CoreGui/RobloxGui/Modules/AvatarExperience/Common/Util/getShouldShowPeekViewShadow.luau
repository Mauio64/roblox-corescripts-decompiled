local CorePackages = game:GetService("CorePackages")
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState

local function shouldShowPeekViewShadow(p1) -- line: 4
	-- upvalues: PeekViewState (copy)
	return not (p1 == PeekViewState.Hidden or (p1 == PeekViewState.Closed or p1 == PeekViewState.SuperBrief))
end

return shouldShowPeekViewShadow
