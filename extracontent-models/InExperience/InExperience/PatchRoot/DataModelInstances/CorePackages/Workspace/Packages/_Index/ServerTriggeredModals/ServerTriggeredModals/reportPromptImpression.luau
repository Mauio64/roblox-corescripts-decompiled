local HttpService = game:GetService("HttpService")

local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local parent = ServerTriggeredModals.Parent

local Promise = require(parent.Promise)
local Logger = require(ServerTriggeredModals.Logger)
local logResponseStatus = require(ServerTriggeredModals.logResponseStatus)
local logResponseLatency = require(ServerTriggeredModals.logResponseLatency)

local FFlagServerTriggeredModalsAccepts2xxImpressionResponses = require(ServerTriggeredModals.Flags.FFlagServerTriggeredModalsAccepts2xxImpressionResponses)

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase

local v = urlBuilder.new({ base = UrlBase.APIS, path = "modals-api/v1/prompts/impression" })

return function(promptType: string, promptId: string?)
	local internal = HttpService:RequestInternal({
		Url = v(),
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = HttpService:JSONEncode({ promptType = promptType, promptId = promptId })
	})

	return Promise.new(function(callback, callback2)
		internal:Start(function(p, p2)
			local statusCode = p2 and p2.StatusCode

			if FFlagServerTriggeredModalsAccepts2xxImpressionResponses then
				if p then
					if statusCode == nil or not (statusCode >= 200) then
						p = false
					else
						p = statusCode < 300
					end
				end
			else
				p = p and statusCode == 200
			end

			if p then
				local roundTripTime = p2 and p2.Stats and p2.Stats.RoundTripTime
				local v2 = roundTripTime and roundTripTime * 1000

				if v2 then
					logResponseLatency("modals-api/v1/prompts/impression", v2, statusCode)
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
