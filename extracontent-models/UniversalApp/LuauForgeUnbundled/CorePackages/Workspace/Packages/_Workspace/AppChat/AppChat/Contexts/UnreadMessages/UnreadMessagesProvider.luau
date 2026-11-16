local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local UnreadMessagesDispatchContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/UnreadMessages/UnreadMessagesDispatchContext")

local function UnreadMessagesProvider(p2)
	return React.createElement(UnreadMessagesDispatchContext.Provider, { value = p2.dispatch }, p2.children)
end

return UnreadMessagesProvider
