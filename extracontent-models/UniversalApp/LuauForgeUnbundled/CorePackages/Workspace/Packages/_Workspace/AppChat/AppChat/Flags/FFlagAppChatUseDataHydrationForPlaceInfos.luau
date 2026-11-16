local fFlagShareTargetGameCleanup = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagShareTargetGameCleanup

return game:DefineFastFlag("AppChatUseDataHydrationForPlaceInfos", false) and fFlagShareTargetGameCleanup
