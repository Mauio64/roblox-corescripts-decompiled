local PlayerConnector = require(script.Parent.Parent.connectors.PlayerConnector)
local findAvatarHeadshotById = PlayerConnector.findAvatarHeadshotById
require(script.Parent.Parent.generatedTypes)
return {
	default = {
		Player = {
			avatarHeadshot = function(p, _, p2, _)
				local fetchImpl = p2.fetchImpl
				return findAvatarHeadshotById(p.id, fetchImpl)
			end
		}
	}
}
