local HttpService = game:GetService("HttpService")

local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/UrlBuilder")

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Logger")
local serializeTable = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Utils/serializeTable")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Types")

local urlBuilder = UrlBuilder.UrlBuilder
local urlBase = UrlBuilder.UrlBase

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "group-up/v1/get-subscribed-scheduled-group-ups"
})()

return function(callback, callback2)
	return HttpService:RequestInternal({
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
		Method = "GET",
		Url = v5
	}):Start(function(p2, data)
		if data.StatusCode == 200 then
			local body = data.Body

			if callback then
				callback(HttpService:JSONDecode(body))
			end

			Logger:debug("Response: {}", serializeTable(body))
			return data
		end

		if callback2 then
			callback2()
		end

		Logger:error("Error getting subscribed scheduled squads: {}", data.StatusMessage)

		return data
	end)
end
