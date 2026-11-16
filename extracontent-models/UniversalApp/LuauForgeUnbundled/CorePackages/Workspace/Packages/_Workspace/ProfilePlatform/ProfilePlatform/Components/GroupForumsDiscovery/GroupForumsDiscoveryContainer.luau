local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local GroupPeekSduiSection = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/GroupPeekSduiSection")

local function GroupForumsDiscoveryContainer(p2)
	return React.createElement(GroupPeekSduiSection, {
		layoutOrder = p2.layoutOrder,
		section = Enums.Components.GroupForumsDiscovery
	})
end

return React.memo(GroupForumsDiscoveryContainer)
