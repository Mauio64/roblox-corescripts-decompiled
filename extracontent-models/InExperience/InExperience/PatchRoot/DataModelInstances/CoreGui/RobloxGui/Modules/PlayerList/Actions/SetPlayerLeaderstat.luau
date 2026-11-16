local ActionCreator = require(script.Parent.Parent.ActionCreator)

return ActionCreator("SetPlayerLeaderstat", function(player, leaderstat, p)
	return { player = player, userId = player.UserId, leaderstat = leaderstat, value = p }
end)
