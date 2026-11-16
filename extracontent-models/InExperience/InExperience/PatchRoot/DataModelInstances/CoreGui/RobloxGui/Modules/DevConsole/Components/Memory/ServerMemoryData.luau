local Signal = require(script.Parent.Parent.Parent.Signal)
local CircularBuffer = require(script.Parent.Parent.Parent.CircularBuffer)
local Constants = require(script.Parent.Parent.Parent.Constants)
local ChartHeaderNames = Constants.MemoryFormatting.ChartHeaderNames

local fVariable = tonumber(settings():GetFVariable("NewDevConsoleMaxGraphCount"))

local v = {
	[ChartHeaderNames[1]] = function(p, p2): boolean
		return p.name < p2.name
	end,
	[ChartHeaderNames[2]] = function(p, p2): boolean
		return p.dataStats.dataSet:back().data < p2.dataStats.dataSet:back().data
	end
}

local getClientReplicator = require(script.Parent.Parent.Parent.Util.getClientReplicator)

local ServerMemoryData = {}
ServerMemoryData.__index = ServerMemoryData

function ServerMemoryData.new()
	local v2 = {}

	setmetatable(v2, ServerMemoryData)
	v2._init = false
	v2._isRunning = false
	v2._totalMemory = 0

	v2._memoryData = {}
	v2._memoryDataSorted = {}

	v2._coreTreeData = {}
	v2._coreTreeDataSorted = {}

	v2._placeTreeData = {}
	v2._placeTreeDataSorted = {}

	v2._placeScriptTreeData = {}
	v2._placeScriptTreeDataSorted = {}

	v2._coreScriptTreeData = {}
	v2._coreScriptTreeDataSorted = {}

	v2._treeViewUpdated = Signal.new()
	v2._sortType = ChartHeaderNames[1]

	return v2
end

function ServerMemoryData:updateEntry(p, list, name, min)
	if p[name] then
		local v2 = p[name].max
		local v3 = p[name].min

		local v4 = { data = min, time = self._lastUpdate }

		local push_back = p[name].dataSet:push_back(v4)

		if push_back then
			local iterator = p[name].dataSet:iterator()
			local v5 = iterator:next()

			if v2 == push_back.data then
				v2 = v3

				while v5 do
					v2 = v5.data < v2 and v2 or v5.data
					v5 = iterator:next()
				end
			end

			if v3 == push_back.data then
				v3 = v2

				while v5 do
					v3 = v3 < v5.data and v3 or v5.data
					v5 = iterator:next()
				end
			end
		end

		p[name].max = v2 < min and min or v2
		local v5 = p[name]
		min = v3 < min and v3 or min
		v5.min = min
	else
		local dataSet = CircularBuffer.new(fVariable)

		dataSet:push_back({ data = min, time = self._lastUpdate })

		p[name] = { min = min, max = min, dataSet = dataSet }

		table.insert(list, { name = name, dataStats = p[name] })
	end
end

function ServerMemoryData:updateEntryList(items, list, items2)
	local total = 0

	for k, item in pairs(items2) do
		local v2 = item / 1048576
		total += v2

		self:updateEntry(items, list, k, v2)
	end

	for k, _ in pairs(items) do
		if items2[k] ~= nil then
			continue
		end

		items[k] = nil

		for i, item in ipairs(list) do
			if k == item.name then
				table.remove(list, i)
				break
			end
		end
	end

	return total
end

