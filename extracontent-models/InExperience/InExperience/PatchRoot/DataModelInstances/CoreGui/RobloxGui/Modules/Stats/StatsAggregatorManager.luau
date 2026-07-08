local CoreGui = game:GetService("CoreGui")
local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)
local StatsAggregator = require(CoreGui.RobloxGui.Modules.Stats.StatsAggregator)
local GetFFlagLazyPerfStatsInit = require(CoreGui.RobloxGui.Modules.Flags.GetFFlagLazyPerfStatsInit)
local t1 = {}

t1.__index = t1
t1.SecondsBetweenUpdate = 1
t1.NumSamplesToKeep = 20

local u6 = nil

function t1.getSingleton() -- line: 26
	-- upvalues: u6 (ref), t1 (copy), GetFFlagLazyPerfStatsInit (copy)
	if u6 == nil then
		u6 = t1.__new()

		if not GetFFlagLazyPerfStatsInit() then
			u6:StartListening()
		end
	end

	return u6
end
function t1.__new() -- line: 36
	-- upvalues: t1 (copy), StatsUtils (copy), StatsAggregator (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2._statsAggregators = {}

	for _, v in ipairs(StatsUtils.AllStatTypes) do
		local v10 = StatsAggregator.new(v, t1.NumSamplesToKeep, t1.SecondsBetweenUpdate)

		t2._statsAggregators[v] = v10
	end

	return t2
end
function t1.StartListening(p1) -- line: 53
	for _, v in pairs(p1._statsAggregators) do
		v:StartListening()
	end
end
function t1.StopListening(p2) -- line: 59
	for _, v in pairs(p2._statsAggregators) do
		v:StopListening()
	end
end
function t1.GetAggregator(p3, p4) -- line: 65
	return p3._statsAggregators[p4]
end

return t1
