local parent = script:FindFirstAncestor("ProfilePlatform").Parent

local PeekView = require(parent.PeekView)
local PeekViewState = PeekView.PeekViewState

return function(p): boolean
	return p == PeekViewState.Full or p == PeekViewState.Extended
end
