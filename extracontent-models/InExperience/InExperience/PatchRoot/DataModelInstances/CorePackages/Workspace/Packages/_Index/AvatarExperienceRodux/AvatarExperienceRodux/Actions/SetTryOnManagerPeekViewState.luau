local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator("SetTryOnManagerPeekViewState", function(viewState)
	return { viewState = viewState }
end)
