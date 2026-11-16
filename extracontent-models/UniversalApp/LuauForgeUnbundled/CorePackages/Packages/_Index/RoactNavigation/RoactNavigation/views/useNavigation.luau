local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/RoactNavigation")

local function useNavigation()
	return React.useContext(RoactNavigation.Context)
end

return useNavigation
