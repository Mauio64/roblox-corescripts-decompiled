local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Rodux")

require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Enums/ChatEntryPointNames")

return Rodux.makeActionCreator("EnteredChatFromEntryPoint", function(p2)
	return { entryPoint = p2 }
end)
