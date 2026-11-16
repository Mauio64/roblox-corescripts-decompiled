local FFlagAppChatEnableAutotranslation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatEnableAutotranslation")

game:DefineFastFlag("AppChatEnableManualTranslation", false)

return function()
	return game:GetFastFlag("AppChatEnableManualTranslation") and FFlagAppChatEnableAutotranslation
end
