local ok = pcall(function() -- line: 1
	return Enum.AvatarAssetType.EyeMakeup, Enum.MakeupType.Eye
end)
local FFlagAXMigrateSlotsSignals = require(script.Parent.FFlagAXMigrateSlotsSignals)

return ok and (game:DefineFastFlag("AXCustomizeMakeupSupport4", false) and FFlagAXMigrateSlotsSignals)
