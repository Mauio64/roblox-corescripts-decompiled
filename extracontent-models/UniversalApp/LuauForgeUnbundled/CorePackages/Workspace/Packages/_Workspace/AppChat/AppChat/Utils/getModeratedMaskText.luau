local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local fIntFriendsChatModeratedMaskMinLength = SharedFlags.FIntFriendsChatModeratedMaskMinLength
local fIntFriendsChatModeratedMaskMaxLength = SharedFlags.FIntFriendsChatModeratedMaskMaxLength

local function getModeratedMaskText(value)
	local v5 = fIntFriendsChatModeratedMaskMaxLength - fIntFriendsChatModeratedMaskMinLength + 1

	return string.rep("#", fIntFriendsChatModeratedMaskMinLength + string.byte(value, #value) % v5)
end

return getModeratedMaskText
