local CircularBuffer = require(script.Parent.Parent.Parent.CircularBuffer)
local Signal = require(script.Parent.Parent.Parent.Signal)

local fVariable = tonumber(settings():GetFVariable("NewDevConsoleMaxGraphCount"))

local getClientReplicator = require(script.Parent.Parent.Parent.Util.getClientReplicator)

local DataStoresData = {}
DataStoresData.__index = DataStoresData

function DataStoresData.new()
	local v = {}
	setmetatable(v, DataStoresData)

	v._dataStoresUpdated = Signal.new()
	v._dataStoresData = {}
	v._dataStoresDataCount = 0
	v._lastUpdateTime = 0
	v._isRunning = false
	return v
end

function DataStoresData:Signal()
	return self._dataStoresUpdated
end

function DataStoresData:getCurrentData()
	return self._dataStoresData, self._dataStoresDataCount
end

function DataStoresData:updateValue(p, min)
	if self._dataStoresData[p] then
		local v = self._dataStoresData[p]
		local v2 = v.max
		local v3 = v.min

		local v4 = { value = min, time = self._lastUpdateTime }

		local push_back = self._dataStoresData[p].dataSet:push_back(v4)

		if push_back then
			local iterator = self._dataStoresData[p].dataSet:iterator()
			local v5 = iterator:next()

			if v2 == push_back.value then
				v2 = v3

				while v5 do
					v2 = v5.value < v2 and v2 or v5.value
					v5 = iterator:next()
				end
			end

			if v3 == push_back.value then
				v3 = v2

				while v5 do
					v3 = v3 < v5.value and v3 or v5.value
					v5 = iterator:next()
				end
			end
		end

		self._dataStoresData[p].max = v2 < min and min or v2
		local v5 = self._dataStoresData[p]
		min = v3 < min and v3 or min
		v5.min = min
	else
		local dataSet = CircularBuffer.new(fVariable)
		dataSet:push_back({ value = min, time = self._lastUpdateTime })

		self._dataStoresData[p] = { max = min, min = min, dataSet = dataSet }
	end
end

function DataStoresData:isRunning()
	return self._isRunning
end

function DataStoresData:start()
	local clientReplicator = getClientReplicator()

	if clientReplicator and not self._statsListenerConnection then
		self._statsListenerConnection = clientReplicator.StatsReceived:connect(function(p)
			local dataStoreBudget = p.DataStoreBudget
			self._lastUpdateTime = os.time()

			if dataStoreBudget then
				local count = 0

				for k, v in pairs(dataStoreBudget) do
					if type(v) ~= "number" then
						continue
					end

					self:updateValue(k, v)
					count += 1
				end

				self._dataStoresDataCount = count
				self._dataStoresUpdated:Fire(self._dataStoresData, self._dataStoresDataCount)
			end
		end)
		clientReplicator:RequestServerStats(true)
		self._isRunning = true
	end
end

function DataStoresData:stop()
	if self._statsListenerConnection then
		self._statsListenerConnection:Disconnect()
		self._statsListenerConnection = nil
	end

	self._isRunning = false
end

return DataStoresData
