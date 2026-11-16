local defineFastFlag = game:DefineFastFlag("EnableChatNewMessage", false)
local GetFFlagEnableAppChatInExperience = require(script.Parent.GetFFlagEnableAppChatInExperience)

return function()
	return defineFastFlag and GetFFlagEnableAppChatInExperience()
end
