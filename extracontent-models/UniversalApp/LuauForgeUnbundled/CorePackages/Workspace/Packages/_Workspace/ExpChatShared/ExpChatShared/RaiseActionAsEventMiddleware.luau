local ActionBindableEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/ExpChatShared/ActionBindableEvent")

return function(callback, p2)
	return function(p3)
		ActionBindableEvent:Fire(p3)
		callback(p3)
	end
end
