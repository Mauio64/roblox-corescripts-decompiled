local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

local function useSignal(p, callback)
	local v, v2 = React.useMemo(function()
		return Signals.createSignal(p, callback)
	end, {})
	return v, v2
end

return useSignal
