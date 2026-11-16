local CompleteExternalNavigationIntoChat = require(script.Parent.Parent.Parent.Actions.CompleteExternalNavigationIntoChat)

return function(callback)
	return {
		completeExternalNavigation = function(p)
			callback(CompleteExternalNavigationIntoChat(p))
		end
	}
end
