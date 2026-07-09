local Parent = script:FindFirstAncestor("RobloxAppHooks").Parent
local React = require(Parent.React)
local RoactServicesContext = require(Parent.RoactServices).RoactServicesContext

local function useRoactService(p1) -- line: 23
	-- upvalues: React (copy), RoactServicesContext (copy)
	local v6 = React.useContext(RoactServicesContext)

	return (p1.get(v6))
end

return useRoactService
