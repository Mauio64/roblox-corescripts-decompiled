local ContextActionService = game:GetService("ContextActionService")
local Signal = require(script.Parent.Parent.Parent.Signal)
local ChartHeaderNames = require(script.Parent.Parent.Parent.Constants).ActionBindingsFormatting.ChartHeaderNames
local t1 = {
	[ChartHeaderNames[1]] = function(p1, p2) -- line: 9
		return p1.counter < p2.counter
	end,
	[ChartHeaderNames[2]] = function(p3, p4) -- line: 12
		if p3.actionInfo.priorityLevel == p4.actionInfo.priorityLevel then
			return p3.counter < p4.counter
		end

		return p3.actionInfo.priorityLevel < p4.actionInfo.priorityLevel
	end,
	[ChartHeaderNames[3]] = function(p5, p6) -- line: 18
		if p5.actionInfo.isCore == p6.actionInfo.isCore then
			return p5.counter < p6.counter
		end

		return p5.actionInfo.isCore
	end,
	[ChartHeaderNames[4]] = function(p7, p8) -- line: 25
		return p7.name:lower() < p8.name:lower()
	end,
	[ChartHeaderNames[5]] = function(p9, p10) -- line: 28
		return tostring(p9.actionInfo.inputTypes[1]) < tostring(p10.actionInfo.inputTypes[1])
	end
}
local t2 = {}

t2.__index = t2

function t2.new() -- line: 36
	-- upvalues: t2 (copy), Signal (copy), ChartHeaderNames (copy)
	local t3 = {}

	setmetatable(t3, t2)
	t3._bindingsUpdated = Signal.new()
	t3._bindingsData = {}
	t3._bindingCounter = 0
	t3._sortedBindingData = {}
	t3._sortType = ChartHeaderNames[1]
	t3._isRunning = false

	return t3
end
function t2.setSortType(p11, p12) -- line: 49
	-- upvalues: t1 (copy)
	if t1[p12] then
		p11._sortType = p12
		table.sort(p11._sortedBindingData, t1[p11._sortType])
		p11._bindingsUpdated:Fire(p11._sortedBindingData)

		return
	end

	error(string.format("attempted to pass invalid sortType: %s", (tostring(p12))), 2)
end
function t2.getSortType(p13) -- line: 59
	return p13._sortType
end
function t2.Signal(p14) -- line: 63
	return p14._bindingsUpdated
end
function t2.getCurrentData(p15) -- line: 67
	return p15._sortedBindingData
end
function t2.updateBindingDataEntry(p16, p17, p18) -- line: 73
	if p18 == nil then
		p16._bindingsData[p17] = nil

		for k, v in pairs(p16._sortedBindingData) do
			if p17 == v.name then
				table.remove(p16._sortedBindingData, k)

				return
			end
		end

		return
	end

	if not p16._bindingsData[p17] then
		p16._bindingCounter = p16._bindingCounter + 1
		p16._bindingsData[p17] = p18

		local t4 = {
			name = p17,
			actionInfo = p16._bindingsData[p17],
			counter = p16._bindingCounter
		}

		table.insert(p16._sortedBindingData, t4)

		return
	end

	p16._bindingsData[p17] = p18
end
function t2.isRunning(p19) -- line: 98
	return p19._isRunning
end
function t2.start(p20) -- line: 102
	-- upvalues: ContextActionService (copy)
	local AllBoundActionInfo = ContextActionService:GetAllBoundActionInfo()

	for k, v in pairs(AllBoundActionInfo) do
		v.isCore = false
		p20:updateBindingDataEntry(k, v)
	end

	local AllBoundCoreActionInfo = ContextActionService:GetAllBoundCoreActionInfo()

	for k, v in pairs(AllBoundCoreActionInfo) do
		v.isCore = true
		p20:updateBindingDataEntry(k, v)
	end

	if not p20._actionChangedConnection then
		p20._actionChangedConnection = ContextActionService.BoundActionChanged:connect(function(p21, p22, p23) -- line: 117
			-- upvalues: p20 (copy)
			p20:updateBindingDataEntry(p21, nil)
			p20:updateBindingDataEntry(p22, p23)
			p20._bindingsUpdated:Fire(p20._sortedBindingData)
		end)
	end

	if not p20._actionAddedConnection then
		p20._actionAddedConnection = ContextActionService.BoundActionAdded:connect(function(p24, _, p26, p27) -- line: 126
			-- upvalues: p20 (copy)
			p26.isCore = p27
			p20:updateBindingDataEntry(p24, p26)
			p20._bindingsUpdated:Fire(p20._sortedBindingData)
		end)
	end

	if not p20._actionRemovedConnection then
		p20._actionRemovedConnection = ContextActionService.BoundActionRemoved:connect(function(p28, _, _) -- line: 135
			-- upvalues: p20 (copy)
			p20:updateBindingDataEntry(p28, nil)
			p20._bindingsUpdated:Fire(p20._sortedBindingData)
		end)
	end

	p20._isRunning = true
end
function t2.stop(p31) -- line: 143
	if p31.actionChangedConnector then
		p31.actionChangedConnector:Disconnect()
		p31.actionChangedConnector = nil
	end

	if p31.actionAddedConnector then
		p31.actionAddedConnector:Disconnect()
		p31.actionAddedConnector = nil
	end

	if p31.actionRemovedConnector then
		p31.actionRemovedConnector:Disconnect()
		p31.actionRemovedConnector = nil
	end

	p31._isRunning = false
end

return t2
