local Signal = require(script.Parent.Parent.Parent.Signal)
local CircularBuffer = require(script.Parent.Parent.Parent.CircularBuffer)
local ChartHeaderNames = require(script.Parent.Parent.Parent.Constants).MemoryFormatting.ChartHeaderNames
local num = tonumber(settings():GetFVariable("NewDevConsoleMaxGraphCount"))
local t1 = {
	[ChartHeaderNames[1]] = function(p1, p2) -- line: 11
		return p1.name < p2.name
	end,
	[ChartHeaderNames[2]] = function(p3, p4) -- line: 14
		return p3.dataStats.dataSet:back().data < p4.dataStats.dataSet:back().data
	end
}
local getClientReplicator = require(script.Parent.Parent.Parent.Util.getClientReplicator)
local t2 = {}

t2.__index = t2

function t2.new() -- line: 24
	-- upvalues: t2 (copy), Signal (copy), ChartHeaderNames (copy)
	local t3 = {}

	setmetatable(t3, t2)
	t3._init = false
	t3._isRunning = false
	t3._totalMemory = 0
	t3._memoryData = {}
	t3._memoryDataSorted = {}
	t3._coreTreeData = {}
	t3._coreTreeDataSorted = {}
	t3._placeTreeData = {}
	t3._placeTreeDataSorted = {}
	t3._placeScriptTreeData = {}
	t3._placeScriptTreeDataSorted = {}
	t3._coreScriptTreeData = {}
	t3._coreScriptTreeDataSorted = {}
	t3._treeViewUpdated = Signal.new()
	t3._sortType = ChartHeaderNames[1]

	return t3
end
function t2.updateEntry(p5, p6, p7, p8, p9) -- line: 53
	-- upvalues: CircularBuffer (copy), num (copy)
	if not p6[p8] then
		local v19 = CircularBuffer.new(num)

		v19:push_back({
			data = p9,
			time = p5._lastUpdate
		})
		p6[p8] = {
			min = p9,
			max = p9,
			dataSet = v19
		}
		table.insert(p7, {
			name = p8,
			dataStats = p6[p8]
		})

		return
	end

	local max = p6[p8].max
	local min = p6[p8].min
	local t4 = {
		data = p9,
		time = p5._lastUpdate
	}
	local v23 = p6[p8].dataSet:push_back(t4)

	if v23 then
		local v24 = p6[p8].dataSet:iterator()
		local v25 = v24:next()

		if max == v23.data then
			max = min

			while v25 do
				max = max > v25.data and max or v25.data
				v25 = v24:next()
			end
		end

		if min == v23.data then
			min = max

			while v25 do
				min = min < v25.data and min or v25.data
				v25 = v24:next()
			end
		end
	end

	p6[p8].max = max < p9 and p9 or max
	p6[p8].min = min < p9 and min or p9
end
function t2.updateEntryList(p10, p11, p12, p13) -- line: 109
	local n1 = 0

	for k, v in pairs(p13) do
		local v33 = v / 1048576

		n1 += v33
		p10:updateEntry(p11, p12, k, v33)
	end

	for k, _ in pairs(p11) do
		if p13[k] == nil then
			p11[k] = nil

			for i, v in ipairs(p12) do
				if k == v.name then
					table.remove(p12, i)

					break
				end
			end
		end
	end

	return n1
