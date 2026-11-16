local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)

local Enums = require(ProfilePlatform.Common.Enums)
local GroupPeekSduiSection = require(ProfilePlatform.Components.GroupPeekSduiSection)

local function GroupForumsDiscoveryContainer(p)
	return React.createElement(GroupPeekSduiSection, {
		layoutOrder = p.layoutOrder,
		section = Enums.Components.GroupForumsDiscovery
	})
end

return React.memo(GroupForumsDiscoveryContainer)
