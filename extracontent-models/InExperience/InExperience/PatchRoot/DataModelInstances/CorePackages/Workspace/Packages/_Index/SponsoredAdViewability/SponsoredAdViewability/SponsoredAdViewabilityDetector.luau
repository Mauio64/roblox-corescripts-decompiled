local CollectionService = game:GetService("CollectionService")
local Constants = require(script.Parent.Constants)
local calculateIntersectionRatio = require(script.Parent.calculateIntersectionRatio)
local sponsoredAdViewabilityRegistry = require(script.Parent.sponsoredAdViewabilityRegistry)
local sponsoredAdViewabilityState = require(script.Parent.sponsoredAdViewabilityState)
local t1 = {
	SurfaceTeardown = "SurfaceTeardown",
	FeedRefresh = "FeedRefresh"
}

local function measureTile(p1, p2, p3) -- line: 54
	-- upvalues: Constants (copy), sponsoredAdViewabilityRegistry (copy), calculateIntersectionRatio (copy)
	if not p1:IsA("GuiObject") then
		return nil
	end

	if not p1:IsDescendantOf(p2) then
		return nil
	end

	local ConstantsViewabilityTargetIdAttribute = p1:GetAttribute(Constants.ViewabilityTargetIdAttribute)

	if typeof(ConstantsViewabilityTargetIdAttribute) ~= "string" then
		return nil
	end

	local v13 = sponsoredAdViewabilityRegistry.get(ConstantsViewabilityTargetIdAttribute)

	if v13 == nil then
		return nil
	end

	local AbsoluteSize = p1.AbsoluteSize

	return {
		metadata = v13,
		geometry = {
			adSize = AbsoluteSize,
			viewportBounds = p3
		},
		ratio = calculateIntersectionRatio(p1.AbsolutePosition, AbsoluteSize, p3)
	}
end

local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}) -- line: 102
	-- upvalues: t2 (copy)
	return (setmetatable({
		_surfaceScope = nil,
		_viewportBounds = nil,
		_running = false,
		_paused = false,
		_scanThread = nil,
		_callbacks = t3,
		_sessions = {}
	}, t2))
end
function t2.setSurfaceScope(p4, p5) -- line: 114
	p4._surfaceScope = p5
end
function t2.setViewportBounds(p6, p7) -- line: 118
	p6._viewportBounds = p7
end
function t2.start(p8) -- line: 125
	if p8._running then
		return
	end

	p8._running = true

	if not p8._paused then
		p8:_scheduleNextScan()
	end
end
function t2._cancelScheduledScan(p9) -- line: 135
	local _scanThread = p9._scanThread

	if _scanThread ~= nil and coroutine.status(_scanThread) == "suspended" then
		task.cancel(_scanThread)
	end

	p9._scanThread = nil
end
function t2._scheduleNextScan(p10) -- line: 143
	assert(p10._scanThread == nil, "scan is already scheduled")
	p10._scanThread = task.delay(0.2, function() -- line: 145
		-- upvalues: p10 (copy)
		p10._scanThread = nil

		if not p10._running or p10._paused then
			return
		end

		p10:_scanTick(DateTime.now().UnixTimestampMillis)

		if p10._running and not p10._paused then
			p10:_scheduleNextScan()
		end
	end)
end
function t2._scanTick(p11, n1: number) -- line: 159
	-- upvalues: CollectionService (copy), Constants (copy), measureTile (copy), sponsoredAdViewabilityState (copy)
	local _surfaceScope = p11._surfaceScope
	local _viewportBounds = p11._viewportBounds

	if _surfaceScope == nil or _viewportBounds == nil then
		return
	end

	if _viewportBounds.max.X <= _viewportBounds.min.X or _viewportBounds.max.Y <= _viewportBounds.min.Y then
		return
	end

	local t4 = {}

	for _, v30 in CollectionService:GetTagged(Constants.CandidateTag) do
		local v31 = measureTile(v30, _surfaceScope, _viewportBounds)

		if v31 then
			local metadata = v31.metadata
			local encryptedAdTrackingData = metadata.encryptedAdTrackingData

			t4[encryptedAdTrackingData] = true

			local v34 = p11._sessions[encryptedAdTrackingData]

			if not v34 then
				v34 = {
					state = sponsoredAdViewabilityState.new(n1),
					metadata = metadata
				}
				p11._sessions[encryptedAdTrackingData] = v34
				p11._callbacks.onSessionStart(metadata, v31.geometry, n1)
			end

			for _, v36 in v34.state:advance(n1, v31.ratio, v31.geometry) do
				p11._callbacks.onMilestone(metadata, v36)
			end
		end
	end

	for v37, v38 in p11._sessions do
		if not t4[v37] then
			v38.state:advance(n1, 0, nil)
		end
	end
end
function t2.pause(p12, n2: number?) -- line: 200
	if p12._paused then
		return
	end

	local v41 = n2 or DateTime.now().UnixTimestampMillis

	for _, v43 in p12._sessions do
		v43.state:pause(v41)
	end

	p12._paused = true
	p12:_cancelScheduledScan()
end
function t2.resume(p13, n3: number?) -- line: 212
	if not p13._paused then
		return
	end

	local v46 = n3 or DateTime.now().UnixTimestampMillis

	for _, v48 in p13._sessions do
		v48.state:resume(v46)
	end

	p13._paused = false

	if p13._running then
		p13:_scheduleNextScan()
	end
end
function t2._terminateAllSessions(p14, n4: number, s1: string) -- line: 227
	local _sessions = p14._sessions

	p14._sessions = {}

	for _, v54 in _sessions do
		local v55 = v54.state:finalize(n4)

		p14._callbacks.onUnload(v54.metadata, v55, s1)
	end
end
function t2.onFeedRefresh(p15, n5: number?) -- line: 243
	-- upvalues: t1 (copy)
	p15:_terminateAllSessions(n5 or DateTime.now().UnixTimestampMillis, t1.FeedRefresh)
end
function t2.reset(p16, n6: number?) -- line: 248
	-- upvalues: t1 (copy)
	p16._running = false
	p16:_cancelScheduledScan()
	p16:_terminateAllSessions(n6 or DateTime.now().UnixTimestampMillis, t1.SurfaceTeardown)
end

t2.TerminalReason = t1

return t2
