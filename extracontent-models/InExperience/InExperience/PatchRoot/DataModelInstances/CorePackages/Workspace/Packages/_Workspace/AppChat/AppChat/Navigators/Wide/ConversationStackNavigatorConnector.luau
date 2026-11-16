local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle

local EnumScreens = require(AppChat.EnumScreens)
local configureTopBarWithNavigationOptions = require(AppChat.configureTopBarWithNavigationOptions)
local conversationStackNavigator = require(script.Parent.conversationStackNavigator)
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local ChatConversationTopBar = require(AppChat.Components.TopBar.ChatConversationTopBar)
local ChatTopBarBase = require(AppChat.Components.TopBar.ChatTopBarBase)
local SystemMenuTopBar = require(AppChat.Components.TopBar.SystemMenuTopBar)
local SquadAddFriendsIconButton = require(AppChat.Components.Squads.SquadAddFriendsIconButton)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatConsoleFocusFixes = require(AppChat.Flags.FFlagAppChatConsoleFocusFixes)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local useChatWideModeFocus = require(AppChat.Contexts.ChatWideModeFocus.useChatWideModeFocus)

local v = {
	configureTopBar = configureTopBarWithNavigationOptions,
	createNewNavigator = conversationStackNavigator
}

function ConversationStackNavigatorConnector(p)
	local union = Cryo.Dictionary.union(v, p)

	local v2 = useStyle()
	local v3 = useChatWideModeFocus()

	local state, setState = React.useState(UserGameSettings.ReducedMotion)

	React.useEffect(function()
		local reducedMotionChangedConnection = UserGameSettings:GetPropertyChangedSignal("ReducedMotion"):Connect(function()
			setState(UserGameSettings.ReducedMotion)
		end)
		return function()
			reducedMotionChangedConnection:Disconnect()
		end
	end, {})

	local v4 = React.useMemo(function()
		local newNavigator = union.createNewNavigator(
			{ cardColor3 = v2.Theme.BackgroundDefault.Color, transparent = true },
			state
		)

		union.setRouter(newNavigator.router)
		return newNavigator
	end, { v2.Theme.BackgroundDefault.Color, state, union.createNewNavigator, union.setRouter })

	local v5 = nil

	if FFlagAppChatPerfTracking then
		AppChatPerfTracker.start(AppChatPerfTracker.Events.TopBarRenderInterval)
	end

	local state2 = union.navigation and union.navigation.state

	local routeName = state2
		and state2.routes
		and state2.index
		and state2.routes[state2.index]
		and state2.routes[state2.index].routeName
		or nil

	if routeName == EnumScreens.ChatConversation then
		v5 = React.createElement(ChatConversationTopBar, {
			screenName = EnumScreens.ChatConversation,
			navigation = union.navigation
		})
	elseif routeName == EnumScreens.ChatDetails then
		v5 = React.createElement(ChatTopBarBase, {
			screenName = EnumScreens.ChatDetails,
			navigation = union.navigation
		})
	elseif routeName == EnumScreens.SquadLobby then
		v5 = React.createElement(ChatTopBarBase, {
			screenName = EnumScreens.SquadLobby,
			navigation = union.navigation,
			renderRight = function()
				return React.createElement(SquadAddFriendsIconButton, {
					navigation = union.navigation
				})
			end
		})
	elseif routeName == EnumScreens.SquadInviteFriends then
		v5 = React.createElement(SystemMenuTopBar, {
			screenName = EnumScreens.SquadInviteFriends,
			navigation = union.navigation
		})
	end

	local v6 = v5 or union.configureTopBar(union.navigation)

	local screenProps = union.navigation.getScreenProps("topBarHeight", 0)

	local createElement = React.createElement
	local fragment = React.Fragment
	local v7 = {
		layout = React.createElement("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }),
		topBar = 0,
		navigatorFrame = 0
	}

	if FFlagAppChatConsoleFocusFixes then
		v6 = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, screenProps),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = -1,
			ref = v3 and v3.conversationTopBarRef
		}, { Content = v6 })
	end

	v7.topBar = v6

	local createElement2 = React.createElement
	local v8 = {
		Size = UDim2.new(1, 0, 1, -screenProps),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ref = 0
	}
	local ref

	if FFlagAppChatConsoleFocusFixes and v3 then
		ref = v3.conversationPanelRef
	end

	v8.ref = ref
	v7.navigatorFrame = createElement2("Frame", v8, { navigator = React.createElement(v4, union) })
	return createElement(fragment, nil, v7)
end

local extended = React.PureComponent:extend("ConversationStackNavigatorConnectorWrapper")

extended.router = conversationStackNavigator().router

function extended:init()
	function self.setRouter(router)
		extended.router = router
	end
end

function extended.render(p)
	return React.createElement(
		ConversationStackNavigatorConnector,
		Cryo.Dictionary.join(p.props, { setRouter = p.setRouter })
	)
end

return extended
