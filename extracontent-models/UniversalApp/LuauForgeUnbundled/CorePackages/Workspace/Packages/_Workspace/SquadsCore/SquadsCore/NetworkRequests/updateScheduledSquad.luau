local HttpService = game:GetService("HttpService")

local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/UrlBuilder")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/t")

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Logger")
local ScheduledSquadModel = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Models/ScheduledSquadModel")
local serializeTable = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Utils/serializeTable")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Types")

local urlBuilder = UrlBuilder.UrlBuilder
local urlBase = UrlBuilder.UrlBase

local strictInterface = t.strictInterface({
	scheduledGroupUpId = t.number,
	title = t.string,
	startTime = t.string
})

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "group-up/v1/update-scheduled-group-up"
})()

return function(data, callback, callback2)
	assert(strictInterface(data))

	return HttpService:RequestInternal({
		Body = HttpService:JSONEncode({
			scheduledGroupUpId = data.scheduledGroupUpId,
			title = data.title,
			startTime = data.startTime
		}),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
		Method = "POST",
		Url = v5
	}):Start(function(p2, data2)
		if data2.StatusCode == 200 then
			local body = data2.Body

			if callback then
				callback(ScheduledSquadModel.format(HttpService:JSONDecode(body)))
			end

			Logger:debug("Response: {}", serializeTable(body))
			return data2
		end

		if callback2 then
			callback2()
		end

		Logger:error("Error updating scheduled squad: {}", data2.StatusMessage)

		return data2
	end)
end
