local HttpService = game:GetService("HttpService")

local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/UrlBuilder")

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Logger")
local serializeTable = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Utils/serializeTable")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Types")

local urlBuilder = UrlBuilder.UrlBuilder
local urlBase = UrlBuilder.UrlBase

return function(p2, callback, callback2)
	return HttpService:RequestInternal({
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
		Method = "GET",
		Url = urlBuilder.new({
			base = urlBase.APIS,
			path = "group-up/v1/get-scheduled-group-up-status",
			query = { scheduledGroupUpId = p2 }
		})()
	}):Start(function(p3, data)
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
