local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)

local Enums = require(ProfilePlatform.Common.Enums)
local GroupPeekSduiSection = require(ProfilePlatform.Components.GroupPeekSduiSection)

local function AnnouncementsSduiContainer(p)
	return React.createElement(GroupPeekSduiSection, {
		layoutOrder = p.layoutOrder,
		section = Enums.Components.Announcements
	})
end

return React.memo(AnnouncementsSduiContainer)