end
function t2.updateWithTreeStats(p14, p15) -- line: 138
	local t5 = {
		PlaceMemory = 0,
		CoreMemory = 0,
		UntrackedMemory = 0,
		PlaceScriptMemory = 0,
		CoreScriptMemory = 0
	}

	for k, v in pairs(p15) do
		if k == "totalServerMemory" then
			p14._totalMemory = v / 1048576
		elseif k == "developerTags" then
			t5.PlaceMemory = p14:updateEntryList(p14._placeTreeData, p14._placeTreeDataSorted, v)
		elseif k == "internalCategories" then
			t5.CoreMemory = p14:updateEntryList(p14._coreTreeData, p14._coreTreeDataSorted, v)
		elseif k == "placeScriptMemoryCategories" then
			t5.PlaceScriptMemory = p14:updateEntryList(p14._placeScriptTreeData, p14._placeScriptTreeDataSorted, v)
		elseif k == "coreScriptMemoryCategories" then
			t5.CoreScriptMemory = p14:updateEntryList(p14._coreScriptTreeData, p14._coreScriptTreeDataSorted, v)
		end
	end

	t5.UntrackedMemory = p14._totalMemory - t5.PlaceMemory - t5.CoreMemory

	if p14._init then
		for k, v in pairs(t5) do
			p14:updateEntry(p14._memoryData.Memory.children, p14._memoryData.Memory.sortedChildren, k, v)
		end

		p14:updateEntry(p14._memoryData, p14._memoryDataSorted, "Memory", p14._totalMemory)

		return
	end

	local t6 = {}
	local t7 = {}

	for k, v in pairs(t5) do
		p14:updateEntry(t6, t7, k, v)
	end

	p14:updateEntry(p14._memoryData, p14._memoryDataSorted, "Memory", p14._totalMemory)
	t6.PlaceMemory.children = p14._placeTreeData
	t6.PlaceMemory.sortedChildren = p14._placeTreeDataSorted
	t6.CoreMemory.children = p14._coreTreeData
	t6.CoreMemory.sortedChildren = p14._coreTreeDataSorted
	t6.PlaceScriptMemory.children = p14._placeScriptTreeData
	t6.PlaceScriptMemory.sortedChildren = p14._placeScriptTreeDataSorted
	t6.CoreScriptMemory.children = p14._coreScriptTreeData
	t6.CoreScriptMemory.sortedChildren = p14._coreScriptTreeDataSorted
	p14._memoryData.Memory.children = t6
	p14._memoryData.Memory.sortedChildren = t7
	p14._init = true
end
function t2.totalMemSignal(p16) -- line: 204
	return p16._totalMemoryUpdated
end
function t2.treeUpdatedSignal(p17) -- line: 208
	return p17._treeViewUpdated
end
function t2.getSortType(p18) -- line: 212
	return p18._sortType
end

local function recursiveSort(p19, p20) -- line: 216
	-- upvalues: recursiveSort (copy)
	table.sort(p19, p20)

	for _, v in pairs(p19) do
		if v.dataStats.sortedChildren then
			recursiveSort(v.dataStats.sortedChildren, p20)
		end
	end
end

function t2.setSortType(p21, p22) -- line: 225
	-- upvalues: t1 (copy), recursiveSort (copy)
	if t1[p22] then
		p21._sortType = p22
		recursiveSort(p21._memoryDataSorted, t1[p21._sortType])

		return
	end

	error(string.format("attempted to pass invalid sortType: %s", (tostring(p22))), 2)
end
function t2.getMemoryData(p23) -- line: 234
	return p23._memoryDataSorted
end
function t2.isRunning(p24) -- line: 238
	return p24._isRunning
end
function t2.start(p25) -- line: 242
	-- upvalues: getClientReplicator (copy)
	local v61 = getClientReplicator()

	if v61 and not p25._statsListenerConnection then
		p25._statsListenerConnection = v61.StatsReceived:connect(function(p26) -- line: 245
			-- upvalues: p25 (copy)
			if not p26.ServerMemoryTree then
				return
			end

			p25._lastUpdate = os.time()

			local ServerMemoryTree = p26.ServerMemoryTree

			if ServerMemoryTree then
				p25:updateWithTreeStats(ServerMemoryTree)
				p25._treeViewUpdated:Fire(p25._memoryDataSorted)
			end
		end)
		v61:RequestServerStats(true)
		p25._isRunning = true
	end
end
function t2.stop(p27) -- line: 263
	-- upvalues: getClientReplicator (copy)
	local v63 = getClientReplicator()

	if v63 then
		v63:RequestServerStats(false)
		p27._statsListenerConnection:Disconnect()
		p27._isRunning = false
	end
end

return t2
