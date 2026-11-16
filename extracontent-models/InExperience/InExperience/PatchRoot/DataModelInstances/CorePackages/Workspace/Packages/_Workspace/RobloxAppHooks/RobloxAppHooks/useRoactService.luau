local parent = script:FindFirstAncestor("RobloxAppHooks").Parent
local React = require(parent.React)
local RoactServices = require(parent.RoactServices)
local RoactServicesContext = RoactServices.RoactServicesContext

local function useRoactService(p)
	local v = React.useContext(RoactServicesContext)

	return (p.get(v))
end

return useRoactService
