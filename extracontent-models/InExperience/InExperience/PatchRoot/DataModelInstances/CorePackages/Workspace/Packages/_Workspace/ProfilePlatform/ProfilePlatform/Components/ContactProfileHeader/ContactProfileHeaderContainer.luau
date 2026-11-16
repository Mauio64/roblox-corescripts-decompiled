local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local Enums = require(ProfilePlatform.Common.Enums)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local ContactProfileHeader = require(ProfilePlatform.Components.ContactProfileHeader.ContactProfileHeader)

local function ContactProfileHeaderContainer(p)
	local v = useProfileJsonComponent(Enums.Components.ContactProfileHeader)
	local contactName = v.contactName
	local avatarThumbnailUrl = v.avatarThumbnailUrl

	return React.createElement(ContactProfileHeader, {
		layoutOrder = p.layoutOrder,
		contactName = contactName,
		avatarThumbnailUrl = avatarThumbnailUrl
	})
end

return ContactProfileHeaderContainer
