local v1 = game:DefineFastFlag("EnableChatNewMessage", false)
local GetFFlagEnableAppChatInExperience = require(script.Parent.GetFFlagEnableAppChatInExperience)

return function() -- line: 5
	-- upvalues: v1 (copy), GetFFlagEnableAppChatInExperience (copy)
	return v1 and GetFFlagEnableAppChatInExperience()
end
