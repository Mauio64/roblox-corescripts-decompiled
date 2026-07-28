local HttpService = game:GetService("HttpService")
local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local UrlBuilder = require(SquadsCoreParent.UrlBuilder)
local Logger = require(SquadsCore.Logger)
local serializeTable = require(SquadsCore.Utils.serializeTable)
local SquadLuckyRecommendationError = require(SquadsCore.Enums.SquadLuckyRecommendationError)

require(SquadsCore.Types)

local UrlBuilder2 = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase

return function(s1: string, p1: ((...any) -> ...any)?, p2: ((...any) -> ...any)?) -- line: 20
	-- upvalues: UrlBuilder2 (copy), UrlBase (copy), HttpService (copy), Logger (copy), serializeTable (copy), SquadLuckyRecommendationError (copy)
	local v13 = UrlBuilder2.new({
		path = "group-up/v1/get-lucky-recommendation",
		base = UrlBase.APIS,
		query = {
			pickRequestId = s1
		}
	})()
	local v14 = HttpService:RequestInternal({
		Method = "GET",
		Headers = {
			["Content-Type"] = "application/json",
			Accept = "application/json"
		},
		Url = v13
	})
	local u15 = false

	v14:Start(function(_, p4) -- line: 44
		-- upvalues: u15 (ref), HttpService (copy), Logger (copy), serializeTable (copy), p2 (copy), SquadLuckyRecommendationError (copy), p1 (copy)
		if u15 then
			return
		end

		if p4 ~= nil and p4.StatusCode == 200 then
			local recommendations = HttpService:JSONDecode(p4.Body).recommendations
			local v19 = if not recommendations then nil else recommendations[1]

			Logger:debug("Response: {}", serializeTable(p4.Body))

			if v19 == nil then
				if p2 then
					p2(SquadLuckyRecommendationError.NoRecommendations)

					return
				end
			elseif p1 then
				p1({
					universeId = v19.universeId,
					rootPlaceId = v19.rootPlaceId,
					universeName = v19.universeName
				})

				return
			end
		else
			local v20 = if p4 == nil then nil else p4.StatusCode

			if p2 then
				p2(if v20 ~= 404 then SquadLuckyRecommendationError.Failed else SquadLuckyRecommendationError.NoRecommendations)
			end

			Logger:error("Error getting lucky recommendation: {}", p4 == nil and "request aborted" or p4.StatusMessage)
		end
	end)

	return function() -- line: 84
		-- upvalues: u15 (ref), v14 (copy)
		u15 = true
		v14:Cancel()
	end
end
