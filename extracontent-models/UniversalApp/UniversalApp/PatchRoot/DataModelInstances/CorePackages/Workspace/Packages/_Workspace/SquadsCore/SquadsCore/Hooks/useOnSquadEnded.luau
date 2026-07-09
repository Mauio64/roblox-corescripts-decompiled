local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local useCurrentSquadId = require(SquadsCore.Hooks.useCurrentSquadId)
local React = require(SquadsCoreParent.React)
local usePrevious = require(SquadsCoreParent.RoactUtils).Hooks.usePrevious

return function(p1: ((...any) -> ...any)?) -- line: 9
	-- upvalues: useCurrentSquadId (copy), usePrevious (copy), React (copy)
	local v7 = useCurrentSquadId() or ""
	local v8 = usePrevious(v7) or ""

	React.useEffect(function() -- line: 12
		-- upvalues: v7 (copy), v8 (copy), p1 (copy)
		if v7 ~= v8 and (v8 ~= "" and p1) then
			p1()
		end
	end, {
		v7,
		p1
	})
end
