local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")

local FFlagProfilePlatformAddCurrentlyPlaying = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformAddCurrentlyPlaying")

return function(p2): boolean
	local contextualInformation = (useProfileJsonComponent(Enums.Components.UserProfileHeader) or {}).contextualInformation
	local context = contextualInformation and contextualInformation.context

	if
		not context
		or context == "None"
		or context == Enums.ContextualTypes.Presence
		and (p2 == Enums.PresenceTypes.Online or p2 == Enums.PresenceTypes.Offline)
		or FFlagProfilePlatformAddCurrentlyPlaying and p2 == Enums.PresenceTypes.InGame and context == Enums.ContextualTypes.Presence
	then
		return false
	end

	return true
end
