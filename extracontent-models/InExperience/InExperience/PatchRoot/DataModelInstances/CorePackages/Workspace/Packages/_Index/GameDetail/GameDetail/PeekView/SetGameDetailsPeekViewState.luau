local parent = script:FindFirstAncestor("GameDetail").Parent
local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator("SetGameDetailsPeekViewState", function(viewState)
	return { viewState = viewState }
end)
