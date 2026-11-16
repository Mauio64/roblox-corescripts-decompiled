local parent = script:FindFirstAncestor("AvatarExperienceFlags").Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local FFlagAXPPEReturnToEntrySurface = SharedFlags.FFlagAXPPEReturnToEntrySurface

return game:DefineFastFlag("AXUseProfileIconEntryPoint", false)
	and FFlagAXEnableProfileTab
	and FFlagAXPPEReturnToEntrySurface
