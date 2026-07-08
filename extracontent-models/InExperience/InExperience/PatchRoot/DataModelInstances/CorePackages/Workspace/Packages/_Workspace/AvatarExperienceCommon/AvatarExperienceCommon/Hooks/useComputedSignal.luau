local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(Parent.React)
local Signals = require(Parent.Signals)

local function useComputedSignal(p1: ((...any) -> ...any), p2: ((...any) -> ...any)?) -- line: 13
	-- upvalues: React (copy), Signals (copy)
	return (React.useMemo(function() -- line: 14
		-- upvalues: Signals (copy), p1 (copy), p2 (copy)
		return Signals.createComputed(p1, p2)
	end, {}))
end

return useComputedSignal
