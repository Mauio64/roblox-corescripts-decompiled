local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local console = LuauPolyfill.console
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local class = {}
class.__index = class
function class.new()
	local self = setmetatable({}, class)
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

local filtered = {}
local v = 10
local v2 = nil

local FillRateHelper = {}
FillRateHelper.__index = FillRateHelper

function FillRateHelper.new(getFrameMetrics)
	local self = setmetatable({}, FillRateHelper)
	self._anyBlankStartTime = nil
	self._enabled = false
	self._info = class.new()
	self._mostlyBlankStartTime = nil
	self._samplesStartTime = nil
	self._getFrameMetrics = getFrameMetrics

	if v2 then
		self._enabled = v2 > math.random()
	else
		self._enabled = math.random() < 0
	end

	self:_resetData()
	return self
end

function FillRateHelper.addListener(callback)
	if v2 == nil then
		console.warn("Call `FillRateHelper.setSampleRate` before `addListener`.")
	end

	table.insert(filtered, callback)
	return {
		remove = function()
			filtered = Array.filter(filtered, function(p): boolean
				return callback ~= p
			end)
		end
	}
end

function FillRateHelper.setSampleRate(p: number)
	v2 = p
end

function FillRateHelper.setMinSampleCount(p: number)
	v = p
end

function FillRateHelper:activate()
	if self._enabled and self._samplesStartTime == nil then
		self._samplesStartTime = os.clock()
	end
end

function FillRateHelper:deactivateAndFlush()
	if not self._enabled then
		return
	end

	local samplesStartTime = self._samplesStartTime

	if samplesStartTime == nil then
		return
	end

	if self._info.sample_count < v then
		self:_resetData()
		return
	end

	local total_time_spent = os.clock() - samplesStartTime
	local v3 = Object.assign({}, self._info, { total_time_spent = total_time_spent })

	Array.forEach(filtered, function(callback)
		return callback(v3)
	end)

	self:_resetData()
end

function FillRateHelper:computeBlankness(p, p2, data)
	if not self._enabled or p.getItemCount(p.data) == 0 or self._samplesStartTime == nil then
		return 0
	end

	local dOffset = data.dOffset
	local offset = data.offset
	local velocity = data.velocity
	local visibleLength = data.visibleLength

	self._info.sample_count += 1
	self._info.pixels_sampled += math.round(visibleLength)
	self._info.pixels_scrolled += math.round((math.abs(dOffset or 0)))
	local v3 = math.round(math.abs(velocity or 0) * 1000)

	local v4 = os.clock() * 1000

	if self._anyBlankStartTime ~= nil then
		self._info.any_blank_ms += v4 - self._anyBlankStartTime
	end

	self._anyBlankStartTime = nil

	if self._mostlyBlankStartTime ~= nil then
		self._info.mostly_blank_ms += v4 - self._mostlyBlankStartTime
	end

	self._mostlyBlankStartTime = nil

	local first = p2.first
	local v5 = self._getFrameMetrics(first)
	local v6 = 0

	while first <= p2.last and not (v5 and v5.inLayout) do
		v5 = self._getFrameMetrics(first)
		first += 1
	end

	if v5 and first > 1 then
		v6 = math.min(visibleLength, (math.max(0, v5.offset - offset)))
	end

	local last = p2.last
	local v7 = self._getFrameMetrics(last)
	local v8 = 0

	while p2.first <= last and not (v7 and v7.inLayout) do
		v7 = self._getFrameMetrics(last)
		last -= 1
	end

	if v7 and last < p.getItemCount(p.data) then
		local v9 = v7.offset + v7.length
		v8 = math.min(visibleLength, (math.max(0, offset + visibleLength - v9)))
	end

	local v9 = math.round(v6 + v8)
	local v10 = v9 / visibleLength

	if v10 > 0 then
		self._anyBlankStartTime = v4
		self._info.any_blank_speed_sum += v3
		self._info.any_blank_count += 1
		self._info.pixels_blank += v9

		if v10 > 0.5 then
			self._mostlyBlankStartTime = v4
			self._info.mostly_blank_count += 1
			return v10
		end
	elseif v3 < 0.01 or math.abs(dOffset or 0) < 1 then
		self:deactivateAndFlush()
	end

	return v10
end

function FillRateHelper:enabled()
	return self._enabled
end

function FillRateHelper:_resetData()
	self._anyBlankStartTime = nil
	self._info = class.new()
	self._mostlyBlankStartTime = nil
	self._samplesStartTime = nil
end

return FillRateHelper
