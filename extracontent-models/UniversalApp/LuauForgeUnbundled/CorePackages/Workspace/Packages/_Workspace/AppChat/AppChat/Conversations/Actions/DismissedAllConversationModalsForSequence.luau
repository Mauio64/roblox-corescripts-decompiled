local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

return Rodux.makeActionCreator("DismissedAllConversationModalsForSequence", function(p2)
	return { modalSequence = p2 }
end)
