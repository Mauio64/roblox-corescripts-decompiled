local parent = script:FindFirstAncestor("AppChat").Parent
local React = require(parent.React)

local UnreadMessagesDispatchContext = require(script.Parent.UnreadMessagesDispatchContext)

local function useUnreadMessagesDispatch()
	return React.useContext(UnreadMessagesDispatchContext)
end

return useUnreadMessagesDispatch
