local HttpService = game:GetService("HttpService")

local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/UrlBuilder")

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Logger")
local serializeTable = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Utils/serializeTable")
local SquadLuckyRecommendationError = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadLuckyRecommendationError")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Types")

local urlBuilder = UrlBuilder.UrlBuilder
local urlBase = UrlBuilder.UrlBase

return function(p2, callback, callback2)
	local internal = HttpService:RequestInternal({
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
		Method = "GET",
		Url = urlBuilder.new({
			base = urlBase.APIS,
			path = "group-up/v1/get-lucky-recommendation",
			query = { pickRequestId = p2 }
		})()
	})

	local flag = false

	internal:Start(function(p3, data)
		if flag then
			return
		end

		if data == nil or data.StatusCode ~= 200 then
			local statusCode = if data ~= nil then data.StatusCode else nil

			if callback2 then
				local v7 = if statusCode == 404 then SquadLuckyRecommendationError.NoRecommendations else SquadLuckyRecommendationError.Failed
				callback2(v7)
			end

			Logger:error(
				"Error getting lucky recommendation: {}",
				data == nil and "request aborted" or data.StatusMessage
			)
		else
			local recommendations = HttpService:JSONDecode(data.Body).recommendations
			local v6 = if recommendations then recommendations[1] else nil

			Logger:debug("Response: {}", serializeTable(data.Body))

			if v6 == nil then
				if callback2 then
					callback2(SquadLuckyRecommendationError.NoRecommendations)
				end
			elseif callback then
				callback({
					universeId = v6.universeId,
					rootPlaceId = v6.rootPlaceId,
					universeName = v6.universeName
				})
			end
		end
	end)

	return function()
		flag = true
		internal:Cancel()
	end
end
