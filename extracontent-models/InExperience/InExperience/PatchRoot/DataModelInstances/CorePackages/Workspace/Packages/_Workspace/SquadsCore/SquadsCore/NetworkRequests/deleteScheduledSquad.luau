local HttpService = game:GetService("HttpService")

local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local UrlBuilder = require(parent.UrlBuilder)
local t = require(parent.t)

local Logger = require(SquadsCore.Logger)
local serializeTable = require(SquadsCore.Utils.serializeTable)

local urlBuilder = UrlBuilder.UrlBuilder
local UrlBase = UrlBuilder.UrlBase

local strictInterface = t.strictInterface({ scheduledGroupUpId = t.number })

local url = urlBuilder.new({ base = UrlBase.APIS, path = "group-up/v1/delete-scheduled-group-up" })()

return function(p, callback, callback2)
	assert(strictInterface(p))

	return HttpService:RequestInternal({
		Body = HttpService:JSONEncode({ scheduledGroupUpId = p.scheduledGroupUpId }),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" },
		Method = "DELETE",
		Url = url
	}):Start(function(_, data)
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
