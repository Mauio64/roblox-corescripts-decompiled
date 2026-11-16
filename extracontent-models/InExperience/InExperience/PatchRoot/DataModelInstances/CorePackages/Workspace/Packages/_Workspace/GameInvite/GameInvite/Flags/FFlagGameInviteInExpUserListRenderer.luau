local parent = script:FindFirstAncestor("GameInvite").Parent

local SharedFlags = require(parent.SharedFlags)

return game:DefineFastFlag("GameInviteInExpUserListRenderer_v3", false) and SharedFlags.FFlagUserListSurfaceExtensions
