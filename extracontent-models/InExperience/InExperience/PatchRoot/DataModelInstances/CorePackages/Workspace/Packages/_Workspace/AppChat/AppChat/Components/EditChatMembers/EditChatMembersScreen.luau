local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local EnumScreens = require(AppChat.EnumScreens)
local ArgCheck = require(parent.ArgCheck)
local React = require(parent.React)
local Roact = require(parent.Roact)

local ParentContainerContext = require(AppChat.Contexts.ParentContainer.ParentContainerContext)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)

local FFlagAppChatIxpScreenExposure = require(AppChat.Flags.FFlagAppChatIxpScreenExposure)

local IXPNavigationUtils = require(AppChat.Utils.IXPNavigationUtils)

local getFFlagAppChatEnableRootedNavigation = require(AppChat.Flags.getFFlagAppChatEnableRootedNavigation)
local EditChatMembersContainer = require(script.Parent.EditChatMembersContainer)
local Logger = require(script.Parent.Logger)

local function renderContainer(p, conversation, navigateToConversation, navigateToToast, setSystemButtonActivated, setSystemButtonEnabled)
	return Roact.createElement(EditChatMembersContainer, {
		topBarHeight = p.getScreenProps("topBarHeight", 0),
		conversation = conversation,
		navigateToConversation = navigateToConversation,
		navigateToToast = navigateToToast,
		setSystemButtonActivated = setSystemButtonActivated,
		setSystemButtonEnabled = setSystemButtonEnabled
	})
end

local function RootedEditChatMembersContainer(data)
	local v = React.useContext(ParentContainerContext)
	local navigateToConversation = data.navigateToConversation
	local openFriendsChatConversation = v.openFriendsChatConversation
	local navigateToConversation2 = React.useCallback(function(p)
		openFriendsChatConversation(p):andThen(function(p2)
			if not p2 then
				Logger:warning("Failed to navigate to Friends Chat conversation {}", p)
				navigateToConversation(p)
			end
		end)
	end, { navigateToConversation, openFriendsChatConversation })

	return renderContainer(
		data.navigation,
		data.conversation,
		navigateToConversation2,
		data.navigateToToast,
		data.setSystemButtonActivated,
		data.setSystemButtonEnabled
	)
end

local extended = Roact.PureComponent:extend("EditChatMembersScreen")
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
		Logger:info("Navigate To Conversation: {} from {screen}", conversationId)
		local v = getFFlagAppChatEnableRootedNavigation()
			and {
				conversationId = conversationId,
				isRooted = self.props.navigation.getParam("isRooted", false)
			}
			or { conversationId = conversationId }
		self.props.navigation.navigate(EnumScreens.ChatConversation, v)
	end

	function self.navigateToToast(p)
		Logger:info("Navigate To Toast from {screen}")
		self.props.navigation.navigate(EnumScreens.RoactChatToast, p)
	end

	function self.setSystemButtonActivated(systemButtonActivated)
		GetTopBarStore(false).setScreenTopBar(EnumScreens.EditChatMembers, {
			systemButtonActivated = systemButtonActivated
		})
	end

	function self.setSystemButtonEnabled(systemButtonEnabled)
		GetTopBarStore(false).setScreenTopBar(EnumScreens.EditChatMembers, {
			systemButtonEnabled = systemButtonEnabled
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

function extended.didMount(p)
	Logger:info("{screen} mounted")
	GetTopBarStore(false).setScreenTopBar(EnumScreens.EditChatMembers, {
		headerText = { raw = "Feature.Chat.Label.AddFriends", shouldLocalize = true },
		backButtonEnabled = true,
		systemButtonText = "Feature.Chat.Action.Add"
	})

	p.setSystemButtonEnabled(false)
end

function extended.willUnmount(p)
	GetTopBarStore(false).clearScreenTopBar(EnumScreens.EditChatMembers)

	if p.ixpSubscription then
		p.ixpSubscription.remove()
	end
end

return extended
