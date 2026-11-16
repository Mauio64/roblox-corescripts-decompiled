local parent = script:FindFirstAncestor("AvatarExperienceFlags").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsCreateAvatarPosts = SharedFlags.FFlagMomentsCreateAvatarPosts

return game:DefineFastFlag("AXAvatarMomentsCreation", false) and FFlagMomentsCreateAvatarPosts
