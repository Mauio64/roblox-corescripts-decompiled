local parent = script:FindFirstAncestor("LegacyFriendsRodux").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(presenceCounts)
	return { presenceCounts = presenceCounts }
end)
