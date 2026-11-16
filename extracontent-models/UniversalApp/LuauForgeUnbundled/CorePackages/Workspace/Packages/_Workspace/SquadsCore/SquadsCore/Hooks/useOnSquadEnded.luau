local useCurrentSquadId = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Hooks/useCurrentSquadId")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local usePrevious = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.usePrevious

return function(callback)
	local v5 = useCurrentSquadId() or ""
	local v6 = usePrevious(v5) or ""
	React.useEffect(function()
		if v5 ~= v6 and v6 ~= "" and callback then
			callback()
		end
	end, { v5, callback })
end
