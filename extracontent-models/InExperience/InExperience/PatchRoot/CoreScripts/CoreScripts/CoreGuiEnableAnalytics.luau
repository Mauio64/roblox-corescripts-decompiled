local StarterGui = game:GetService("StarterGui")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")
local EventStream = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventStream
local t1 = {}

t1.__index = t1

function t1.new() -- line: 19
	-- upvalues: EventStream (copy), RbxAnalyticsService (copy), StarterGui (copy), t1 (copy)
	local t2 = {
		evenStream = EventStream.new(RbxAnalyticsService),
		playSessionStart = os.clock()
	}

	function t2.sendCoreGuiAnalytic(p1, b1: boolean) -- line: 25
		-- upvalues: t2 (copy), RbxAnalyticsService (copy)
		local v10 = math.round((os.clock() - t2.playSessionStart) * 1000)
		local t3 = {
			placeid = tostring(game.PlaceId),
			universeid = tostring(game.GameId),
			type = tostring(p1.Name),
			enabled = tostring(b1),
			sessionid = RbxAnalyticsService:GetSessionId(),
			playSessionDurationMs = tostring(v10)
		}

		t2.evenStream:sendEventDeferred("core_gui_type", "core_gui_type", t3)
	end

	t2.signalConnection = StarterGui.CoreGuiChangedSignal:Connect(function(p2, b2: boolean) -- line: 42
		-- upvalues: t2 (copy)
		t2.sendCoreGuiAnalytic(p2, b2)
	end)
	setmetatable(t2, t1)

	return t2
end
function t1.DisconnectSignal(p3) -- line: 50
	p3.signalConnection:Disconnect()
end

t1.new()

return t1
