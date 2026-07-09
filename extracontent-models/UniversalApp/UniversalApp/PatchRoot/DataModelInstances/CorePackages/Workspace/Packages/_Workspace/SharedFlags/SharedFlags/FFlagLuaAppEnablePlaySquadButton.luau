local GetFFlagIsSquadEnabled = require(script.Parent.GetFFlagIsSquadEnabled)

game:SetFlagVersion("LuaAppEnablePlaySquadButton", 3)

return GetFFlagIsSquadEnabled() and game:DefineFastFlag("LuaAppEnablePlaySquadButton", false)
