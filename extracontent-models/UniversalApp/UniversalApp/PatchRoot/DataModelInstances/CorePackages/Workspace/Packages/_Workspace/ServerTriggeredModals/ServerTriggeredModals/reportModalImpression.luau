local HttpService = game:GetService("HttpService")
local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local ServerTriggeredModalsParent = ServerTriggeredModals.Parent
local UrlBuilder = require(ServerTriggeredModalsParent.UrlBuilder).UrlBuilder
local UrlBase = require(ServerTriggeredModalsParent.UrlBuilder).UrlBase
local Logger = require(ServerTriggeredModals.Logger)
local logResponseStatus = require(ServerTriggeredModals.logResponseStatus)
local logResponseLatency = require(ServerTriggeredModals.logResponseLatency)
local v9 = UrlBuilder.new({
	path = "modals-api/v1/impression",
	base = UrlBase.APIS
})

return function(p1, s1: string, s2: string) -- line: 20
	-- upvalues: Logger (copy), v9 (copy), HttpService (copy), logResponseLatency (copy), logResponseStatus (copy)
	if not p1 then
		Logger:error("Missing networking implementation")

		return
	end

	local ok, result = pcall(function() -- line: 26
		-- upvalues: v9 (copy), HttpService (copy), s1 (copy), s2 (copy), p1 (copy)
		local v15 = v9()
		local json = HttpService:JSONEncode({
			modalId = s1,
			modalType = s2
		})

		return p1(v15, "POST", {
			postBody = json
		})
	end)

	if not ok then
		Logger:error(`Report impression request failed to start: { result }`)

		return
	end

	result:andThen(function(p2) -- line: 38
		-- upvalues: logResponseLatency (copy), Logger (copy)
		local v18 = p2 and p2.responseCode or nil

		logResponseLatency("modals-api/v1/impression", p2.responseTimeMs, v18)

		if v18 ~= nil and v18 ~= 200 then
			Logger:error(`Unexpected responseCode when reporting impression: { v18 }`)
		end
	end):catch(function(p3) -- line: 45
		-- upvalues: logResponseStatus (copy), Logger (copy)
		logResponseStatus("modals-api/v1/impression", p3.StatusCode)
		Logger:error(`Report Impression request error: { p3 }`)
	end)
end
