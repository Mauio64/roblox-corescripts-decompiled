local peekViewState = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/PeekView").PeekViewState

return function(p2): boolean
	return p2 == peekViewState.Full or p2 == peekViewState.Extended
end
