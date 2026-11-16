local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local Analytics = require(ExpChatShared.Analytics)

return function(p, p2, p3)
	p.Error:Connect(function(_, value, p4)
		if p4 == p2 or value and string.find(value, "ExpChat") then
			Analytics.reportCounter(p3 and "expChatErrorCountServer" or "expChatErrorCountClient")
		end
	end)
end
