local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local EnumScreens = require(AppChat.EnumScreens)
local Roact = require(parent.Roact)

local ChatDetailsContainer = require(script.Parent.ChatDetailsContainer)
local ChatDetailsNavigationOptions = require(script.Parent.ChatDetailsNavigationOptions)
local Logger = require(script.Parent.Logger)

local FFlagAppChatIxpScreenExposure = require(AppChat.Flags.FFlagAppChatIxpScreenExposure)

local IXPNavigationUtils = require(AppChat.Utils.IXPNavigationUtils)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local GetRootedNavigationStore = require(AppChat.Stores.GetRootedNavigationStore)

local extended = Roact.PureComponent:extend("ChatDetailsScreen")
extended.defaultProps = { navigation = nil }

extended.navigationOptions = ChatDetailsNavigationOptions.getNavigationOptions

function extended:init()
	local ixpSubscription

	if FFlagAppChatIxpScreenExposure then
		ixpSubscription = IXPNavigationUtils.registerExposureOnFocus(self.props.navigation, "Party.ChatDetailsPage")
	end

	self.ixpSubscription = ixpSubscription

	function self.navigateToEditChatMembers(conversation)
		Logger:info("Navigate To EditChatMembers from {screen}")
		self.props.navigation.navigate(EnumScreens.EditChatMembers, {
			conversation = conversation,
			isRooted = self.props.navigation.getParam("isRooted", false)
		})
	end

	function self.navigateToToast(p)
		Logger:info("Navigate To Toast from {screen}")
		self.props.navigation.navigate(EnumScreens.RoactChatToast, p)
	end

	function self.navigateToDialog(p, p2)
		Logger:info("Navigate To {} from {screen}", p)
		self.props.navigation.navigate(p, p2)
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

	function self.navigateToConversation(conversationId)
		Logger:info("Navigate To Conversation from {screen}")
		self.props.navigation.navigate(EnumScreens.ChatConversation, {
			conversationId = conversationId,
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

function extended.didMount(p)
	Logger:info("{screen} mounted")

	GetTopBarStore(false).setScreenTopBar(
		EnumScreens.ChatDetails,
		ChatDetailsNavigationOptions.getTopBarConfig(p.props.navigation)
	)

	if p.props.navigation.getParam("isRooted", false) then
		GetRootedNavigationStore(false).completeNavigation(p.props.navigation.getParam("rootedNavigationRequestId", nil))
	end
end

function extended.willUnmount(p)
	if p.ixpSubscription then
		p.ixpSubscription.remove()
	end
end

return extended
