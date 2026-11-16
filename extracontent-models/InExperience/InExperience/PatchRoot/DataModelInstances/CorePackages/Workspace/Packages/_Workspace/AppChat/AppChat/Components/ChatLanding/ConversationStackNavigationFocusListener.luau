local AppChat = script:FindFirstAncestor("AppChat")
local EnumScreens = require(AppChat.EnumScreens)
local parent = AppChat.Parent

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local React = require(parent.React)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local RoactUtils = require(parent.RoactUtils)
local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local Loggers = require(parent.Loggers)
local mutedError = Loggers.mutedError

local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local getFirstFocusableDescendant = FocusNavigationUtils.getFirstFocusableDescendant
local flushPendingActivationOnFocus = FocusNavigationUtils.flushPendingActivationOnFocus
local FFlagAppChatConsoleFocusFixes = require(AppChat.Flags.FFlagAppChatConsoleFocusFixes)

local FFlagAppChatDebounceConversationFocusActivation = require(AppChat.Flags.FFlagAppChatDebounceConversationFocusActivation)

local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local Enums = require(parent.SquadsCore.Enums)
local SquadPromptType = Enums.SquadPromptType
local Thunks = require(parent.SquadsCore.Thunks)
local leaveSquad = Thunks.leaveSquad
local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadParentChannelId = Hooks.useCurrentSquadParentChannelId

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local v = {
	[Enum.KeyCode.ButtonX] = FocusNavigationEventNameEnum.SquadJoin,
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function ConversationStackNavigationFocusListener(props)
	local v2 = useDispatch()
	local v3 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
	local v4 = React.useContext(SquadExternalContractContext)
	local v5 = useCurrentSquadParentChannelId()

	local v6 = React.useCallback(function(object)
		local childNavigation = props.navigation.getChildNavigation("ConversationStackNavigator")

		if v3 and childNavigation and childNavigation.state.index == 1 then
			local value = v3.focusedGuiObject:getValue()

			if value ~= nil and value:IsDescendantOf(props.rightContainerRef.current) then
				local v6 = FFlagAppChatConsoleFocusFixes
					and props.conversationPanelRef.current
					and value:IsDescendantOf(props.conversationPanelRef.current)
					and props.conversationTopBarRef.current
					and getFirstFocusableDescendant(props.conversationTopBarRef.current)

				if v6 then
					v3:focusGuiObject(v6, true)
					object:cancel()
				else
					v3:focusGuiObject(props.leftContainerRef.current, true)
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
		v3
	})

	local v7 = React.useCallback(function(object)
		local function joinConversationSquad(conversationId: string)
			if v5 == nil or v5 == conversationId then
				props.navigation.navigate(EnumScreens.SquadLobby, {
					conversationId = conversationId
				})
			else
				v2(leaveSquad(SquadPromptType.JoinAnotherSquad, v4.setSquadPrompt, function()
					props.navigation.navigate(EnumScreens.SquadLobby, {
						conversationId = conversationId
					})
				end, v4.squadLocation, true))
			end
		end

		local childNavigation = props.navigation.getChildNavigation("ConversationStackNavigator")

		if childNavigation and childNavigation.state.index == 1 then
			if FFlagAppChatDebounceConversationFocusActivation then
				local conversationId = flushPendingActivationOnFocus()

				if conversationId ~= nil then
					joinConversationSquad(conversationId)
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
	end, { v5, v2, props.navigation, v4.setSquadPrompt, v4.squadLocation })

	local v8 = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = { handler = InputHandlers.onRelease(v6) },
			[FocusNavigationEventNameEnum.SquadJoin] = { handler = InputHandlers.onRelease(v7) }
		}
	end, { v6, v7 })

	local v9 = ReactFocusNavigation.useEventMap(v)
	local ref = ReactFocusNavigation.useEventHandlerMap(v8, v9)

	return React.createElement(
		"Frame",
		{ Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, ref = ref },
		props.children
	)
end

return ConversationStackNavigationFocusListener
