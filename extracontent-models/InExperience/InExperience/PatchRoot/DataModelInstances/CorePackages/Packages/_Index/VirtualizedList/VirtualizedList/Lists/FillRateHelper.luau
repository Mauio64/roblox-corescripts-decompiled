local ParentParent = script.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local console = LuauPolyfill.console
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local t1 = {}

t1.__index = t1

function t1.new() -- line: 34
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self.any_blank_count = 0
	self.any_blank_ms = 0
	self.any_blank_speed_sum = 0
	self.mostly_blank_count = 0
	self.mostly_blank_ms = 0
	self.pixels_blank = 0
	self.pixels_sampled = 0
	self.pixels_scrolled = 0
	self.total_time_spent = 0
	self.sample_count = 0

	return self
end

local t2 = {}
local n1 = 10
local u9 = nil
local t3 = {}

t3.__index = t3

function t3.new(p1: ((...any) -> ...any)) -- line: 98
	-- upvalues: t3 (copy), t1 (copy), u9 (ref)
	local self = setmetatable({}, t3)

	self._anyBlankStartTime = nil
	self._enabled = false
	self._info = t1.new()
	self._mostlyBlankStartTime = nil
	self._samplesStartTime = nil
	self._getFrameMetrics = p1

	if u9 then
		self._enabled = u9 > math.random()
	else
		self._enabled = math.random() < 0
	end

	self:_resetData()

	return self
end
function t3.addListener(p2: ((...any) -> ...any)) -- line: 115
	-- upvalues: u9 (ref), console (copy), t2 (ref), Array (copy)
	if u9 == nil then
		console.warn("Call `FillRateHelper.setSampleRate` before `addListener`.")
	end

	table.insert(t2, p2)

	return {
		remove = function() -- line: 121
			-- upvalues: t2 (ref), Array (copy), p2 (copy)
			t2 = Array.filter(t2, function(p3) -- line: 122
				-- upvalues: p2 (copy)
				return p3 ~= p2
			end)
		end
	}
end
function t3.setSampleRate(n2: number) -- line: 129
	-- upvalues: u9 (ref)
	u9 = n2
end
function t3.setMinSampleCount(n3: number) -- line: 133
	-- upvalues: n1 (ref)
	n1 = n3
end
function t3.activate(p4) -- line: 137
	if p4._enabled and p4._samplesStartTime == nil then
		p4._samplesStartTime = os.clock()
	end
end
function t3.deactivateAndFlush(t4: {[any]: any}) -- line: 146
	-- upvalues: n1 (ref), Object (copy), Array (copy), t2 (ref)
	if not t4._enabled then
		return
	end

	local _samplesStartTime = t4._samplesStartTime

	if _samplesStartTime == nil then
		return
	end

	if t4._info.sample_count < n1 then
		t4:_resetData()

		return
	end

	local v20 = os.clock() - _samplesStartTime
	local v21 = Object.assign({}, t4._info, {
		total_time_spent = v20
	})

	Array.forEach(t2, function(p5) -- line: 179
		-- upvalues: v21 (copy)
		return p5(v21)
	end)
	t4:_resetData()
end
function t3.computeBlankness(t5: {[any]: any}, t6: {[any]: any}, t7: {[any]: any}, t8: {[any]: any}) -- line: 185
	if not t5._enabled or (t6.getItemCount(t6.data) == 0 or t5._samplesStartTime == nil) then
		return 0
	end

	local dOffset = t8.dOffset
	local offset = t8.offset
	local velocity = t8.velocity
	local visibleLength = t8.visibleLength
	local _info = t5._info

	_info.sample_count = _info.sample_count + 1

	local _info2 = t5._info

	_info2.pixels_sampled = _info2.pixels_sampled + math.round(visibleLength)

	local _info3 = t5._info

	_info3.pixels_scrolled = _info3.pixels_scrolled + math.round((math.abs(dOffset or 0)))

	local v33 = math.round(math.abs(velocity or 0) * 1000)
	local v34 = os.clock() * 1000

	if t5._anyBlankStartTime ~= nil then
		local _info4 = t5._info

		_info4.any_blank_ms = _info4.any_blank_ms + (v34 - t5._anyBlankStartTime)
	end

	t5._anyBlankStartTime = nil

	if t5._mostlyBlankStartTime ~= nil then
		local _info5 = t5._info

		_info5.mostly_blank_ms = _info5.mostly_blank_ms + (v34 - t5._mostlyBlankStartTime)
	end

	t5._mostlyBlankStartTime = nil

	local n4 = 0
	local first = t7.first
	local v39 = t5._getFrameMetrics(first)

	while first <= t7.last and (not v39 or not v39.inLayout) do
		v39 = t5._getFrameMetrics(first)
		first += 1
	end

	if v39 and first > 1 then
		n4 = math.min(visibleLength, (math.max(0, v39.offset - offset)))
	end

	local n5 = 0
	local last = t7.last
	local v42 = t5._getFrameMetrics(last)

	while last >= t7.first and (not v42 or not v42.inLayout) do
		v42 = t5._getFrameMetrics(last)
		last -= 1
	end

	if v42 and last < t6.getItemCount(t6.data) then
		local v43 = v42.offset + v42.length

		n5 = math.min(visibleLength, (math.max(0, offset + visibleLength - v43)))
	end

	local v44 = math.round(n4 + n5)
	local v45 = v44 / visibleLength

	if v45 > 0 then
		t5._anyBlankStartTime = v34

		local _info6 = t5._info

		_info6.any_blank_speed_sum = _info6.any_blank_speed_sum + v33

		local _info7 = t5._info

		_info7.any_blank_count = _info7.any_blank_count + 1

		local _info8 = t5._info

		_info8.pixels_blank = _info8.pixels_blank + v44

		if v45 > 0.5 then
			t5._mostlyBlankStartTime = v34

			local _info9 = t5._info

			_info9.mostly_blank_count = _info9.mostly_blank_count + 1

			return v45
		end
	elseif v33 < 0.01 or math.abs(dOffset or 0) < 1 then
		t5:deactivateAndFlush()
	end

	return v45
end
function t3.enabled(p6) -- line: 271
	return p6._enabled
end
function t3._resetData(p7) -- line: 275
	-- upvalues: t1 (copy)
	p7._anyBlankStartTime = nil
	p7._info = t1.new()
	p7._mostlyBlankStartTime = nil
	p7._samplesStartTime = nil
end

return t3
