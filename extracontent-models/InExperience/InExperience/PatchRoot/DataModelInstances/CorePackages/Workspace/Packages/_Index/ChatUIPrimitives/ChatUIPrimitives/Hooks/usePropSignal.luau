local Parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(Parent.React)

require(Parent.Signals)

local useStableSignal = require(script.Parent.useStableSignal)

local function usePropSignal(p1) -- line: 25
	-- upvalues: useStableSignal (copy), React (copy)
	local v6, v7 = useStableSignal(p1)

	React.useEffect(function() -- line: 27
		-- upvalues: v6 (copy), p1 (copy), v7 (copy)
		if v6(false) ~= p1 then
			v7(p1)
		end
	end, {
		p1,
		v6,
		v7
	})

	return v6
end

return usePropSignal
