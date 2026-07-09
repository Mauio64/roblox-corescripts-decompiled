local Parent = script:FindFirstAncestor("GameDetailRodux").Parent
local Promise = require(Parent.Promise)
local Url = require(Parent.Http).Url
local t1 = {}

return function(p1, p2) -- line: 10
	-- upvalues: t1 (copy), Url (copy), Promise (copy)
	if t1[p2] then
		return t1[p2]
	end

	t1[p2] = p1(string.format("%sv1/games?universeIds=%s", Url.GAME_URL, (tostring(p2))), "GET"):andThen(function(p3) -- line: 16
		-- upvalues: Promise (copy)
		if not p3.responseBody or not p3.responseBody.data then
			Promise.reject("Unexpected response when fetching game name")
		end

		local v8 = p3.responseBody.data[1]

		if not v8 or not v8.name then
			Promise.reject("Unexpected response when fetching game name, no game info")
		end

		return Promise.resolve({
			Name = v8.name,
			Description = v8.description or "",
			Created = v8.created
		})
	end, function(p4) -- line: 32
		-- upvalues: Promise (copy)
		return Promise.reject(p4)
	end)

	return t1[p2]
end
