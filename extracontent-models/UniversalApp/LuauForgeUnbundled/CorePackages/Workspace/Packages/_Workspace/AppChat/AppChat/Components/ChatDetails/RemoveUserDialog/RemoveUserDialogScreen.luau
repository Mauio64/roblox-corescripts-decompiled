local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")

local RemoveUserDialogContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/RemoveUserDialog/RemoveUserDialogContainer")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/RemoveUserDialog/Logger")

local extended = Roact.PureComponent:extend("RemoveUserDialog")
extended.defaultProps = { navigation = nil }

function extended:init()
	function self.onRemoveUserDialogClose()
		self.props.navigation.goBack()
	end
end

function extended.render(p2)
	local navigation = p2.props.navigation
	assert(type(navigation) ~= "nil", "RemoveUserDialog should be wrapped with Roact Navigation")

	local param = navigation.getParam("conversationId", nil)
	local param2 = navigation.getParam("participantId", nil)

	if param ~= nil and param2 ~= nil then
		return Roact.createElement(RemoveUserDialogContainer, {
			conversationId = param,
			participantId = param2,
			onModalClose = p2.onRemoveUserDialogClose
		})
	end

	Logger:warning("ConversationId and participantId are required to open {screen}")
	return nil
end

function extended.didMount(p2)
	Logger:info("{screen} mounted")
end

return extended
