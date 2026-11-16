local FFlagDevConsoleKeyCollisionFix = require(script.Parent.Flags.FFlagDevConsoleKeyCollisionFix)

local Signal = require(script.Parent.Parent.Parent.Signal)
local SoundService = game:GetService("SoundService")
local TextService = game:GetService("TextService")
local MeshContentProvider = game:GetService("MeshContentProvider")
local KeyframeSequenceProvider = game:GetService("KeyframeSequenceProvider")

local Stats = game:GetService("Stats")
local StatsUtils = require(script.Parent.Parent.Parent.Parent.Stats.StatsUtils)

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

local ClientMemoryData = {}
ClientMemoryData.__index = ClientMemoryData

function ClientMemoryData.new()
	local v2 = {}
	setmetatable(v2, ClientMemoryData)

	v2._pollingId = 0
	v2._totalMemory = 0
	v2._memoryData = {}
	v2._memoryDataSorted = {}
	v2._treeViewUpdatedSignal = Signal.new()
	v2._totalMemoryUpdated = Signal.new()
	v2._sortType = ChartHeaderNames[1]
	v2._isRunning = false

	v2._doGranularMemUpdate = {}
	v2._granularMemTable = {}

	return v2
end

local function GetMemoryPerformanceStatsItem() -- 1 equivalent call inferred from this helper
	local performanceStats = Stats and Stats:FindFirstChild("PerformanceStats")

	if performanceStats then
		return (performanceStats:FindFirstChild(StatsUtils.StatNames[StatsUtils.StatType_Memory]))
	end

	return nil
end

local function fetchSoundMemoryData()
	local soundMemoryData = SoundService:GetSoundMemoryData()
	local soundMemoryData2 = {}

	for k, v2 in pairs(soundMemoryData) do
		table.insert(soundMemoryData2, { name = k, value = v2 })
	end

	table.sort(soundMemoryData2, function(a, b): boolean
		return a.value > b.value
	end)

	return soundMemoryData2
end

local function fetchGraphicsTextureMemoryData()
	local paginatedMemoryByTexture = Stats:GetPaginatedMemoryByTexture(Enum.TextureQueryType.NonHumanoid, 0, 100)
	local paginatedMemoryByTexture2 = Stats:GetPaginatedMemoryByTexture(
		Enum.TextureQueryType.NonHumanoidOrphaned,
		0,
		100
	)
	local graphicsTextureMemoryData = {}

	local function aggregateData(list, paginatedMemoryByTexture3)
		for _, result in ipairs(paginatedMemoryByTexture3.Results) do
			local v2 = result.MemoryInBytes / 1048576
			table.insert(list, { name = result.TextureId, value = v2 })
		end
	end

	aggregateData(graphicsTextureMemoryData, paginatedMemoryByTexture)
	aggregateData(graphicsTextureMemoryData, paginatedMemoryByTexture2)

	table.sort(graphicsTextureMemoryData, function(a, b): boolean
		return a.value > b.value
	end)

	return graphicsTextureMemoryData
end

local function fetchGraphicsTextureCharacterMemoryData()
	local paginatedMemoryByTexture = Stats:GetPaginatedMemoryByTexture(Enum.TextureQueryType.Humanoid, 0, 100)
	local paginatedMemoryByTexture2 = Stats:GetPaginatedMemoryByTexture(Enum.TextureQueryType.HumanoidOrphaned, 0, 100)
	local graphicsTextureCharacterMemoryData = {}

	local function aggregateData(list, paginatedMemoryByTexture3)
		for _, result in ipairs(paginatedMemoryByTexture3.Results) do
			local v2 = result.MemoryInBytes / 1048576

			local textureId = result.TextureId
			local v3 = {}
			local moreInfo = {}

			for _, v4 in pairs(string.split(textureId, " ")) do
				if string.sub(v4, 1, 2) == "T[" then
					table.insert(v3, v4)
				end
			end

			local set = {}

			for _, v4 in pairs(v3) do
				local v5 = string.split(v4, ".mesh:")[2]

				local v6 = string.find(v5, ":", 12)

				if v6 ~= nil then
					v6 -= 1
				end

				set[string.sub(v5, 1, v6)] = true
			end

			for k, _ in pairs(set) do
				table.insert(moreInfo, { name = k })
			end

			table.sort(moreInfo, function(a, b): boolean
				return a.name < b.name
			end)

			if FFlagDevConsoleKeyCollisionFix then
				table.insert(list, {
					name = "Composite Texture",
					id = result.TextureId,
					value = v2,
					moreInfo = moreInfo
				})
			else
				table.insert(list, { name = "Composite Texture", value = v2, moreInfo = moreInfo })
			end
		end
	end
	aggregateData(graphicsTextureCharacterMemoryData, paginatedMemoryByTexture)
	aggregateData(graphicsTextureCharacterMemoryData, paginatedMemoryByTexture2)

	return graphicsTextureCharacterMemoryData
