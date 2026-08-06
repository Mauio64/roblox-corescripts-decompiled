local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local FFlagSocialEnableProfileInspectAndBuy = require(Parent.SharedFlags).FFlagSocialEnableProfileInspectAndBuy

return game:DefineFastFlag("ProfileInspectAvatarCWEntry", false) and FFlagSocialEnableProfileInspectAndBuy
