local CircularBuffer = require(script.Parent.Parent.Parent.CircularBuffer)
local Signal = require(script.Parent.Parent.Parent.Signal)

local Constants = require(script.Parent.Parent.Parent.Constants)
local fVariable = tonumber(settings():GetFVariable("NewDevConsoleMaxGraphCount"))

local ChartHeaderNames = Constants.ServerScriptsFormatting.ChartHeaderNames

local v = {
	[ChartHeaderNames[1]] = function(p, p2): boolean
		return p.dataStats.dataSet:back().name < p2.dataStats.dataSet:back().name
	end,
	[ChartHeaderNames[2]] = function(p, p2): boolean
		return p.dataStats.dataSet:back().data[1] < p2.dataStats.dataSet:back().data[1]
	end,
	[ChartHeaderNames[3]] = function(p, p2): boolean
		return p.dataStats.dataSet:back().data[2] < p2.dataStats.dataSet:back().data[2]
	end
}

local minOfTable = require(script.Parent.Parent.Parent.Util.minOfTable)
local maxOfTable = require(script.Parent.Parent.Parent.Util.maxOfTable)
local getClientReplicator = require(script.Parent.Parent.Parent.Util.getClientReplicator)

local ServerScriptsData = {}
ServerScriptsData.__index = ServerScriptsData

function ServerScriptsData.new()
	local v2 = {}
	setmetatable(v2, ServerScriptsData)

	v2._serverScriptsUpdated = Signal.new()
	v2._serverScriptsData = {}
	v2._lastUpdate = 0
	v2._sortedScriptsData = {}
	v2._sortType = ChartHeaderNames[1]
	v2._isRunning = false

	return v2
end

function ServerScriptsData:setSortType(sortType)
	if not v[sortType] then
		error(string.format("attempted to pass invalid sortType: %s", (tostring(sortType))), 2)

		return
	end

	self._sortType = sortType

	table.sort(self._sortedScriptsData, v[self._sortType])
end

function ServerScriptsData:getSortType()
	return self._sortType
end

function ServerScriptsData:Signal()
	return self._serverScriptsUpdated
end

function ServerScriptsData:getCurrentData()
	return self._sortedScriptsData
end

function ServerScriptsData:updateScriptsData(items)
	self._lastUpdate = os.time()

	for k, item in pairs(items) do
		if self._serverScriptsData[k] then
			local v2 = {}

			for k2, v3 in pairs(self._serverScriptsData[k].max) do
				v2[k2] = v3
			end

			local v3 = {}

			for k2, v4 in pairs(self._serverScriptsData[k].min) do
				v3[k2] = v4
			end

			local v4 = { data = item, time = self._lastUpdate }

			local push_back = self._serverScriptsData[k].dataSet:push_back(v4)

			if push_back then
				for k2, v5 in pairs(push_back.data) do
					if v2[k2] ~= v5 then
						continue
					end

					local iterator = self._serverScriptsData[k].dataSet:iterator()
					local v6 = iterator:next()
					v2[k2] = v3[k2]

					while v6 do
						v2[k2] = v6.data[k2] < v2[k2] and v2[k2] or v6.data[k2]
						v6 = iterator:next()
					end
				end

				for k2, v5 in pairs(push_back.data) do
					if v3[k2] ~= v5 then
						continue
					end

					local iterator = self._serverScriptsData[k].dataSet:iterator()
					local v6 = iterator:next()
					v3[k2] = v2[k2]

					while v6 do
						v3[k2] = v3[k2] < v6.data[k2] and v3[k2] or v6.data[k2]
						v6 = iterator:next()
					end
				end
			end

			self._serverScriptsData[k].max = maxOfTable(v2, item)
			self._serverScriptsData[k].min = minOfTable(v3, item)
		else
			local dataSet = CircularBuffer.new(fVariable)
			dataSet:push_back({ data = item, time = self._lastUpdate })

			self._serverScriptsData[k] = { max = item, min = item, dataSet = dataSet }

			local v2 = { name = k, dataStats = self._serverScriptsData[k] }

			table.insert(self._sortedScriptsData, v2)
		end
	end
end

function ServerScriptsData:isRunning()
	return self._isRunning
end

function ServerScriptsData:start()
	local clientReplicator = getClientReplicator()

	if clientReplicator and not self._statsListenerConnection then
		self._statsListenerConnection = clientReplicator.StatsReceived:connect(function(p)
			if p then
				self._lastUpdate = os.time()

				local scripts = p.Scripts

				if scripts then
					self:updateScriptsData(scripts)
				end

				self._serverScriptsUpdated:Fire(self._sortedScriptsData)
			end
		end)
		clientReplicator:RequestServerStats(true)
		self._isRunning = true
	end
end

function ServerScriptsData:stop()
	if self._statsListenerConnection then
		self._statsListenerConnection:Disconnect()
		self._statsListenerConnection = nil
	end

	self._isRunning = false
end

return ServerScriptsData
