require(script.Parent.calculateIntersectionRatio)

local t1 = {
	IabDisplayStandard = "IabDisplayStandard",
	IabDisplayLarge = "IabDisplayLarge",
	FullView = "FullView"
}

local function newBand(n1: number) -- line: 71
	return {
		enteredAtMs = nil,
		cumulativeMs = 0,
		maxContinuousMs = 0,
		threshold = n1
	}
end
local function closeWindow(t2: {[any]: any}, n2: number) -- line: 75
	local enteredAtMs = t2.enteredAtMs

	if enteredAtMs == nil then
		return
	end

	local v12 = n2 - enteredAtMs

	t2.cumulativeMs = t2.cumulativeMs + v12

	if v12 > t2.maxContinuousMs then
		t2.maxContinuousMs = v12
	end

	t2.enteredAtMs = nil
end
local function updateBandTimer(t3: {[any]: any}, n3: number, n4: number) -- line: 89
	if n3 >= t3.threshold then
		if t3.enteredAtMs == nil then
			t3.enteredAtMs = n4

			return
		end
	else
		local enteredAtMs = t3.enteredAtMs

		if enteredAtMs == nil then
			return
		end

		local v17 = n4 - enteredAtMs

		t3.cumulativeMs = t3.cumulativeMs + v17

		if v17 > t3.maxContinuousMs then
			t3.maxContinuousMs = v17
		end

		t3.enteredAtMs = nil
	end
end
local function durationAsOf(t4: {[any]: any}, n5: number) -- line: 102
	local cumulativeMs = t4.cumulativeMs
	local maxContinuousMs = t4.maxContinuousMs
	local enteredAtMs = t4.enteredAtMs

	if enteredAtMs ~= nil then
		local v23 = n5 - enteredAtMs

		cumulativeMs += v23

		if maxContinuousMs < v23 then
			maxContinuousMs = v23
		end
	end

	return cumulativeMs, maxContinuousMs
end
local function realEstateOf(n6: number, t5: {[any]: any}?) -- line: 115
	if t5 == nil then
		return 0
	end

	local viewportBounds = t5.viewportBounds
	local v27 = (viewportBounds.max.X - viewportBounds.min.X) * (viewportBounds.max.Y - viewportBounds.min.Y)

	if v27 <= 0 then
		return 0
	end

	return n6 * t5.adSize.X * t5.adSize.Y / v27
end

local t6 = {}

t6.__index = t6

function t6.new(n7: number) -- line: 161
	-- upvalues: t6 (copy)
	return (setmetatable({
		_displayLabel = nil,
		_lastSampleMs = nil,
		_lastRatio = 0,
		_lastRealEstate = 0,
		_percentWeightedSum = 0,
		_realEstateWeightedSum = 0,
		_visibleWeightedMs = 0,
		_minPercentSeen = nil,
		_maxPercentSeen = nil,
		_latchedGeometry = nil,
		_pausedAtMs = nil,
		_pausedDurationMs = 0,
		_finalized = false,
		startTimestampMs = n7,
		_achieved = {},
		_band30 = {
			threshold = 0.3,
			enteredAtMs = nil,
			cumulativeMs = 0,
			maxContinuousMs = 0
		},
		_band50 = {
			threshold = 0.5,
			enteredAtMs = nil,
			cumulativeMs = 0,
			maxContinuousMs = 0
		},
		_band100 = {
			threshold = 1,
			enteredAtMs = nil,
			cumulativeMs = 0,
			maxContinuousMs = 0
		}
	}, t6))
end
function t6._classifyDisplayOnce(p1, vector2: Vector2) -- line: 186
	-- upvalues: t1 (copy)
	if p1._displayLabel ~= nil then
		return
	end

	local v31 = vector2.X * vector2.Y

	if v31 <= 0 then
		return
	end

	p1._displayLabel = if not (v31 > 242500) then t1.IabDisplayStandard else t1.IabDisplayLarge
