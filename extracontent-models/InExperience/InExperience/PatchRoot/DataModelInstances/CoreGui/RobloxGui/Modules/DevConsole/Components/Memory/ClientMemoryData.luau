local Signal = require(script.Parent.Parent.Parent.Signal)
local SoundService = game:GetService("SoundService")
local TextService = game:GetService("TextService")
local MeshContentProvider = game:GetService("MeshContentProvider")
local KeyframeSequenceProvider = game:GetService("KeyframeSequenceProvider")
local Stats = game:GetService("Stats")
local StatsUtils = require(script.Parent.Parent.Parent.Parent.Stats.StatsUtils)
local CircularBuffer = require(script.Parent.Parent.Parent.CircularBuffer)
local ChartHeaderNames = require(script.Parent.Parent.Parent.Constants).MemoryFormatting.ChartHeaderNames
local num = tonumber(settings():GetFVariable("NewDevConsoleMaxGraphCount"))
local t1 = {
	[ChartHeaderNames[1]] = function(p1, p2) -- line: 21
		return p1.name < p2.name
	end,
	[ChartHeaderNames[2]] = function(p3, p4) -- line: 24
		return p3.dataStats.dataSet:back().data < p4.dataStats.dataSet:back().data
	end
}
local t2 = {}

t2.__index = t2

function t2.new() -- line: 32
	-- upvalues: t2 (copy), Signal (copy), ChartHeaderNames (copy)
	local t3 = {}

	setmetatable(t3, t2)
	t3._pollingId = 0
	t3._totalMemory = 0
	t3._memoryData = {}
	t3._memoryDataSorted = {}
	t3._treeViewUpdatedSignal = Signal.new()
	t3._totalMemoryUpdated = Signal.new()
	t3._sortType = ChartHeaderNames[1]
	t3._isRunning = false
	t3._doGranularMemUpdate = {}
	t3._granularMemTable = {}

	return t3
end

local function GetMemoryPerformanceStatsItem() -- line: 51
	-- upvalues: Stats (copy), StatsUtils (copy)
	local v26 = Stats and Stats:FindFirstChild("PerformanceStats")

	if not v26 then
		return nil
	end

	return (v26:FindFirstChild(StatsUtils.StatNames[StatsUtils.StatType_Memory]))
end
local function fetchSoundMemoryData() -- line: 62
	-- upvalues: SoundService (copy)
	local SoundMemoryData = SoundService:GetSoundMemoryData()
	local t4 = {}

	for k, v in pairs(SoundMemoryData) do
		table.insert(t4, {
			name = k,
			value = v
		})
	end

	table.sort(t4, function(p5, p6) -- line: 76
		return p5.value > p6.value
	end)

	return t4
end
local function fetchGraphicsTextureMemoryData() -- line: 83
	-- upvalues: Stats (copy)
	local PaginatedMemoryByTexture = Stats:GetPaginatedMemoryByTexture(Enum.TextureQueryType.NonHumanoid, 0, 100)
	local PaginatedMemoryByTexture2 = Stats:GetPaginatedMemoryByTexture(Enum.TextureQueryType.NonHumanoidOrphaned, 0, 100)
	local t5 = {}

	local function aggregateData(p7, p8) -- line: 88
		for _, v in ipairs(p8.Results) do
			local v101 = v.MemoryInBytes / 1048576

			table.insert(p7, {
				name = v.TextureId,
				value = v101
			})
		end
	end

	aggregateData(t5, PaginatedMemoryByTexture)
	aggregateData(t5, PaginatedMemoryByTexture2)
	table.sort(t5, function(p9, p10) -- line: 101
		return p9.value > p10.value
	end)

	return t5
