local parent = script.Parent.Parent.Parent
local React = require(parent.React)
local useEffect = React.useEffect

function usePingLazyRenderResizing(p, p2)
	useEffect(function()
		if p.current then
			local _absoluteSize = p.current.AbsoluteSize
		end
	end, { p2 })
end

return usePingLazyRenderResizing
