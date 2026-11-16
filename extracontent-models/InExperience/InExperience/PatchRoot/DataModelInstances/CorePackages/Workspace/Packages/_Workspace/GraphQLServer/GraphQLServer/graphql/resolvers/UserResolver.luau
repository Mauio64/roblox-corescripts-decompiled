local UserConnector = require(script.Parent.Parent.connectors.UserConnector)
local findUserById = UserConnector.findUserById
local findMe = UserConnector.findMe
return {
	default = {
		User = {
			__resolveType = function(): string
				return "Player"
			end
		},
		Query = {
			me = function(_, _, p)
				return findMe(p.fetchImpl)
			end,
			user = function(_, p, p2)
				return findUserById(p.id, p2.fetchImpl)
			end
		}
	}
}
