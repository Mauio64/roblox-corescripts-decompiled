local Parent = script:FindFirstAncestor("AppChat").Parent
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch
local React = require(Parent.React)

return function(p1) -- line: 7
	-- upvalues: useDispatch (copy), React (copy)
	local v5 = useDispatch()

	return React.useMemo(function() -- line: 10
		-- upvalues: p1 (copy), v5 (copy)
		return p1(v5)
	end, {
		v5,
		p1
	})
end
