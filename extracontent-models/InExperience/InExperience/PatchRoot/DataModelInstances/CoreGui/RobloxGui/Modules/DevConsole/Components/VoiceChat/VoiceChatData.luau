local Signal = require(script.Parent.Parent.Parent.Signal)
local VoiceChatService = game:GetService("VoiceChatService")

local VoiceChatData = {}
VoiceChatData.__index = VoiceChatData

function VoiceChatData.new()
	local v = {}
	setmetatable(v, VoiceChatData)

	v._statsUpdated = Signal.new()
	v._statsData = {}
	v._isRunning = false
	return v
end

function VoiceChatData:Signal()
	return self._statsUpdated
end

function VoiceChatData:getCurrentData()
	return self._statsData
end

function VoiceChatData:isRunning()
	return self._isRunning
end

function VoiceChatData:start()
	if VoiceChatService and not self._statsListenerConnection then
		self._statsListenerConnection = VoiceChatService.VoiceChatStatsCollected:Connect(function()
			self._statsData = VoiceChatService:lastVoiceChatStats()
			self._statsUpdated:Fire(self._statsData)
		end)
		self._isRunning = true
	end
end

function VoiceChatData:stop()
	self._isRunning = false

	if self._statsListenerConnection then
		self._statsListenerConnection:Disconnect()
	end
end

return VoiceChatData
