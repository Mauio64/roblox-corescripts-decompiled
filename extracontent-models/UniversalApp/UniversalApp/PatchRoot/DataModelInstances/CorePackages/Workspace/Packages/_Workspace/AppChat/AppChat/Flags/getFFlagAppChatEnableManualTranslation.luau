local FFlagAppChatEnableAutotranslation = require(script.Parent.FFlagAppChatEnableAutotranslation)

game:DefineFastFlag("AppChatEnableManualTranslation", false)

return function() -- line: 5
	-- upvalues: FFlagAppChatEnableAutotranslation (copy)
	return game:GetFastFlag("AppChatEnableManualTranslation") and FFlagAppChatEnableAutotranslation
end
