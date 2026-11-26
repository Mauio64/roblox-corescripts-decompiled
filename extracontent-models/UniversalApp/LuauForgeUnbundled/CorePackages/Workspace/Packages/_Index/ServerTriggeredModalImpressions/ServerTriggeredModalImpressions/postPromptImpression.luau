local HttpService = game:GetService("HttpService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModalImpressions/Promise")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModalImpressions/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModalImpressions/UrlBuilder").UrlBase

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "modals-api/v1/prompts/impression"
})

return function(callback, p2, p3)
	local success, result = pcall(function()
		return callback(v5(), "POST", {
			postBody = HttpService:JSONEncode({ promptType = p2, promptId = p3 })
		})
	end)

	if success then
		return result
	end

	return Promise.reject(result)
end
