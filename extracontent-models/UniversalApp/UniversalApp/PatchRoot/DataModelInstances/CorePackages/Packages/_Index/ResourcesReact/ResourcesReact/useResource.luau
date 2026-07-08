local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)

require(ParentParent.Resources)

local function useResource(p1) -- line: 6
	-- upvalues: React (copy)
	local v5, v6 = React.useState(function() -- line: 7
		return nil
	end)

	React.useLayoutEffect(function() -- line: 11
		-- upvalues: p1 (copy), v6 (copy)
		local v7, v8 = p1()

		v6(v8)

		return function() -- line: 14
			-- upvalues: v6 (copy), v7 (copy)
			v6(nil)
			v7()
		end
	end, { p1 })

	return v5
end

return useResource
