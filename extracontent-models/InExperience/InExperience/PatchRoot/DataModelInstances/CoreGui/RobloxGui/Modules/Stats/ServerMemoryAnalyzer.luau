local CoreGui = game:GetService("CoreGui")

local BaseMemoryAnalyzer = require(CoreGui.RobloxGui.Modules.Stats.BaseMemoryAnalyzer)
local TreeViewItem = require(CoreGui.RobloxGui.Modules.Stats.TreeViewItem)
require(CoreGui.RobloxGui.Modules.Common.CommonUtil)

local function __ReadAndSumValues(object, item)
	local total = 0

	for k, item2 in pairs(item) do
		local v = item2 / 1048576
		total += v
		object:getOrMakeChildById(k):setLabelAndValue(k, v)
	end

	return total
end

local ServerMemoryAnalyzer = {}

setmetatable(ServerMemoryAnalyzer, BaseMemoryAnalyzer)
ServerMemoryAnalyzer.__index = ServerMemoryAnalyzer

function ServerMemoryAnalyzer.new(p)
	local v = BaseMemoryAnalyzer.new(p)
	setmetatable(v, ServerMemoryAnalyzer)

	v._cachedRootTreeViewItem = nil
	v._coreTreeViewItem = nil
	v._placeTreeViewItem = nil
	v._untrackedTreeViewItem = nil

	v._isVisible = false

	return v
end

function ServerMemoryAnalyzer.filterServerMemoryTreeStats(_, p)
	if p.ServerMemoryTree == nil then
		return {}
	end

	return p.ServerMemoryTree
end

function ServerMemoryAnalyzer:updateWithTreeStats(items)
	local v = 0

	if self._cachedRootTreeViewItem == nil then
		self._cachedRootTreeViewItem = TreeViewItem.new("root", nil)

		self._coreTreeViewItem = self._cachedRootTreeViewItem:getOrMakeChildById("CoreMemory")
		self._placeTreeViewItem = self._cachedRootTreeViewItem:getOrMakeChildById("PlaceMemory")
		self._untrackedTreeViewItem = self._cachedRootTreeViewItem:getOrMakeChildById("UntrackedMemory")
	end

	for k, item in pairs(items) do
		if k == "totalServerMemory" then
			v = item / 1048576
		elseif k == "developerTags" then
			local v2 = __ReadAndSumValues(self._placeTreeViewItem, item)
			self._placeTreeViewItem:setLabelAndValue("PlaceMemory", v2)
		elseif k == "internalCategories" then
			local v2 = __ReadAndSumValues(self._coreTreeViewItem, item)
			self._coreTreeViewItem:setLabelAndValue("CoreMemory", v2)
		end
	end

	self._cachedRootTreeViewItem:setLabelAndValue("Memory", v)

	local v2 = v - (self._coreTreeViewItem:getValue() + self._placeTreeViewItem:getValue())
	self._untrackedTreeViewItem:setLabelAndValue("UntrackedMemory", v2)

	self:renderUpdates()
end

function ServerMemoryAnalyzer:getMemoryUsageTree()
	return self._cachedRootTreeViewItem
end

function ServerMemoryAnalyzer:setVisible(isVisible)
	self._isVisible = isVisible

	if self._isVisible then
		self:renderUpdates()
	end
end

return ServerMemoryAnalyzer
