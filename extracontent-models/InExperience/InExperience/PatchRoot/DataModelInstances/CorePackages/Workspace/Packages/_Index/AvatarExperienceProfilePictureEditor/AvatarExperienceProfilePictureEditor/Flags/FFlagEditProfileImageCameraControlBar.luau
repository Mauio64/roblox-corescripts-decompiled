local parent = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor").Parent

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXMigrateBuilderIcons = AvatarExperienceFlags.FFlagAXMigrateBuilderIcons

return game:DefineFastFlag("EditProfileImageCameraControlBar", false) and FFlagAXMigrateBuilderIcons
