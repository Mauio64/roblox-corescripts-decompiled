local parent = script:FindFirstAncestor("UserSearch").Parent

local React = require(parent.React)
local Dash = require(parent.Dash)

local function fn(users, state: number)
	local v = state + 1
	return Dash.slice(users, v)
end

return function(p)
	local users = p.users or {}
	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(users)

	React.useEffect(function()
		setState2(fn(users, state))
		setState(#users)
	end, { #users })

	return state2
end
