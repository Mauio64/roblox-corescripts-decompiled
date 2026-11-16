local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpRequest")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GamePass/GamePassStoreTypes")
local GamePassUrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GamePass/GamePassUrlBuilder")

local config = HttpRequest.config({
	requestFunction = function(p2, p3, p4)
		return HttpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
	end
})

local function fetchGamePasses(p2)
	return config(GamePassUrlBuilder.buildGamePassesUrl({ universeId = p2 }), "GET"):andThen(function(p3)
		local gamePasses = p3.responseBody and p3.responseBody.gamePasses or {}
		return { universeId = p2, gamePasses = gamePasses }
	end)
end

return fetchGamePasses
