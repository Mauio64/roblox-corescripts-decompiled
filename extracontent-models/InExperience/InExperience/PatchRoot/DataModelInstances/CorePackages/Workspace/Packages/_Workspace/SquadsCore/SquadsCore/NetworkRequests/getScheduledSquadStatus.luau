local HttpService = game:GetService("HttpService")

local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local UrlBuilder = require(parent.UrlBuilder)

local Logger = require(SquadsCore.Logger)
local serializeTable = require(SquadsCore.Utils.serializeTable)
require(SquadsCore.Types)

local urlBuilder = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase

return function(scheduledGroupUpId: number, callback, callback2)
	return HttpService:RequestInternal({
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
		Method = "GET",
		Url = urlBuilder.new({
			base = UrlBase.APIS,
			path = "group-up/v1/get-scheduled-group-up-status",
			query = { scheduledGroupUpId = scheduledGroupUpId }
		})()
	}):Start(function(_, data)
		if data.StatusCode == 200 then
			local body = data.Body

			if callback then
				callback(HttpService:JSONDecode(body).scheduledGroupUp)
			end

			Logger:debug("Response: {}", serializeTable(body))
			return data
		end

		if callback2 then
			callback2()
		end

		Logger:error("Error getting scheduled squad status: {}", data.StatusMessage)

		return data
	end)
end
