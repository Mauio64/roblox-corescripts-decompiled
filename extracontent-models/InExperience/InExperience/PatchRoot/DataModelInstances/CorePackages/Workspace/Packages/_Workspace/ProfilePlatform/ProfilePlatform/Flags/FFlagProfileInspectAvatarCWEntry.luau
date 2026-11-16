local parent = script:FindFirstAncestor("ProfilePlatform").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSocialEnableProfileInspectAndBuy = SharedFlags.FFlagSocialEnableProfileInspectAndBuy

return game:DefineFastFlag("ProfileInspectAvatarCWEntry_v2", false) and FFlagSocialEnableProfileInspectAndBuy
