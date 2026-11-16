local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpRequest = require(parent.HttpRequest)

local GameDeveloperProductUrlBuilder = require(script.Parent.GameDeveloperProductUrlBuilder)

local config = HttpRequest.config({
	requestFunction = function(p: string, p2: string, p3)
		return HttpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
	end
})

local function parseStatusCounts(responseBody)
	local statusCounts = {}

	if typeof(responseBody) ~= "table" then
		return statusCounts
	end

	for _, item in ipairs(responseBody) do
		if not (typeof(item) == "table" and item.actionArgs and item.receipt) then
			continue
		end

		for _, actionArg in ipairs(item.actionArgs) do
			if actionArg.Key == "productId" and actionArg.Value then
				statusCounts[tostring(actionArg.Value)] = (statusCounts[tostring(actionArg.Value)] or 0) + 1
			end
		end
	end

	return statusCounts
end

local function fetchGameDeveloperProductStatuses(playerId: string, placeId: string)
	return config(GameDeveloperProductUrlBuilder.buildStatusesUrl({
		playerId = playerId,
		placeId = placeId
	}), "GET"):andThen(function(p)
		return {
			playerId = playerId,
			placeId = placeId,
			counts = parseStatusCounts(p and p.responseBody)
		}
	end)
end

return { fetch = fetchGameDeveloperProductStatuses, _parseStatusCounts = parseStatusCounts }
