local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local UserLib = require(parent.UserLib)
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb
local FFlagAppChatUseProfileFrameThumbnail = require(AppChat.Flags.FFlagAppChatUseProfileFrameThumbnail)

return function(p)
	return Cryo.List.map(p, function(p2)
		return getStandardSizeAvatarHeadShotRbxthumb(tostring(p2), FFlagAppChatUseProfileFrameThumbnail)
	end)
end
