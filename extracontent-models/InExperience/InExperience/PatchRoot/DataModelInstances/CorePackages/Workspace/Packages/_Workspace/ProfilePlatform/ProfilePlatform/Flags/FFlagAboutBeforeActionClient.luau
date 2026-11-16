local parent = script:FindFirstAncestor("ProfilePlatform").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader

return game:DefineFastFlag("ProfilePlatformAboutBeforeActionClient", false) and FFlagProfilePlatformNewProfileHeader
