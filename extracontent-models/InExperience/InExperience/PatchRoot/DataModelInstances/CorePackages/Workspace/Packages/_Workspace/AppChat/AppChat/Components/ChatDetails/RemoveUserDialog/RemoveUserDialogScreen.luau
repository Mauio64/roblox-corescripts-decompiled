local parent = script:FindFirstAncestor("AppChat").Parent

local Roact = require(parent.Roact)

local RemoveUserDialogContainer = require(script.Parent.RemoveUserDialogContainer)
local Logger = require(script.Parent.Logger)

local extended = Roact.PureComponent:extend("RemoveUserDialog")
extended.defaultProps = { navigation = nil }

function extended:init()
	function self.onRemoveUserDialogClose()
		self.props.navigation.goBack()
	end
end

function extended.render(p)
	local navigation = p.props.navigation
	assert(type(navigation) ~= "nil", "RemoveUserDialog should be wrapped with Roact Navigation")

	local param = navigation.getParam("conversationId", nil)
	local param2 = navigation.getParam("participantId", nil)

	if param ~= nil and param2 ~= nil then
		return Roact.createElement(RemoveUserDialogContainer, {
			conversationId = param,
			participantId = param2,
			onModalClose = p.onRemoveUserDialogClose
		})
	end

	Logger:warning("ConversationId and participantId are required to open {screen}")
	return nil
end

function extended.didMount(_)
	Logger:info("{screen} mounted")
end

return extended
