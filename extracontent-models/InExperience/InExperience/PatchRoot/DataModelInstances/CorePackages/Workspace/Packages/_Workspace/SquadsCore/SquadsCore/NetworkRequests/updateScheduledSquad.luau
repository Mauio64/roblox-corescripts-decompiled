local HttpService = game:GetService("HttpService")

local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local UrlBuilder = require(parent.UrlBuilder)
local t = require(parent.t)

local Logger = require(SquadsCore.Logger)
local ScheduledSquadModel = require(SquadsCore.Models.ScheduledSquadModel)
local serializeTable = require(SquadsCore.Utils.serializeTable)
require(SquadsCore.Types)

local urlBuilder = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase

local strictInterface = t.strictInterface({
	scheduledGroupUpId = t.number,
	title = t.string,
	startTime = t.string
})

local url = urlBuilder.new({ base = UrlBase.APIS, path = "group-up/v1/update-scheduled-group-up" })()

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
		Url = url
	}):Start(function(_, data2)
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