function ServerMemoryData:updateWithTreeStats(items)
	local v2 = {
		PlaceMemory = 0,
		CoreMemory = 0,
		UntrackedMemory = 0,
		PlaceScriptMemory = 0,
		CoreScriptMemory = 0
	}

	for k, item in pairs(items) do
		if k == "totalServerMemory" then
			self._totalMemory = item / 1048576
		elseif k == "developerTags" then
			v2.PlaceMemory = self:updateEntryList(self._placeTreeData, self._placeTreeDataSorted, item)
		elseif k == "internalCategories" then
			v2.CoreMemory = self:updateEntryList(self._coreTreeData, self._coreTreeDataSorted, item)
		elseif k == "placeScriptMemoryCategories" then
			v2.PlaceScriptMemory = self:updateEntryList(
				self._placeScriptTreeData,
				self._placeScriptTreeDataSorted,
				item
			)
		elseif k == "coreScriptMemoryCategories" then
			v2.CoreScriptMemory = self:updateEntryList(self._coreScriptTreeData, self._coreScriptTreeDataSorted, item)
		end
	end

	v2.UntrackedMemory = self._totalMemory - v2.PlaceMemory - v2.CoreMemory

	if self._init then
		for k, v3 in pairs(v2) do
			self:updateEntry(self._memoryData.Memory.children, self._memoryData.Memory.sortedChildren, k, v3)
		end

		self:updateEntry(self._memoryData, self._memoryDataSorted, "Memory", self._totalMemory)
	else
		local children = {}
		local sortedChildren = {}

		for k, v3 in pairs(v2) do
			self:updateEntry(children, sortedChildren, k, v3)
		end

		self:updateEntry(self._memoryData, self._memoryDataSorted, "Memory", self._totalMemory)

		children.PlaceMemory.children = self._placeTreeData
		children.PlaceMemory.sortedChildren = self._placeTreeDataSorted

		children.CoreMemory.children = self._coreTreeData
		children.CoreMemory.sortedChildren = self._coreTreeDataSorted

		children.PlaceScriptMemory.children = self._placeScriptTreeData
		children.PlaceScriptMemory.sortedChildren = self._placeScriptTreeDataSorted

		children.CoreScriptMemory.children = self._coreScriptTreeData
		children.CoreScriptMemory.sortedChildren = self._coreScriptTreeDataSorted

		self._memoryData.Memory.children = children
		self._memoryData.Memory.sortedChildren = sortedChildren

		self._init = true
	end
end

function ServerMemoryData:totalMemSignal()
	return self._totalMemoryUpdated
end

function ServerMemoryData:treeUpdatedSignal()
	return self._treeViewUpdated
end

function ServerMemoryData:getSortType()
	return self._sortType
end

local function recursiveSort(memoryDataSorted, p)
	table.sort(memoryDataSorted, p)

	for _, item in pairs(memoryDataSorted) do
		if item.dataStats.sortedChildren then
			recursiveSort(item.dataStats.sortedChildren, p)
		end
	end
end

function ServerMemoryData:setSortType(sortType)
	if not v[sortType] then
		error(string.format("attempted to pass invalid sortType: %s", (tostring(sortType))), 2)

		return
	end

	self._sortType = sortType
	recursiveSort(self._memoryDataSorted, v[self._sortType])
end

function ServerMemoryData:getMemoryData()
	return self._memoryDataSorted
end

function ServerMemoryData:isRunning()
	return self._isRunning
end

function ServerMemoryData:start()
	local clientReplicator = getClientReplicator()

	if clientReplicator and not self._statsListenerConnection then
		self._statsListenerConnection = clientReplicator.StatsReceived:connect(function(p)
			if not p.ServerMemoryTree then
				return
			end

			self._lastUpdate = os.time()

			local serverMemoryTree = p.ServerMemoryTree

			if serverMemoryTree then
				self:updateWithTreeStats(serverMemoryTree)
				self._treeViewUpdated:Fire(self._memoryDataSorted)
			end
		end)
		clientReplicator:RequestServerStats(true)
		self._isRunning = true
	end
end

function ServerMemoryData:stop()
	local clientReplicator = getClientReplicator()

	if clientReplicator then
		clientReplicator:RequestServerStats(false)
		self._statsListenerConnection:Disconnect()
		self._isRunning = false
	end
end

return ServerMemoryData
