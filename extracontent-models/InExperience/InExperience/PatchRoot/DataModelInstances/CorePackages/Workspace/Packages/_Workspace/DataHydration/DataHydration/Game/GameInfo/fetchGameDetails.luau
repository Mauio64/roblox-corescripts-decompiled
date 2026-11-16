local parent = script:FindFirstAncestor("DataHydration").Parent

local Http = require(parent.Http)
local HttpRequest = require(parent.HttpRequest)

local Url = Http.Url

local function requestGameDetails(list)
	local joined = table.concat(list, ",")

	local v = string.format("%sv1/games?universeIds=%s", Url.GAME_URL, joined)
	return HttpRequest.config({
		requestFunction = function(p: string, p2: string, p3)
			return HttpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
		end
	})(v, "GET")
end

return requestGameDetails
