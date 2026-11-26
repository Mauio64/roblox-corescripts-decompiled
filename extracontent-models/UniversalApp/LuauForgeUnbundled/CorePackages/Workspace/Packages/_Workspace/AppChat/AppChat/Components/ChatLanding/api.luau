local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

return {
	ConversationListViewRecycler = function(p2)
		local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationListViewRecycler")

		return React.createElement(module2, p2)
	end,
	ConversationRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationRow")
}
