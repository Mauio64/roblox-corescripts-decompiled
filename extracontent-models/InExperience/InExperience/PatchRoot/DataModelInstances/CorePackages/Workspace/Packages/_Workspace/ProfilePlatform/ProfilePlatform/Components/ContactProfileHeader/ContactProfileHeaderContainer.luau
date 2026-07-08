local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Enums = require(ProfilePlatform.Common.Enums)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local ContactProfileHeader = require(ProfilePlatform.Components.ContactProfileHeader.ContactProfileHeader)

local function ContactProfileHeaderContainer(t1: {[any]: any}) -- line: 18
	-- upvalues: useProfileJsonComponent (copy), Enums (copy), React (copy), ContactProfileHeader (copy)
	local v9 = useProfileJsonComponent(Enums.Components.ContactProfileHeader)
	local contactName = v9.contactName
	local avatarThumbnailUrl = v9.avatarThumbnailUrl

	return React.createElement(ContactProfileHeader, {
		layoutOrder = t1.layoutOrder,
		contactName = contactName,
		avatarThumbnailUrl = avatarThumbnailUrl
	})
end

return ContactProfileHeaderContainer