end
local function fetchGraphicsTextureCharacterMemoryData() -- line: 107
	-- upvalues: Stats (copy)
	local PaginatedMemoryByTexture = Stats:GetPaginatedMemoryByTexture(Enum.TextureQueryType.Humanoid, 0, 100)
	local PaginatedMemoryByTexture3 = Stats:GetPaginatedMemoryByTexture(Enum.TextureQueryType.HumanoidOrphaned, 0, 100)
	local t6 = {}

	local function aggregateData(p11, p12) -- line: 112
		for _, v in ipairs(p12.Results) do
			local v108 = v.MemoryInBytes / 1048576
			local t7 = {}
			local TextureId = v.TextureId
			local t8 = {}

			for _, v2 in pairs(string.split(TextureId, " ")) do
				if string.sub(v2, 1, 2) == "T[" then
					table.insert(t8, v2)
				end
			end

			local t9 = {}

			for _, v3 in pairs(t8) do
				local v117 = string.split(v3, ".mesh:")[2]
				local v118 = string.find(v117, ":", 12)

				if v118 ~= nil then
					v118 -= 1
				end

				t9[string.sub(v117, 1, v118)] = true
			end

			for k, _ in pairs(t9) do
				table.insert(t7, {
					name = k
				})
			end

			table.sort(t7, function(p13, p14) -- line: 154
				return p13.name < p14.name
			end)
			table.insert(p11, {
				name = "Composite Texture",
				value = v108,
				moreInfo = t7
			})
		end
	end

	aggregateData(t6, PaginatedMemoryByTexture)
	aggregateData(t6, PaginatedMemoryByTexture3)

	return t6
end
local function fetchGraphicsMeshPartsMemoryData() -- line: 171
	-- upvalues: MeshContentProvider (copy)
	local v39 = MeshContentProvider:getContentMemoryData()
	local t10 = {}

	for k, v in pairs(v39) do
		local v43 = v / 1048576

		table.insert(t10, {
			name = k,
			value = v43
		})
	end

	table.sort(t10, function(p15, p16) -- line: 183
		return p15.value > p16.value
	end)

	return t10
end
local function fetchFuncAnimation() -- line: 190
	-- upvalues: KeyframeSequenceProvider (copy)
	local MemStats = KeyframeSequenceProvider:GetMemStats()
	local t11 = {}

	for k, v in pairs(MemStats) do
		local v48 = v / 1048576

		table.insert(t11, {
			name = k,
			value = v48
		})
	end

	table.sort(t11, function(p17, p18) -- line: 202
		return p17.value > p18.value
	end)

	return t11
end
local function fetchFontMemoryData() -- line: 209
	-- upvalues: TextService (copy)
	local FontMemoryData = TextService:GetFontMemoryData()
	local t12 = {}

	for k, v in pairs(FontMemoryData) do
		table.insert(t12, {
			name = k,
			value = v / 1048576
		})
	end

	table.sort(t12, function(p19, p20) -- line: 220
		return p19.value > p20.value
	end)

	return t12
end

function t2.updateCachedData(p21, p22, p23) -- line: 227
	if p21._doGranularMemUpdate[p22] then
		p21._doGranularMemUpdate[p22] = false
		p21._granularMemTable[p22] = p23()
	end
end
function t2.getAdditionalMemoryFunc(p24, p25) -- line: 234
	-- upvalues: fetchSoundMemoryData (copy), fetchGraphicsTextureMemoryData (copy), fetchGraphicsTextureCharacterMemoryData (copy), fetchGraphicsMeshPartsMemoryData (copy), fetchFuncAnimation (copy), fetchFontMemoryData (copy)
	local u58 = nil

	if p25 == "Sounds" then
		u58 = fetchSoundMemoryData
	elseif p25 == "GraphicsTexture" then
		u58 = fetchGraphicsTextureMemoryData
	elseif p25 == "GraphicsTextureCharacter" then
		u58 = fetchGraphicsTextureCharacterMemoryData
	elseif p25 == "GraphicsMeshParts" then
		u58 = fetchGraphicsMeshPartsMemoryData
	elseif p25 ~= "csgDictionary" then
		if p25 == "Animation" then
			u58 = fetchFuncAnimation
		elseif p25 == "gui/FontData" and game:GetEngineFeature("TextServiceGetFontMemoryData") then
			u58 = fetchFontMemoryData
		end
	end

	if u58 then
		return function() -- line: 256
			-- upvalues: p24 (copy), p25 (copy), u58 (ref)
			p24:updateCachedData(p25, u58)

			return p24._granularMemTable[p25]
		end
	end

	return nil
