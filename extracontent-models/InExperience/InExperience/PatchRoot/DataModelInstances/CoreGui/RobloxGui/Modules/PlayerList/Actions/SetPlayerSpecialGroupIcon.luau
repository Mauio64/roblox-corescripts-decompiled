local ActionCreator = require(script.Parent.Parent.ActionCreator)

return ActionCreator("SetPlayerSpecialGroupIcon", function(player, specialGroupIcon)
	return { player = player, userId = player.UserId, specialGroupIcon = specialGroupIcon }
end)
