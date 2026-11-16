local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")

local Enums = require(ProfilePlatform.Common.Enums)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)

local FFlagProfilePlatformAddCurrentlyPlaying = require(ProfilePlatform.Flags.FFlagProfilePlatformAddCurrentlyPlaying)

return function(p: string?): boolean
	local contextualInformation = (useProfileJsonComponent(Enums.Components.UserProfileHeader) or {}).contextualInformation
	local context = contextualInformation and contextualInformation.context

	if
		not context
		or context == "None"
		or context == Enums.ContextualTypes.Presence
		and (p == Enums.PresenceTypes.Online or p == Enums.PresenceTypes.Offline)
		or FFlagProfilePlatformAddCurrentlyPlaying
		and p == Enums.PresenceTypes.InGame
		and context == Enums.ContextualTypes.Presence
	then
		return false
	end

	return true
end
