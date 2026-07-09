local Parent = script:FindFirstAncestor("AppChat").Parent
local Roact = require(Parent.Roact)
local RemoveUserDialogContainer = require(script.Parent.RemoveUserDialogContainer)
local Logger = require(script.Parent.Logger)
local v5 = Roact.PureComponent:extend("RemoveUserDialog")

v5.defaultProps = {
	navigation = nil
}

function v5.init(p1) -- line: 14
	function p1.onRemoveUserDialogClose() -- line: 15
		-- upvalues: p1 (copy)
		p1.props.navigation.goBack()
	end
end
function v5.render(p2) -- line: 20
	-- upvalues: Logger (copy), Roact (copy), RemoveUserDialogContainer (copy)
	local navigation = p2.props.navigation

	assert(type(navigation) ~= "nil", "RemoveUserDialog should be wrapped with Roact Navigation")

	local v9 = navigation.getParam("conversationId", nil)
	local v10 = navigation.getParam("participantId", nil)

	if v9 == nil or v10 == nil then
		Logger:warning("ConversationId and participantId are required to open {screen}")

		return nil
	end

	return Roact.createElement(RemoveUserDialogContainer, {
		conversationId = v9,
		participantId = v10,
		onModalClose = p2.onRemoveUserDialogClose
	})
end
function v5.didMount(_) -- line: 38
	-- upvalues: Logger (copy)
	Logger:info("{screen} mounted")
end

return v5
