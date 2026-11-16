local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

return {
	ConversationListUltimate = function(p2)
		local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationListUltimate")

		return React.createElement(module2, p2)
	end,
	ConversationRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ConversationRow"),
	logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/Logger"),
	screenComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatLanding/ChatLandingScreen")
}
