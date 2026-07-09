local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent

require(AppChat.types)

local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local useStyle = require(AppChatParent.UIBlox).Core.Style.useStyle
local EnumScreens = require(AppChat.EnumScreens)
local configureTopBarWithNavigationOptions = require(AppChat.configureTopBarWithNavigationOptions)
local conversationStackNavigator = require(script.Parent.conversationStackNavigator)
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local ChatConversationTopBar = require(AppChat.Components.TopBar.ChatConversationTopBar)
local ChatTopBarBase = require(AppChat.Components.TopBar.ChatTopBarBase)
local SystemMenuTopBar = require(AppChat.Components.TopBar.SystemMenuTopBar)
local SquadAddFriendsIconButton = require(AppChat.Components.Squads.SquadAddFriendsIconButton)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local t1 = {
	configureTopBar = configureTopBarWithNavigationOptions,
	createNewNavigator = conversationStackNavigator
}

function ConversationStackNavigatorConnector(p1) -- line: 40
	-- upvalues: Cryo (copy), t1 (copy), useStyle (copy), React (copy), UserGameSettings (copy), FFlagAppChatTopBarConfigDriven (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), EnumScreens (copy), ChatConversationTopBar (copy), ChatTopBarBase (copy), SquadAddFriendsIconButton (copy), SystemMenuTopBar (copy)
	local v20 = Cryo.Dictionary.union(t1, p1)
	local v21 = useStyle()
	local v22, v23 = React.useState(UserGameSettings.ReducedMotion)

	React.useEffect(function() -- line: 47
		-- upvalues: UserGameSettings (copy), v23 (copy)
		local connection = UserGameSettings:GetPropertyChangedSignal("ReducedMotion"):Connect(function() -- line: 48
			-- upvalues: v23 (copy), UserGameSettings (copy)
			v23(UserGameSettings.ReducedMotion)
		end)

		return function() -- line: 51
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	local v24 = React.useMemo(function() -- line: 56
		-- upvalues: v20 (copy), v21 (copy), v22 (copy)
		local v30 = v20.createNewNavigator({
			transparent = true,
			cardColor3 = v21.Theme.BackgroundDefault.Color
		}, v22)

		v20.setRouter(v30.router)

		return v30
	end, {
		v21.Theme.BackgroundDefault.Color,
		v22
	})
	local v25 = nil

	if FFlagAppChatTopBarConfigDriven() then
		if FFlagAppChatPerfTracking then
			AppChatPerfTracker.start(AppChatPerfTracker.Events.TopBarRenderInterval)
		end

		local v26 = v20.navigation and v20.navigation.state
		local v27 = v26 and (not not v26.routes and (not not v26.index and (not not v26.routes[v26.index] and v26.routes[v26.index].routeName))) or nil

		if v27 == EnumScreens.ChatConversation then
			v25 = React.createElement(ChatConversationTopBar, {
				screenName = EnumScreens.ChatConversation,
				navigation = v20.navigation
			})
		elseif v27 == EnumScreens.ChatDetails then
			v25 = React.createElement(ChatTopBarBase, {
				screenName = EnumScreens.ChatDetails,
				navigation = v20.navigation
			})
		elseif v27 == EnumScreens.SquadLobby then
			v25 = React.createElement(ChatTopBarBase, {
				screenName = EnumScreens.SquadLobby,
				navigation = v20.navigation,
				renderRight = function() -- line: 92
					-- upvalues: React (copy), SquadAddFriendsIconButton (copy), v20 (copy)
					return React.createElement(SquadAddFriendsIconButton, {
						navigation = v20.navigation
					})
				end
			})
		elseif v27 == EnumScreens.SquadInviteFriends then
			v25 = React.createElement(SystemMenuTopBar, {
				screenName = EnumScreens.SquadInviteFriends,
				navigation = v20.navigation
			})
		end
	end

	if not v25 then
		v25 = v20.configureTopBar(v20.navigation)
	end

	return React.createElement(React.Fragment, nil, {
		layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		topBar = v25,
		navigatorFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, -v20.navigation.getScreenProps("topBarHeight", 0))
		}, {
			navigator = React.createElement(v24, v20)
		})
	})
end

local v18 = React.PureComponent:extend("ConversationStackNavigatorConnectorWrapper")

v18.router = conversationStackNavigator().router

function v18.render(p2) -- line: 129
	-- upvalues: React (copy), Cryo (copy), v18 (copy)
	return React.createElement(ConversationStackNavigatorConnector, Cryo.Dictionary.join(p2.props, {
		setRouter = function(p3) -- line: 133
			-- upvalues: v18 (copy)
			v18.router = p3
		end
	}))
end

return v18
