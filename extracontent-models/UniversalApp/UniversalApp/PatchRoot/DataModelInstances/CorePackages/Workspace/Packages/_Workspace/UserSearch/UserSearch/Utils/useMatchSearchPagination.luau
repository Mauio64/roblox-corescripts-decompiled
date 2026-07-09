local Parent = script:FindFirstAncestor("UserSearch").Parent
local React = require(Parent.React)
local Dash = require(Parent.Dash)

local function v4(t1: {[any]: any}, n1: number) -- line: 13
	-- upvalues: Dash (copy)
	local v7 = n1 + 1

	return Dash.slice(t1, v7)
end

return function(t2: {[any]: any}) -- line: 18
	-- upvalues: React (copy), v4 (copy)
	local v9 = t2.users or {}
	local v10, v11 = React.useState(0)
	local v12, v13 = React.useState(v9)

	React.useEffect(function() -- line: 23
		-- upvalues: v13 (copy), v4 (copy), v9 (copy), v10 (copy), v11 (copy)
		v13(v4(v9, v10))
		v11(#v9)
	end, { #v9 })

	return v12
end
