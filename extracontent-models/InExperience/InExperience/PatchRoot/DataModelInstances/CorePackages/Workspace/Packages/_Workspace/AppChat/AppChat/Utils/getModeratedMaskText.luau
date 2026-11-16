local parent = script:FindFirstAncestor("AppChat").Parent

local SharedFlags = require(parent.SharedFlags)
local FIntFriendsChatModeratedMaskMinLength = SharedFlags.FIntFriendsChatModeratedMaskMinLength
local FIntFriendsChatModeratedMaskMaxLength = SharedFlags.FIntFriendsChatModeratedMaskMaxLength

local function getModeratedMaskText(value: string)
	local v = FIntFriendsChatModeratedMaskMaxLength - FIntFriendsChatModeratedMaskMinLength + 1

	return string.rep("#", FIntFriendsChatModeratedMaskMinLength + string.byte(value, #value) % v)
end

return getModeratedMaskText
