local ultimatelist = script:FindFirstAncestor("ultimate-list")

local React = require(ultimatelist.Parent.React)

local function joinAndMapBindings(callback, p, p2, p3)
	return React.joinBindings({ p, p2, p3 }):map(function(list)
		return callback(unpack(list))
	end)
end

return joinAndMapBindings
