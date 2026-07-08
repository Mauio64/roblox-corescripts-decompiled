local scriptParent = script.Parent
local FFlagLuaAppEnableWhyThisAdModal = require(scriptParent.FFlagLuaAppEnableWhyThisAdModal)

return game:DefineFastFlag("LuaAppEnableSponsoredReportAd3", false) and FFlagLuaAppEnableWhyThisAdModal
