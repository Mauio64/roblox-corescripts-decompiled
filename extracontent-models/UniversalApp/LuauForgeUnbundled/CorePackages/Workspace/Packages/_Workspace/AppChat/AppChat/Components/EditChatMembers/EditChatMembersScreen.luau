local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ArgCheck")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Roact")

local ParentContainerContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ParentContainer/ParentContainerContext")
local GetTopBarStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetTopBarStore")

local FFlagAppChatIxpScreenExposure = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatIxpScreenExposure")

local IXPNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/IXPNavigationUtils")

local getFFlagAppChatEnableRootedNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFFlagAppChatEnableRootedNavigation")
local EditChatMembersContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EditChatMembers/EditChatMembersContainer")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/EditChatMembers/Logger")

local function renderContainer(p2, p3, p4, navigateToToast, setSystemButtonActivated, setSystemButtonEnabled)
	return Roact.createElement(EditChatMembersContainer, {
		topBarHeight = p2.getScreenProps("topBarHeight", 0),
		conversation = p3,
		navigateToConversation = p4,
		navigateToToast = navigateToToast,
		setSystemButtonActivated = setSystemButtonActivated,
		setSystemButtonEnabled = setSystemButtonEnabled
	})
end

local function RootedEditChatMembersContainer(data)
	local v5 = React.useContext(ParentContainerContext)
	local navigateToConversation = data.navigateToConversation
	local openFriendsChatConversation = v5.openFriendsChatConversation
	local v6 = React.useCallback(function(p2)
		openFriendsChatConversation(p2):andThen(function(p3)
			if not p3 then
				Logger:warning("Failed to navigate to Friends Chat conversation {}", p2)
				navigateToConversation(p2)
			end
		end)
	end, { navigateToConversation, openFriendsChatConversation })

	return renderContainer(
		data.navigation,
		data.conversation,
		v6,
		data.navigateToToast,
		data.setSystemButtonActivated,
		data.setSystemButtonEnabled
	)
end

local extended = Roact.PureComponent:extend("EditChatMembersScreen")
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
		Logger:info("Navigate To Conversation: {} from {screen}", p3)
		local v6 = getFFlagAppChatEnableRootedNavigation()
			and {
				conversationId = p3,
				isRooted = self.props.navigation.getParam("isRooted", false)
			}
			or { conversationId = p3 }
		self.props.navigation.navigate(EnumScreens.ChatConversation, v6)
	end

	function self.navigateToToast(p3)
		Logger:info("Navigate To Toast from {screen}")
		self.props.navigation.navigate(EnumScreens.RoactChatToast, p3)
	end

	function self.setSystemButtonActivated(p3)
		GetTopBarStore(false).setScreenTopBar(EnumScreens.EditChatMembers, {
			systemButtonActivated = p3
		})
	end

	function self.setSystemButtonEnabled(p3)
		GetTopBarStore(false).setScreenTopBar(EnumScreens.EditChatMembers, {
			systemButtonEnabled = p3
		})
	end
end

function extended.render(props)
	local notNil = ArgCheck.isNotNil(props.props.navigation, "navigation in EditChatMembersScreen")

	local param = notNil.getParam("conversation", nil)

	if not param then
		Logger:warning("Conversation info required to open {screen}")
		return nil
	end

	if getFFlagAppChatEnableRootedNavigation() and notNil.getParam("isRooted", false) then
		return Roact.createElement(RootedEditChatMembersContainer, {
			navigation = notNil,
			conversation = param,
			navigateToConversation = props.navigateToConversation,
			navigateToToast = props.navigateToToast,
			setSystemButtonActivated = props.setSystemButtonActivated,
			setSystemButtonEnabled = props.setSystemButtonEnabled
		})
	end

	return renderContainer(
		notNil,
		param,
		props.navigateToConversation,
		props.navigateToToast,
		props.setSystemButtonActivated,
		props.setSystemButtonEnabled
	)
end

function extended.didMount(p2)
	Logger:info("{screen} mounted")
	GetTopBarStore(false).setScreenTopBar(EnumScreens.EditChatMembers, {
		headerText = { raw = "Feature.Chat.Label.AddFriends", shouldLocalize = true },
		backButtonEnabled = true,
		systemButtonText = "Feature.Chat.Action.Add"
	})

	p2.setSystemButtonEnabled(false)
end

function extended.willUnmount(p2)
	GetTopBarStore(false).clearScreenTopBar(EnumScreens.EditChatMembers)

	if p2.ixpSubscription then
		p2.ixpSubscription.remove()
	end
end

return extended
