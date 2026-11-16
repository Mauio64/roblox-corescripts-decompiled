local FFlagAppChatEnableAutotranslation = require(script.Parent.FFlagAppChatEnableAutotranslation)

game:DefineFastFlag("AppChatEnableManualTranslation", false)

return function()
	return game:GetFastFlag("AppChatEnableManualTranslation") and FFlagAppChatEnableAutotranslation
end
