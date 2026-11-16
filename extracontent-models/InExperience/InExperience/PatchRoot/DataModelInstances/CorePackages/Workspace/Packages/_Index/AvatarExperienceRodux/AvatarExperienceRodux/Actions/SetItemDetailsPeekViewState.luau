local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator("SetItemDetailsPeekViewState", function(viewState)
	return { viewState = viewState }
end)
