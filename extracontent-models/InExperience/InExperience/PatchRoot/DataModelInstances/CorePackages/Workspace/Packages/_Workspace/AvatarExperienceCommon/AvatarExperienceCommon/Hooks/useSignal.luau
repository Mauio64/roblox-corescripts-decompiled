local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)

local function useSignal(p1, p2: ((...any) -> ...any)?) -- line: 13
	-- upvalues: React (copy), Signals (copy)
	local v7, v8 = React.useMemo(function() -- line: 14
		-- upvalues: Signals (copy), p1 (copy), p2 (copy)
		return Signals.createSignal(p1, p2)
	end, {})

	return v7, v8
end

return useSignal
