local CoreGui = game:GetService("CoreGui")

local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)
local StatsAggregator = require(CoreGui.RobloxGui.Modules.Stats.StatsAggregator)

local GetFFlagLazyPerfStatsInit = require(CoreGui.RobloxGui.Modules.Flags.GetFFlagLazyPerfStatsInit)

local StatsAggregatorManager = {}
StatsAggregatorManager.__index = StatsAggregatorManager

StatsAggregatorManager.SecondsBetweenUpdate = 1
StatsAggregatorManager.NumSamplesToKeep = 20

local singleton = nil

function StatsAggregatorManager.getSingleton()
	if singleton == nil then
		singleton = StatsAggregatorManager.__new()

		if not GetFFlagLazyPerfStatsInit() then
			singleton:StartListening()
		end
	end

	return singleton
end

function StatsAggregatorManager.__new()
	local v = {}
	setmetatable(v, StatsAggregatorManager)

	v._statsAggregators = {}

	for _, allStatType in ipairs(StatsUtils.AllStatTypes) do
		local v2 = StatsAggregator.new(
			allStatType,
			StatsAggregatorManager.NumSamplesToKeep,
			StatsAggregatorManager.SecondsBetweenUpdate
		)
		v._statsAggregators[allStatType] = v2
	end

	return v
end

function StatsAggregatorManager:StartListening()
	for _, statsAggregator in pairs(self._statsAggregators) do
		statsAggregator:StartListening()
	end
end

function StatsAggregatorManager:StopListening()
	for _, statsAggregator in pairs(self._statsAggregators) do
		statsAggregator:StopListening()
	end
end

function StatsAggregatorManager:GetAggregator(p)
	return self._statsAggregators[p]
end

return StatsAggregatorManager
