local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local FFlagAXCustomizeBackgrounds = require(Parent.AvatarExperienceFlags).FFlagAXCustomizeBackgrounds

return game:DefineFastFlag("ProfilePlatformEditBackgroundMenuItem", false) and FFlagAXCustomizeBackgrounds
