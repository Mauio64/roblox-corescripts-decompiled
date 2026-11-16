local HttpService = game:GetService("HttpService")

local parent = script:FindFirstAncestor("ServerTriggeredModalImpressions").Parent

local Promise = require(parent.Promise)
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase

local v = urlBuilder.new({ base = UrlBase.APIS, path = "modals-api/v1/prompts/impression" })

return function(callback, promptType: string, promptId: string?)
	local success, result = pcall(function()
		return callback(v(), "POST", {
			postBody = HttpService:JSONEncode({ promptType = promptType, promptId = promptId })
		})
	end)

	if success then
		return result
	end

	return Promise.reject(result)
end
