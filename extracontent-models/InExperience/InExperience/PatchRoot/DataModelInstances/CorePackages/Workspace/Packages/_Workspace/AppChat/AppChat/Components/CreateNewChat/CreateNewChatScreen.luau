local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local EnumScreens = require(AppChat.EnumScreens)
local ArgCheck = require(parent.ArgCheck)
local Roact = require(parent.Roact)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)

local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)

local CreateNewChatContainer = require(script.Parent.CreateNewChatContainer)
local Logger = require(script.Parent.Logger)

local SharedFlags = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags.GetFFlagIsSquadEnabled
local FFlagAppChatIxpScreenExposure = require(AppChat.Flags.FFlagAppChatIxpScreenExposure)

local IXPNavigationUtils = require(AppChat.Utils.IXPNavigationUtils)

local extended = Roact.PureComponent:extend("CreateNewChatScreen")
extended.defaultProps = {}

local function getTabBarVisible(p) -- 1 equivalent call inferred from this helper
	local navigation = p and p.navigation

	if navigation and navigation.getScreenProps then
		return (navigation.getScreenProps("wideMode", false))
	end

	return false
end

function extended.navigationOptions(p)
	local tabBarVisible = getTabBarVisible(p) -- inferred equivalent call
	return { tabBarVisible = tabBarVisible }
end

function extended:init()
	local ixpSubscription

	if FFlagAppChatIxpScreenExposure then
		ixpSubscription = IXPNavigationUtils.registerExposureOnFocus(self.props.navigation, "Party.ChatMembersPage")
	end

	self.ixpSubscription = ixpSubscription

	function self.navigateToConversation(conversationId)
		local navigation = self.props.navigation
		Logger:info("Navigate To Conversation: {} from {screen}", conversationId)

		if navigation.getScreenProps("wideMode", false) then
			navigation.navigate(EnumScreens.ChatConversation, { conversationId = conversationId })
		else
			navigation.replace(EnumScreens.ChatConversation, { conversationId = conversationId })
		end
	end

	function self.navigateToToast(p)
		Logger:info("Navigate To Toast from {screen}")
		self.props.navigation.navigate(EnumScreens.RoactChatToast, p)
	end

	function self.setSystemButtonActivated(systemButtonActivated)
		GetTopBarStore(false).setScreenTopBar(EnumScreens.CreateNewChat, {
			systemButtonActivated = systemButtonActivated
		})
	end

	function self.setSystemButtonEnabled(systemButtonEnabled)
		GetTopBarStore(false).setScreenTopBar(EnumScreens.CreateNewChat, {
			systemButtonEnabled = systemButtonEnabled
		})
	end
end

function extended.render(props)
	local notNil = ArgCheck.isNotNil(props.props.navigation, "navigation in CreateNewChatScreen")

	return Roact.createElement(CreateNewChatContainer, {
		topBarHeight = notNil.getScreenProps("topBarHeight", 0),
		navigateToConversation = props.navigateToConversation,
		navigateToToast = props.navigateToToast,
		setSystemButtonActivated = props.setSystemButtonActivated,
		setSystemButtonEnabled = props.setSystemButtonEnabled
	})
end

function extended.didMount(p)
	Logger:info("{screen} mounted")
	GetTopBarStore(false).setScreenTopBar(EnumScreens.CreateNewChat, {
		headerText = {
			raw = GetFFlagIsSquadEnabled() and (UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "Feature.Chat.Title.NewChat" or "Feature.Chat.Heading.PartyWithFriends") or "Feature.Chat.Heading.ChatWithConnections",
			shouldLocalize = true
		},
		backButtonEnabled = true,
		systemButtonText = GetFFlagIsSquadEnabled() and "Feature.Chat.Action.Create" or "Feature.Chat.Action.StartChatWithFriends"
	})

	p.setSystemButtonEnabled(false)
end

function extended.willUnmount(p)
	GetTopBarStore(false).clearScreenTopBar(EnumScreens.CreateNewChat)

	if p.ixpSubscription then
		p.ixpSubscription.remove()
	end
end

return extended
