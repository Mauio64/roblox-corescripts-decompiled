local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local getStandardSizeAvatarHeadShotRbxthumb = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserLib").Utils.getStandardSizeAvatarHeadShotRbxthumb
local FFlagAppChatUseProfileFrameThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseProfileFrameThumbnail")

return function(p2)
	return Cryo.List.map(p2, function(p3)
		return getStandardSizeAvatarHeadShotRbxthumb(tostring(p3), FFlagAppChatUseProfileFrameThumbnail)
	end)
end
