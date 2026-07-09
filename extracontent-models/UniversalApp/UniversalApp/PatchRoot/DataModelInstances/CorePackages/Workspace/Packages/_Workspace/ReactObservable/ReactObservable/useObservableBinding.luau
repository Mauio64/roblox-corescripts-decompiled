local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)

require(ParentParent.Observable)

return function(p1) -- line: 9
	-- upvalues: React (copy)
	local v4, v5 = React.useBinding(p1:get())

	React.useEffect(function() -- line: 11
		-- upvalues: p1 (copy), v5 (copy)
		local v6 = p1:connect(function() -- line: 12
			-- upvalues: v5 (copy), p1 (copy)
			v5(p1:get())
		end, true)

		return function() -- line: 16
			-- upvalues: v6 (copy)
			v6:disconnect()
		end
	end, { p1 })

	return v4
end
