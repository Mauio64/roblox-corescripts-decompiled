local ParentParent = script.Parent.Parent.Parent
local useEffect = require(ParentParent.React).useEffect

function usePingLazyRenderResizing(p1, p2) -- line: 6
	-- upvalues: useEffect (copy)
	useEffect(function() -- line: 7
		-- upvalues: p1 (copy)
		if p1.current then
			local _ = p1.current.AbsoluteSize
		end
	end, { p2 })
end

return usePingLazyRenderResizing
