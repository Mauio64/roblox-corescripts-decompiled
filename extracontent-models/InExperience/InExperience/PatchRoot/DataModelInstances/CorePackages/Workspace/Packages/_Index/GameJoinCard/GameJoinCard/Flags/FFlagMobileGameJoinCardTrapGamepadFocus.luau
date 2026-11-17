local parent = script:FindFirstAncestor("GameJoinCard").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagMobileGameJoinCardGamepadSupport = SharedFlags.FFlagMobileGameJoinCardGamepadSupport

return game:DefineFastFlag("MobileGameJoinCardTrapGamepadFocus", false) and FFlagMobileGameJoinCardGamepadSupport
