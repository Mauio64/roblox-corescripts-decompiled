local CircularBuffer = require(script.Parent.Parent.Parent.CircularBuffer)
local Signal = require(script.Parent.Parent.Parent.Signal)

local fVariable = tonumber(settings():GetFVariable("NewDevConsoleMaxGraphCount"))

local getClientReplicator = require(script.Parent.Parent.Parent.Util.getClientReplicator)

local ServerStatsData = {}
ServerStatsData.__index = ServerStatsData

function ServerStatsData.new()
	local v = {}
	setmetatable(v, ServerStatsData)

	v._serverStatsUpdated = Signal.new()
	v._serverStatsPing = Signal.new()
	v._serverStatsData = {}
	v._serverStatsDataCount = 0
	v._lastUpdateTime = 0
	v._isRunning = false
	return v
end

function ServerStatsData:avgPing()
	return self._serverStatsPing
end

function ServerStatsData:Signal()
	return self._serverStatsUpdated
end

function ServerStatsData:getCurrentData()
	return self._serverStatsData
end

function ServerStatsData:updateValue(p, min)
	if self._serverStatsData[p] then
		local v = self._serverStatsData[p]
		local v2 = v.max
		local v3 = v.min

		local v4 = { value = min, time = self._lastUpdateTime }

		local push_back = self._serverStatsData[p].dataSet:push_back(v4)

		if push_back then
			local iterator = self._serverStatsData[p].dataSet:iterator()
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

		self._serverStatsData[p].max = v2 < min and min or v2
		local v5 = self._serverStatsData[p]
		min = v3 < min and v3 or min
		v5.min = min
	else
		local dataSet = CircularBuffer.new(fVariable)
		dataSet:push_back({ value = min, time = self._lastUpdateTime })

		self._serverStatsData[p] = { max = min, min = min, dataSet = dataSet }
	end
end

function ServerStatsData:isRunning()
	return self._isRunning
end

function ServerStatsData:start()
	local clientReplicator = getClientReplicator()

	if clientReplicator and not self._statsListenerConnection then
		self._statsListenerConnection = clientReplicator.StatsReceived:connect(function(items)
			if items then
				self._lastUpdateTime = os.time()
				local count = 0

				for k, item in pairs(items) do
					if type(item) ~= "number" then
						continue
					end

					self:updateValue(k, item)
					count += 1
				end

				self._serverStatsDataCount = count
				self._serverStatsUpdated:Fire(self._serverStatsData)

				if self._serverStatsData["Avg Data Ping ms"] then
					self._serverStatsPing:Fire(self._serverStatsData["Avg Data Ping ms"].dataSet:back().value)
				end
			end
		end)
		clientReplicator:RequestServerStats(true)
		self._isRunning = true
	end
end

function ServerStatsData:stop()
	if self._statsListenerConnection then
		self._statsListenerConnection:Disconnect()
		self._statsListenerConnection = nil
	end

	self._isRunning = false
end

return ServerStatsData
