local GetFFlagEnableAppChatInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableAppChatInExperience")

return game:DefineFastFlag("ExpChatCanShowFriendsTabRC1", false) and GetFFlagEnableAppChatInExperience()
