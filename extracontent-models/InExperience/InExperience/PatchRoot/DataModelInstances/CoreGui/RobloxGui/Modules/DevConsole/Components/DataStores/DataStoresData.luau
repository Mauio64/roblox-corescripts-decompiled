local CircularBuffer = require(script.Parent.Parent.Parent.CircularBuffer)
local Signal = require(script.Parent.Parent.Parent.Signal)
local num = tonumber(settings():GetFVariable("NewDevConsoleMaxGraphCount"))
local getClientReplicator = require(script.Parent.Parent.Parent.Util.getClientReplicator)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 12
	-- upvalues: t1 (copy), Signal (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2._dataStoresUpdated = Signal.new()
	t2._dataStoresData = {}
	t2._dataStoresDataCount = 0
	t2._lastUpdateTime = 0
	t2._isRunning = false

	return t2
end
function t1.Signal(p1) -- line: 24
	return p1._dataStoresUpdated
end
function t1.getCurrentData(p2) -- line: 28
	return p2._dataStoresData, p2._dataStoresDataCount
end
function t1.updateValue(p3, p4, p5) -- line: 32
	-- upvalues: CircularBuffer (copy), num (copy)
	if not p3._dataStoresData[p4] then
		local v12 = CircularBuffer.new(num)

		v12:push_back({
			value = p5,
			time = p3._lastUpdateTime
		})
		p3._dataStoresData[p4] = {
			max = p5,
			min = p5,
			dataSet = v12
		}

		return
	end

	local v13 = p3._dataStoresData[p4]
	local max = v13.max
	local min = v13.min
	local t3 = {
		value = p5,
		time = p3._lastUpdateTime
	}
	local v17 = p3._dataStoresData[p4].dataSet:push_back(t3)

	if v17 then
		local v18 = p3._dataStoresData[p4].dataSet:iterator()
		local v19 = v18:next()

		if max == v17.value then
			max = min

			while v19 do
				max = max > v19.value and max or v19.value
				v19 = v18:next()
			end
		end

		if min == v17.value then
			min = max

			while v19 do
				min = min < v19.value and min or v19.value
				v19 = v18:next()
			end
		end
	end

	p3._dataStoresData[p4].max = max < p5 and p5 or max
	p3._dataStoresData[p4].min = min < p5 and min or p5
end
function t1.isRunning(p6) -- line: 80
	return p6._isRunning
end
function t1.start(p7) -- line: 84
	-- upvalues: getClientReplicator (copy)
	local v22 = getClientReplicator()

	if v22 and not p7._statsListenerConnection then
		p7._statsListenerConnection = v22.StatsReceived:connect(function(p8) -- line: 87
			-- upvalues: p7 (copy)
			local DataStoreBudget = p8.DataStoreBudget

			p7._lastUpdateTime = os.time()

			if DataStoreBudget then
				local n1 = 0

				for k, v in pairs(DataStoreBudget) do
					if type(v) == "number" then
						p7:updateValue(k, v)
						n1 += 1
					end
				end

				p7._dataStoresDataCount = n1
				p7._dataStoresUpdated:Fire(p7._dataStoresData, p7._dataStoresDataCount)
			end
		end)
		v22:RequestServerStats(true)
		p7._isRunning = true
	end
end
function t1.stop(p9) -- line: 107
	if p9._statsListenerConnection then
		p9._statsListenerConnection:Disconnect()
		p9._statsListenerConnection = nil
	end

	p9._isRunning = false
end

return t1
