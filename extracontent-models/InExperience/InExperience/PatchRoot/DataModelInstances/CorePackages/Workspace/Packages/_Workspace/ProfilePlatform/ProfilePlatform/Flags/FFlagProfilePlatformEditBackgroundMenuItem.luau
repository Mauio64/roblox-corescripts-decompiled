local parent = script:FindFirstAncestor("ProfilePlatform").Parent
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXCustomizeBackgrounds = AvatarExperienceFlags.FFlagAXCustomizeBackgrounds

return game:DefineFastFlag("ProfilePlatformEditBackgroundMenuItem", false) and FFlagAXCustomizeBackgrounds
