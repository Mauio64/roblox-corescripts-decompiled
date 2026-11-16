local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local UnreadMessagesDispatchContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/UnreadMessages/UnreadMessagesDispatchContext")

local function useUnreadMessagesDispatch()
	return React.useContext(UnreadMessagesDispatchContext)
end

return useUnreadMessagesDispatch
