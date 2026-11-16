local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")

local BaseMemoryAnalyzer = require(CoreGui.RobloxGui.Modules.Stats.BaseMemoryAnalyzer)
local CommonUtil = require(CoreGui.RobloxGui.Modules.Common.CommonUtil)
local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)
local TreeViewItem = require(CoreGui.RobloxGui.Modules.Stats.TreeViewItem)

local function __GetMemoryPerformanceStatsItem() -- 1 equivalent call inferred from this helper
	local performanceStats = Stats and Stats:FindFirstChild("PerformanceStats")

	if performanceStats == nil then
		return nil
	end

	return (performanceStats:FindFirstChild(StatsUtils.StatNames[StatsUtils.StatType_Memory]))
end

local function __FillInMemoryUsageTreeRecursive(rootTreeViewItem, instance)
	local name = instance.Name
	rootTreeViewItem:setLabelAndValue(StatsUtils.GetMemoryAnalyzerStatName(name), (instance:GetValue()))

	local children = instance:GetChildren()

	local sortByName = CommonUtil.SortByName(children)

	for _, v in ipairs(sortByName) do
		__FillInMemoryUsageTreeRecursive(rootTreeViewItem:getOrMakeChildById(v.Name), v)
	end
end

local ClientMemoryAnalyzer = {}

setmetatable(ClientMemoryAnalyzer, BaseMemoryAnalyzer)
ClientMemoryAnalyzer.__index = ClientMemoryAnalyzer

function ClientMemoryAnalyzer.new(p)
	local v = BaseMemoryAnalyzer.new(p)
	setmetatable(v, ClientMemoryAnalyzer)

	v._rootTreeViewItem = nil

	v._shouldListenForUpdates = false

	v._spawnedLoopScheduled = false

	return v
end

function ClientMemoryAnalyzer:startListeningForUpdates()
	self._shouldListenForUpdates = true

	if self._spawnedLoopScheduled then
		return
	end

	self._spawnedLoopScheduled = true

	spawn(function()
		while self._shouldListenForUpdates do
			self:refreshMemoryUsageTree()
			self:renderUpdates()
			wait(1)
		end

		self._spawnedLoopScheduled = false
	end)
end

function ClientMemoryAnalyzer:stopListeningForUpdates()
	self._shouldListenForUpdates = false
end

function ClientMemoryAnalyzer:refreshMemoryUsageTree()
	if self._rootTreeViewItem == nil then
		self._rootTreeViewItem = TreeViewItem.new("root", nil)
	end

	local v = __GetMemoryPerformanceStatsItem() -- inferred equivalent call

	if v == nil then
		return nil
	end

	__FillInMemoryUsageTreeRecursive(self._rootTreeViewItem, v)
end

function ClientMemoryAnalyzer:getMemoryUsageTree()
	return self._rootTreeViewItem
end

return ClientMemoryAnalyzer
