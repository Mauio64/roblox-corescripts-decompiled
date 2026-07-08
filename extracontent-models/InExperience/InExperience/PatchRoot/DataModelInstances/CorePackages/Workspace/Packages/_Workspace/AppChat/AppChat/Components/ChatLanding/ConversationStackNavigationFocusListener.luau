local AppChat = script:FindFirstAncestor("AppChat")
local EnumScreens = require(AppChat.EnumScreens)
local AppChatParent = AppChat.Parent
local FocusNavigationUtils = require(AppChatParent.FocusNavigationUtils)
local InputHandlers = require(AppChatParent.InputHandlers)
local React = require(AppChatParent.React)
local ReactFocusNavigation = require(AppChatParent.ReactFocusNavigation)
local RoactUtils = require(AppChatParent.RoactUtils)
local SquadExternalContractProvider = require(AppChatParent.SquadsCore.SquadExternalContractProvider)
local mutedError = require(AppChatParent.Loggers).mutedError
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local SquadPromptType = require(AppChatParent.SquadsCore.Enums).SquadPromptType
local leaveSquad = require(AppChatParent.SquadsCore.Thunks).leaveSquad
local useCurrentSquadParentChannelId = require(AppChatParent.SquadsCore.Hooks).useCurrentSquadParentChannelId
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local t1 = {
	[Enum.KeyCode.ButtonX] = FocusNavigationEventNameEnum.SquadJoin,
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local function ConversationStackNavigationFocusListener(t2: {[any]: any}) -- line: 35
	-- upvalues: useDispatch (copy), React (copy), ReactFocusNavigation (copy), SquadExternalContractContext (copy), useCurrentSquadParentChannelId (copy), EnumScreens (copy), leaveSquad (copy), SquadPromptType (copy), mutedError (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), t1 (copy)
	local v20 = useDispatch()
	local v21 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
	local v22 = React.useContext(SquadExternalContractContext)
	local v23 = useCurrentSquadParentChannelId()
	local v24 = React.useCallback(function(p1) -- line: 41
		-- upvalues: t2 (copy), v21 (copy)
		local v30 = t2.navigation.getChildNavigation("ConversationStackNavigator")

		if v21 and (v30 and v30.state.index == 1) then
			local v31 = v21.focusedGuiObject:getValue()

			if v31 ~= nil and v31:IsDescendantOf(t2.rightContainerRef.current) then
				v21:focusGuiObject(t2.leftContainerRef.current, true)
				p1:cancel()
			end
		end
	end, {
		t2.navigation,
		t2.leftContainerRef,
		t2.rightContainerRef,
		v21
	})
	local v25 = React.useCallback(function(p2) -- line: 54
		-- upvalues: t2 (copy), EnumScreens (copy), v23 (copy), v20 (copy), leaveSquad (copy), SquadPromptType (copy), v22 (copy), mutedError (copy)
		local v33 = t2.navigation.getChildNavigation("ConversationStackNavigator")

		if v33 and v33.state.index == 1 then
			local v34 = v33.state.routes[1]

			if v34.routeName == EnumScreens.ChatConversation and v34.params then
				local conversationId = v34.params.conversationId

				if conversationId then
					if v23 == nil or conversationId == v23 then
						t2.navigation.navigate(EnumScreens.SquadLobby, {
							conversationId = conversationId
						})
					else
						v20(leaveSquad(SquadPromptType.JoinAnotherSquad, v22.setSquadPrompt, function() -- line: 64
							-- upvalues: t2 (copy), EnumScreens (copy), conversationId (copy)
							t2.navigation.navigate(EnumScreens.SquadLobby, {
								conversationId = conversationId
							})
						end, v22.squadLocation, true))
					end

					p2:cancel()

					return
				end

				mutedError("ConversationStackNavigationFocusListener: Missing conversationId for ChatConversation.")

				return
			end

			mutedError("ConversationStackNavigationFocusListener: Found" .. tostring(v34.routeName) .. " at root.")
		end
	end, {
		v23,
		v20,
		t2.navigation,
		v22.setSquadPrompt,
		v22.squadLocation
	})
	local v26 = React.useMemo(function() -- line: 86
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v24 (copy), v25 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(v24)
			},
			[FocusNavigationEventNameEnum.SquadJoin] = {
				handler = InputHandlers.onRelease(v25)
			}
		}
	end, {
		v24,
		v25
	})
	local v27 = ReactFocusNavigation.useEventMap(t1)
	local v28 = ReactFocusNavigation.useEventHandlerMap(v26, v27)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ref = v28
	}, t2.children)
end

return ConversationStackNavigationFocusListener
