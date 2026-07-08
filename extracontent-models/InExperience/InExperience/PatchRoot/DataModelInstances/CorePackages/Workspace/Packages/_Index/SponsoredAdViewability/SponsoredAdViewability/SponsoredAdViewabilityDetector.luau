local CollectionService = game:GetService("CollectionService")
local Constants = require(script.Parent.Constants)
local calculateIntersectionRatio = require(script.Parent.calculateIntersectionRatio)
local sponsoredAdViewabilityRegistry = require(script.Parent.sponsoredAdViewabilityRegistry)
local sponsoredAdViewabilityState = require(script.Parent.sponsoredAdViewabilityState)

local function measureTile(p1, p2, p3) -- line: 32
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

	local v12 = sponsoredAdViewabilityRegistry.get(ConstantsViewabilityTargetIdAttribute)

	if v12 == nil then
		return nil
	end

	local AbsoluteSize = p1.AbsoluteSize

	return {
		metadata = v12,
		geometry = {
			adSize = AbsoluteSize,
			viewportBounds = p3
		},
		ratio = calculateIntersectionRatio(p1.AbsolutePosition, AbsoluteSize, p3)
	}
end

local t1 = {}

t1.__index = t1

function t1.new(t2: {[any]: any}) -- line: 79
	-- upvalues: t1 (copy)
	return (setmetatable({
		_surfaceScope = nil,
		_viewportBounds = nil,
		_running = false,
		_scanThread = nil,
		_callbacks = t2,
		_sessions = {}
	}, t1))
end
function t1.setSurfaceScope(p4, p5) -- line: 90
	p4._surfaceScope = p5
end
function t1.setViewportBounds(p6, p7) -- line: 94
	p6._viewportBounds = p7
end
function t1.start(p8) -- line: 101
	if p8._running then
		return
	end

	p8._running = true
	p8:_scheduleNextScan()
end
function t1._scheduleNextScan(p9) -- line: 109
	p9._scanThread = task.delay(0.2, function() -- line: 110
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
function t1._scanTick(p10, n1: number) -- line: 123
	-- upvalues: CollectionService (copy), Constants (copy), measureTile (copy), sponsoredAdViewabilityState (copy)
	local _surfaceScope = p10._surfaceScope
	local _viewportBounds = p10._viewportBounds

	if _surfaceScope == nil or _viewportBounds == nil then
		return
	end

	if _viewportBounds.max.X <= _viewportBounds.min.X or _viewportBounds.max.Y <= _viewportBounds.min.Y then
		return
	end

	local t3 = {}

	for _, v27 in CollectionService:GetTagged(Constants.CandidateTag) do
		local v28 = measureTile(v27, _surfaceScope, _viewportBounds)

		if v28 then
			local metadata = v28.metadata
			local encryptedAdTrackingData = metadata.encryptedAdTrackingData

			t3[encryptedAdTrackingData] = true

			local v31 = p10._sessions[encryptedAdTrackingData]

			if not v31 then
				v31 = sponsoredAdViewabilityState.new(n1)
				p10._sessions[encryptedAdTrackingData] = v31
				p10._callbacks.onSessionStart(metadata, v28.geometry, n1)
			end

			for _, v33 in v31:advance(n1, v28.ratio, v28.geometry) do
				p10._callbacks.onMilestone(metadata, v33)
			end
		end
	end

	for v34, v35 in p10._sessions do
		if not t3[v34] then
			v35:advance(n1, 0, nil)
		end
	end
end
function t1.reset(p11) -- line: 164
	p11._running = false

	local _scanThread = p11._scanThread

	if _scanThread ~= nil and coroutine.status(_scanThread) == "suspended" then
		task.cancel(_scanThread)
	end

	p11._scanThread = nil
	p11._sessions = {}
end

return t1
