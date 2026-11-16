local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

local function useStableSignal(p)
	local ref = React.useRef(nil)

	if ref.current == nil then
		local signal, set = Signals.createSignal(p)
		ref.current = { get = signal, set = set }
	end

	local current = ref.current
	return current.get, current.set
end

return useStableSignal
