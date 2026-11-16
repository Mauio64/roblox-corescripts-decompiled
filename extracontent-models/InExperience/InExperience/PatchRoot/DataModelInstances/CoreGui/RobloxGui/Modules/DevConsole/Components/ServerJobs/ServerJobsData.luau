local CircularBuffer = require(script.Parent.Parent.Parent.CircularBuffer)
local Signal = require(script.Parent.Parent.Parent.Signal)

local Constants = require(script.Parent.Parent.Parent.Constants)
local ChartHeaderNames = Constants.ServerJobsFormatting.ChartHeaderNames

local fVariable = tonumber(settings():GetFVariable("NewDevConsoleMaxGraphCount"))

local v = {
	[ChartHeaderNames[1]] = function(p, p2): boolean
		return p.name < p2.name
	end,
	[ChartHeaderNames[2]] = function(p, p2): boolean
		return p.dataStats.dataSet:back().data[1] < p2.dataStats.dataSet:back().data[1]
	end,
	[ChartHeaderNames[3]] = function(p, p2): boolean
		return p.dataStats.dataSet:back().data[2] < p2.dataStats.dataSet:back().data[2]
	end,
	[ChartHeaderNames[4]] = function(p, p2): boolean
		return p.dataStats.dataSet:back().data[3] < p2.dataStats.dataSet:back().data[3]
	end
}

local minOfTable = require(script.Parent.Parent.Parent.Util.minOfTable)
local maxOfTable = require(script.Parent.Parent.Parent.Util.maxOfTable)
local getClientReplicator = require(script.Parent.Parent.Parent.Util.getClientReplicator)

local ServerJobsData = {}
ServerJobsData.__index = ServerJobsData

function ServerJobsData.new()
	local v2 = {}
	setmetatable(v2, ServerJobsData)

	v2._serverJobsUpdated = Signal.new()
	v2._serverJobsData = {}
	v2._sortedJobsData = {}
	v2._sortType = ChartHeaderNames[1]
	v2._lastUpdate = 0
	v2._isRunning = false

	return v2
end

function ServerJobsData:setSortType(sortType)
	if not v[sortType] then
		error(string.format("attempted to pass invalid sortType: %s", (tostring(sortType))), 2)

		return
	end

	self._sortType = sortType

	table.sort(self._sortedJobsData, v[self._sortType])
end

function ServerJobsData:getSortType()
	return self._sortType
end

function ServerJobsData:Signal()
	return self._serverJobsUpdated
end

function ServerJobsData:getCurrentData()
	return self._sortedJobsData
end

function ServerJobsData:updateServerJobsData(items)
	self._lastUpdate = os.time()

	for k, item in pairs(items) do
		if self._serverJobsData[k] then
			local v2 = {}

			for k2, v3 in pairs(self._serverJobsData[k].max) do
				v2[k2] = v3
			end

			local v3 = {}

			for k2, v4 in pairs(self._serverJobsData[k].min) do
				v3[k2] = v4
			end

			local v4 = { data = item, time = self._lastUpdate }

			local push_back = self._serverJobsData[k].dataSet:push_back(v4)

			if push_back then
				for k2, v5 in pairs(push_back.data) do
					if v2[k2] ~= v5 then
						continue
					end

					local iterator = self._serverJobsData[k].dataSet:iterator()
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

					local iterator = self._serverJobsData[k].dataSet:iterator()
					local v6 = iterator:next()
					v3[k2] = v2[k2]

					while v6 do
						v3[k2] = v3[k2] < v6.data[k2] and v3[k2] or v6.data[k2]
						v6 = iterator:next()
					end
				end
			end

			self._serverJobsData[k].max = maxOfTable(v2, item)
			self._serverJobsData[k].min = minOfTable(v3, item)
		else
			local dataSet = CircularBuffer.new(fVariable)
			dataSet:push_back({ data = item, time = self._lastUpdate })

			self._serverJobsData[k] = { max = item, min = item, dataSet = dataSet }

			local v2 = { name = k, dataStats = self._serverJobsData[k] }

			table.insert(self._sortedJobsData, v2)
		end
	end
end

function ServerJobsData:isRunning()
	return self._isRunning
end

function ServerJobsData:start()
	local clientReplicator = getClientReplicator()

	if clientReplicator and not self._statsListenerConnection then
		self._statsListenerConnection = clientReplicator.StatsReceived:connect(function(p)
			local jobs = p.Jobs

			if jobs then
				self:updateServerJobsData(jobs)
				self._serverJobsUpdated:Fire(self._sortedJobsData)
			end
		end)
		clientReplicator:RequestServerStats(true)
		self._isRunning = true
	end
end

function ServerJobsData:stop()
	if self._statsListenerConnection then
		self._statsListenerConnection:Disconnect()
		self._statsListenerConnection = nil
		self._isRunning = false
	end
end

return ServerJobsData
