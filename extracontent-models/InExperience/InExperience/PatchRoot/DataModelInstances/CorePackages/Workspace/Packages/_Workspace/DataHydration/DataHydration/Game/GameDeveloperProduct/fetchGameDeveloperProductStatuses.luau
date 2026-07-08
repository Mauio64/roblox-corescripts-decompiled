local Parent = script:FindFirstAncestor("DataHydration").Parent
local HttpRequest = require(Parent.HttpRequest)
local GameDeveloperProductUrlBuilder = require(script.Parent.GameDeveloperProductUrlBuilder)
local v4 = HttpRequest.config({
	requestFunction = function(s1: string, s2: string, p1) -- line: 18
		-- upvalues: HttpRequest (copy)
		return HttpRequest.requestFunctions.HttpRbxApi(s1, s2, p1)
	end
})

local function parseStatusCounts(p2) -- line: 23
	local t1 = {}

	if typeof(p2) ~= "table" then
		return t1
	end

	for _, v in ipairs(p2) do
		if typeof(v) == "table" and v.actionArgs and v.receipt then
			for _, v2 in ipairs(v.actionArgs) do
				if v2.Key == "productId" and v2.Value then
					t1[tostring(v2.Value)] = (t1[tostring(v2.Value)] or 0) + 1
				end
			end
		end
	end

	return t1
end
local function fetchGameDeveloperProductStatuses(s3: string, s4: string) -- line: 40
	-- upvalues: GameDeveloperProductUrlBuilder (copy), v4 (copy), parseStatusCounts (copy)
	local v18 = GameDeveloperProductUrlBuilder.buildStatusesUrl({
		playerId = s3,
		placeId = s4
	})

	return v4(v18, "GET"):andThen(function(p3) -- line: 42
		-- upvalues: s3 (copy), s4 (copy), parseStatusCounts (copy)
		return {
			playerId = s3,
			placeId = s4,
			counts = parseStatusCounts(p3 and p3.responseBody)
		}
	end)
end

return {
	fetch = fetchGameDeveloperProductStatuses,
	_parseStatusCounts = parseStatusCounts
}
