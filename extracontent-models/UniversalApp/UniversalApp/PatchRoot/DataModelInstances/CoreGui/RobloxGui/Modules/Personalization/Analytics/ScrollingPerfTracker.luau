local v1 = game:DefineFastInt("ScrollingPerfTrackerEventStream", 0)
local v2 = game:DefineFastInt("ScrollingPerfTrackerKibana", 0)
local v3 = game:DefineFastInt("ScrollingPerfTrackerSampleCountThreshold", 50)
local v4 = game:DefineFastInt("ScrollingPerfTrackerTargetFPS", 60)

function applicationId() -- line: 38
	local AppStorageService = game:GetService("AppStorageService")

	if not AppStorageService then
		return nil
	end

	local Item = AppStorageService:GetItem("AppInstallationId")
	local v18 = typeof(Item)

	if v18 == "number" then
		return tonumber(Item) or nil
	end

	if v18 == "string" then
		if string.len(Item) <= 0 then
			return nil
		end

		return (tonumber((string.sub(Item, -string.len((tostring(1000)))))))
	end

	return nil
end

local u5 = v1
local u6 = v2

if not (u5 > 0) and not (u6 > 0) then
	return nil
end

local v7 = math.random(0, 1000)
local v8 = applicationId()

if v8 ~= nil then
	v7 = (v8 + 647) % 1000
else
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer

	while not LocalPlayer do
		Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		LocalPlayer = Players.LocalPlayer
	end

	if LocalPlayer and LocalPlayer.UserId > 0 then
		v7 = (LocalPlayer.UserId + 647) % 1000
	end
end

if not (v7 < u5) then
	u5 = 0
end

if not (v7 < u6) then
	u6 = 0
end

if not (u5 > 0) and not (u6 > 0) then
	return nil
end

local RunService = game:GetService("RunService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local ScrollingPerformance = require(script.Parent.RobloxTelemetryConfigs.ScrollingPerformance)
local u14 = not (v4 > 0) and 0.016666666666666666 or 1 / v4
local t1 = {}

t1.__index = t1

function t1.new(s1: string, p1) -- line: 116
	-- upvalues: t1 (copy)
	local t2 = {
		id = s1,
		lastScrollPosition = 0,
		histogram = {},
		sampleCount = 0,
		renderStepConn = nil,
		canvasPositionConn = nil,
		scrollingFrame = nil,
		totalScrollDistance = 0
	}

	if p1 then
		if p1.analyticsService then
			t2.analyticsService = p1.analyticsService.EventStream
		end

		t2.loggingProtocol = p1.loggingProtocol
	end

	return (setmetatable(t2, t1))
end
function t1.eventData(p2) -- line: 135
	-- upvalues: RbxAnalyticsService (copy)
	if p2.sampleCount == 0 then
		return {}
	end

	local v23 = (p2.histogram[1] or 0) / p2.sampleCount
	local n1 = 0
	local n2 = 0

	if p2.scrollingFrame then
		local AbsoluteSize = p2.scrollingFrame.AbsoluteSize

		n1 = AbsoluteSize.X
		n2 = AbsoluteSize.Y
	end

	return {
		component_id = p2.id,
		sessionid = not RbxAnalyticsService and "" or RbxAnalyticsService:GetSessionId(),
		smooth_ratio = v23,
		drop_count_0 = p2.histogram[1] or 0,
		drop_count_1 = p2.histogram[2] or 0,
		drop_count_2 = p2.histogram[3] or 0,
		drop_count_3 = p2.histogram[4] or 0,
		distance_pixels = math.ceil(p2.totalScrollDistance),
		frame_width = n1,
		frame_height = n2
	}
end
function t1.sendEvent(p3) -- line: 165
	-- upvalues: v3 (copy), u5 (ref), u6 (ref), ScrollingPerformance (copy)
	if p3.sampleCount < v3 or p3.sampleCount == 0 then
		return
	end

	local v28 = p3:eventData()

	p3:resetCounts()

	if u5 > 0 and p3.analyticsService then
		p3.analyticsService:sendEventDeferred(p3.id, "scrolling_performance", v28)
	end

	if u6 > 0 and p3.loggingProtocol then
		p3.loggingProtocol:logRobloxTelemetryEvent(ScrollingPerformance, {}, v28)
	end
end
function t1.resetCounts(p4) -- line: 182
	p4.histogram = {}
	p4.sampleCount = 0
	p4.totalScrollDistance = 0
end
function t1.canvasPositionChanged(p5) -- line: 188
	-- upvalues: RunService (copy)
	if not p5.renderStepConn then
		p5.renderStepConn = RunService.Heartbeat:Connect(function(dt) -- line: 190
			-- upvalues: p5 (copy)
			p5:captureFrameUpdate(dt)
		end)
	end
end
function t1.captureFrameUpdate(t3: {[any]: any}, n3: number) -- line: 196
	-- upvalues: u14 (ref)
	local v33 = t3.scrollingFrame and t3.scrollingFrame.CanvasPosition.Y or 0

	if v33 == t3.lastScrollPosition then
		local renderStepConn = t3.renderStepConn

		if renderStepConn then
			renderStepConn:Disconnect()
		end

		t3.renderStepConn = nil
		t3:sendEvent()

		return
	end

	t3.totalScrollDistance = t3.totalScrollDistance + math.abs(v33 - t3.lastScrollPosition)

	local v35 = math.min(4, math.floor(math.max(0, n3 - 0.002) / u14) + 1)

	t3.histogram[v35] = (t3.histogram[v35] or 0) + 1
	t3.lastScrollPosition = v33
	t3.sampleCount = t3.sampleCount + 1
end
function t1.setScrollingFrame(t4: {[any]: any}, p6) -- line: 219
	if p6 ~= t4.scrollingFrame then
		t4.scrollingFrame = p6

		local canvasPositionConn = t4.canvasPositionConn

		if p6 then
			t4.lastScrollPosition = p6.CanvasPosition.Y
			t4.canvasPositionConn = p6:GetPropertyChangedSignal("CanvasPosition"):Connect(function(_, _, _) -- line: 227
				-- upvalues: t4 (copy)
				t4:canvasPositionChanged()
			end)
		else
			t4.canvasPositionConn = nil
		end

		if canvasPositionConn then
			canvasPositionConn:Disconnect()
		end
	end
end
function t1.clean(p10) -- line: 239
	p10:setScrollingFrame(nil)

	local renderStepConn = p10.renderStepConn

	if renderStepConn then
		renderStepConn:Disconnect()
	end

	p10.renderStepConn = nil
	p10:resetCounts()
end

return t1
