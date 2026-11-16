local ContextActionService = game:GetService("ContextActionService")
local Signal = require(script.Parent.Parent.Parent.Signal)

local Constants = require(script.Parent.Parent.Parent.Constants)
local ChartHeaderNames = Constants.ActionBindingsFormatting.ChartHeaderNames

local v = {
	[ChartHeaderNames[1]] = function(p, p2): boolean
		return p.counter < p2.counter
	end,
	[ChartHeaderNames[2]] = function(p, p2): boolean
		if p.actionInfo.priorityLevel == p2.actionInfo.priorityLevel then
			return p.counter < p2.counter
		end

		return p.actionInfo.priorityLevel < p2.actionInfo.priorityLevel
	end,
	[ChartHeaderNames[3]] = function(p, p2)
		if p.actionInfo.isCore == p2.actionInfo.isCore then
			return p.counter < p2.counter
		end

		return p.actionInfo.isCore
	end,
	[ChartHeaderNames[4]] = function(p, p2): boolean
		return p.name:lower() < p2.name:lower()
	end,
	[ChartHeaderNames[5]] = function(p, p2): boolean
		return tostring(p.actionInfo.inputTypes[1]) < tostring(p2.actionInfo.inputTypes[1])
	end
}

local ActionBindingsData = {}
ActionBindingsData.__index = ActionBindingsData

function ActionBindingsData.new()
	local v2 = {}
	setmetatable(v2, ActionBindingsData)

	v2._bindingsUpdated = Signal.new()
	v2._bindingsData = {}
	v2._bindingCounter = 0
	v2._sortedBindingData = {}
	v2._sortType = ChartHeaderNames[1]
	v2._isRunning = false
	return v2
end

function ActionBindingsData:setSortType(sortType)
	if not v[sortType] then
		error(string.format("attempted to pass invalid sortType: %s", (tostring(sortType))), 2)

		return
	end

	self._sortType = sortType
	table.sort(self._sortedBindingData, v[self._sortType])
	self._bindingsUpdated:Fire(self._sortedBindingData)
end

function ActionBindingsData:getSortType()
	return self._sortType
end

function ActionBindingsData:Signal()
	return self._bindingsUpdated
end

function ActionBindingsData:getCurrentData()
	return self._sortedBindingData
end

function ActionBindingsData:updateBindingDataEntry(name, p)
	if p == nil then
		self._bindingsData[name] = nil

		for k, v2 in pairs(self._sortedBindingData) do
			if v2.name == name then
				table.remove(self._sortedBindingData, k)
				return
			end
		end
	else
		if self._bindingsData[name] then
			self._bindingsData[name] = p

			return
		end

		self._bindingCounter += 1
		self._bindingsData[name] = p
		local v2 = {
			name = name,
			actionInfo = self._bindingsData[name],
			counter = self._bindingCounter
		}

		table.insert(self._sortedBindingData, v2)
	end
end

function ActionBindingsData:isRunning()
	return self._isRunning
end

function ActionBindingsData:start()
	local allBoundActionInfo = ContextActionService:GetAllBoundActionInfo()

	for k, v2 in pairs(allBoundActionInfo) do
		v2.isCore = false
		self:updateBindingDataEntry(k, v2)
	end

	local allBoundCoreActionInfo = ContextActionService:GetAllBoundCoreActionInfo()

	for k, v2 in pairs(allBoundCoreActionInfo) do
		v2.isCore = true
		self:updateBindingDataEntry(k, v2)
	end

	if not self._actionChangedConnection then
		self._actionChangedConnection = ContextActionService.BoundActionChanged:connect(function(p, p2, p3)
			self:updateBindingDataEntry(p, nil)
			self:updateBindingDataEntry(p2, p3)
			self._bindingsUpdated:Fire(self._sortedBindingData)
		end)
	end

	if not self._actionAddedConnection then
		self._actionAddedConnection = ContextActionService.BoundActionAdded:connect(function(p, _, p2, isCore)
			p2.isCore = isCore
			self:updateBindingDataEntry(p, p2)
			self._bindingsUpdated:Fire(self._sortedBindingData)
		end)
	end

	if not self._actionRemovedConnection then
		self._actionRemovedConnection = ContextActionService.BoundActionRemoved:connect(function(p, _, _)
			self:updateBindingDataEntry(p, nil)
			self._bindingsUpdated:Fire(self._sortedBindingData)
		end)
	end

	self._isRunning = true
end

function ActionBindingsData:stop()
	if self.actionChangedConnector then
		self.actionChangedConnector:Disconnect()
		self.actionChangedConnector = nil
	end

	if self.actionAddedConnector then
		self.actionAddedConnector:Disconnect()
		self.actionAddedConnector = nil
	end

	if self.actionRemovedConnector then
		self.actionRemovedConnector:Disconnect()
		self.actionRemovedConnector = nil
	end

	self._isRunning = false
end

return ActionBindingsData
