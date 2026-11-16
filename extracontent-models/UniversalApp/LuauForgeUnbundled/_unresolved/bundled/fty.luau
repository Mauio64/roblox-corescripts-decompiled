local HttpService = game:GetService("HttpService")

local timeToInteractiveTracker = require("@luauforge/bundled/ftz").TimeToInteractiveTracker
local milestone = timeToInteractiveTracker.Milestone

local module = require("@luauforge/bundled/ftA")
local module2 = require("@luauforge/bundled/ftB")

local unixTimestampMillis = nil

local function trackMilestoneUa(p2, p3)
	timeToInteractiveTracker.trackMilestone("BuyRobux_WebView_TTI", p2, p3)
end

local function handleBridgePayload(result)
	if not (typeof(result) == "table" and result.feature == module.FEATURE and result.eventName == "BuyRobux_WebView_TTI" and typeof(result.milestones) == "table") then
		return
	end

	local name = milestone.PrimaryDataReady.Name
	local v5 = { id = module.UA_ID }
	timeToInteractiveTracker.trackMilestone("BuyRobux_WebView_TTI", name, v5)

	local recordWebViewMilestones = timeToInteractiveTracker.recordWebViewMilestones

	if recordWebViewMilestones ~= nil then
		recordWebViewMilestones("BuyRobux_WebView_TTI", result.milestones)
	end

	timeToInteractiveTracker.trackEnd("BuyRobux_WebView_TTI")

	unixTimestampMillis = nil
end

return {
	EVENT_NAME = "BuyRobux_WebView_TTI",
	startTracking = function()
		unixTimestampMillis = DateTime.now().UnixTimestampMillis
		timeToInteractiveTracker.trackStart("BuyRobux_WebView_TTI", true)
	end,
	getTtiStartMs = function()
		return unixTimestampMillis
	end,
	appendTtiStartMsToUrl = function(value)
		local v5 = unixTimestampMillis

		if v5 == nil then
			return value
		end

		return value .. (string.find(value, "?", 1, true) and "&" or "?") .. module.TTI_START_MS_QUERY_PARAM .. "=" .. tostring(v5)
	end,
	L2 = {
		renderStartedUA = function()
			local renderStarted = milestone.RenderStarted
			local v5 = { id = module.UA_ID }
			timeToInteractiveTracker.trackMilestone("BuyRobux_WebView_TTI", renderStarted, v5)
		end,
		surfaceMountedUA = function()
			local surfaceMounted = milestone.SurfaceMounted
			local v5 = { id = module.UA_ID }
			timeToInteractiveTracker.trackMilestone("BuyRobux_WebView_TTI", surfaceMounted, v5)
		end,
		primaryDataStartedUA = function()
			local name = milestone.PrimaryDataStarted.Name
			local v5 = { id = module.UA_ID }
			timeToInteractiveTracker.trackMilestone("BuyRobux_WebView_TTI", name, v5)
		end
	},
	handleBridgePayload = handleBridgePayload,
	simulateWebPayload = function()
		if not module2 then
			return
		end

		task.delay(1, function()
			local success, result = pcall(HttpService.JSONDecode, HttpService, [[
{
	    "feature": "TTIComplete",
	    "eventName": "BuyRobux_WebView_TTI",
	    "milestones": [
	        { "name": "PrimaryDataReady",       "id": "web", "deltaMs": 412, "subphases": [{ "name": "ResponseReceived", "deltaMs": 380 }] },
	        { "name": "DataProcessingStarted",  "id": "web", "deltaMs": 430 },
	        { "name": "RenderStarted",          "id": "web", "deltaMs": 510 },
	        { "name": "SurfaceMounted",         "id": "web", "deltaMs": 580 },
	        { "name": "DataProcessingCompleted","id": "web", "deltaMs": 720, "subphases": [{ "name": "Decode", "deltaMs": 700 }, { "name": "TreeBuild", "deltaMs": 720 }] },
	        { "name": "FunctionallyReady",      "id": "web", "deltaMs": 800 },
	        { "name": "SurfaceReady",           "id": "web", "deltaMs": 850 }
	    ]
	}]])

			if not success or typeof(result) ~= "table" then
				return
			end

			handleBridgePayload(result)
		end)
	end
}
