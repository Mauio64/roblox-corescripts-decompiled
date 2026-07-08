local CircularBuffer = require(script.Parent.Parent.Parent.CircularBuffer)
local Signal = require(script.Parent.Parent.Parent.Signal)
local ChartHeaderNames = require(script.Parent.Parent.Parent.Constants).ServerJobsFormatting.ChartHeaderNames
local num = tonumber(settings():GetFVariable("NewDevConsoleMaxGraphCount"))
local t1 = {
	[ChartHeaderNames[1]] = function(p1, p2) -- line: 11
		return p1.name < p2.name
	end,
	[ChartHeaderNames[2]] = function(p3, p4) -- line: 14
		return p3.dataStats.dataSet:back().data[1] < p4.dataStats.dataSet:back().data[1]
	end,
	[ChartHeaderNames[3]] = function(p5, p6) -- line: 17
		return p5.dataStats.dataSet:back().data[2] < p6.dataStats.dataSet:back().data[2]
	end,
	[ChartHeaderNames[4]] = function(p7, p8) -- line: 20
		return p7.dataStats.dataSet:back().data[3] < p8.dataStats.dataSet:back().data[3]
	end
}
local minOfTable = require(script.Parent.Parent.Parent.Util.minOfTable)
local maxOfTable = require(script.Parent.Parent.Parent.Util.maxOfTable)
local getClientReplicator = require(script.Parent.Parent.Parent.Util.getClientReplicator)
local t2 = {}

t2.__index = t2

function t2.new() -- line: 32
	-- upvalues: t2 (copy), Signal (copy), ChartHeaderNames (copy)
	local t3 = {}

	setmetatable(t3, t2)
	t3._serverJobsUpdated = Signal.new()
	t3._serverJobsData = {}
	t3._sortedJobsData = {}
	t3._sortType = ChartHeaderNames[1]
	t3._lastUpdate = 0
	t3._isRunning = false

	return t3
end
function t2.setSortType(p9, p10) -- line: 46
	-- upvalues: t1 (copy)
	if t1[p10] then
		p9._sortType = p10
		table.sort(p9._sortedJobsData, t1[p9._sortType])

		return
	end

	error(string.format("attempted to pass invalid sortType: %s", (tostring(p10))), 2)
end
function t2.getSortType(p11) -- line: 56
	return p11._sortType
end
function t2.Signal(p12) -- line: 60
	return p12._serverJobsUpdated
end
function t2.getCurrentData(p13) -- line: 64
	return p13._sortedJobsData
end
function t2.updateServerJobsData(p14, p15) -- line: 68
	-- upvalues: CircularBuffer (copy), num (copy), maxOfTable (copy), minOfTable (copy)
	p14._lastUpdate = os.time()

	for k, v in pairs(p15) do
		if not p14._serverJobsData[k] then
			local v28 = CircularBuffer.new(num)

			v28:push_back({
				data = v,
				time = p14._lastUpdate
			})
			p14._serverJobsData[k] = {
				max = v,
				min = v,
				dataSet = v28
			}

			local t4 = {
				name = k,
				dataStats = p14._serverJobsData[k]
			}

			table.insert(p14._sortedJobsData, t4)
		else
			local t5 = {}

			for k2, v2 in pairs(p14._serverJobsData[k].max) do
				t5[k2] = v2
			end

			local t6 = {}

			for k3, v3 in pairs(p14._serverJobsData[k].min) do
				t6[k3] = v3
			end

			local t7 = {
				data = v,
				time = p14._lastUpdate
			}
			local v37 = p14._serverJobsData[k].dataSet:push_back(t7)

			if v37 then
				for k4, v4 in pairs(v37.data) do
					if v4 == t5[k4] then
						local v40 = p14._serverJobsData[k].dataSet:iterator()
						local v41 = v40:next()

						t5[k4] = t6[k4]

						while v41 do
							t5[k4] = v41.data[k4] < t5[k4] and t5[k4] or v41.data[k4]
							v41 = v40:next()
						end
					end
				end

				for k5, v5 in pairs(v37.data) do
					if v5 == t6[k5] then
						local v44 = p14._serverJobsData[k].dataSet:iterator()
						local v45 = v44:next()

						t6[k5] = t5[k5]

						while v45 do
							t6[k5] = t6[k5] < v45.data[k5] and t6[k5] or v45.data[k5]
							v45 = v44:next()
						end
					end
				end
			end

			p14._serverJobsData[k].max = maxOfTable(t5, v)
			p14._serverJobsData[k].min = minOfTable(t6, v)
		end
	end
end
function t2.isRunning(p16) -- line: 141
	return p16._isRunning
end
function t2.start(p17) -- line: 145
	-- upvalues: getClientReplicator (copy)
	local v48 = getClientReplicator()

	if v48 and not p17._statsListenerConnection then
		p17._statsListenerConnection = v48.StatsReceived:connect(function(p18) -- line: 148
			-- upvalues: p17 (copy)
			local Jobs = p18.Jobs

			if Jobs then
				p17:updateServerJobsData(Jobs)
				p17._serverJobsUpdated:Fire(p17._sortedJobsData)
			end
		end)
		v48:RequestServerStats(true)
		p17._isRunning = true
	end
end
function t2.stop(p19) -- line: 161
	if p19._statsListenerConnection then
		p19._statsListenerConnection:Disconnect()
		p19._statsListenerConnection = nil
		p19._isRunning = false
	end
end

return t2
