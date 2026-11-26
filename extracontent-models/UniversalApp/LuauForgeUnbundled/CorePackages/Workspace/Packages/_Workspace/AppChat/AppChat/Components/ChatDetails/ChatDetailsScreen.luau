local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")

local ChatDetailsContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ChatDetailsContainer")
local ChatDetailsNavigationOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ChatDetailsNavigationOptions")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/Logger")

local FFlagAppChatIxpScreenExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatIxpScreenExposure")

local IXPNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/IXPNavigationUtils")
local GetTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore")
local GetRootedNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetRootedNavigationStore")

local extended = Roact.PureComponent:extend("ChatDetailsScreen")
extended.defaultProps = { navigation = nil }

extended.navigationOptions = ChatDetailsNavigationOptions.getNavigationOptions

function extended:init()
	local v5 = if FFlagAppChatIxpScreenExposure then IXPNavigationUtils.registerExposureOnFocus(
		self.props.navigation,
		"Party.ChatDetailsPage"
	) else nil
	self.ixpSubscription = v5

	function self.navigateToEditChatMembers(p2)
		Logger:info("Navigate To EditChatMembers from {screen}")
		self.props.navigation.navigate(EnumScreens.EditChatMembers, {
			conversation = p2,
			isRooted = self.props.navigation.getParam("isRooted", false)
		})
	end

	function self.navigateToToast(p2)
		Logger:info("Navigate To Toast from {screen}")
		self.props.navigation.navigate(EnumScreens.RoactChatToast, p2)
	end

	function self.navigateToDialog(p2, p3)
		Logger:info("Navigate To {} from {screen}", p2)
		self.props.navigation.navigate(p2, p3)
	end

	function self.closeRootedChatDetails()
		local screenProps = self.props.navigation.getScreenProps("navigateToRootStack", nil)

		if screenProps then
			screenProps()
		elseif self.props.navigation.isFocused() then
			self.props.navigation.goBack()
		end
	end

	function self.navigateBack()
		if self.props.navigation.isFocused() then
			if self.props.navigation.getParam("isRooted", false) then
				self.closeRootedChatDetails()
			else
				self.props.navigation.goBack()
			end
		end
	end

	function self.navigateToConversation(p2)
		Logger:info("Navigate To Conversation from {screen}")
		self.props.navigation.navigate(EnumScreens.ChatConversation, {
			conversationId = p2,
			isRooted = self.props.navigation.getParam("isRooted", false)
		})
	end

	function self.navigateToChatLanding()
		Logger:info("Navigate To ChatLanding from {screen}")

		if self.props.navigation.getParam("isRooted", false) then
			self.closeRootedChatDetails()
		elseif self.props.navigation.getScreenProps("wideMode", false) then
			self.props.navigation.navigate(EnumScreens.EmptyConversation)
		else
			self.props.navigation.navigate(EnumScreens.ChatLanding)
		end
	end
end

function extended.render(props)
	local navigation = props.props.navigation
	assert(type(navigation) ~= "nil", "ChatDetailsScreen should be wrapped with Roact Navigation")

	local param = navigation.getParam("conversationId", nil)

	if param ~= nil then
		return Roact.createElement(ChatDetailsContainer, {
			topBarHeight = navigation.getScreenProps("topBarHeight", 0),
			wideMode = navigation.getScreenProps("wideMode", false),
			conversationId = param,
			navigateBack = props.navigateBack,
			navigateToEditChatMembers = props.navigateToEditChatMembers,
			navigateToDialog = props.navigateToDialog,
			navigateToToast = props.navigateToToast,
			navigateToConversation = props.navigateToConversation,
			navigateToChatLanding = props.navigateToChatLanding
		})
	end

	Logger:warning("ConversationId is required to open {screen}")
	return nil
end

function extended.didMount(p2)
	Logger:info("{screen} mounted")

	GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatDetails, ChatDetailsNavigationOptions.getTopBarConfig(p2.props.navigation))

	if p2.props.navigation.getParam("isRooted", false) then
		GetRootedNavigationStore(false).completeNavigation(p2.props.navigation.getParam("rootedNavigationRequestId", nil))
	end
end

function extended.willUnmount(p2)
	if p2.ixpSubscription then
		p2.ixpSubscription.remove()
	end
end

return extended
