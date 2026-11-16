local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

local function useComputedSignal(callback, callback2)
	return (React.useMemo(function()
		return Signals.createComputed(callback, callback2)
	end, {}))
end

return useComputedSignal
