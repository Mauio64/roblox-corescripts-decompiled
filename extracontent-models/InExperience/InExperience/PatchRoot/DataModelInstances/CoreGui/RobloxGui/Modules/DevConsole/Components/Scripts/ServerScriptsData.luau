local CircularBuffer = require(script.Parent.Parent.Parent.CircularBuffer)
local Signal = require(script.Parent.Parent.Parent.Signal)
local Constants = require(script.Parent.Parent.Parent.Constants)
local num = tonumber(settings():GetFVariable("NewDevConsoleMaxGraphCount"))
local ChartHeaderNames = Constants.ServerScriptsFormatting.ChartHeaderNames
local t1 = {
	[ChartHeaderNames[1]] = function(p1, p2) -- line: 11
		return p1.dataStats.dataSet:back().name < p2.dataStats.dataSet:back().name
	end,
	[ChartHeaderNames[2]] = function(p3, p4) -- line: 14
		return p3.dataStats.dataSet:back().data[1] < p4.dataStats.dataSet:back().data[1]
	end,
	[ChartHeaderNames[3]] = function(p5, p6) -- line: 17
		return p5.dataStats.dataSet:back().data[2] < p6.dataStats.dataSet:back().data[2]
	end
}
local minOfTable = require(script.Parent.Parent.Parent.Util.minOfTable)
local maxOfTable = require(script.Parent.Parent.Parent.Util.maxOfTable)
local getClientReplicator = require(script.Parent.Parent.Parent.Util.getClientReplicator)
local t2 = {}

t2.__index = t2

function t2.new() -- line: 29
	-- upvalues: t2 (copy), Signal (copy), ChartHeaderNames (copy)
	local t3 = {}

	setmetatable(t3, t2)
	t3._serverScriptsUpdated = Signal.new()
	t3._serverScriptsData = {}
	t3._lastUpdate = 0
	t3._sortedScriptsData = {}
	t3._sortType = ChartHeaderNames[1]
	t3._isRunning = false

	return t3
end
function t2.setSortType(p7, p8) -- line: 43
	-- upvalues: t1 (copy)
	if t1[p8] then
		p7._sortType = p8
		table.sort(p7._sortedScriptsData, t1[p7._sortType])

		return
	end

	error(string.format("attempted to pass invalid sortType: %s", (tostring(p8))), 2)
end
function t2.getSortType(p9) -- line: 53
	return p9._sortType
end
function t2.Signal(p10) -- line: 57
	return p10._serverScriptsUpdated
end
function t2.getCurrentData(p11) -- line: 61
	return p11._sortedScriptsData
end
function t2.updateScriptsData(p12, p13) -- line: 66
	-- upvalues: CircularBuffer (copy), num (copy), maxOfTable (copy), minOfTable (copy)
	p12._lastUpdate = os.time()

	for k, v in pairs(p13) do
		if not p12._serverScriptsData[k] then
			local v27 = CircularBuffer.new(num)

			v27:push_back({
				data = v,
				time = p12._lastUpdate
			})
			p12._serverScriptsData[k] = {
				max = v,
				min = v,
				dataSet = v27
			}

			local t4 = {
				name = k,
				dataStats = p12._serverScriptsData[k]
			}

			table.insert(p12._sortedScriptsData, t4)
		else
			local t5 = {}

			for k2, v2 in pairs(p12._serverScriptsData[k].max) do
				t5[k2] = v2
			end

			local t6 = {}

			for k3, v3 in pairs(p12._serverScriptsData[k].min) do
				t6[k3] = v3
			end

			local t7 = {
				data = v,
				time = p12._lastUpdate
			}
			local v36 = p12._serverScriptsData[k].dataSet:push_back(t7)

			if v36 then
				for k4, v4 in pairs(v36.data) do
					if v4 == t5[k4] then
						local v39 = p12._serverScriptsData[k].dataSet:iterator()
						local v40 = v39:next()

						t5[k4] = t6[k4]

						while v40 do
							t5[k4] = v40.data[k4] < t5[k4] and t5[k4] or v40.data[k4]
							v40 = v39:next()
						end
					end
				end

				for k5, v5 in pairs(v36.data) do
					if v5 == t6[k5] then
						local v43 = p12._serverScriptsData[k].dataSet:iterator()
						local v44 = v43:next()

						t6[k5] = t5[k5]

						while v44 do
							t6[k5] = t6[k5] < v44.data[k5] and t6[k5] or v44.data[k5]
							v44 = v43:next()
						end
					end
				end
			end

			p12._serverScriptsData[k].max = maxOfTable(t5, v)
			p12._serverScriptsData[k].min = minOfTable(t6, v)
		end
	end
end
function t2.isRunning(p14) -- line: 139
	return p14._isRunning
end
function t2.start(p15) -- line: 143
	-- upvalues: getClientReplicator (copy)
	local v47 = getClientReplicator()

	if v47 and not p15._statsListenerConnection then
		p15._statsListenerConnection = v47.StatsReceived:connect(function(p16) -- line: 146
			-- upvalues: p15 (copy)
			if p16 then
				p15._lastUpdate = os.time()

				local Scripts = p16.Scripts

				if Scripts then
					p15:updateScriptsData(Scripts)
				end

				p15._serverScriptsUpdated:Fire(p15._sortedScriptsData)
			end
		end)
		v47:RequestServerStats(true)
		p15._isRunning = true
	end
end
function t2.stop(p17) -- line: 163
	if p17._statsListenerConnection then
		p17._statsListenerConnection:Disconnect()
		p17._statsListenerConnection = nil
	end

	p17._isRunning = false
end

return t2
