local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local EnumScreens = require(AppChat.EnumScreens)
local getFFlagAppChatEnableRootedNavigation = require(AppChat.Flags.getFFlagAppChatEnableRootedNavigation)

local Roact = require(parent.Roact)

local LeaveGroupDialogContainer = require(script.Parent.LeaveGroupDialogContainer)
local Logger = require(script.Parent.Logger)

local extended = Roact.PureComponent:extend("LeaveGroupDialogScreen")
extended.defaultProps = { navigation = nil }

function extended:init()
	function self.onLeaveGroupDialogClose()
		self.props.navigation.goBack()
	end

	function self.onLeaveGroupSuccess()
		local navigation = self.props.navigation

		if getFFlagAppChatEnableRootedNavigation() and navigation.getParam("isRooted", false) then
			Logger:info("Close rooted ChatDetails after leave from {screen}")
			local screenProps = navigation.getScreenProps("navigateToRootStack", nil)

			if screenProps then
				screenProps()
			elseif navigation.isFocused() then
				navigation.goBack()
			end
		elseif navigation.getScreenProps("wideMode", false) then
			Logger:info("Navigate To ChatLanding with EmptyConversation from {screen}")

			navigation.navigate(EnumScreens.EmptyConversation)
		else
			Logger:info("Navigate To ChatLanding from {screen}")
			navigation.navigate(EnumScreens.ChatLanding)
		end
	end
end

function extended.render(props)
	local navigation = props.props.navigation
	assert(type(navigation) ~= "nil", "LeaveGroupDialogScreen should be wrapped with Roact Navigation")

	local param = navigation.getParam("conversationId", nil)

	if param == nil then
		Logger:warning("ConversationId is required to open {screen}")
		return nil
	end

	local isRooted = getFFlagAppChatEnableRootedNavigation() and navigation.getParam("isRooted", false)

	return Roact.createElement(LeaveGroupDialogContainer, {
		conversationId = param,
		isRooted = isRooted,
		onModalClose = props.onLeaveGroupDialogClose,
		onLeaveSuccess = props.onLeaveGroupSuccess
	})
end

function extended.didMount(_)
	Logger:info("{screen} mounted")
end

return extended
