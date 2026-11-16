local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent

local React = require(parent.React)
require(parent.Signals)

local useStableSignal = require(script.Parent.useStableSignal)

local function usePropSignal(p)
	local v, v2 = useStableSignal(p)
	React.useEffect(function()
		if v(false) ~= p then
			v2(p)
		end
	end, { p, v, v2 })
	return v
end

return usePropSignal
