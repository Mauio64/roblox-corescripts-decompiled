local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpRequest")

local GameDeveloperProductUrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameDeveloperProduct/GameDeveloperProductUrlBuilder")

local config = HttpRequest.config({
	requestFunction = function(p2, p3, p4)
		return HttpRequest.requestFunctions.HttpRbxApi(p2, p3, p4)
	end
})

local function parseStatusCounts(responseBody)
	local statusCounts = {}

	if typeof(responseBody) ~= "table" then
		return statusCounts
	end

	for i, item in ipairs(responseBody) do
		if not (typeof(item) == "table" and item.actionArgs and item.receipt) then
			continue
		end

		for j, actionArg in ipairs(item.actionArgs) do
			if actionArg.Key == "productId" and actionArg.Value then
				statusCounts[tostring(actionArg.Value)] = (statusCounts[tostring(actionArg.Value)] or 0) + 1
			end
		end
	end

	return statusCounts
end

local function fetchGameDeveloperProductStatuses(p2, p3)
	return config(GameDeveloperProductUrlBuilder.buildStatusesUrl({ playerId = p2, placeId = p3 }), "GET"):andThen(function(p4)
		return {
			playerId = p2,
			placeId = p3,
			counts = parseStatusCounts(p4 and p4.responseBody)
		}
	end)
end

return {
	fetch = fetchGameDeveloperProductStatuses,
	_parseStatusCounts = parseStatusCounts
}
