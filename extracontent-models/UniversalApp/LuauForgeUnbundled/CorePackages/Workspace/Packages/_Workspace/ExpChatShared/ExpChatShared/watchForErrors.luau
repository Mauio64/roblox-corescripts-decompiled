local Analytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/Analytics")

return function(p2, p3, p4)
	p2.Error:Connect(function(p5, value, p6)
		if p6 == p3 or value and string.find(value, "ExpChat") then
			Analytics.reportCounter(p4 and "expChatErrorCountServer" or "expChatErrorCountClient")
		end
	end)
end