end
function t6._tryFire(p2, t7: {[any]: any}, s1: string, n8: number, t8: {[any]: any}, t9: {[any]: any}) -- line: 199
	if p2._achieved[s1] then
		return
	end

	local enteredAtMs = t7.enteredAtMs

	if enteredAtMs == nil then
		return
	end

	if n8 - enteredAtMs < 1000 then
		return
	end

	p2._achieved[s1] = true

	local _band30 = p2._band30
	local cumulativeMs = _band30.cumulativeMs
	local maxContinuousMs = _band30.maxContinuousMs
	local enteredAtMs2 = _band30.enteredAtMs

	if enteredAtMs2 ~= nil then
		local v43 = n8 - enteredAtMs2

		cumulativeMs += v43

		if maxContinuousMs < v43 then
			maxContinuousMs = v43
		end
	end

	local _band50 = p2._band50
	local cumulativeMs2 = _band50.cumulativeMs
	local maxContinuousMs2 = _band50.maxContinuousMs
	local enteredAtMs3 = _band50.enteredAtMs

	if enteredAtMs3 ~= nil then
		local v48 = n8 - enteredAtMs3

		cumulativeMs2 += v48

		if maxContinuousMs2 < v48 then
			maxContinuousMs2 = v48
		end
	end

	local _band100 = p2._band100
	local cumulativeMs3 = _band100.cumulativeMs
	local maxContinuousMs3 = _band100.maxContinuousMs
	local enteredAtMs4 = _band100.enteredAtMs

	if enteredAtMs4 ~= nil then
		local v53 = n8 - enteredAtMs4

		cumulativeMs3 += v53

		if maxContinuousMs3 < v53 then
			maxContinuousMs3 = v53
		end
	end

	table.insert(t9, {
		milestoneLabel = s1,
		geometry = {
			adSize = t8.adSize,
			viewportBounds = {
				min = t8.viewportBounds.min,
				max = t8.viewportBounds.max
			}
		},
		viewabilitySessionStartTimestampMs = p2.startTimestampMs,
		cumulative30PercentInViewDurationMs = cumulativeMs,
		cumulative50PercentInViewDurationMs = cumulativeMs2,
		cumulative100PercentInViewDurationMs = cumulativeMs3,
		maxContinuous30PercentInViewDurationMs = maxContinuousMs,
		maxContinuous50PercentInViewDurationMs = maxContinuousMs2,
		maxContinuous100PercentInViewDurationMs = maxContinuousMs3
	})
end
function t6._accumulate(p3, n9: number, n10: number, t10: {[any]: any}?) -- line: 246
	local _lastSampleMs = p3._lastSampleMs

	if _lastSampleMs ~= nil and p3._lastRatio > 0 then
		local v59 = n9 - _lastSampleMs

		if v59 > 0 then
			p3._percentWeightedSum = p3._percentWeightedSum + p3._lastRatio * v59
			p3._realEstateWeightedSum = p3._realEstateWeightedSum + p3._lastRealEstate * v59
			p3._visibleWeightedMs = p3._visibleWeightedMs + v59
		end
	end

	p3._lastSampleMs = n9
	p3._lastRatio = n10

	local n11

	if t10 == nil then
		n11 = 0
	else
		local viewportBounds = t10.viewportBounds
		local v62 = (viewportBounds.max.X - viewportBounds.min.X) * (viewportBounds.max.Y - viewportBounds.min.Y)

		n11 = if not (v62 <= 0) then n10 * t10.adSize.X * t10.adSize.Y / v62 else 0
	end

	p3._lastRealEstate = n11

	if n10 > 0 then
		if p3._minPercentSeen == nil or n10 < p3._minPercentSeen then
			p3._minPercentSeen = n10
		end

		if p3._maxPercentSeen == nil or n10 > p3._maxPercentSeen then
			p3._maxPercentSeen = n10
		end
	end
