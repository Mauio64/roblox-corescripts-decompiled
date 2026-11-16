local UserConnector = require(script.Parent.Parent.connectors.UserConnector)
local findUserById = UserConnector.findUserById
local findMe = UserConnector.findMe
return {
	default = {
		findUserById = function(_, p: string)
			return findUserById(p)
		end,
		findMe = function(_)
			return findMe()
		end
	}
}
