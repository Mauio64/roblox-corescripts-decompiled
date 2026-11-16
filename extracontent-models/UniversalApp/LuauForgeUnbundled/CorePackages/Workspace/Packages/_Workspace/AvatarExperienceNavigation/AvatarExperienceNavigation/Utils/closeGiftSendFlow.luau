local AvatarScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/Enums/AvatarScreen")
local ClearScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/NavigationActions/ClearScreens")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/Types/NavigationType")

local function closeGiftSendFlow(p2)
	p2.dispatch(ClearScreens({ AvatarScreen.SendGiftRecipientPicker, AvatarScreen.SendGiftReview }))
end

return closeGiftSendFlow
