local CompleteExternalNavigationIntoChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/CompleteExternalNavigationIntoChat")

return function(callback)
	return {
		completeExternalNavigation = function(p2)
			callback(CompleteExternalNavigationIntoChat(p2))
		end
	}
end
