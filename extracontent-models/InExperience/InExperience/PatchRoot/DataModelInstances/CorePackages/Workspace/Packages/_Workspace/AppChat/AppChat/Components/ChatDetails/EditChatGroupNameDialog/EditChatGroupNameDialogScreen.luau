local parent = script:FindFirstAncestor("AppChat").Parent

local Roact = require(parent.Roact)

local EditChatGroupNameDialogContainer = require(script.Parent.EditChatGroupNameDialogContainer)
local Logger = require(script.Parent.Logger)

local extended = Roact.PureComponent:extend("EditChatGroupNameDialogScreen")
extended.defaultProps = { navigation = nil }

function extended:init()
	function self.onEditChatGroupNameDialogClose()
		self.props.navigation.goBack()
	end
end

function extended.render(p)
	local navigation = p.props.navigation
	assert(type(navigation) ~= "nil", "EditChatGroupNameDialogScreen should be wrapped with Roact Navigation")

	local param = navigation.getParam("conversationId", nil)

	if param ~= nil then
		return Roact.createElement(EditChatGroupNameDialogContainer, {
			conversationId = param,
			onModalClose = p.onEditChatGroupNameDialogClose
		})
	end

	Logger:warning("ConversationId is required to open {screen}")
	return nil
end

function extended.didMount(_)
	Logger:info("{screen} mounted")
end

return extended
