require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Core.Style.useStyle

local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")
local configureTopBarWithNavigationOptions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/configureTopBarWithNavigationOptions")
local conversationStackNavigator = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Navigators/Wide/conversationStackNavigator")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local ChatConversationTopBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TopBar/ChatConversationTopBar")
local ChatTopBarBase = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TopBar/ChatTopBarBase")
local SystemMenuTopBar = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/TopBar/SystemMenuTopBar")
local SquadAddFriendsIconButton = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/Squads/SquadAddFriendsIconButton")
local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local FFlagAppChatConsoleFocusFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConsoleFocusFixes")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")
local useChatWideModeFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatWideModeFocus/useChatWideModeFocus")

local v5 = { configureTopBar = configureTopBarWithNavigationOptions, createNewNavigator = conversationStackNavigator }

function LUAUFORGE_MODULE_GLOBALS_hFz_ConversationStackNavigatorConnector(p2)
	local union = Cryo.Dictionary.union(v5, p2)

	local v6 = useStyle()
	local v7 = useChatWideModeFocus()

	local state, setState = React.useState(UserGameSettings.ReducedMotion)

	React.useEffect(function()
		local reducedMotionChangedConnection = UserGameSettings:GetPropertyChangedSignal("ReducedMotion"):Connect(function()
			setState(UserGameSettings.ReducedMotion)
		end)
		return function()
			reducedMotionChangedConnection:Disconnect()
		end
	end, {})

	local v8 = React.useMemo(function()
		local newNavigator = union.createNewNavigator(
			{ cardColor3 = v6.Theme.BackgroundDefault.Color, transparent = true },
			state
		)

		union.setRouter(newNavigator.router)
		return newNavigator
	end, {
		v6.Theme.BackgroundDefault.Color,
		state,
		union.createNewNavigator,
		union.setRouter
	})

	local v9 = nil

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
		v9 = React.createElement(ChatConversationTopBar, {
			screenName = EnumScreens.ChatConversation,
			navigation = union.navigation
		})
	elseif routeName == EnumScreens.ChatDetails then
		v9 = React.createElement(ChatTopBarBase, {
			screenName = EnumScreens.ChatDetails,
			navigation = union.navigation
		})
	elseif routeName == EnumScreens.SquadLobby then
		v9 = React.createElement(ChatTopBarBase, {
			screenName = EnumScreens.SquadLobby,
			navigation = union.navigation,
			renderRight = function()
				return React.createElement(SquadAddFriendsIconButton, { navigation = union.navigation })
			end
		})
	elseif routeName == EnumScreens.SquadInviteFriends then
		v9 = React.createElement(SystemMenuTopBar, {
			screenName = EnumScreens.SquadInviteFriends,
			navigation = union.navigation
		})
	end

	local v10 = v9 or union.configureTopBar(union.navigation)

	local screenProps = union.navigation.getScreenProps("topBarHeight", 0)

	local createElement = React.createElement
	local fragment = React.Fragment
	local v12 = {
		layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		topBar = 0,
		navigatorFrame = 0
	}

	if FFlagAppChatConsoleFocusFixes then
		v10 = React.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, screenProps),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = -1,
			ref = v7 and v7.conversationTopBarRef
		}, { Content = v10 })
	end

	v12.topBar = v10

	local createElement2 = React.createElement
	local v14 = {
		Size = UDim2.new(1, 0, 1, -screenProps),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ref = 0
	}

	local v15 = if FFlagAppChatConsoleFocusFixes and v7 then v7.conversationPanelRef else nil
	v14.ref = v15
	v12.navigatorFrame = createElement2("Frame", v14, {
		navigator = React.createElement(v8, union)
	})
	return createElement(fragment, nil, v12)
end

local extended = React.PureComponent:extend("ConversationStackNavigatorConnectorWrapper")

extended.router = conversationStackNavigator().router

function extended:init()
	function self.setRouter(router)
		extended.router = router
	end
end

function extended.render(p2)
	return React.createElement(
		LUAUFORGE_MODULE_GLOBALS_hFz_ConversationStackNavigatorConnector,
		Cryo.Dictionary.join(p2.props, { setRouter = p2.setRouter })
	)
end

return extended
