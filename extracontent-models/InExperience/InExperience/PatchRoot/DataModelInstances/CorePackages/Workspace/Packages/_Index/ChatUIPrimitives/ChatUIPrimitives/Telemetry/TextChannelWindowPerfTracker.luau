local Parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local TimeToInteractiveTracker = require(Parent.TimeToInteractiveTracker).TimeToInteractiveTracker
local IntervalPerformanceTracker = require(Parent.IntervalPerformanceTracker).IntervalPerformanceTracker
local t1 = {
	"duration",
	"averageFPS",
	"longestFrameTime"
}
local v5 = game:DefineFastFlag("TextChannelWindowPerfTrackingEnabled", false)
local u6 = nil
local t2 = {}
local t3 = {}
local t4 = {}

local function isEnabled() -- line: 31
	-- upvalues: u6 (ref), v5 (copy)
	if u6 ~= nil then
		return u6
	end

	return v5
end

function t4.withTrackers(p1, p2) -- line: 39
	-- upvalues: TimeToInteractiveTracker (ref), IntervalPerformanceTracker (ref)
	TimeToInteractiveTracker = p1
	IntervalPerformanceTracker = p2
end
function t4._setEnabledForTesting(b1: boolean?) -- line: 44
	-- upvalues: u6 (ref)
	u6 = b1
end
function t4.startMountTTI(s1: string) -- line: 50
	-- upvalues: u6 (ref), v5 (copy), TimeToInteractiveTracker (ref)
	if not if u6 == nil then v5 else u6 then
		return
	end

	TimeToInteractiveTracker.trackStart("TextChannelWindow_MountTTI_" .. s1)
end
function t4.finishMountTTI(s2: string) -- line: 57
	-- upvalues: u6 (ref), v5 (copy), TimeToInteractiveTracker (ref)
	if not if u6 == nil then v5 else u6 then
		return
	end

	TimeToInteractiveTracker.trackEnd("TextChannelWindow_MountTTI_" .. s2)
end

local function sendIntervalName(s3: string) -- line: 64
	return "TextChannelWindow_MessageSendToRenderInterval_" .. s3
end
local function receiveIntervalName(s4: string) -- line: 68
	return "TextChannelWindow_MessageReceiveToRenderInterval_" .. s4
end

function t4.startSendInterval(s5: string, s6: string) -- line: 72
	-- upvalues: u6 (ref), v5 (copy), t2 (ref), IntervalPerformanceTracker (ref), t1 (copy)
	if not if u6 == nil then v5 else u6 then
		return
	end

	local v22 = t2[s6]
	local v23 = v22 == nil and 0 or (v22.timestamp or 0)

	if v22 ~= nil and v22.id ~= nil and v23 + 5 > os.clock() then
		return
	end

	t2[s6] = {
		id = s5,
		timestamp = os.clock()
	}

	local v24 = "TextChannelWindow_MessageSendToRenderInterval_" .. s6

	IntervalPerformanceTracker:cancelTracking(v24)
	IntervalPerformanceTracker:startTracking(v24, nil, t1, true, true)
end
function t4.startReceiveInterval(s7: string, s8: string) -- line: 87
	-- upvalues: u6 (ref), v5 (copy), t3 (ref), IntervalPerformanceTracker (ref), t1 (copy)
	if not if u6 == nil then v5 else u6 then
		return
	end

	local v27 = t3[s8]
	local v28 = v27 == nil and 0 or (v27.timestamp or 0)

	if v27 ~= nil and v27.id ~= nil and v28 + 5 > os.clock() then
		return
	end

	t3[s8] = {
		id = s7,
		timestamp = os.clock()
	}

	local v29 = "TextChannelWindow_MessageReceiveToRenderInterval_" .. s8

	IntervalPerformanceTracker:cancelTracking(v29)
	IntervalPerformanceTracker:startTracking(v29, nil, t1, true, true)
end
function t4.finishMessageIntervals(s9: string) -- line: 104
	-- upvalues: u6 (ref), v5 (copy), t2 (ref), IntervalPerformanceTracker (ref), t3 (ref)
	if not if u6 == nil then v5 else u6 then
		return
	end

	for v31, v32 in t2 do
		if s9 == v32.id then
			t2[v31] = {}
			IntervalPerformanceTracker:stopAndLogTracking("TextChannelWindow_MessageSendToRenderInterval_" .. v31)
		end
	end

	for v33, v34 in t3 do
		if s9 == v34.id then
			t3[v33] = {}
			IntervalPerformanceTracker:stopAndLogTracking("TextChannelWindow_MessageReceiveToRenderInterval_" .. v33)
		end
	end
end
function t4.cancelForChannel(s10: string) -- line: 123
	-- upvalues: u6 (ref), v5 (copy), t2 (ref), IntervalPerformanceTracker (ref), t3 (ref)
	if not if u6 == nil then v5 else u6 then
		return
	end

	if t2[s10] then
		t2[s10] = {}
		IntervalPerformanceTracker:cancelTracking("TextChannelWindow_MessageSendToRenderInterval_" .. s10)
	end

	if t3[s10] then
		t3[s10] = {}
		IntervalPerformanceTracker:cancelTracking("TextChannelWindow_MessageReceiveToRenderInterval_" .. s10)
	end
end
function t4.cancelAll() -- line: 138
	-- upvalues: t2 (ref), IntervalPerformanceTracker (ref), t3 (ref)
	for v36 in t2 do
		IntervalPerformanceTracker:cancelTracking("TextChannelWindow_MessageSendToRenderInterval_" .. v36)
	end

	for v37 in t3 do
		IntervalPerformanceTracker:cancelTracking("TextChannelWindow_MessageReceiveToRenderInterval_" .. v37)
	end

	t2 = {}
	t3 = {}
end

return t4