end
function t6.pause(p4, n12: number) -- line: 276
	assert(not p4._finalized, "pause called after finalize")
	assert(p4._pausedAtMs == nil, "pause called while already paused")
	assert(n12 >= (p4._lastSampleMs or p4.startTimestampMs), "pause timestamp precedes the last sample")
	p4:_accumulate(n12, 0, nil)

	local _band30 = p4._band30
	local enteredAtMs = _band30.enteredAtMs

	if enteredAtMs ~= nil then
		local v67 = n12 - enteredAtMs

		_band30.cumulativeMs = _band30.cumulativeMs + v67

		if v67 > _band30.maxContinuousMs then
			_band30.maxContinuousMs = v67
		end

		_band30.enteredAtMs = nil
	end

	local _band50 = p4._band50
	local enteredAtMs5 = _band50.enteredAtMs

	if enteredAtMs5 ~= nil then
		local v70 = n12 - enteredAtMs5

		_band50.cumulativeMs = _band50.cumulativeMs + v70

		if v70 > _band50.maxContinuousMs then
			_band50.maxContinuousMs = v70
		end

		_band50.enteredAtMs = nil
	end

	local _band100 = p4._band100
	local enteredAtMs6 = _band100.enteredAtMs

	if enteredAtMs6 ~= nil then
		local v73 = n12 - enteredAtMs6

		_band100.cumulativeMs = _band100.cumulativeMs + v73

		if v73 > _band100.maxContinuousMs then
			_band100.maxContinuousMs = v73
		end

		_band100.enteredAtMs = nil
	end

	p4._pausedAtMs = n12
end
function t6.resume(p5, n13: number) -- line: 288
	assert(not p5._finalized, "resume called after finalize")

	local _pausedAtMs = p5._pausedAtMs

	assert(_pausedAtMs ~= nil, "resume called while not paused")
	assert(_pausedAtMs <= n13, "resume timestamp precedes pause")
	p5._pausedDurationMs = p5._pausedDurationMs + (n13 - _pausedAtMs)
	p5._pausedAtMs = nil
	p5._lastSampleMs = n13
	p5._lastRatio = 0
	p5._lastRealEstate = 0
end
function t6.advance(p6, n14: number, n15: number, t11: {[any]: any}?) -- line: 303
	-- upvalues: t1 (copy)
	assert(not p6._finalized, "advance called after finalize")
	assert(p6._pausedAtMs == nil, "advance called while paused")

	local t12 = {}

	if t11 ~= nil then
		p6:_classifyDisplayOnce(t11.adSize)
		p6._latchedGeometry = t11
	end

	p6:_accumulate(n14, n15, t11)

	local _band30 = p6._band30

	if n15 >= _band30.threshold then
		if _band30.enteredAtMs == nil then
			_band30.enteredAtMs = n14
		end
	else
		local enteredAtMs = _band30.enteredAtMs

		if enteredAtMs ~= nil then
			local v84 = n14 - enteredAtMs

			_band30.cumulativeMs = _band30.cumulativeMs + v84

			if v84 > _band30.maxContinuousMs then
				_band30.maxContinuousMs = v84
			end

			_band30.enteredAtMs = nil
		end
	end

	local _band50 = p6._band50

	if n15 >= _band50.threshold then
		if _band50.enteredAtMs == nil then
			_band50.enteredAtMs = n14
		end
	else
		local enteredAtMs = _band50.enteredAtMs

		if enteredAtMs ~= nil then
			local v87 = n14 - enteredAtMs

			_band50.cumulativeMs = _band50.cumulativeMs + v87

			if v87 > _band50.maxContinuousMs then
				_band50.maxContinuousMs = v87
			end

			_band50.enteredAtMs = nil
		end
	end

	local _band100 = p6._band100

	if n15 >= _band100.threshold then
		if _band100.enteredAtMs == nil then
			_band100.enteredAtMs = n14
		end
	else
		local enteredAtMs = _band100.enteredAtMs

		if enteredAtMs ~= nil then
			local v90 = n14 - enteredAtMs

			_band100.cumulativeMs = _band100.cumulativeMs + v90

			if v90 > _band100.maxContinuousMs then
				_band100.maxContinuousMs = v90
			end

			_band100.enteredAtMs = nil
		end
	end

	if t11 == nil then
		return t12
	end

	local _displayLabel = p6._displayLabel

	if _displayLabel ~= nil then
		p6:_tryFire(if _displayLabel ~= t1.IabDisplayLarge then p6._band50 else p6._band30, _displayLabel, n14, t11, t12)
	end

	p6:_tryFire(p6._band100, t1.FullView, n14, t11, t12)

	return t12
