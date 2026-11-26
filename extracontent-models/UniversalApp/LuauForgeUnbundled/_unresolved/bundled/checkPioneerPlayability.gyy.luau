local pioneerInfo = require("@luauforge/bundled/gid").PioneerInfo
local getUniverseIdFromPlaceId = require("@game/CorePackages/Workspace/Packages/AuthCommon").Thunks.GetUniverseIdFromPlaceId
local url = require("@game/CorePackages/Workspace/Packages/Http").Url

local function checkPioneerPlayability(callback)
	local pioneerRootPlaceId = pioneerInfo.getPioneerRootPlaceId()
	assert(pioneerRootPlaceId, "checkPioneerPlayability: could not resolve a Pioneer root placeId")

	return getUniverseIdFromPlaceId(callback, pioneerRootPlaceId):andThen(function(p2)
		return callback(
			string.format(
				"%sv1/games/multiget-playability-status?universeIds=%s",
				url.GAME_URL,
				(tostring(p2))
			),
			"GET"
		)
	end):andThen(function(p2)
		local v5 = p2 and p2.responseBody and p2.responseBody[1]
		assert(v5, "checkPioneerPlayability: empty playability response")
		return {
			isPlayable = v5.isPlayable == true,
			playabilityStatus = v5.playabilityStatus
		}
	end)
end

return checkPioneerPlayability
