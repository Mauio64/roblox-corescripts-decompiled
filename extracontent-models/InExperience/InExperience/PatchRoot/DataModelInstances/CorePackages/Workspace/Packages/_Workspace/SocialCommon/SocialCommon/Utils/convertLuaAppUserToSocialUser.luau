local Parent = script:FindFirstAncestor("SocialCommon").Parent
local Dash = require(Parent.Dash)

return function(t1: {[any]: any}) -- line: 13
	-- upvalues: Dash (copy)
	return Dash.join(t1, {
		name = t1.username,
		gameInstanceId = t1.gameId
	})
end
