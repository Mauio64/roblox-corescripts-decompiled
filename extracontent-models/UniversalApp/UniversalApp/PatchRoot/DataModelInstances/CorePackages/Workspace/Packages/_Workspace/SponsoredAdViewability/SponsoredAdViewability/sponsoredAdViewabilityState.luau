require(script.Parent.calculateIntersectionRatio)

local t1 = {
	IabDisplayStandard = "IabDisplayStandard",
	IabDisplayLarge = "IabDisplayLarge",
	FullView = "FullView"
}

local function newBand(n1: number) -- line: 45
	return {
		enteredAtMs = nil,
		threshold = n1
	}
end
local function updateBandTimer(t2: {[any]: any}, n2: number, n3: number) -- line: 50
	if n2 >= t2.threshold then
		if t2.enteredAtMs == nil then
			t2.enteredAtMs = n3

			return
		end
	else
		t2.enteredAtMs = nil
	end
end

local t3 = {}

t3.__index = t3

function t3.new(n4: number) -- line: 75
	-- upvalues: t3 (copy)
	return (setmetatable({
		_displayBand = nil,
		_displayLabel = nil,
		startTimestampMs = n4,
		_achieved = {},
		_band100 = {
			threshold = 1,
			enteredAtMs = nil
		}
	}, t3))
end
function t3._classifyDisplayOnce(p1, vector2: Vector2) -- line: 87
	-- upvalues: t1 (copy)
	if p1._displayBand ~= nil then
		return
	end

	local v12 = vector2.X * vector2.Y

	if v12 <= 0 then
		return
	end

	if v12 > 242500 then
		p1._displayBand = {
			threshold = 0.3,
			enteredAtMs = nil
		}
		p1._displayLabel = t1.IabDisplayLarge

		return
	end

	p1._displayBand = {
		threshold = 0.5,
		enteredAtMs = nil
	}
	p1._displayLabel = t1.IabDisplayStandard
end
function t3._tryFire(p2, t4: {[any]: any}, s1: string, n5: number, t5: {[any]: any}, t6: {[any]: any}) -- line: 104
	if p2._achieved[s1] then
		return
	end

	local enteredAtMs = t4.enteredAtMs

	if enteredAtMs == nil then
		return
	end

	if n5 - enteredAtMs < 1000 then
		return
	end

	p2._achieved[s1] = true
	table.insert(t6, {
		milestoneLabel = s1,
		geometry = {
			adSize = t5.adSize,
			viewportBounds = {
				min = t5.viewportBounds.min,
				max = t5.viewportBounds.max
			}
		},
		viewabilitySessionStartTimestampMs = p2.startTimestampMs
	})
end
function t3.advance(p3, n6: number, n7: number, t7: {[any]: any}?) -- line: 141
	-- upvalues: t1 (copy)
	if t7 ~= nil then
		p3:_classifyDisplayOnce(t7.adSize)
	end

	local _displayBand = p3._displayBand

	if _displayBand ~= nil then
		if n7 >= _displayBand.threshold then
			if _displayBand.enteredAtMs == nil then
				_displayBand.enteredAtMs = n6
			end
		else
			_displayBand.enteredAtMs = nil
		end
	end

	local _band100 = p3._band100

	if n7 >= _band100.threshold then
		if _band100.enteredAtMs == nil then
			_band100.enteredAtMs = n6
		end
	else
		_band100.enteredAtMs = nil
	end

	local t8 = {}

	if t7 == nil then
		return t8
	end

	local _displayLabel = p3._displayLabel

	if _displayBand ~= nil and _displayLabel ~= nil then
		p3:_tryFire(_displayBand, _displayLabel, n6, t7, t8)
	end

	p3:_tryFire(p3._band100, t1.FullView, n6, t7, t8)

	return t8
end

t3.MilestoneLabels = t1
t3.MilestoneDurationMs = 1000

return t3
