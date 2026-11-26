local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")

local EditChatGroupNameDialogContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/EditChatGroupNameDialog/EditChatGroupNameDialogContainer")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/EditChatGroupNameDialog/Logger")

local extended = Roact.PureComponent:extend("EditChatGroupNameDialogScreen")
extended.defaultProps = { navigation = nil }

function extended:init()
	function self.onEditChatGroupNameDialogClose()
		self.props.navigation.goBack()
	end
end

function extended.render(p2)
	local navigation = p2.props.navigation
	assert(
		type(navigation) ~= "nil",
		"EditChatGroupNameDialogScreen should be wrapped with Roact Navigation"
	)

	local param = navigation.getParam("conversationId", nil)

	if param ~= nil then
		return Roact.createElement(EditChatGroupNameDialogContainer, {
			conversationId = param,
			onModalClose = p2.onEditChatGroupNameDialogClose
		})
	end

	Logger:warning("ConversationId is required to open {screen}")
	return nil
end

function extended.didMount(p2)
	Logger:info("{screen} mounted")
end

return extended
