local Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Services/Analytics")
local Thunk = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Thunk")

local v5 = { Analytics }

local function sendEvent(p2, p3)
	return Thunk.new("sendEvent", v5, function(p4, p5)
		p5[Analytics].signalEvent(p2, p3)
	end)
end

return sendEvent
