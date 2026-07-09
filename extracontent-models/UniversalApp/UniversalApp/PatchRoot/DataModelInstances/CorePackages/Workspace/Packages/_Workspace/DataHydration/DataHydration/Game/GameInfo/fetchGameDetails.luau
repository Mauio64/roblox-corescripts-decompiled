local Parent = script:FindFirstAncestor("DataHydration").Parent
local Http = require(Parent.Http)
local HttpRequest = require(Parent.HttpRequest)
local Url = Http.Url

local function requestGameDetails(t1: {[any]: any}) -- line: 11
	-- upvalues: Url (copy), HttpRequest (copy)
	local v7 = table.concat(t1, ",")
	local v8 = string.format("%sv1/games?universeIds=%s", Url.GAME_URL, v7)

	return HttpRequest.config({
		requestFunction = function(s1: string, s2: string, p1) -- line: 17
			-- upvalues: HttpRequest (copy)
			return HttpRequest.requestFunctions.HttpRbxApi(s1, s2, p1)
		end
	})(v8, "GET")
end

return requestGameDetails
