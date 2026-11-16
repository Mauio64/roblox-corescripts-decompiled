local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/UrlBuilder").UrlBuilder
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerTriggeredModals/UrlBuilder").UrlBase

local Logger = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/Logger")
local logResponseStatus = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/logResponseStatus")
local logResponseLatency = require("@game/CorePackages/Workspace/Packages/_Index/ServerTriggeredModals/ServerTriggeredModals/logResponseLatency")

local v5 = urlBuilder.new({ base = urlBase.APIS, path = "modals-api/v1/impression" })

return function(callback, p2, p3)
	if not callback then
		Logger:error("Missing networking implementation")
		return
	end

	local success, result = pcall(function()
		return callback(v5(), "POST", {
			postBody = HttpService:JSONEncode({ modalId = p2, modalType = p3 })
		})
	end)

	if success then
		result:andThen(function(p4)
			local responseCode = if p4 then p4.responseCode or nil else nil
			logResponseLatency("modals-api/v1/impression", p4.responseTimeMs, responseCode)

			if responseCode ~= nil and responseCode ~= 200 then
				Logger:error(`Unexpected responseCode when reporting impression: {responseCode}`)
			end
		end):catch(function(p4)
			logResponseStatus("modals-api/v1/impression", p4.StatusCode)
			Logger:error(`Report Impression request error: {p4}`)
		end)
	else
		Logger:error(`Report impression request failed to start: {result}`)
	end
end
