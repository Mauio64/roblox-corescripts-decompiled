local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local dependencies = require(FriendsLanding.dependencies)

local roact = dependencies.Roact

return function(p, items)
	for _, item in items do
		p = roact.createElement(item[1], item[2], { p })
	end

	return p
end
