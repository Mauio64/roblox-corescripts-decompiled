local Parent = script:FindFirstAncestor("RobloxAppNavigationCore").Parent

require(Parent.AppCommonLib)

local React = require(Parent.React)
local useDispatch = require(Parent.RoactUtils).Hooks.RoactRodux.useDispatch

require(Parent.Navigation)

local function useProcessNavigationStateChange(p1, p2: ((...any) -> ...any)?) -- line: 13
	-- upvalues: useDispatch (copy), React (copy)
	local v7 = useDispatch()

	return (React.useCallback(function(_, p4, _) -- line: 16
		-- upvalues: p2 (copy), v7 (copy), p1 (copy)
		if p2 then
			p2(p4)
		end

		v7(p1(p4))
	end, {
		v7,
		p1,
		p2
	}))
end

return useProcessNavigationStateChange
