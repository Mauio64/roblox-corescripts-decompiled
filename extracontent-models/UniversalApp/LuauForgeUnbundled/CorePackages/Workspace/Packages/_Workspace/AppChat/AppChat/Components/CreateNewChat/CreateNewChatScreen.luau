local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ArgCheck")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalAppPolicy")

local GetTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore")

local CreateNewChatContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/CreateNewChat/CreateNewChatContainer")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/CreateNewChat/Logger")

local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagIsSquadEnabled
local FFlagAppChatIxpScreenExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatIxpScreenExposure")

local IXPNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/IXPNavigationUtils")

local extended = Roact.PureComponent:extend("CreateNewChatScreen")
extended.defaultProps = {}

local function getTabBarVisible(p2)
	local navigation = p2 and p2.navigation

	if navigation and navigation.getScreenProps then
		return (navigation.getScreenProps("wideMode", false))
	end

	return false
end

function extended.navigationOptions(p2)
	local navigation = p2 and p2.navigation
	return {
		tabBarVisible = if navigation and navigation.getScreenProps then navigation.getScreenProps("wideMode", false) else false
	}
end

function extended:init()
	local v5 = if FFlagAppChatIxpScreenExposure then IXPNavigationUtils.registerExposureOnFocus(
		self.props.navigation,
		"Party.ChatMembersPage"
	) else nil
	self.ixpSubscription = v5

	function self.navigateToConversation(p3)
		local navigation = self.props.navigation
		Logger:info("Navigate To Conversation: {} from {screen}", p3)

		if navigation.getScreenProps("wideMode", false) then
			navigation.navigate(EnumScreens.ChatConversation, { conversationId = p3 })
		else
			navigation.replace(EnumScreens.ChatConversation, { conversationId = p3 })
		end
	end

	function self.navigateToToast(p3)
		Logger:info("Navigate To Toast from {screen}")
		self.props.navigation.navigate(EnumScreens.RoactChatToast, p3)
	end

	function self.setSystemButtonActivated(p3)
		GetTopBarStore(false).setScreenTopBar(EnumScreens.CreateNewChat, {
			systemButtonActivated = p3
		})
	end

	function self.setSystemButtonEnabled(p3)
		GetTopBarStore(false).setScreenTopBar(EnumScreens.CreateNewChat, {
			systemButtonEnabled = p3
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

function extended.didMount(p2)
	Logger:info("{screen} mounted")
	GetTopBarStore(false).setScreenTopBar(EnumScreens.CreateNewChat, {
		headerText = {
			raw = getFFlagIsSquadEnabled() and (UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTerminology() and "Feature.Chat.Title.NewChat" or "Feature.Chat.Heading.PartyWithFriends") or "Feature.Chat.Heading.ChatWithConnections",
			shouldLocalize = true
		},
		backButtonEnabled = true,
		systemButtonText = getFFlagIsSquadEnabled() and "Feature.Chat.Action.Create" or "Feature.Chat.Action.StartChatWithFriends"
	})

	p2.setSystemButtonEnabled(false)
end

function extended.willUnmount(p2)
	GetTopBarStore(false).clearScreenTopBar(EnumScreens.CreateNewChat)

	if p2.ixpSubscription then
		p2.ixpSubscription.remove()
	end
end

return extended
