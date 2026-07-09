local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local Enums = require(ProfilePlatform.Common.Enums)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local FFlagProfilePlatformAddCurrentlyPlaying = require(ProfilePlatform.Flags.FFlagProfilePlatformAddCurrentlyPlaying)

return function(s1: string?) -- line: 8
	-- upvalues: useProfileJsonComponent (copy), Enums (copy), FFlagProfilePlatformAddCurrentlyPlaying (copy)
	local contextualInformation = (useProfileJsonComponent(Enums.Components.UserProfileHeader) or {}).contextualInformation
	local v7 = contextualInformation and contextualInformation.context

	if not v7 or v7 == "None" then
		return false
	end

	if v7 == Enums.ContextualTypes.Presence and (s1 == Enums.PresenceTypes.Online or s1 == Enums.PresenceTypes.Offline) then
		return false
	end

	if FFlagProfilePlatformAddCurrentlyPlaying and s1 == Enums.PresenceTypes.InGame and v7 == Enums.ContextualTypes.Presence then
		return false
	end

	return true
end
