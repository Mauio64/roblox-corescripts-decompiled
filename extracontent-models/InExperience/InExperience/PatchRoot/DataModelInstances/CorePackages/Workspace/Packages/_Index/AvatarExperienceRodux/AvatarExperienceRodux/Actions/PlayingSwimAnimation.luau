local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(playingSwimAnimation)
	return { playingSwimAnimation = playingSwimAnimation }
end)
