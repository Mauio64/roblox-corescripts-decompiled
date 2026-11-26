local GetFFlagLuaAppEnableOpenTypeSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagLuaAppEnableOpenTypeSupport")

return game:DefineFastFlag("FFlagEnableFontStylisticAlternativesOnSocialScreens", false) and GetFFlagLuaAppEnableOpenTypeSupport()
