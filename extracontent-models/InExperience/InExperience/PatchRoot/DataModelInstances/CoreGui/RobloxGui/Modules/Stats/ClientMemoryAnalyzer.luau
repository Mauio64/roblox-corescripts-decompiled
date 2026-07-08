local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local BaseMemoryAnalyzer = require(CoreGui.RobloxGui.Modules.Stats.BaseMemoryAnalyzer)
local CommonUtil = require(CoreGui.RobloxGui.Modules.Common.CommonUtil)
local StatsUtils = require(CoreGui.RobloxGui.Modules.Stats.StatsUtils)
local TreeViewItem = require(CoreGui.RobloxGui.Modules.Stats.TreeViewItem)

local function __GetMemoryPerformanceStatsItem() -- line: 19
	-- upvalues: Stats (copy), StatsUtils (copy)
	local v10 = Stats and Stats:FindFirstChild("PerformanceStats")

	if v10 == nil then
		return nil
	end

	return (v10:FindFirstChild(StatsUtils.StatNames[StatsUtils.StatType_Memory]))
end
local function __FillInMemoryUsageTreeRecursive(p1, p2) -- line: 30
	-- upvalues: StatsUtils (copy), CommonUtil (copy), __FillInMemoryUsageTreeRecursive (copy)
	local p2Name = p2.Name

	p1:setLabelAndValue(StatsUtils.GetMemoryAnalyzerStatName(p2Name), (p2:GetValue()))

	local children = p2:GetChildren()
	local v15 = CommonUtil.SortByName(children)

	for _, v in ipairs(v15) do
		local v18 = p1:getOrMakeChildById(v.Name)

		__FillInMemoryUsageTreeRecursive(v18, v)
	end
end

local t1 = {}

setmetatable(t1, BaseMemoryAnalyzer)
t1.__index = t1

function t1.new(p3) -- line: 61
	-- upvalues: BaseMemoryAnalyzer (copy), t1 (copy)
	local v20 = BaseMemoryAnalyzer.new(p3)

	setmetatable(v20, t1)
	v20._rootTreeViewItem = nil
	v20._shouldListenForUpdates = false
	v20._spawnedLoopScheduled = false

	return v20
end
function t1.startListeningForUpdates(p4) -- line: 86
	p4._shouldListenForUpdates = true

	if p4._spawnedLoopScheduled then
		return
	end

	p4._spawnedLoopScheduled = true
	spawn(function() -- line: 95
		-- upvalues: p4 (copy)
		while p4._shouldListenForUpdates do
			p4:refreshMemoryUsageTree()
			p4:renderUpdates()
			wait(1)
		end

		p4._spawnedLoopScheduled = false
	end)
end
function t1.stopListeningForUpdates(p5) -- line: 107
	p5._shouldListenForUpdates = false
end
function t1.refreshMemoryUsageTree(p6) -- line: 112
	-- upvalues: TreeViewItem (copy), Stats (copy), StatsUtils (copy), __FillInMemoryUsageTreeRecursive (copy)
	if p6._rootTreeViewItem == nil then
		p6._rootTreeViewItem = TreeViewItem.new("root", nil)
	end

	local v24 = Stats and Stats:FindFirstChild("PerformanceStats")
	local v25 = if v24 ~= nil then v24:FindFirstChild(StatsUtils.StatNames[StatsUtils.StatType_Memory]) else nil

	if v25 == nil then
		return nil
	end

	__FillInMemoryUsageTreeRecursive(p6._rootTreeViewItem, v25)
end
function t1.getMemoryUsageTree(p7) -- line: 125
	return p7._rootTreeViewItem
end

return t1
