local AvatarExperienceNavigation = script:FindFirstAncestor("AvatarExperienceNavigation")

local AvatarScreen = require(AvatarExperienceNavigation.Enums.AvatarScreen)
local ClearScreens = require(AvatarExperienceNavigation.NavigationActions.ClearScreens)
require(AvatarExperienceNavigation.Types.NavigationType)

local function closeGiftSendFlow(p)
	p.dispatch(ClearScreens({ AvatarScreen.SendGiftRecipientPicker, AvatarScreen.SendGiftReview }))
end

return closeGiftSendFlow
