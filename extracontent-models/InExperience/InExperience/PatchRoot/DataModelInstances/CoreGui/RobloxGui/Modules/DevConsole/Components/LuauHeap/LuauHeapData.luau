game:GetService("ScriptContext")
local HttpService = game:GetService("HttpService")

local Signal = require(script.Parent.Parent.Parent.Signal)

local getClientReplicator = require(script.Parent.Parent.Parent.Util.getClientReplicator)

local LuauHeapData = {}
LuauHeapData.__index = LuauHeapData

function LuauHeapData.new()
	local v = {}
	setmetatable(v, LuauHeapData)

	v._serverStatsUpdated = Signal.new()
	v._serverStatsData = {}
	v._isRunning = false
	return v
end

function LuauHeapData:Signal()
	return self._serverStatsUpdated
end

function LuauHeapData:getCurrentData()
	return self._serverStatsData
end

function LuauHeapData:isRunning()
	return self._isRunning
end

function LuauHeapData:start()
	local clientReplicator = getClientReplicator()

	if clientReplicator and not self._statsListenerConnection then
		self._statsListenerConnection = clientReplicator.StatsReceived:connect(function(p)
			if p and p.ServerLuauHeapData and #p.ServerLuauHeapData > 0 then
				self._serverStatsData = HttpService:JSONDecode(p.ServerLuauHeapData)
				self._serverStatsUpdated:Fire(self._serverStatsData)
			end
		end)
		clientReplicator:RequestServerStats(true)
		self._isRunning = true
	end
end

function LuauHeapData:stop()
	if self._statsListenerConnection then
		self._statsListenerConnection:Disconnect()
		self._statsListenerConnection = nil
	end

	self._isRunning = false
end

return LuauHeapData
