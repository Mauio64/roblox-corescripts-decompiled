local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local Roact = require(FriendsLanding.dependencies).Roact

return function(p1, p2) -- line: 6
	-- upvalues: Roact (copy)
	for _, v6 in p2 do
		p1 = Roact.createElement(v6[1], v6[2], { p1 })
	end

	return p1
end
