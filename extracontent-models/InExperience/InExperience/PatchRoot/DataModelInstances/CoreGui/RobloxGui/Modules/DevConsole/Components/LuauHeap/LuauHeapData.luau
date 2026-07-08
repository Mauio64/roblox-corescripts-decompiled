game:GetService("ScriptContext")

local HttpService = game:GetService("HttpService")
local Signal = require(script.Parent.Parent.Parent.Signal)
local getClientReplicator = require(script.Parent.Parent.Parent.Util.getClientReplicator)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 13
	-- upvalues: t1 (copy), Signal (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2._serverStatsUpdated = Signal.new()
	t2._serverStatsData = {}
	t2._isRunning = false

	return t2
end
function t1.Signal(p1) -- line: 23
	return p1._serverStatsUpdated
end
function t1.getCurrentData(p2) -- line: 27
	return p2._serverStatsData
end
function t1.isRunning(p3) -- line: 31
	return p3._isRunning
end
function t1.start(p4) -- line: 35
	-- upvalues: getClientReplicator (copy), HttpService (copy)
	local v10 = getClientReplicator()

	if v10 and not p4._statsListenerConnection then
		p4._statsListenerConnection = v10.StatsReceived:connect(function(p5) -- line: 38
			-- upvalues: p4 (copy), HttpService (copy)
			if p5 and (p5.ServerLuauHeapData and #p5.ServerLuauHeapData > 0) then
				p4._serverStatsData = HttpService:JSONDecode(p5.ServerLuauHeapData)
				p4._serverStatsUpdated:Fire(p4._serverStatsData)
			end
		end)
		v10:RequestServerStats(true)
		p4._isRunning = true
	end
end
function t1.stop(p6) -- line: 49
	if p6._statsListenerConnection then
		p6._statsListenerConnection:Disconnect()
		p6._statsListenerConnection = nil
	end

	p6._isRunning = false
end

return t1
