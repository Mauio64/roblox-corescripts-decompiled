local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")

local LeaveGroupDialogContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/LeaveGroupDialog/LeaveGroupDialogContainer")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/LeaveGroupDialog/Logger")

local extended = Roact.PureComponent:extend("LeaveGroupDialogScreen")
extended.defaultProps = { navigation = nil }

function extended:init()
	function self.onLeaveGroupDialogClose()
		self.props.navigation.goBack()
	end

	function self.onLeaveGroupSuccess()
		local navigation = self.props.navigation

		if navigation.getParam("isRooted", false) then
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

	local param2 = navigation.getParam("isRooted", false)

	return Roact.createElement(LeaveGroupDialogContainer, {
		conversationId = param,
		isRooted = param2,
		onModalClose = props.onLeaveGroupDialogClose,
		onLeaveSuccess = props.onLeaveGroupSuccess
	})
end

function extended.didMount(p2)
	Logger:info("{screen} mounted")
end

return extended
