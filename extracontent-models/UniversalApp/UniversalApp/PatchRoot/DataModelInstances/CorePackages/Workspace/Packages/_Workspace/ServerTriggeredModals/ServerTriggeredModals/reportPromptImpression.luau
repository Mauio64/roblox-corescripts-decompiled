local HttpService = game:GetService("HttpService")
local ServerTriggeredModals = script:FindFirstAncestor("ServerTriggeredModals")
local ServerTriggeredModalsParent = ServerTriggeredModals.Parent
local Promise = require(ServerTriggeredModalsParent.Promise)
local Logger = require(ServerTriggeredModals.Logger)
local logResponseStatus = require(ServerTriggeredModals.logResponseStatus)
local logResponseLatency = require(ServerTriggeredModals.logResponseLatency)
local UrlBuilder = require(ServerTriggeredModalsParent.UrlBuilder).UrlBuilder
local UrlBase = require(ServerTriggeredModalsParent.UrlBuilder).UrlBase
local v10 = UrlBuilder.new({
	path = "modals-api/v1/prompts/impression",
	base = UrlBase.APIS
})

return function(s1: string, s2: string?) -- line: 21
	-- upvalues: v10 (copy), HttpService (copy), Promise (copy), logResponseStatus (copy), Logger (copy), logResponseLatency (copy)
	local v13 = v10()
	local json = HttpService:JSONEncode({
		promptType = s1,
		promptId = s2
	})
	local v15 = HttpService:RequestInternal({
		Method = "POST",
		Url = v13,
		Headers = {
			["Content-Type"] = "application/json"
		},
		Body = json
	})

	return Promise.new(function(resolve, reject) -- line: 32
		-- upvalues: v15 (copy), logResponseStatus (copy), Logger (copy), logResponseLatency (copy)
		v15:Start(function(p1, p2) -- line: 33
			-- upvalues: logResponseStatus (copy), Logger (copy), reject (copy), logResponseLatency (copy), resolve (copy)
			local v20 = p2 and p2.StatusCode

			if not p1 or v20 ~= 200 then
				logResponseStatus("modals-api/v1/prompts/impression", v20)
				Logger:error(`Report Prompt Impression request error with status code: { v20 }`)
				reject()

				return
			end

			local v21 = p2 and (p2.Stats and p2.Stats.RoundTripTime)
			local v22 = v21 and v21 * 1000

			if v22 then
				logResponseLatency("modals-api/v1/prompts/impression", v22, v20)
			end

			resolve()
		end)
	end)
end
