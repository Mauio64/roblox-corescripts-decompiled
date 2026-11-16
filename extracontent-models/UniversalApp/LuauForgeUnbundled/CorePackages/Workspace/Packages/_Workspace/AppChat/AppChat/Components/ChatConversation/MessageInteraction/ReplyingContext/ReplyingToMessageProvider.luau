local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local ReplyingToMessageContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageInteraction/ReplyingContext/ReplyingToMessageContext")
local ReplyingToMessageDispatchContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageInteraction/ReplyingContext/ReplyingToMessageDispatchContext")

local function ReplyingToMessageProvider(p2)
	local state, setState = React.useState(nil)

	return React.createElement(ReplyingToMessageContext.Provider, { value = state }, {
		ReplyingToMessageDispatch = React.createElement(
			ReplyingToMessageDispatchContext.Provider,
			{ value = setState },
			p2.children
		)
	})
end

return ReplyingToMessageProvider