end
function t2.recursiveUpdateEntry(p26, p27, p28, p29) -- line: 265
	-- upvalues: StatsUtils (copy), CircularBuffer (copy), num (copy)
	local v63 = StatsUtils.GetMemoryAnalyzerStatName(p29.DisplayName)
	local Value = p29:GetValue()
	local children = p29:GetChildren()

	if not p27[v63] then
		local v66 = CircularBuffer.new(num)

		v66:push_back({
			data = Value,
			time = p26._lastUpdate
		})
		p27[v63] = {
			min = Value,
			max = Value,
			dataSet = v66,
			children = #children > 0 and {},
			sortedChildren = #children > 0 and {}
		}

		local v67 = p26:getAdditionalMemoryFunc(v63)

		if v67 then
			p27[v63].additionalInfoFunc = v67
			p26._doGranularMemUpdate[v63] = true
		end

		table.insert(p28, {
			name = v63,
			dataStats = p27[v63]
		})
	else
		local max = p27[v63].max
		local min = p27[v63].min
		local t13 = {
			data = Value,
			time = p26._lastUpdate
		}

		if p27[v63].additionalInfoFunc and p27[v63].dataSet:back().data ~= t13.data then
			p26._doGranularMemUpdate[v63] = true
		end

		local v71 = p27[v63].dataSet:push_back(t13)

		if v71 then
			local v72 = p27[v63].dataSet:iterator()
			local v73 = v72:next()

			if max == v71.data then
				max = min

				while v73 do
					max = max > v73.data and max or v73.data
					v73 = v72:next()
				end
			end

			if min == v71.data then
				min = max

				while v73 do
					min = min < v73.data and min or v73.data
					v73 = v72:next()
				end
			end
		end

		p27[v63].max = max < Value and Value or max
		p27[v63].min = min < Value and min or Value
	end

	local v74 = p27[v63]
	local t14 = {}

	for _, v in ipairs(children) do
		t14[v.DisplayName] = true
		p26:recursiveUpdateEntry(v74.children, v74.sortedChildren, v)
	end

	if v74.children then
		for k, _ in pairs(v74.children) do
			if t14[k] == nil then
				v74.children[k] = nil

				for i, v in ipairs(v74.sortedChildren) do
					if k == v.name then
						table.remove(v74.sortedChildren, i)

						break
					end
				end
			end
		end
	end
end
function t2.totalMemSignal(p30) -- line: 379
	return p30._totalMemoryUpdated
end
function t2.treeUpdatedSignal(p31) -- line: 383
	return p31._treeViewUpdatedSignal
end
function t2.getSortType(p32) -- line: 387
	return p32._sortType
end

local function recursiveSort(p33, p34) -- line: 391
	-- upvalues: recursiveSort (copy)
	table.sort(p33, p34)

	for _, v in pairs(p33) do
		if v.dataStats.sortedChildren then
			recursiveSort(v.dataStats.sortedChildren, p34)
		end
	end
end

function t2.setSortType(p35, p36) -- line: 400
	-- upvalues: t1 (copy), recursiveSort (copy)
	if t1[p36] then
		p35._sortType = p36
		recursiveSort(p35._memoryDataSorted, t1[p35._sortType])

		return
	end

	error(string.format("attempted to pass invalid sortType: %s", (tostring(p36))), 2)
end
function t2.getMemoryData(p37) -- line: 410
	return p37._memoryDataSorted
end
function t2.isRunning(p38) -- line: 414
	return p38._isRunning
end
function t2.start(p39) -- line: 418
	-- upvalues: Stats (copy), StatsUtils (copy)
	spawn(function() -- line: 419
		-- upvalues: p39 (copy), Stats (copy), StatsUtils (copy)
		p39._pollingId = p39._pollingId + 1

		local _pollingId = p39._pollingId

		p39._isRunning = true

		while _pollingId == p39._pollingId do
			local v128 = Stats and Stats:FindFirstChild("PerformanceStats")
			local v129 = if v128 then v128:FindFirstChild(StatsUtils.StatNames[StatsUtils.StatType_Memory]) else nil

			if not v129 then
				return
			end

			p39._lastUpdate = os.time()
			p39:recursiveUpdateEntry(p39._memoryData, p39._memoryDataSorted, v129)

			if p39._totalMemory ~= v129:getValue() then
				p39._totalMemory = v129:getValue()
				p39._totalMemoryUpdated:Fire(p39._totalMemory)
			end

			p39._treeViewUpdatedSignal:Fire(p39._memoryDataSorted)
			wait(3)
		end

		p39._isRunning = false
	end)
end
function t2.stop(p40) -- line: 444
	p40._pollingId = p40._pollingId + 1
end

return t2
