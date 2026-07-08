local CoreGui = game:GetService("CoreGui")
local BaseMemoryAnalyzer = require(CoreGui.RobloxGui.Modules.Stats.BaseMemoryAnalyzer)
local TreeViewItem = require(CoreGui.RobloxGui.Modules.Stats.TreeViewItem)

require(CoreGui.RobloxGui.Modules.Common.CommonUtil)

local function __ReadAndSumValues(p1, p2) -- line: 25
	local n1 = 0

	for k, v in pairs(p2) do
		local v11 = v / 1048576

		n1 += v11
		p1:getOrMakeChildById(k):setLabelAndValue(k, v11)
	end

	return n1
end

local t1 = {}

setmetatable(t1, BaseMemoryAnalyzer)
t1.__index = t1

function t1.new(p3) -- line: 52
	-- upvalues: BaseMemoryAnalyzer (copy), t1 (copy)
	local v13 = BaseMemoryAnalyzer.new(p3)

	setmetatable(v13, t1)
	v13._cachedRootTreeViewItem = nil
	v13._coreTreeViewItem = nil
	v13._placeTreeViewItem = nil
	v13._untrackedTreeViewItem = nil
	v13._isVisible = false

	return v13
end
function t1.filterServerMemoryTreeStats(_, p5) -- line: 78
	if p5.ServerMemoryTree == nil then
		return {}
	end

	return p5.ServerMemoryTree
end
function t1.updateWithTreeStats(p6, p7) -- line: 86
	-- upvalues: TreeViewItem (copy), __ReadAndSumValues (copy)
	local n2 = 0

	if p6._cachedRootTreeViewItem == nil then
		p6._cachedRootTreeViewItem = TreeViewItem.new("root", nil)
		p6._coreTreeViewItem = p6._cachedRootTreeViewItem:getOrMakeChildById("CoreMemory")
		p6._placeTreeViewItem = p6._cachedRootTreeViewItem:getOrMakeChildById("PlaceMemory")
		p6._untrackedTreeViewItem = p6._cachedRootTreeViewItem:getOrMakeChildById("UntrackedMemory")
	end

	for k, v in pairs(p7) do
		if k == "totalServerMemory" then
			n2 = v / 1048576
		elseif k == "developerTags" then
			local v21 = __ReadAndSumValues(p6._placeTreeViewItem, v)

			p6._placeTreeViewItem:setLabelAndValue("PlaceMemory", v21)
		elseif k == "internalCategories" then
			local v22 = __ReadAndSumValues(p6._coreTreeViewItem, v)

			p6._coreTreeViewItem:setLabelAndValue("CoreMemory", v22)
		end
	end

	p6._cachedRootTreeViewItem:setLabelAndValue("Memory", n2)

	local v23 = n2 - (p6._coreTreeViewItem:getValue() + p6._placeTreeViewItem:getValue())

	p6._untrackedTreeViewItem:setLabelAndValue("UntrackedMemory", v23)
	p6:renderUpdates()
end
function t1.getMemoryUsageTree(p8) -- line: 123
	return p8._cachedRootTreeViewItem
end
function t1.setVisible(p9, p10) -- line: 127
	p9._isVisible = p10

	if p9._isVisible then
		p9:renderUpdates()
	end
end

return t1
