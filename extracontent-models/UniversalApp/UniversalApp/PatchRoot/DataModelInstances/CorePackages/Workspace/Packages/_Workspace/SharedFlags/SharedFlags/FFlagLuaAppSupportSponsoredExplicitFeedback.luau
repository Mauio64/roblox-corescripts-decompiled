local scriptParent = script.Parent
local FFlagLuaAppEnableWhyThisAdModal = require(scriptParent.FFlagLuaAppEnableWhyThisAdModal)

return game:DefineFastFlag("LuaAppSupportSponsoredExplicitFeedback2", false) and FFlagLuaAppEnableWhyThisAdModal
