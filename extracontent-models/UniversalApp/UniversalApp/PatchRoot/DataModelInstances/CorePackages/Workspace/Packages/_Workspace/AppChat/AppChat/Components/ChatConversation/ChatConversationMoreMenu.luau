local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Foundation = require(AppChatParent.Foundation)
local FocusNavigationUtils = require(AppChatParent.FocusNavigationUtils)
local InputHandlers = require(AppChatParent.InputHandlers)
local React = require(AppChatParent.React)
local ReactFocusNavigation = require(AppChatParent.ReactFocusNavigation)
local SharedFlags = require(AppChatParent.SharedFlags)
local SquadExternalContractProvider = require(AppChatParent.SquadsCore.SquadExternalContractProvider)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local ConversationActionType = require(AppChat.Analytics.Enums.ConversationActionType)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatConversationTelemetryEvents = require(script.Parent.ChatConversationTelemetryEvents)
local leaveSquad = require(AppChatParent.SquadsCore.Thunks).leaveSquad
local SquadPromptType = require(AppChatParent.SquadsCore.Enums).SquadPromptType
local useCurrentSquadId = require(AppChatParent.SquadsCore.Hooks).useCurrentSquadId
local useCurrentSquadParentChannelId = require(AppChatParent.SquadsCore.Hooks).useCurrentSquadParentChannelId
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local EventNames = require(AppChatParent.SquadsCore.EventNames)
local ScheduledSquadSheet = require(AppChatParent.Squads.ScheduledSquadSheet)
local ScheduledSquadActionEnum = require(AppChatParent.Squads.Enums).ScheduledSquadActionEnum
local ScheduledSquadActionSourceEnum = require(AppChatParent.Squads.Enums).ScheduledSquadActionSourceEnum
local SquadButtonClickIntentionEnum = require(AppChatParent.Squads.Enums).SquadButtonClickIntentionEnum
local SquadButtonSourceEnum = require(AppChatParent.Squads.Enums).SquadButtonSourceEnum
local IconName = Foundation.Enums.IconName
local Menu = Foundation.Menu
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local useTokens = Foundation.Hooks.useTokens
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot
local useFocusNavigableSurfaceRegistryConnection = FocusNavigationUtils.useFocusNavigableSurfaceRegistryConnection
local FFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled
local v37 = game:DefineFastFlag("EnableMoreMenuGamepadFix", false)
local FFlagEnableScheduledSquads = SharedFlags.FFlagEnableScheduledSquads
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

