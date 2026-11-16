local parent = script:FindFirstAncestor("AppChat").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagShareTargetGameCleanup = SharedFlags.FFlagShareTargetGameCleanup

return game:DefineFastFlag("AppChatUseDataHydrationForPlaceInfos", false) and FFlagShareTargetGameCleanup
