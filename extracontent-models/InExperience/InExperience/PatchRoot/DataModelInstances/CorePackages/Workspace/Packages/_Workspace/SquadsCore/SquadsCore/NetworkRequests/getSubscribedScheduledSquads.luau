local HttpService = game:GetService("HttpService")

local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local UrlBuilder = require(parent.UrlBuilder)

local Logger = require(SquadsCore.Logger)
local serializeTable = require(SquadsCore.Utils.serializeTable)
require(SquadsCore.Types)

local urlBuilder = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase

local url = urlBuilder.new({
	base = UrlBase.APIS,
	path = "group-up/v1/get-subscribed-scheduled-group-ups"
})()

return function(callback, callback2)
	return HttpService:RequestInternal({
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
		Method = "GET",
		Url = url
	}):Start(function(_, data)
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
