local StarterGui = game:GetService("StarterGui")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CorePackages = game:GetService("CorePackages")
local EventStream = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventStream
local t1 = {}

t1.__index = t1

function t1.new() -- line: 22
	-- upvalues: EventStream (copy), RbxAnalyticsService (copy), t1 (copy)
	local t2 = {
		evenStream = EventStream.new(RbxAnalyticsService)
	}

	setmetatable(t2, t1)

	return t2
end
function t1.sendCoreGuiFinalAnalytic(p1) -- line: 30
	-- upvalues: RbxAnalyticsService (copy), StarterGui (copy)
	local t3 = {
		placeid = tostring(game.PlaceId),
		universeid = tostring(game.GameId),
		sessionid = RbxAnalyticsService:GetSessionId()
	}

	for _, v10 in Enum.CoreGuiType:GetEnumItems() do
		t3[v10.Name] = tostring(StarterGui:GetCoreGuiEnabled(v10))
	end

	local s1 = ""

	pcall(function() -- line: 43
		-- upvalues: s1 (ref), StarterGui (copy)
		s1 = tostring(StarterGui:GetCore("ResetButtonCallback"))
	end)
	t3.ResetButtonCallback = s1
	p1.evenStream:sendEventDeferred("core_gui_final_state", "core_gui_final_state", t3)
end

return t1
