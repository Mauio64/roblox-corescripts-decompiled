local parent = script.Parent.Parent.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

local function useLegacyVisibilityMirror(flag: boolean)
	local v, v2 = React.useMemo(function()
		return Signals.createSignal(flag)
	end, {})

	React.useEffect(function()
		v2(flag)
	end, { flag })

	return v
end

return useLegacyVisibilityMirror
