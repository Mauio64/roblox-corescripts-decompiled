local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local useCurrentSquadId = require(SquadsCore.Hooks.useCurrentSquadId)

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local usePrevious = RoactUtils.Hooks.usePrevious

return function(callback)
	local v = useCurrentSquadId() or ""
	local v2 = usePrevious(v) or ""
	React.useEffect(function()
		if v ~= v2 and v2 ~= "" and callback then
			callback()
		end
	end, { v, callback })
end
