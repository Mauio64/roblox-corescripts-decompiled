local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator("SetLookDetailsPeekViewSelectedTab", function(selectedTab)
	return { selectedTab = selectedTab }
end)
