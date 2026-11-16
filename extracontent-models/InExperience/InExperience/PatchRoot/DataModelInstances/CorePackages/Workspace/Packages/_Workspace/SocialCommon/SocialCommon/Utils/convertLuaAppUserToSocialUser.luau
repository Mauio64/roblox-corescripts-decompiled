local parent = script:FindFirstAncestor("SocialCommon").Parent

local Dash = require(parent.Dash)

return function(p)
	return Dash.join(p, { name = p.username, gameInstanceId = p.gameId })
end
