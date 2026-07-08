local t1 = {}
local UserConnector = require(script.Parent.Parent.connectors.UserConnector)
local findUserById = UserConnector.findUserById
local findMe = UserConnector.findMe

t1.default = {
	User = {
		__resolveType = function() -- line: 8
			return "Player"
		end
	},
	Query = {
		me = function(_, _, p3) -- line: 14
			-- upvalues: findMe (copy)
			return findMe(p3.fetchImpl)
		end,
		user = function(_, p5, p6) -- line: 17
			-- upvalues: findUserById (copy)
			local id = p5.id

			return findUserById(id, p6.fetchImpl)
		end
	}
}

return t1
