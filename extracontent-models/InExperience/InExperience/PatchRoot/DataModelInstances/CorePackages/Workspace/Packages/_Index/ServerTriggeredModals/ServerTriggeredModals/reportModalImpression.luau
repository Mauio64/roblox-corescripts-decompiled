local HttpService = game:GetService("HttpService")

local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local parent = ServerTriggeredModals.Parent

local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder
local UrlBuilder2 = require(parent.UrlBuilder)
local UrlBase = UrlBuilder2.UrlBase

local Logger = require(ServerTriggeredModals.Logger)
local logResponseStatus = require(ServerTriggeredModals.logResponseStatus)
local logResponseLatency = require(ServerTriggeredModals.logResponseLatency)

local v = urlBuilder.new({ base = UrlBase.APIS, path = "modals-api/v1/impression" })

return function(callback, modalId: string, modalType: string)
	if not callback then
		Logger:error("Missing networking implementation")
		return
	end

	local success, result = pcall(function()
		return callback(v(), "POST", {
			postBody = HttpService:JSONEncode({ modalId = modalId, modalType = modalType })
		})
	end)

	if success then
		result:andThen(function(p)
			local responseCode

			if p then
				responseCode = p.responseCode or nil
			end

			logResponseLatency("modals-api/v1/impression", p.responseTimeMs, responseCode)

			if responseCode ~= nil and responseCode ~= 200 then
				Logger:error(`Unexpected responseCode when reporting impression: {responseCode}`)
			end
		end):catch(function(p)
			logResponseStatus("modals-api/v1/impression", p.StatusCode)
			Logger:error(`Report Impression request error: {p}`)
		end)
	else
		Logger:error(`Report impression request failed to start: {result}`)
	end
end
