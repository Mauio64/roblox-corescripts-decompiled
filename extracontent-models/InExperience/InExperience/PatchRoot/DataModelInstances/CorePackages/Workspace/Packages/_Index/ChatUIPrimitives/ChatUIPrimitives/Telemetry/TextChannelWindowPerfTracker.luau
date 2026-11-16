local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent

local TimeToInteractiveTracker = require(parent.TimeToInteractiveTracker)
local v = TimeToInteractiveTracker.TimeToInteractiveTracker
local IntervalPerformanceTracker = require(parent.IntervalPerformanceTracker)
local v2 = IntervalPerformanceTracker.IntervalPerformanceTracker

local v3 = { "duration", "averageFPS", "longestFrameTime" }

local defineFastFlag = game:DefineFastFlag("TextChannelWindowPerfTrackingEnabled", false)
local v4 = nil

local v5 = {}
local v6 = {}

local function isEnabled() -- 6 equivalent calls inferred from this helper
	return if v4 == nil then defineFastFlag else v4
end

local TextChannelWindowPerfTracker = {}

function TextChannelWindowPerfTracker.withTrackers(p, p2)
	v = p
	v2 = p2
end

function TextChannelWindowPerfTracker._setEnabledForTesting(flag: boolean?)
	v4 = flag
end

function TextChannelWindowPerfTracker.startMountTTI(p: string)
	if not isEnabled() then -- inferred equivalent call
		return
	end

	v.trackStart("TextChannelWindow_MountTTI_" .. p)
end

function TextChannelWindowPerfTracker.finishMountTTI(p: string)
	if not isEnabled() then -- inferred equivalent call
		return
	end

	v.trackEnd("TextChannelWindow_MountTTI_" .. p)
end

local function sendIntervalName(p: string) -- 4 equivalent calls inferred from this helper
	return "TextChannelWindow_MessageSendToRenderInterval_" .. p
end

local function receiveIntervalName(p: string) -- 4 equivalent calls inferred from this helper
	return "TextChannelWindow_MessageReceiveToRenderInterval_" .. p
end

function TextChannelWindowPerfTracker.startSendInterval(id: string, p: string)
	if not isEnabled() then -- inferred equivalent call
		return
	end

	local v7 = v5[p]
	local v8 = v7 == nil and 0 or v7.timestamp or 0

	if v7 ~= nil and v7.id ~= nil and v8 + 5 > os.clock() then
		return
	end

	v5[p] = { id = id, timestamp = os.clock() }
	local v9 = sendIntervalName(p) -- inferred equivalent call
	v2:cancelTracking(v9)
	v2:startTracking(v9, nil, v3, true, true)
end

function TextChannelWindowPerfTracker.startReceiveInterval(id: string, p: string)
	if not isEnabled() then -- inferred equivalent call
		return
	end

	local v7 = v6[p]
	local v8 = v7 == nil and 0 or v7.timestamp or 0

	if v7 ~= nil and v7.id ~= nil and v8 + 5 > os.clock() then
		return
	end

	v6[p] = { id = id, timestamp = os.clock() }
	local v9 = receiveIntervalName(p) -- inferred equivalent call
	v2:cancelTracking(v9)
	v2:startTracking(v9, nil, v3, true, true)
end

function TextChannelWindowPerfTracker.finishMessageIntervals(p: string)
	if not isEnabled() then -- inferred equivalent call
		return
	end

	for k, v7 in v5 do
		if v7.id ~= p then
			continue
		end

		v5[k] = {}
		v2:stopAndLogTracking(sendIntervalName(k)) -- inferred equivalent call
	end

	for k, v7 in v6 do
		if v7.id ~= p then
			continue
		end

		v6[k] = {}
		v2:stopAndLogTracking(receiveIntervalName(k)) -- inferred equivalent call
	end
end

function TextChannelWindowPerfTracker.cancelForChannel(p: string)
	if not isEnabled() then -- inferred equivalent call
		return
	end

	if v5[p] then
		v5[p] = {}
		v2:cancelTracking(sendIntervalName(p)) -- inferred equivalent call
	end

	if v6[p] then
		v6[p] = {}
		v2:cancelTracking(receiveIntervalName(p)) -- inferred equivalent call
	end
end

function TextChannelWindowPerfTracker.cancelAll()
	for k in v5 do
		v2:cancelTracking(sendIntervalName(k)) -- inferred equivalent call
	end

	for k in v6 do
		v2:cancelTracking(receiveIntervalName(k)) -- inferred equivalent call
	end

	v5 = {}
	v6 = {}
end

return TextChannelWindowPerfTracker
