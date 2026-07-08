local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)
local createEffect = require(ParentParent.Signals).createEffect

local function useSignalBinding(p1) -- line: 9
	-- upvalues: React (copy), createEffect (copy)
	local v6, v7 = React.useBinding(p1(false))

	React.useLayoutEffect(function() -- line: 12
		-- upvalues: v7 (copy), p1 (copy), createEffect (copy)
		v7(p1(false))

		return createEffect(function(p2) -- line: 14
			-- upvalues: v7 (copy), p1 (copy)
			v7(p1(p2))
		end)
	end, { p1 })

	return v6
end

return useSignalBinding
