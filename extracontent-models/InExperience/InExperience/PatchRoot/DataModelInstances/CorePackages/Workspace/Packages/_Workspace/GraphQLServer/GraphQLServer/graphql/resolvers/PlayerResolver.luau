local t1 = {}
local findAvatarHeadshotById = require(script.Parent.Parent.connectors.PlayerConnector).findAvatarHeadshotById

require(script.Parent.Parent.generatedTypes)
t1.default = {
	Player = {
		avatarHeadshot = function(p1, _, p3, _) -- line: 9
			-- upvalues: findAvatarHeadshotById (copy)
			local fetchImpl = p3.fetchImpl

			return findAvatarHeadshotById(p1.id, fetchImpl)
		end
	}
}

return t1
