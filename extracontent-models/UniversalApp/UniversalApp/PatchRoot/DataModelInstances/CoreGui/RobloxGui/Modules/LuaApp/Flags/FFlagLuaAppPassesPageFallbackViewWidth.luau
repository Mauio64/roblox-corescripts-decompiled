local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GetFFlagEnableEdpStoreGridPositionLogging = require(Modules.LuaApp.Flags.GetFFlagEnableEdpStoreGridPositionLogging)

return game:DefineFastFlag("LuaAppPassesPageFallbackViewWidth", false) and GetFFlagEnableEdpStoreGridPositionLogging()
