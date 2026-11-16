local FFlagSocialEnableProfileInspectAndBuy = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagSocialEnableProfileInspectAndBuy")
local FFlagProfileInspectAvatarSpin = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagProfileInspectAvatarSpin")

return game:DefineFastFlag("ProfileInspectAvatarSlideIn", false) and FFlagProfileInspectAvatarSpin and FFlagSocialEnableProfileInspectAndBuy
