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

function t2.new(t3: {[any]: any}) -- line: 101
	-- upvalues: t2 (copy)
	return (setmetatable({
		_surfaceScope = nil,
		_viewportBounds = nil,
		_running = false,
		_scanThread = nil,
		_callbacks = t3,
		_sessions = {}
	}, t2))
end
function t2.setSurfaceScope(p4, p5) -- line: 112
	p4._surfaceScope = p5
end
function t2.setViewportBounds(p6, p7) -- line: 116
	p6._viewportBounds = p7
end
function t2.start(p8) -- line: 123
	if p8._running then
		return
	end

	p8._running = true
	p8:_scheduleNextScan()
end
function t2._scheduleNextScan(p9) -- line: 131
	p9._scanThread = task.delay(0.2, function() -- line: 132
		-- upvalues: p9 (copy)
		if not p9._running then
			return
		end

		p9:_scanTick(DateTime.now().UnixTimestampMillis)

		if p9._running then
			p9:_scheduleNextScan()
		end
	end)
end
function t2._scanTick(p10, n1: number) -- line: 145
	-- upvalues: CollectionService (copy), Constants (copy), measureTile (copy), sponsoredAdViewabilityState (copy)
	local _surfaceScope = p10._surfaceScope
	local _viewportBounds = p10._viewportBounds

	if _surfaceScope == nil or _viewportBounds == nil then
		return
	end

	if _viewportBounds.max.X <= _viewportBounds.min.X or _viewportBounds.max.Y <= _viewportBounds.min.Y then
		return
	end

	local t4 = {}

	for _, v28 in CollectionService:GetTagged(Constants.CandidateTag) do
		local v29 = measureTile(v28, _surfaceScope, _viewportBounds)

		if v29 then
			local metadata = v29.metadata
			local encryptedAdTrackingData = metadata.encryptedAdTrackingData

			t4[encryptedAdTrackingData] = true

			local v32 = p10._sessions[encryptedAdTrackingData]

			if not v32 then
				v32 = {
					state = sponsoredAdViewabilityState.new(n1),
					metadata = metadata
				}
				p10._sessions[encryptedAdTrackingData] = v32
				p10._callbacks.onSessionStart(metadata, v29.geometry, n1)
			end

			for _, v34 in v32.state:advance(n1, v29.ratio, v29.geometry) do
				p10._callbacks.onMilestone(metadata, v34)
			end
		end
	end

	for v35, v36 in p10._sessions do
		if not t4[v35] then
			v36.state:advance(n1, 0, nil)
		end
	end
end
function t2._terminateAllSessions(p11, n2: number, s1: string) -- line: 187
	local _sessions = p11._sessions

	p11._sessions = {}

	for _, v42 in _sessions do
		local v43 = v42.state:finalize(n2)

		p11._callbacks.onUnload(v42.metadata, v43, s1)
	end
end
function t2.onFeedRefresh(p12, n3: number?) -- line: 203
	-- upvalues: t1 (copy)
	p12:_terminateAllSessions(n3 or DateTime.now().UnixTimestampMillis, t1.FeedRefresh)
end
function t2.reset(p13, n4: number?) -- line: 208
	-- upvalues: t1 (copy)
	p13._running = false

	local _scanThread = p13._scanThread

	if _scanThread ~= nil and coroutine.status(_scanThread) == "suspended" then
		task.cancel(_scanThread)
	end

	p13._scanThread = nil
	p13:_terminateAllSessions(n4 or DateTime.now().UnixTimestampMillis, t1.SurfaceTeardown)
end

t2.TerminalReason = t1

return t2
