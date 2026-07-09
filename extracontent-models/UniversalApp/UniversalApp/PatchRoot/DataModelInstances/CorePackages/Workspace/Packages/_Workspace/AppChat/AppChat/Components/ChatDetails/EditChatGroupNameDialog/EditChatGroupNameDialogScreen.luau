local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local EditChatGroupNameDialogContainer = require(script.Parent.EditChatGroupNameDialogContainer)
local Logger = require(script.Parent.Logger)
local v5 = Roact.PureComponent:extend("EditChatGroupNameDialogScreen")

v5.defaultProps = {
	navigation = nil
}

function v5.init(p1) -- line: 14
	function p1.onEditChatGroupNameDialogClose() -- line: 15
		-- upvalues: p1 (copy)
		p1.props.navigation.goBack()
	end
end
function v5.render(p2) -- line: 20
	-- upvalues: Logger (copy), Roact (copy), EditChatGroupNameDialogContainer (copy)
	local navigation = p2.props.navigation

	assert(type(navigation) ~= "nil", "EditChatGroupNameDialogScreen should be wrapped with Roact Navigation")

	local v9 = navigation.getParam("conversationId", nil)

	if v9 == nil then
		Logger:warning("ConversationId is required to open {screen}")

		return nil
	end

	return Roact.createElement(EditChatGroupNameDialogContainer, {
		conversationId = v9,
		onModalClose = p2.onEditChatGroupNameDialogClose
	})
end
function v5.didMount(_) -- line: 36
	-- upvalues: Logger (copy)
	Logger:info("{screen} mounted")
end

return v5
