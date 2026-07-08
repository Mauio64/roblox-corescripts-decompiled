local t1 = {}
local UserConnector = require(script.Parent.Parent.connectors.UserConnector)
local findUserById = UserConnector.findUserById
local findMe = UserConnector.findMe

t1.default = {
	findUserById = function(_, s1: string) -- line: 7
		-- upvalues: findUserById (copy)
		return findUserById(s1)
	end,
	findMe = function(_) -- line: 10
		-- upvalues: findMe (copy)
		return findMe()
	end
}

return t1
