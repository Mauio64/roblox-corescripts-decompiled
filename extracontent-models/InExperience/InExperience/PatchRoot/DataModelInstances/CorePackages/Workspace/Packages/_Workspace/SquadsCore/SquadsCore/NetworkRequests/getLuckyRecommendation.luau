local HttpService = game:GetService("HttpService")

local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local UrlBuilder = require(parent.UrlBuilder)

local Logger = require(SquadsCore.Logger)
local serializeTable = require(SquadsCore.Utils.serializeTable)
local SquadLuckyRecommendationError = require(SquadsCore.Enums.SquadLuckyRecommendationError)
require(SquadsCore.Types)

local urlBuilder = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase

return function(pickRequestId: string, callback, callback2)
	local internal = HttpService:RequestInternal({
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
		Method = "GET",
		Url = urlBuilder.new({
			base = UrlBase.APIS,
			path = "group-up/v1/get-lucky-recommendation",
			query = { pickRequestId = pickRequestId }
		})()
	})

	local flag = false

	internal:Start(function(_, data)
		if flag then
			return
		end

		if data == nil or data.StatusCode ~= 200 then
			local statusCode

			if data ~= nil then
				statusCode = data.StatusCode
			end

			if callback2 then
				local v

				if statusCode == 404 then
					v = SquadLuckyRecommendationError.NoRecommendations
				else
					v = SquadLuckyRecommendationError.Failed
				end

				callback2(v)
			end

			Logger:error(
				"Error getting lucky recommendation: {}",
				data == nil and "request aborted" or data.StatusMessage
			)
		else
			local recommendations = HttpService:JSONDecode(data.Body).recommendations
			local v

			if recommendations then
				v = recommendations[1]
			end

			Logger:debug("Response: {}", serializeTable(data.Body))

			if v == nil then
				if callback2 then
					callback2(SquadLuckyRecommendationError.NoRecommendations)
				end
			elseif callback then
				callback({
					universeId = v.universeId,
					rootPlaceId = v.rootPlaceId,
					universeName = v.universeName
				})
			end
		end
	end)

	return function()
		flag = true
		internal:Cancel()
	end
end
