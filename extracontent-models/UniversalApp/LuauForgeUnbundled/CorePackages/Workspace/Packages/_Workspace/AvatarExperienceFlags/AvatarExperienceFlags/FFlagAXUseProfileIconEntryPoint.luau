local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceFlags/SharedFlags")
local fFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab
local fFlagAXPPEReturnToEntrySurface = SharedFlags.FFlagAXPPEReturnToEntrySurface

return game:DefineFastFlag("AXUseProfileIconEntryPoint", false)
	and fFlagAXEnableProfileTab
	and fFlagAXPPEReturnToEntrySurface
