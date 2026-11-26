local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Cryo")
local useCurrentSquadSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoduxSquads").Hooks.useCurrentSquadSelector

function LUAUFORGE_MODULE_GLOBALS_bva_useCurrentSquadMember(p2)
	local v5 = useCurrentSquadSelector()
	local v6 = React.useMemo(function()
		if v5 then
			return v5.members
		end

		return {}
	end, { v5 })

	return (React.useMemo(function()
		local where = Cryo.List.findWhere(v6, function(p3): boolean
			return p3.userId == p2
		end)

		if where then
			return v6[where]
		end

		return nil
	end, { v6, p2 }))
end

return LUAUFORGE_MODULE_GLOBALS_bva_useCurrentSquadMember
