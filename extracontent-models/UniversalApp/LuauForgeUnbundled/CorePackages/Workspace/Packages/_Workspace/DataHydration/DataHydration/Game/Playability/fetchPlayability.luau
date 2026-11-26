local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpRequest")

local url = Http.Url

local function requestPlayability(list)
	local joined = table.concat(list, ",")

	local v5 = string.format("%sv1/games/multiget-playability-status?universeIds=%s", url.GAME_URL, joined)
	return HttpRequest.config({
		requestFunction = function(p2, p3, p4)
			return HttpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
		end
	})(v5, "GET")
end

return requestPlayability
