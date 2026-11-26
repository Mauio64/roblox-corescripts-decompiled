local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/React")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/Dash")

local function fn(users, state)
	local v5 = state + 1
	return Dash.slice(users, v5)
end

return function(p2)
	local users = p2.users or {}
	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(users)

	React.useEffect(function()
		setState2(fn(users, state))
		setState(#users)
	end, { #users })

	return state2
end
