local ExpChatShared = script:FindFirstAncestor("ExpChatShared")
local Analytics = require(ExpChatShared.Analytics)

return function(p1, p2, p3) -- line: 4
	-- upvalues: Analytics (copy)
	p1.Error:Connect(function(_, p5, p6) -- line: 5
		-- upvalues: p2 (copy), p3 (copy), Analytics (copy)
		if p6 == p2 or p5 and string.find(p5, "ExpChat") then
			local v9 = not p3 and "expChatErrorCountClient" or "expChatErrorCountServer"

			Analytics.reportCounter(v9)
		end
	end)
end
