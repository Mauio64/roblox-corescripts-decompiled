local react = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies").React

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UniversalAppPolicy").useAppPolicy

return function(p2)
	local v5 = react.useContext(squadExternalContractContext).useParentChannelHasSquadAccess(p2.parentChannelId)

	if useAppPolicy(function(p3)
		return p3.getCanAccessParty()
	end) and v5 then
		return p2.children
	end

	return nil
end
