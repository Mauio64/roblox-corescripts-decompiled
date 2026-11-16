local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/Promise")
local url = require("@game/CorePackages/Workspace/Packages/_Workspace/GameDetailRodux/Http").Url

local v5 = {}

return function(callback, p2)
	if v5[p2] then
		return v5[p2]
	end

	v5[p2] = callback(string.format("%sv1/games?universeIds=%s", url.GAME_URL, (tostring(p2))), "GET"):andThen(
		function(p3)
			if not (p3.responseBody and p3.responseBody.data) then
				Promise.reject("Unexpected response when fetching game name")
			end

			local v7 = p3.responseBody.data[1]

			if not (v7 and v7.name) then
				Promise.reject("Unexpected response when fetching game name, no game info")
			end

			return Promise.resolve({
				Name = v7.name,
				Description = v7.description or "",
				Created = v7.created
			})
		end,
		function(p3)
			return Promise.reject(p3)
		end
	)

	return v5[p2]
end