return React.memo(function(t2: {[any]: any}) -- line: 67
	-- upvalues: useTelemetry (copy), ChatConversationTelemetryLayer (copy), useDispatch (copy), useTokens (copy), useLocalization (copy), useCurrentSquadId (copy), useCurrentSquadParentChannelId (copy), React (copy), SquadExternalContractContext (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), FFlagEnableScheduledSquads (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), v37 (copy), useAppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), useFocusNavigableSurfaceRegistryConnection (copy), ReactFocusNavigation (copy), t1 (copy), EventNames (copy), ScheduledSquadActionEnum (copy), ScheduledSquadActionSourceEnum (copy), leaveSquad (copy), SquadPromptType (copy), SquadButtonSourceEnum (copy), SquadButtonClickIntentionEnum (copy), ChatConversationTelemetryEvents (copy), ConversationActionType (copy), IconName (copy), Foundation (copy), ScheduledSquadSheet (copy), Menu (copy), PopoverSide (copy), PopoverAlign (copy)
	local v41 = useTelemetry(ChatConversationTelemetryLayer.Context)
	local v42 = useDispatch()
	local v43 = useTokens()
	local v44 = useLocalization({
		joinParty = "Feature.Squads.Label.JoinParty",
		moreText = "CommonUI.Features.Label.More",
		scheduleAParty = "Feature.Squads.Action.ScheduleAParty",
		startParty = "Feature.Squads.Label.StartParty",
		viewParty = "Feature.Squads.Label.ViewParty"
	})
	local v45 = useCurrentSquadId()
	local v46 = useCurrentSquadParentChannelId()
	local v47 = React.useContext(SquadExternalContractContext)
	local v48 = not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v47.useIsChatEnabled()
	local v49, v50 = React.useState(not FFlagEnableScheduledSquads and nil)
	local v51, v52 = React.useState(false)
	local v53, v54 = React.useState(if not FFlagEnableScheduledSquads then nil else t2.tooltipText and t2.tooltipText ~= "")
	local v55 = React.useRef(nil)
	local v56 = React.useMemo(function() -- line: 93
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v52 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p1) -- line: 96
					-- upvalues: v52 (copy)
					p1.cancelled = true
					v52(false)
				end)
			}
		}
	end, { v52 })
	local v57 = nil
	local v58 = nil

	if v37 then
		local v59 = useAppFocusRoot({
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
			isFocusable = v51,
			customEventHandlers = v56
		})

		v57 = React.useCallback(function(p2) -- line: 114
			-- upvalues: v55 (copy), v59 (copy)
			v55.current = p2

			if type(v59) == "function" then
				v59(p2)
			end
		end, { v59 })
	else
		useFocusNavigableSurfaceRegistryConnection(v55.current, FocusNavigableSurfaceIdentifierEnum.ContextualMenu, v51)

		local v60 = ReactFocusNavigation.useEventMap(t1, v55)

		v58 = ReactFocusNavigation.useEventHandlerMap(v56, v60)
	end

	React.useEffect(function() -- line: 131
		-- upvalues: v55 (copy)
		if v55 and v55.current then
			v55.current.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			v55.current.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
			v55.current.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
			v55.current.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			v55.current.SelectionGroup = true
		end
	end, { v51 })

	local v61 = React.useCallback(function() -- line: 142
		-- upvalues: v52 (copy)
		v52(false)
	end, {})
	local v62 = React.useCallback(function() -- line: 147
		-- upvalues: FFlagEnableScheduledSquads (copy), v50 (copy), v47 (copy), EventNames (copy), ScheduledSquadActionEnum (copy), t2 (copy), ScheduledSquadActionSourceEnum (copy), v45 (copy)
		if FFlagEnableScheduledSquads then
			v50(true)
			v47.fireSquadAnalytics(EventNames.ScheduledSquadAction, {
				actionType = ScheduledSquadActionEnum.ScheduleParty,
				conversationId = t2.conversationId,
				source = ScheduledSquadActionSourceEnum.ChatConversationMoreMenu,
				squadId = v45,
				squadLocation = v47.squadLocation
			})
		end
	end, if not FFlagEnableScheduledSquads then nil else {
		v47.setSquadPrompt,
		t2.conversationId,
		v45,
		v47.squadLocation,
		v47.fireSquadAnalytics
	})
	local v63 = React.useCallback(function() -- line: 172
		-- upvalues: v45 (copy), t2 (copy), v46 (copy), v42 (copy), leaveSquad (copy), SquadPromptType (copy), v47 (copy), v48 (copy), EventNames (copy), SquadButtonSourceEnum (copy), SquadButtonClickIntentionEnum (copy)
		if v45 and t2.conversationId ~= v46 then
			v42(leaveSquad(SquadPromptType.JoinAnotherSquad, v47.setSquadPrompt, function() -- line: 175
				-- upvalues: t2 (copy)
				t2.navigateToSquadLobby(t2.conversationId)
			end, v47.squadLocation, v48))
		else
			t2.navigateToSquadLobby(t2.conversationId)
		end

		v47.fireSquadAnalytics(EventNames.EnterSquadButtonPressed, {
			conversationId = t2.conversationId,
			squadButtonSource = SquadButtonSourceEnum.ChatConversationMoreMenu,
			squadId = v45,
			squadLocation = v47.squadLocation,
			userIntention = if not t2.conversation or (not t2.conversation.hasGroupUp or t2.conversationId ~= v46) then if not t2.conversation or not t2.conversation.hasGroupUp then SquadButtonClickIntentionEnum.Create else SquadButtonClickIntentionEnum.Join else SquadButtonClickIntentionEnum.View
		})
	end, {
		t2.navigateToSquadLobby,
		t2.conversationId,
		t2.conversation and t2.conversation.hasGroupUp,
		v45,
		v46,
		v47,
		v48
	})
	local v64 = React.useCallback(function(p3) -- line: 207
		-- upvalues: v63 (copy), FFlagEnableScheduledSquads (copy), v62 (copy), v52 (copy)
		if p3 == "createJoinViewParty" then
			v63()
		elseif FFlagEnableScheduledSquads and p3 == "scheduleParty" then
			v62()
		end

		v52(false)
	end, {
		v63,
		if not FFlagEnableScheduledSquads then nil else v62
	})
	local v65 = React.useCallback(function() -- line: 222
		-- upvalues: v41 (copy), ChatConversationTelemetryEvents (copy), v51 (copy), ConversationActionType (copy), v52 (copy)
		v41.emit(ChatConversationTelemetryEvents.ConversationMoreMenuBtnClicked, {
			action = if not v51 then ConversationActionType.OpenMoreMenu else ConversationActionType.CloseMoreMenu
		})
		v52(not v51)
	end, {
		v51,
		v41
	})
	local v66 = React.useCallback(function() -- line: 230
		-- upvalues: v54 (copy)
		v54(false)
	end, {})
	local v67 = React.useMemo(function() -- line: 235
		-- upvalues: t2 (copy), v46 (copy), v44 (copy), FFlagEnableScheduledSquads (copy), IconName (copy)
		local t3 = {}

		table.insert(t3, {
			icon = "icons/menu/groups",
			id = "createJoinViewParty",
			isDisabled = false,
			isChecked = false,
			text = if not t2.conversation or (not t2.conversation.hasGroupUp or t2.conversationId ~= v46) then if not t2.conversation or not t2.conversation.hasGroupUp then v44.startParty else v44.joinParty else v44.viewParty
		})

		if FFlagEnableScheduledSquads then
			table.insert(t3, {
				id = "scheduleParty",
				isDisabled = false,
				isChecked = false,
				icon = IconName.Calendar,
				text = v44.scheduleAParty
			})
		end

		return t3
	end, {
		t2.conversation and t2.conversation.hasGroupUp,
		t2.conversationId,
		v46
	})

	if FFlagEnableScheduledSquads then
		local v68 = React.useRef(nil)

		return React.createElement(Foundation.View, {
			tag = "auto-xy align-y-center"
		}, {
			MoreMenuButton = React.createElement(Foundation.IconButton, {
				isCircular = true,
				testId = "ChatConversationMoreMenuButton",
				icon = {
					name = Foundation.Enums.IconName.PlusLarge,
					variant = if not v51 then Foundation.Enums.IconVariant.Regular else Foundation.Enums.IconVariant.Filled
				},
				variant = if not v51 then Foundation.Enums.ButtonVariant.Utility else Foundation.Enums.ButtonVariant.Standard,
				LayoutOrder = t2.layoutOrder,
				onActivated = v65,
				size = Foundation.Enums.InputSize.Medium,
				ref = v68
			}),
			ScheduledSquadSheet = if not FFlagEnableScheduledSquads then nil else React.createElement(ScheduledSquadSheet, {
				conversationId = t2.conversationId,
				isOpen = v49,
				onClose = function() -- line: 301
					-- upvalues: v50 (copy)
					v50(false)
				end
			}),
			Menu = React.createElement(Menu, {
				anchorRef = v68,
				items = v67,
				isOpen = v51,
				onActivated = v64,
				onPressedOutside = v61,
				ref = if not v37 then nil else v57,
				side = PopoverSide.Top
			}),
			Tooltip = React.createElement(Foundation.Popover.Root, {
				isOpen = v53
			}, {
				Anchor = React.createElement(Foundation.Popover.Anchor, {
					anchorRef = v68
				}),
				Content = React.createElement(Foundation.Popover.Content, {
					hasArrow = true,
					align = {
						offset = 0,
						position = PopoverAlign.Start
					},
					backgroundStyle = v43.Inverse.Surface.Surface_0,
					onPressedOutside = v66
				}, {
					TooltipText = React.createElement(Foundation.Text, {
						tag = "auto-xy text-wrap padding-small content-inverse-emphasis text-body-small",
						Text = t2.tooltipText
					})
				})
			})
		})
	end

	return (React.createElement(Menu, {
		items = v67,
		isOpen = v51,
		LayoutOrder = t2.layoutOrder,
		onActivated = v64,
		onPressedOutside = v61,
		ref = v58,
		side = PopoverSide.Top
	}, {
		MoreMenuButton = React.createElement(Foundation.View, {
			tag = "auto-xy align-y-center"
		}, { React.createElement(Foundation.IconButton, {
			isCircular = true,
			testId = "ChatConversationMoreMenuButton",
			icon = {
				name = Foundation.Enums.IconName.PlusLarge,
				variant = if not v51 then Foundation.Enums.IconVariant.Regular else Foundation.Enums.IconVariant.Filled
			},
			variant = if not v51 then Foundation.Enums.ButtonVariant.Utility else Foundation.Enums.ButtonVariant.Standard,
			LayoutOrder = t2.layoutOrder,
			onActivated = v65,
			size = Foundation.Enums.InputSize.Medium
		}) })
	}))
end)
