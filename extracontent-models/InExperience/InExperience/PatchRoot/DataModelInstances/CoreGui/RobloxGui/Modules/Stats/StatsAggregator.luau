local CoreGui = game:GetService("CoreGui")

local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)

local StatsAggregator = {}
StatsAggregator.__index = StatsAggregator

function StatsAggregator.new(statType, numSamples, pauseBetweenSamples)
	local v = {}
	setmetatable(v, StatsAggregator)

	v._statType = statType
	v._numSamples = numSamples
	v._pauseBetweenSamples = pauseBetweenSamples

	v._statName = StatsUtils.StatNames[v._statType]
	v._statMaxName = StatsUtils.StatMaxNames[v._statType]

	v._samples = {}

	for i = 0, numSamples - 1 do
		v._samples[i] = 0
	end

	v._oldestIndex = 0

	v._listeners = {}

	v._nextListenerId = 1001

	return v
end

function StatsAggregator:AddListener(p)
	local nextListenerId = self._nextListenerId
	self._nextListenerId += 1
	self._listeners[nextListenerId] = p
	return nextListenerId
end

function StatsAggregator:RemoveListener(p)
	self._listeners[p] = nil
end

function StatsAggregator:_notifyAllListeners()
	for _, listener in pairs(self._listeners) do
		listener()
	end
end

function StatsAggregator:StartListening()
	if self._listening == true then
		return
	end

	spawn(function()
		self._listening = true

		while self._listening do
			self:_storeStatValue((self:_getStatValue()))
			self:_notifyAllListeners()
			wait(self._pauseBetweenSamples)
		end
	end)
end

function StatsAggregator:StopListening()
	self._listening = false
end

function StatsAggregator:GetValues()
	local values = {}

	for i = 0, self._numSamples - 1 do
		local v = (self._oldestIndex + i) % self._numSamples
		values[i + 1] = self._samples[v]
	end

	return values
end

function StatsAggregator:GetAverage()
	local total = 0

	for i = 0, self._numSamples - 1 do
		total += self._samples[i]
	end

	return total / self._numSamples
end

function StatsAggregator:GetLatestValue()
	local v = (self._oldestIndex + self._numSamples - 1) % self._numSamples
	return self._samples[v]
end

function StatsAggregator:_storeStatValue(p)
	self._samples[self._oldestIndex] = p
	self._oldestIndex = (self._oldestIndex + 1) % self._numSamples
end

function StatsAggregator:_getStatValue()
	local Stats = game:GetService("Stats")

	if Stats == nil then
		return 0
	end

	local performanceStats = Stats:FindFirstChild("PerformanceStats")

	if performanceStats == nil then
		return 0
	end

	local child = performanceStats:FindFirstChild(self._statName)

	if child == nil then
		return 0
	end

	return child:GetValue()
end

function StatsAggregator:GetTarget()
	local Stats = game:GetService("Stats")

	if Stats == nil then
		return 0
	end

	local performanceStats = Stats:FindFirstChild("PerformanceStats")

	if performanceStats == nil then
		return 0
	end

	local child = performanceStats:FindFirstChild(self._statMaxName)

	if child == nil then
		return 0
	end

	return child:GetValue()
end

return StatsAggregator
