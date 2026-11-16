local GetFFlagEnableAppChatInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableAppChatInExperience")
local FFlagExpChatEnableFriendsTab = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagExpChatEnableFriendsTab")

return game:DefineFastFlag("ExpChatCanShowFriendsTabRC1", false) and GetFFlagEnableAppChatInExperience() and FFlagExpChatEnableFriendsTab
