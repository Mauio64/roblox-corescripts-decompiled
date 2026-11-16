local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

return Rodux.makeActionCreator("ConversationModerationTypeChanged", function(p2, p3)
	return { conversationId = p2, moderationType = p3 }
end)
