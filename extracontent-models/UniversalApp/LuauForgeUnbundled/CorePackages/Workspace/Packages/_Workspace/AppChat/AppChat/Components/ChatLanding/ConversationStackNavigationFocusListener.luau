local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InputHandlers")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local ReactFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils")
local SquadExternalContractProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/SquadExternalContractProvider")
local mutedError = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Loggers").mutedError

local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local getFirstFocusableDescendant = FocusNavigationUtils.getFirstFocusableDescendant
local flushPendingActivationOnFocus = FocusNavigationUtils.flushPendingActivationOnFocus
local FFlagAppChatConsoleFocusFixes = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatConsoleFocusFixes")

local FFlagAppChatDebounceConversationFocusActivation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatDebounceConversationFocusActivation")

local squadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local squadPromptType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Enums").SquadPromptType
local leaveSquad = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Thunks").leaveSquad
local useCurrentSquadParentChannelId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Hooks").useCurrentSquadParentChannelId

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local v5 = {
	[Enum.KeyCode.ButtonX] = focusNavigationEventNameEnum.SquadJoin,
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local function ConversationStackNavigationFocusListener(props)
	local v6 = useDispatch()
	local v7 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
	local v8 = React.useContext(squadExternalContractContext)
	local v9 = useCurrentSquadParentChannelId()

	local v10 = React.useCallback(function(object)
		local childNavigation = props.navigation.getChildNavigation("ConversationStackNavigator")

		if v7 and childNavigation and childNavigation.state.index == 1 then
			local value = v7.focusedGuiObject:getValue()

			if value ~= nil and value:IsDescendantOf(props.rightContainerRef.current) then
				local v11 = FFlagAppChatConsoleFocusFixes
					and props.conversationPanelRef.current
					and value:IsDescendantOf(props.conversationPanelRef.current)
					and props.conversationTopBarRef.current
					and getFirstFocusableDescendant(props.conversationTopBarRef.current)

				if v11 then
					v7:focusGuiObject(v11, true)
					object:cancel()
				else
					v7:focusGuiObject(props.leftContainerRef.current, true)
					object:cancel()
				end
			end
		end
	end, {
		props.navigation,
		props.leftContainerRef,
		props.rightContainerRef,
		props.conversationTopBarRef,
		props.conversationPanelRef,
		v7
	})

	local v11 = React.useCallback(function(object)
		local function joinConversationSquad(p2)
			if v9 == nil or v9 == p2 then
				props.navigation.navigate(EnumScreens.SquadLobby, { conversationId = p2 })
			else
				v6(leaveSquad(squadPromptType.JoinAnotherSquad, v8.setSquadPrompt, function()
					props.navigation.navigate(EnumScreens.SquadLobby, { conversationId = p2 })
				end, v8.squadLocation, true))
			end
		end

		local childNavigation = props.navigation.getChildNavigation("ConversationStackNavigator")

		if childNavigation and childNavigation.state.index == 1 then
			if FFlagAppChatDebounceConversationFocusActivation then
				local v12 = flushPendingActivationOnFocus()

				if v12 ~= nil then
					joinConversationSquad(v12)
					object:cancel()
					return
				end
			end

			local route = childNavigation.state.routes[1]

			if route.routeName == EnumScreens.ChatConversation and route.params then
				local conversationId = route.params.conversationId

				if not conversationId then
					mutedError("ConversationStackNavigationFocusListener: Missing conversationId for ChatConversation.")
					return
				end

				joinConversationSquad(conversationId)
				object:cancel()
			else
				mutedError("ConversationStackNavigationFocusListener: Found" .. tostring(route.routeName) .. " at root.")
			end
		end
	end, { v9, v6, props.navigation, v8.setSquadPrompt, v8.squadLocation })

	local v12 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(v10)
			},
			[focusNavigationEventNameEnum.SquadJoin] = {
				handler = InputHandlers.onRelease(v11)
			}
		}
	end, { v10, v11 })

	local v13 = ReactFocusNavigation.useEventMap(v5)
	local v14 = ReactFocusNavigation.useEventHandlerMap(v12, v13)

	return React.createElement(
		"Frame",
		{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ref = v14 },
		props.children
	)
end

return ConversationStackNavigationFocusListener
