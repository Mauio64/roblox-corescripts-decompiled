local Modules = game:GetService("CoreGui").RobloxGui.Modules
local FFlagLuaAppRemoveSeeAllDropdownIXP = require(Modules.Personalization.Flags.FFlagLuaAppRemoveSeeAllDropdownIXP)

return game:DefineFastFlag("LuaAppRemoveSeeAllDropdown", false) or FFlagLuaAppRemoveSeeAllDropdownIXP
