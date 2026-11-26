local HttpService = game:GetService("HttpService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/Promise")
local Logger = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/Logger")
local logResponseStatus = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/logResponseStatus")
local logResponseLatency = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/logResponseLatency")

local FFlagServerTriggeredModalsAccepts2xxImpressionResponses = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/Flags/FFlagServerTriggeredModalsAccepts2xxImpressionResponses")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/UrlBuilder").UrlBase

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "modals-api/v1/prompts/impression"
})

return function(p2, p3)
	local internal = HttpService:RequestInternal({
		Url = v5(),
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = HttpService:JSONEncode({ promptType = p2, promptId = p3 })
	})

	return Promise.new(function(callback, callback2)
		internal:Start(function(p4, p5)
			local statusCode = p5 and p5.StatusCode

			if FFlagServerTriggeredModalsAccepts2xxImpressionResponses then
				if p4 then
					p4 = not (statusCode == nil or not (statusCode >= 200)) and statusCode < 300
				end
			else
				p4 = p4 and statusCode == 200
			end

			if p4 then
				local roundTripTime = p5 and p5.Stats and p5.Stats.RoundTripTime
				local v7 = roundTripTime and roundTripTime * 1000

				if v7 then
					logResponseLatency("modals-api/v1/prompts/impression", v7, statusCode)
				end

				callback()
			else
				logResponseStatus("modals-api/v1/prompts/impression", statusCode)
				Logger:error(`Report Prompt Impression request error with status code: {statusCode}`)
				callback2()
			end
		end)
	end)
end
