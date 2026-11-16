local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpRequest = require(parent.HttpRequest)

require(script.Parent.GamePassStoreTypes)
local GamePassUrlBuilder = require(script.Parent.GamePassUrlBuilder)

local config = HttpRequest.config({
	requestFunction = function(p: string, p2: string, p3)
		return HttpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
	end
})

local function fetchGamePasses(universeId: string)
	return config(GamePassUrlBuilder.buildGamePassesUrl({ universeId = universeId }), "GET"):andThen(function(p)
		return {
			universeId = universeId,
			gamePasses = p.responseBody and p.responseBody.gamePasses or {}
		}
	end)
end

return fetchGamePasses
