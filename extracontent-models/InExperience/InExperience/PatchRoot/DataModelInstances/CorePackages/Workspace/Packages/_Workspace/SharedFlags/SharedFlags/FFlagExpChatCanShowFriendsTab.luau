local GetFFlagEnableAppChatInExperience = require(script.Parent.GetFFlagEnableAppChatInExperience)
local FFlagExpChatEnableFriendsTab = require(script.Parent.FFlagExpChatEnableFriendsTab)

return game:DefineFastFlag("ExpChatCanShowFriendsTabRC1", false)
	and GetFFlagEnableAppChatInExperience()
	and FFlagExpChatEnableFriendsTab
