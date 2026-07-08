local CircularBuffer = require(script.Parent.Parent.Parent.CircularBuffer)
local Signal = require(script.Parent.Parent.Parent.Signal)
local num = tonumber(settings():GetFVariable("NewDevConsoleMaxGraphCount"))
local getClientReplicator = require(script.Parent.Parent.Parent.Util.getClientReplicator)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 14
	-- upvalues: t1 (copy), Signal (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2._serverStatsUpdated = Signal.new()
	t2._serverStatsPing = Signal.new()
	t2._serverStatsData = {}
	t2._serverStatsDataCount = 0
	t2._lastUpdateTime = 0
	t2._isRunning = false

	return t2
end
function t1.avgPing(p1) -- line: 27
	return p1._serverStatsPing
end
function t1.Signal(p2) -- line: 31
	return p2._serverStatsUpdated
end
function t1.getCurrentData(p3) -- line: 35
	return p3._serverStatsData
end
function t1.updateValue(p4, p5, p6) -- line: 39
	-- upvalues: CircularBuffer (copy), num (copy)
	if not p4._serverStatsData[p5] then
		local v13 = CircularBuffer.new(num)

		v13:push_back({
			value = p6,
			time = p4._lastUpdateTime
		})
		p4._serverStatsData[p5] = {
			max = p6,
			min = p6,
			dataSet = v13
		}

		return
	end

	local v14 = p4._serverStatsData[p5]
	local max = v14.max
	local min = v14.min
	local t3 = {
		value = p6,
		time = p4._lastUpdateTime
	}
	local v18 = p4._serverStatsData[p5].dataSet:push_back(t3)

	if v18 then
		local v19 = p4._serverStatsData[p5].dataSet:iterator()
		local v20 = v19:next()

		if max == v18.value then
			max = min

			while v20 do
				max = max > v20.value and max or v20.value
				v20 = v19:next()
			end
		end

		if min == v18.value then
			min = max

			while v20 do
				min = min < v20.value and min or v20.value
				v20 = v19:next()
			end
		end
	end

	p4._serverStatsData[p5].max = max < p6 and p6 or max
	p4._serverStatsData[p5].min = min < p6 and min or p6
end
function t1.isRunning(p7) -- line: 87
	return p7._isRunning
end
function t1.start(p8) -- line: 91
	-- upvalues: getClientReplicator (copy)
	local v23 = getClientReplicator()

	if v23 and not p8._statsListenerConnection then
		p8._statsListenerConnection = v23.StatsReceived:connect(function(p9) -- line: 94
			-- upvalues: p8 (copy)
			if p9 then
				p8._lastUpdateTime = os.time()

				local n1 = 0

				for k, v in pairs(p9) do
					if type(v) == "number" then
						p8:updateValue(k, v)
						n1 += 1
					end
				end

				p8._serverStatsDataCount = n1
				p8._serverStatsUpdated:Fire(p8._serverStatsData)

				if p8._serverStatsData["Avg Data Ping ms"] then
					p8._serverStatsPing:Fire(p8._serverStatsData["Avg Data Ping ms"].dataSet:back().value)
				end
			end
		end)
		v23:RequestServerStats(true)
		p8._isRunning = true
	end
end
function t1.stop(p10) -- line: 117
	if p10._statsListenerConnection then
		p10._statsListenerConnection:Disconnect()
		p10._statsListenerConnection = nil
	end

	p10._isRunning = false
end

return t1
