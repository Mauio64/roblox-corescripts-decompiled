local Parent = script:FindFirstAncestor("AvatarExperienceFlags").Parent
local FFlagEnableMeTabProfile = require(Parent.SharedFlags).FFlagEnableMeTabProfile

return game:DefineFastFlag("AXEnableFoundationSegmentedMenu", false) or FFlagEnableMeTabProfile
