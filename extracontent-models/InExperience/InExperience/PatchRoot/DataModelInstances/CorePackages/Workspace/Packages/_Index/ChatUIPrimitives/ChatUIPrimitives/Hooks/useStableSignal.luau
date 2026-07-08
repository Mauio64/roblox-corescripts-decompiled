local Parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)

local function useStableSignal(p1) -- line: 21
	-- upvalues: React (copy), Signals (copy)
	local v6 = React.useRef(nil)

	if v6.current == nil then
		local v7, v8 = Signals.createSignal(p1)

		v6.current = {
			get = v7,
			set = v8
		}
	end

	local current = v6.current

	return current.get, current.set
end

return useStableSignal
