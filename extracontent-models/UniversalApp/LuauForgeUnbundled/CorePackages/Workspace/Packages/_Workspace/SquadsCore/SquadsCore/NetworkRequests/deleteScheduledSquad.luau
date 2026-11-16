local HttpService = game:GetService("HttpService")

local UrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/UrlBuilder")
local t = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/t")

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Logger")
local serializeTable = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Utils/serializeTable")

local urlBuilder = UrlBuilder.UrlBuilder
local urlBase = UrlBuilder.UrlBase

local strictInterface = t.strictInterface({ scheduledGroupUpId = t.number })

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "group-up/v1/delete-scheduled-group-up"
})()

return function(p2, callback, callback2)
	assert(strictInterface(p2))

	return HttpService:RequestInternal({
		Body = HttpService:JSONEncode({ scheduledGroupUpId = p2.scheduledGroupUpId }),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
		Method = "DELETE",
		Url = v5
	}):Start(function(p3, data)
		if data.StatusCode == 200 then
			local body = data.Body

			if callback then
				callback()
			end

			Logger:debug("Response: {}", serializeTable(body))
			return data
		end

		if callback2 then
			callback2()
		end

		Logger:error("Error deleting scheduled squad: {}", data.StatusMessage)

		return data
	end)
end
