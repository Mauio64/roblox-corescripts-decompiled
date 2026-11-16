local defineFastFlag = game:DefineFastFlag("EnableChatNewMessage", false)
local GetFFlagEnableAppChatInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagEnableAppChatInExperience")

return function()
	return defineFastFlag and GetFFlagEnableAppChatInExperience()
end
