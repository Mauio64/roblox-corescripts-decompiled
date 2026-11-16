local parent = script:FindFirstAncestor("AvatarExperienceFlags").Parent
local SharedFlags = require(parent.SharedFlags)
return SharedFlags.FFlagEnableInspectAndBuyV2RootFlag and game:DefineFastFlag("AXEnableBatchItemDetailsFetchV2", false)
