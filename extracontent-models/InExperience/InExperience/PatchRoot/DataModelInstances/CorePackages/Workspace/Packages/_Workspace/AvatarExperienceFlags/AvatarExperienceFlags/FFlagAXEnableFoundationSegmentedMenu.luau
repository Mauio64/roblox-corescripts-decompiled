local parent = script:FindFirstAncestor("AvatarExperienceFlags").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableMeTabProfile = SharedFlags.FFlagEnableMeTabProfile
return game:DefineFastFlag("AXEnableFoundationSegmentedMenu", false) or FFlagEnableMeTabProfile
