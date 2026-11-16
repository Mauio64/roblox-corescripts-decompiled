require("@luauforge/bundled/bXj")
local gameParams = require("@luauforge/bundled/bXj").GameParams
local experienceService = require("@luauforge/bundled/bXj").ExperienceService

local function launchGame(p2, p3, p4)
	experienceService:LaunchExperience(p2, p3, p4)
end

return {
	ByUser = function(p2, p3, p4, p5)
		local v6 = gameParams.fromUserId(p3.id)
		assert(v6.userId ~= nil, "Joining a game by user should always be done by user id")
		experienceService:LaunchExperience(v6, p4, p5)
	end,
	ByUserAndPlaceId = function(self, p3, p4, p5, p6)
		local v6 = gameParams.fromUserId(p3.id, p4)
		assert(v6.userId ~= nil, "Joining a game by user and placeId should always contain a user id param")
		assert(
			v6.placeId ~= nil,
			"Joining a game by user and placeId should always contain a place id param"
		)
		experienceService:LaunchExperience(v6, p5, p6)
	end,
	ByGame = function(p2, p3, p4, p5)
		experienceService:LaunchExperience(gameParams.fromPlaceId(p3), p4, p5)
	end
}
