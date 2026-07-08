local CoreGui = game:GetService("CoreGui")
local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)
local t1 = {}

t1.__index = t1

function t1.new(p1, p2, p3) -- line: 18
	-- upvalues: t1 (copy), StatsUtils (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2._statType = p1
	t2._numSamples = p2
	t2._pauseBetweenSamples = p3
	t2._statName = StatsUtils.StatNames[t2._statType]
	t2._statMaxName = StatsUtils.StatMaxNames[t2._statType]
	t2._samples = {}

	for i = 0, p2 - 1 do
		t2._samples[i] = 0
	end

	t2._oldestIndex = 0
	t2._listeners = {}
	t2._nextListenerId = 1001

	return t2
end
function t1.AddListener(p4, p5) -- line: 45
	local _nextListenerId = p4._nextListenerId

	p4._nextListenerId = p4._nextListenerId + 1
	p4._listeners[_nextListenerId] = p5

	return _nextListenerId
end
function t1.RemoveListener(p6, p7) -- line: 52
	p6._listeners[p7] = nil
end
function t1._notifyAllListeners(p8) -- line: 56
	for _, v in pairs(p8._listeners) do
		v()
	end
end
function t1.StartListening(p9) -- line: 62
	if p9._listening == true then
		return
	end

	spawn(function() -- line: 70
		-- upvalues: p9 (copy)
		p9._listening = true

		while p9._listening do
			local v38 = p9:_getStatValue()

			p9:_storeStatValue(v38)
			p9:_notifyAllListeners()
			wait(p9._pauseBetweenSamples)
		end
	end)
end
function t1.StopListening(p10) -- line: 81
	p10._listening = false
end
function t1.GetValues(p11) -- line: 85
	local t3 = {}

	for i = 0, p11._numSamples - 1 do
		local v22 = (p11._oldestIndex + i) % p11._numSamples

		t3[i + 1] = p11._samples[v22]
	end

	return t3
end
function t1.GetAverage(p12) -- line: 96
	local n1 = 0

	for i = 0, p12._numSamples - 1 do
		n1 += p12._samples[i]
	end

	return n1 / p12._numSamples
end
function t1.GetLatestValue(p13) -- line: 105
	local v27 = (p13._oldestIndex + p13._numSamples - 1) % p13._numSamples

	return p13._samples[v27]
end
function t1._storeStatValue(p14, p15) -- line: 111
	p14._samples[p14._oldestIndex] = p15
	p14._oldestIndex = (p14._oldestIndex + 1) % p14._numSamples
end
function t1._getStatValue(p16) -- line: 117
	local Stats = game:GetService("Stats")

	if Stats == nil then
		return 0
	end

	local PerformanceStats = Stats:FindFirstChild("PerformanceStats")

	if PerformanceStats == nil then
		return 0
	end

	local p16_statName = PerformanceStats:FindFirstChild(p16._statName)

	if p16_statName == nil then
		return 0
	end

	return p16_statName:GetValue()
end
function t1.GetTarget(p17) -- line: 137
	local Stats = game:GetService("Stats")

	if Stats == nil then
		return 0
	end

	local PerformanceStats = Stats:FindFirstChild("PerformanceStats")

	if PerformanceStats == nil then
		return 0
	end

	local p17_statMaxName = PerformanceStats:FindFirstChild(p17._statMaxName)

	if p17_statMaxName == nil then
		return 0
	end

	return p17_statMaxName:GetValue()
end

return t1
