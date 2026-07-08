local Parent = script:FindFirstAncestor("DataHydration").Parent
local HttpRequest = require(Parent.HttpRequest)

require(script.Parent.GamePassStoreTypes)

local GamePassUrlBuilder = require(script.Parent.GamePassUrlBuilder)
local v4 = HttpRequest.config({
	requestFunction = function(s1: string, s2: string, p1) -- line: 15
		-- upvalues: HttpRequest (copy)
		return HttpRequest.requestFunctions.HttpRbxApi(s1, s2, p1)
	end
})

local function fetchGamePasses(s3: string) -- line: 20
	-- upvalues: GamePassUrlBuilder (copy), v4 (copy)
	local v10 = GamePassUrlBuilder.buildGamePassesUrl({
		universeId = s3
	})

	return v4(v10, "GET"):andThen(function(p2) -- line: 22
		-- upvalues: s3 (copy)
		local v12 = p2.responseBody and p2.responseBody.gamePasses or {}

		return {
			universeId = s3,
			gamePasses = v12
		}
	end)
end

return fetchGamePasses
