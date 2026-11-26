local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

return Rodux.makeActionCreator("DismissedChatModal", function(p2, p3)
	return { key = p3, modalSequence = p2 }
end)
