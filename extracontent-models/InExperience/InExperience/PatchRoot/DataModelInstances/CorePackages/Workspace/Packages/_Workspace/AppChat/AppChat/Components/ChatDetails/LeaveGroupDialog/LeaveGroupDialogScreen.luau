local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local EnumScreens = require(AppChat.EnumScreens)
local Roact = require(AppChatParent.Roact)
local LeaveGroupDialogContainer = require(script.Parent.LeaveGroupDialogContainer)
local Logger = require(script.Parent.Logger)
local v7 = Roact.PureComponent:extend("LeaveGroupDialogScreen")

v7.defaultProps = {
	navigation = nil
}

function v7.init(p1) -- line: 16
	-- upvalues: Logger (copy), EnumScreens (copy)
	function p1.onLeaveGroupDialogClose() -- line: 17
		-- upvalues: p1 (copy)
		p1.props.navigation.goBack()
	end
	function p1.onLeaveGroupSuccess() -- line: 21
		-- upvalues: p1 (copy), Logger (copy), EnumScreens (copy)
		local navigation = p1.props.navigation

		if navigation.getScreenProps("wideMode", false) then
			Logger:info("Navigate To ChatLanding with EmptyConversation from {screen}")
			navigation.navigate(EnumScreens.EmptyConversation)

			return
		end

		Logger:info("Navigate To ChatLanding from {screen}")
		navigation.navigate(EnumScreens.ChatLanding)
	end
end
function v7.render(p2) -- line: 34
	-- upvalues: Logger (copy), Roact (copy), LeaveGroupDialogContainer (copy)
	local navigation = p2.props.navigation

	assert(type(navigation) ~= "nil", "LeaveGroupDialogScreen should be wrapped with Roact Navigation")

	local v11 = navigation.getParam("conversationId", nil)

	if v11 == nil then
		Logger:warning("ConversationId is required to open {screen}")

		return nil
	end

	return Roact.createElement(LeaveGroupDialogContainer, {
		conversationId = v11,
		onModalClose = p2.onLeaveGroupDialogClose,
		onLeaveSuccess = p2.onLeaveGroupSuccess
	})
end
function v7.didMount(_) -- line: 51
	-- upvalues: Logger (copy)
	Logger:info("{screen} mounted")
end

return v7
