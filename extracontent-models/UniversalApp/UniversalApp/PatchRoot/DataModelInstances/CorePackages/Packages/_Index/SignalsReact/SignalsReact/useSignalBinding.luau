local parent = script.Parent.Parent
local React = require(parent.React)

local Signals = require(parent.Signals)
local createEffect = Signals.createEffect

local function useSignalBinding(callback)
	local v, v2 = React.useBinding(callback(false))

	React.useLayoutEffect(function()
		v2(callback(false))
		return createEffect(function(p)
			v2(callback(p))
		end)
	end, { callback })

	return v
end

return useSignalBinding
