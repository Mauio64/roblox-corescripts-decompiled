local default = require("@luauforge/bundled/bXj").GameProtocol.default

local module = require("@luauforge/bundled/hZS")

require("@luauforge/bundled/hZh")
local module2 = require("@luauforge/bundled/hMx")

return function(p2, p3)
	local experienceEventData = p2 and p2.responseBody and p2.responseBody.experienceEventData or {}

	if not (experienceEventData and experienceEventData.universeId and experienceEventData.placeId) then
		return
	end

	local v5 = {}

	local joinData = experienceEventData.joinData

	if joinData then
		v5 = module.mergeExperienceJoinData(v5, joinData)
	end

	p3.launchGame(
		experienceEventData.placeId,
		module2.ExperienceEvent,
		v5.experienceJoinData,
		default,
		"ExperienceEventShareLink"
	)
end
