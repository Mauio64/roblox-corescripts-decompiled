local ParentParent = script.Parent.Parent
local React = require(ParentParent.React)

local function useEventLifecycleRef(p1: ((...any) -> ...any), p2: ((...any) -> ...any)?) -- line: 8
	-- upvalues: React (copy)
	local v6 = React.useRef(nil)

	return (React.useCallback(function(p3) -- line: 10
		-- upvalues: v6 (copy), p2 (copy), p1 (copy)
		if v6.current and p2 then
			p2(v6.current)
		end

		if p3 then
			p1(p3)
		end

		v6.current = p3
	end, {
		p1,
		p2
	}))
end

return useEventLifecycleRef
