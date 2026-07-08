local ParentParent = script.Parent.Parent.Parent
local React = require(ParentParent.React)
local Signals = require(ParentParent.Signals)

require(ParentParent.CoreScriptsRoactCommon)

local function useSignalMapState(p1) -- line: 10
	-- upvalues: React (copy), Signals (copy)
	local v6, v7 = React.useState(p1)

	React.useLayoutEffect(function() -- line: 13
		-- upvalues: v7 (copy), p1 (copy), Signals (copy)
		v7(p1)

		return Signals.createEffect(function(p2) -- line: 15
			-- upvalues: p1 (copy), v7 (copy)
			p1.getCount(p2)
			v7(p1)
		end)
	end, { p1 })

	return v6
end

return useSignalMapState