end
function t6.finalize(p7, n16: number) -- line: 339
	assert(not p7._finalized, "finalize called more than once on the same session")
	p7._finalized = true
	p7:_accumulate(n16, p7._lastRatio, p7._latchedGeometry)

	local _band30 = p7._band30
	local enteredAtMs = _band30.enteredAtMs

	if enteredAtMs ~= nil then
		local v96 = n16 - enteredAtMs

		_band30.cumulativeMs = _band30.cumulativeMs + v96

		if v96 > _band30.maxContinuousMs then
			_band30.maxContinuousMs = v96
		end

		_band30.enteredAtMs = nil
	end

	local _band50 = p7._band50
	local enteredAtMs7 = _band50.enteredAtMs

	if enteredAtMs7 ~= nil then
		local v99 = n16 - enteredAtMs7

		_band50.cumulativeMs = _band50.cumulativeMs + v99

		if v99 > _band50.maxContinuousMs then
			_band50.maxContinuousMs = v99
		end

		_band50.enteredAtMs = nil
	end

	local _band100 = p7._band100
	local enteredAtMs8 = _band100.enteredAtMs

	if enteredAtMs8 ~= nil then
		local v102 = n16 - enteredAtMs8

		_band100.cumulativeMs = _band100.cumulativeMs + v102

		if v102 > _band100.maxContinuousMs then
			_band100.maxContinuousMs = v102
		end

		_band100.enteredAtMs = nil
	end

	local _visibleWeightedMs = p7._visibleWeightedMs
	local _latchedGeometry = p7._latchedGeometry
	local _pausedDurationMs = p7._pausedDurationMs
	local _pausedAtMs = p7._pausedAtMs

	if _pausedAtMs ~= nil then
		assert(_pausedAtMs <= n16, "session end precedes pause")
		_pausedDurationMs += n16 - _pausedAtMs
	end

	return {
		geometry = if _latchedGeometry == nil then {
			adSize = Vector2.zero,
			viewportBounds = {
				min = Vector2.zero,
				max = Vector2.zero
			}
		} else {
			adSize = _latchedGeometry.adSize,
			viewportBounds = {
				min = _latchedGeometry.viewportBounds.min,
				max = _latchedGeometry.viewportBounds.max
			}
		},
		viewabilitySessionStartTimestampMs = p7.startTimestampMs,
		viewabilitySessionEndTimestampMs = n16,
		dwellDurationMs = n16 - p7.startTimestampMs - _pausedDurationMs,
		cumulative30PercentInViewDurationMs = p7._band30.cumulativeMs,
		cumulative50PercentInViewDurationMs = p7._band50.cumulativeMs,
		cumulative100PercentInViewDurationMs = p7._band100.cumulativeMs,
		maxContinuous30PercentInViewDurationMs = p7._band30.maxContinuousMs,
		maxContinuous50PercentInViewDurationMs = p7._band50.maxContinuousMs,
		maxContinuous100PercentInViewDurationMs = p7._band100.maxContinuousMs,
		averagePercentSeen = not (_visibleWeightedMs > 0) and 0 or p7._percentWeightedSum / _visibleWeightedMs,
		minPercentSeen = p7._minPercentSeen or 0,
		maxPercentSeen = p7._maxPercentSeen or 0,
		averageOnScreenRealEstate = not (_visibleWeightedMs > 0) and 0 or p7._realEstateWeightedSum / _visibleWeightedMs
	}
end

t6.MilestoneLabels = t1
t6.MilestoneDurationMs = 1000

return t6
