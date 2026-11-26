local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local ContactProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ContactProfileHeader/ContactProfileHeader")

local function ContactProfileHeaderContainer(p2)
	local v5 = useProfileJsonComponent(Enums.Components.ContactProfileHeader)
	local contactName = v5.contactName
	local avatarThumbnailUrl = v5.avatarThumbnailUrl

	return React.createElement(ContactProfileHeader, {
		layoutOrder = p2.layoutOrder,
		contactName = contactName,
		avatarThumbnailUrl = avatarThumbnailUrl
	})
end

return ContactProfileHeaderContainer
