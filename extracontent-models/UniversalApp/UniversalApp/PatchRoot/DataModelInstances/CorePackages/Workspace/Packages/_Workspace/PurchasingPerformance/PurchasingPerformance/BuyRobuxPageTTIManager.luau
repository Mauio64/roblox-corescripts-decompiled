local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("PurchasingPerformance").Parent
local TimeToInteractiveTracker = require(Parent.TimeToInteractiveTracker).TimeToInteractiveTracker
local Milestone = TimeToInteractiveTracker.Milestone
local Bridge = require(script.Parent.Bridge)
local FFlagSimulateBuyRobuxPageWebTTIPayload = require(script.Parent.Flags.FFlagSimulateBuyRobuxPageWebTTIPayload)
local u7 = nil

local function trackMilestoneUa(p1, p2) -- line: 43
	-- upvalues: TimeToInteractiveTracker (copy)
	TimeToInteractiveTracker.trackMilestone("BuyRobux_WebView_TTI", p1, p2)
end
local function handleBridgePayload(t1: {[any]: any}?) -- line: 67
	-- upvalues: Bridge (copy), Milestone (copy), TimeToInteractiveTracker (copy), u7 (ref)
	if typeof(t1) ~= "table" then
		return
	end

	if t1.feature ~= Bridge.FEATURE then
		return
	end

	if t1.eventName ~= "BuyRobux_WebView_TTI" then
		return
	end

	if typeof(t1.milestones) ~= "table" then
		return
	end

	local PrimaryDataReadyName = Milestone.PrimaryDataReady.Name
	local t2 = {
		id = Bridge.UA_ID
	}

	TimeToInteractiveTracker.trackMilestone("BuyRobux_WebView_TTI", PrimaryDataReadyName, t2)

	local recordWebViewMilestones = TimeToInteractiveTracker.recordWebViewMilestones

	if recordWebViewMilestones ~= nil then
		recordWebViewMilestones("BuyRobux_WebView_TTI", t1.milestones)
	end

	TimeToInteractiveTracker.trackEnd("BuyRobux_WebView_TTI")
	u7 = nil
end

return {
	EVENT_NAME = "BuyRobux_WebView_TTI",
	startTracking = function() -- line: 95
		-- upvalues: u7 (ref), TimeToInteractiveTracker (copy)
		u7 = DateTime.now().UnixTimestampMillis
		TimeToInteractiveTracker.trackStart("BuyRobux_WebView_TTI", true)
	end,
	getTtiStartMs = function() -- line: 100
		-- upvalues: u7 (ref)
		return u7
	end,
	appendTtiStartMsToUrl = function(s1: string) -- line: 104
		-- upvalues: u7 (ref), Bridge (copy)
		local v17 = u7

		if v17 == nil then
			return s1
		end

		return s1 .. (not string.find(s1, "?", 1, true) and "?" or "&") .. Bridge.TTI_START_MS_QUERY_PARAM .. "=" .. tostring(v17)
	end,
	L2 = {
		renderStartedUA = function() -- line: 114
			-- upvalues: Milestone (copy), Bridge (copy), TimeToInteractiveTracker (copy)
			local RenderStarted = Milestone.RenderStarted
			local t3 = {
				id = Bridge.UA_ID
			}

			TimeToInteractiveTracker.trackMilestone("BuyRobux_WebView_TTI", RenderStarted, t3)
		end,
		surfaceMountedUA = function() -- line: 117
			-- upvalues: Milestone (copy), Bridge (copy), TimeToInteractiveTracker (copy)
			local SurfaceMounted = Milestone.SurfaceMounted
			local t4 = {
				id = Bridge.UA_ID
			}

			TimeToInteractiveTracker.trackMilestone("BuyRobux_WebView_TTI", SurfaceMounted, t4)
		end,
		primaryDataStartedUA = function() -- line: 120
			-- upvalues: Milestone (copy), Bridge (copy), TimeToInteractiveTracker (copy)
			local PrimaryDataStartedName = Milestone.PrimaryDataStarted.Name
			local t5 = {
				id = Bridge.UA_ID
			}

			TimeToInteractiveTracker.trackMilestone("BuyRobux_WebView_TTI", PrimaryDataStartedName, t5)
		end
	},
	handleBridgePayload = handleBridgePayload,
	simulateWebPayload = function() -- line: 133
		-- upvalues: FFlagSimulateBuyRobuxPageWebTTIPayload (copy), HttpService (copy), handleBridgePayload (copy)
		if not FFlagSimulateBuyRobuxPageWebTTIPayload then
			return
		end

		task.delay(1, function() -- line: 137
			-- upvalues: HttpService (copy), handleBridgePayload (copy)
			local ok, result = pcall(HttpService.JSONDecode, HttpService, "{\n    \"feature\": \"TTIComplete\",\n    \"eventName\": \"BuyRobux_WebView_TTI\",\n    \"milestones\": [\n        { \"name\": \"PrimaryDataReady\",       \"id\": \"web\", \"deltaMs\": 412, \"subphases\": [{ \"name\": \"ResponseReceived\", \"deltaMs\": 380 }] },\n        { \"name\": \"DataProcessingStarted\",  \"id\": \"web\", \"deltaMs\": 430 },\n        { \"name\": \"RenderStarted\",          \"id\": \"web\", \"deltaMs\": 510 },\n        { \"name\": \"SurfaceMounted\",         \"id\": \"web\", \"deltaMs\": 580 },\n        { \"name\": \"DataProcessingCompleted\",\"id\": \"web\", \"deltaMs\": 720, \"subphases\": [{ \"name\": \"Decode\", \"deltaMs\": 700 }, { \"name\": \"TreeBuild\", \"deltaMs\": 720 }] },\n        { \"name\": \"FunctionallyReady\",      \"id\": \"web\", \"deltaMs\": 800 },\n        { \"name\": \"SurfaceReady\",           \"id\": \"web\", \"deltaMs\": 850 }\n    ]\n}")

			if not ok or typeof(result) ~= "table" then
				return
			end

			handleBridgePayload(result)
		end)
	end
}