end

local function fetchGraphicsMeshPartsMemoryData()
	local contentMemoryData = MeshContentProvider:getContentMemoryData()
	local graphicsMeshPartsMemoryData = {}

	for k, v2 in pairs(contentMemoryData) do
		table.insert(graphicsMeshPartsMemoryData, {
			name = k,
			value = v2 / 1048576
		})
	end

	table.sort(graphicsMeshPartsMemoryData, function(a, b): boolean
		return a.value > b.value
	end)

	return graphicsMeshPartsMemoryData
end

local function fetchFuncAnimation()
	local memStats = KeyframeSequenceProvider:GetMemStats()
	local funcAnimation = {}

	for k, memStat in pairs(memStats) do
		table.insert(funcAnimation, {
			name = k,
			value = memStat / 1048576
		})
	end

	table.sort(funcAnimation, function(a, b): boolean
		return a.value > b.value
	end)

	return funcAnimation
end

local function fetchFontMemoryData()
	local fontMemoryData = TextService:GetFontMemoryData()
	local fontMemoryData2 = {}

	for k, v2 in pairs(fontMemoryData) do
		table.insert(fontMemoryData2, {
			name = k,
			value = v2 / 1048576
		})
	end

	table.sort(fontMemoryData2, function(a, b): boolean
		return a.value > b.value
	end)

	return fontMemoryData2
end

function ClientMemoryData:updateCachedData(p, callback)
	if self._doGranularMemUpdate[p] then
		self._doGranularMemUpdate[p] = false
		self._granularMemTable[p] = callback()
	end
end

function ClientMemoryData:getAdditionalMemoryFunc(p)
	local v2 = nil

	if p == "Sounds" then
		v2 = fetchSoundMemoryData
	elseif p == "GraphicsTexture" then
		v2 = fetchGraphicsTextureMemoryData
	elseif p == "GraphicsTextureCharacter" then
		v2 = fetchGraphicsTextureCharacterMemoryData
	elseif p == "GraphicsMeshParts" then
		v2 = fetchGraphicsMeshPartsMemoryData
	elseif p ~= "csgDictionary" then
		if p == "Animation" then
			v2 = fetchFuncAnimation
		elseif p == "gui/FontData" and game:GetEngineFeature("TextServiceGetFontMemoryData") then
			v2 = fetchFontMemoryData
		end
	end

	if v2 then
		return function()
			self:updateCachedData(p, v2)
			return self._granularMemTable[p]
		end
	end

	return nil
end

