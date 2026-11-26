local receivedCanShowUserAlias = require("@luauforge/deferred/hnP").Actions.ReceivedCanShowUserAlias

return function(callback)
	return {
		receivedCanShowUserAlias = function(p2)
			callback(receivedCanShowUserAlias(p2))
		end
	}
end
