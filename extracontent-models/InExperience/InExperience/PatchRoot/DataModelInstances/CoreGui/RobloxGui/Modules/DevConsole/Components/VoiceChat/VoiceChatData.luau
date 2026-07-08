local Signal = require(script.Parent.Parent.Parent.Signal)
local VoiceChatService = game:GetService("VoiceChatService")
local t1 = {}

t1.__index = t1

function t1.new() -- line: 9
	-- upvalues: t1 (copy), Signal (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2._statsUpdated = Signal.new()
	t2._statsData = {}
	t2._isRunning = false

	return t2
end
function t1.Signal(p1) -- line: 19
	return p1._statsUpdated
end
function t1.getCurrentData(p2) -- line: 23
	return p2._statsData
end
function t1.isRunning(p3) -- line: 27
	return p3._isRunning
end
function t1.start(p4) -- line: 31
	-- upvalues: VoiceChatService (copy)
	if VoiceChatService and not p4._statsListenerConnection then
		p4._statsListenerConnection = VoiceChatService.VoiceChatStatsCollected:Connect(function() -- line: 33
			-- upvalues: p4 (copy), VoiceChatService (copy)
			p4._statsData = VoiceChatService:lastVoiceChatStats()
			p4._statsUpdated:Fire(p4._statsData)
		end)
		p4._isRunning = true
	end
end
function t1.stop(p5) -- line: 41
	p5._isRunning = false

	if p5._statsListenerConnection then
		p5._statsListenerConnection:Disconnect()
	end
end

return t1
