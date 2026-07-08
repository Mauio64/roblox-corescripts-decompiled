local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local FFlagProfilePlatformNewProfileHeader = require(Parent.SharedFlags).FFlagProfilePlatformNewProfileHeader

return game:DefineFastFlag("ProfilePlatformAboutBeforeActionClient", false) and FFlagProfilePlatformNewProfileHeader
