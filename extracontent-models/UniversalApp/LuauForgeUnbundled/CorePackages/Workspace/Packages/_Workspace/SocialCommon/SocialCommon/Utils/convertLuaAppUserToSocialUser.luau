local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Dash")

return function(p2)
	return Dash.join(p2, { name = p2.username, gameInstanceId = p2.gameId })
end