function ClientMemoryData:recursiveUpdateEntry(p, list, instance)
	local memoryAnalyzerStatName = StatsUtils.GetMemoryAnalyzerStatName(instance.DisplayName)
	local v2 = instance:GetValue()

	local children = instance:GetChildren()

	if p[memoryAnalyzerStatName] then
		local v3 = p[memoryAnalyzerStatName].max
		local v4 = p[memoryAnalyzerStatName].min

		local v5 = { data = v2, time = self._lastUpdate }

		if
			p[memoryAnalyzerStatName].additionalInfoFunc
			and p[memoryAnalyzerStatName].dataSet:back().data ~= v5.data
		then
			self._doGranularMemUpdate[memoryAnalyzerStatName] = true
		end

		local push_back = p[memoryAnalyzerStatName].dataSet:push_back(v5)

		if push_back then
			local iterator = p[memoryAnalyzerStatName].dataSet:iterator()
			local v6 = iterator:next()

			if v3 == push_back.data then
				v3 = v4

				while v6 do
					v3 = v6.data < v3 and v3 or v6.data
					v6 = iterator:next()
				end
			end

			if v4 == push_back.data then
				v4 = v3

				while v6 do
					v4 = v4 < v6.data and v4 or v6.data
					v6 = iterator:next()
				end
			end
		end

		p[memoryAnalyzerStatName].max = v3 < v2 and v2 or v3
		local v6 = p[memoryAnalyzerStatName]
		v2 = v4 < v2 and v4 or v2
		v6.min = v2
	else
		local dataSet = CircularBuffer.new(fVariable)

		dataSet:push_back({ data = v2, time = self._lastUpdate })

		p[memoryAnalyzerStatName] = {
			min = v2,
			max = v2,
			dataSet = dataSet,
			children = #children > 0 and {} or false,
			sortedChildren = #children > 0 and {} or false
		}

		local additionalMemoryFunc = self:getAdditionalMemoryFunc(memoryAnalyzerStatName)

		if additionalMemoryFunc then
			p[memoryAnalyzerStatName].additionalInfoFunc = additionalMemoryFunc
			self._doGranularMemUpdate[memoryAnalyzerStatName] = true
		end

		table.insert(list, { name = memoryAnalyzerStatName, dataStats = p[memoryAnalyzerStatName] })
	end

	local v3 = p[memoryAnalyzerStatName]

	local displayNameSet = {}

	for _, child in ipairs(children) do
		displayNameSet[child.DisplayName] = true

		self:recursiveUpdateEntry(v3.children, v3.sortedChildren, child)
	end

	if v3.children then
		for k, _ in pairs(v3.children) do
			if displayNameSet[k] ~= nil then
				continue
			end

			v3.children[k] = nil

			for i, v4 in ipairs(v3.sortedChildren) do
				if k == v4.name then
					table.remove(v3.sortedChildren, i)
					break
				end
			end
		end
	end
end

function ClientMemoryData:totalMemSignal()
	return self._totalMemoryUpdated
end

function ClientMemoryData:treeUpdatedSignal()
	return self._treeViewUpdatedSignal
end

function ClientMemoryData:getSortType()
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

function ClientMemoryData:setSortType(sortType)
	if not v[sortType] then
		error(string.format("attempted to pass invalid sortType: %s", (tostring(sortType))), 2)

		return
	end

	self._sortType = sortType

	recursiveSort(self._memoryDataSorted, v[self._sortType])
end

function ClientMemoryData:getMemoryData()
	return self._memoryDataSorted
end

function ClientMemoryData:isRunning()
	return self._isRunning
end

function ClientMemoryData:start()
	spawn(function()
		self._pollingId += 1
		local pollingId = self._pollingId
		self._isRunning = true

		while pollingId == self._pollingId do
			local memoryPerformanceStatsItem = GetMemoryPerformanceStatsItem() -- inferred equivalent call

			if not memoryPerformanceStatsItem then
				return
			end

			self._lastUpdate = os.time()
			self:recursiveUpdateEntry(self._memoryData, self._memoryDataSorted, memoryPerformanceStatsItem)

			if self._totalMemory ~= memoryPerformanceStatsItem:getValue() then
				self._totalMemory = memoryPerformanceStatsItem:getValue()
				self._totalMemoryUpdated:Fire(self._totalMemory)
			end

			self._treeViewUpdatedSignal:Fire(self._memoryDataSorted)

			wait(3)
		end

		self._isRunning = false
	end)
end

function ClientMemoryData:stop()
	self._pollingId += 1
end

return ClientMemoryData
