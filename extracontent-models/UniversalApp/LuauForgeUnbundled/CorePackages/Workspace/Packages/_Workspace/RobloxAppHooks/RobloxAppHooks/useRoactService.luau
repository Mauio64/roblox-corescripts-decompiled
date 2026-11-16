local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/React")
local roactServicesContext = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppHooks/RoactServices").RoactServicesContext

local function useRoactService(p2)
	local v5 = React.useContext(roactServicesContext)

	return p2.get(v5)
end

return useRoactService
