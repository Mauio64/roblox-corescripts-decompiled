local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local act = require(FriendsLanding.dependencies).Roact.act
local RunService = game:GetService("RunService")

return function(p1, n1: number?) -- line: 7
	-- upvalues: act (copy), RunService (copy)
	local v6 = n1 or 1
	local n2 = 0

	while v6 > n2 and not p1() do
		act(function() -- line: 11
			-- upvalues: n2 (ref), RunService (copy)
			n2 += RunService.Heartbeat:Wait()
		end)
	end
end
