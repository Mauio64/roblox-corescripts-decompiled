local parent = script:FindFirstAncestor("GameDetailRodux").Parent

local Promise = require(parent.Promise)
local Http = require(parent.Http)
local Url = Http.Url

local v = {}

return function(callback, p)
	if v[p] then
		return v[p]
	end

	v[p] = callback(string.format("%sv1/games?universeIds=%s", Url.GAME_URL, (tostring(p))), "GET"):andThen(function(p2)
		if not (p2.responseBody and p2.responseBody.data) then
			Promise.reject("Unexpected response when fetching game name")
		end

		local v2 = p2.responseBody.data[1]

		if not (v2 and v2.name) then
			Promise.reject("Unexpected response when fetching game name, no game info")
		end

		return Promise.resolve({
			Name = v2.name,
			Description = v2.description or "",
			Created = v2.created
		})
	end, function(p2)
		return Promise.reject(p2)
	end)

	return v[p]
end
