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
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

return React.memo(function(t2: {[any]: any}) -- line: 66
	-- upvalues: useTelemetry (copy), ChatConversationTelemetryLayer (copy), useDispatch (copy), useTokens (copy), useLocalization (copy), useCurrentSquadId (copy), useCurrentSquadParentChannelId (copy), React (copy), SquadExternalContractContext (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), v37 (copy), useAppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), useFocusNavigableSurfaceRegistryConnection (copy), ReactFocusNavigation (copy), t1 (copy), EventNames (copy), ScheduledSquadActionEnum (copy), ScheduledSquadActionSourceEnum (copy), leaveSquad (copy), SquadPromptType (copy), SquadButtonSourceEnum (copy), SquadButtonClickIntentionEnum (copy), ChatConversationTelemetryEvents (copy), ConversationActionType (copy), IconName (copy), Foundation (copy), ScheduledSquadSheet (copy), Menu (copy), PopoverSide (copy), PopoverAlign (copy)
	local v40 = useTelemetry(ChatConversationTelemetryLayer.Context)
	local v41 = useDispatch()
	local v42 = useTokens()
	local v43 = useLocalization({
		joinParty = "Feature.Squads.Label.JoinParty",
		moreText = "CommonUI.Features.Label.More",
		scheduleAParty = "Feature.Squads.Action.ScheduleAParty",
		startParty = "Feature.Squads.Label.StartParty",
		viewParty = "Feature.Squads.Label.ViewParty"
	})
	local v44 = useCurrentSquadId()
	local v45 = useCurrentSquadParentChannelId()
	local v46 = React.useContext(SquadExternalContractContext)
	local v47 = not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v46.useIsChatEnabled()
	local v48, v49 = React.useState(false)
	local v50, v51 = React.useState(false)
	local v52, v53 = React.useState(t2.tooltipText and t2.tooltipText ~= "")
	local v54 = React.useRef(nil)
	local v55 = React.useMemo(function() -- line: 90
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v51 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p1) -- line: 93
					-- upvalues: v51 (copy)
					p1.cancelled = true
					v51(false)
				end)
			}
		}
	end, { v51 })
	local v56 = nil

	if v37 then
		local v57 = useAppFocusRoot({
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
			isFocusable = v50,
			customEventHandlers = v55
		})

		v56 = React.useCallback(function(p2) -- line: 110
			-- upvalues: v54 (copy), v57 (copy)
			v54.current = p2

			if type(v57) == "function" then
				v57(p2)
			end
		end, { v57 })
	else
		useFocusNavigableSurfaceRegistryConnection(v54.current, FocusNavigableSurfaceIdentifierEnum.ContextualMenu, v50)

		local v58 = ReactFocusNavigation.useEventMap(t1, v54)

		ReactFocusNavigation.useEventHandlerMap(v55, v58)
	end

	React.useEffect(function() -- line: 127
		-- upvalues: v54 (copy)
		if v54 and v54.current then
			v54.current.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			v54.current.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
			v54.current.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
			v54.current.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			v54.current.SelectionGroup = true
		end
	end, { v50 })

	local v59 = React.useCallback(function() -- line: 138
		-- upvalues: v51 (copy)
		v51(false)
	end, {})
	local v60 = React.useCallback(function() -- line: 143
		-- upvalues: v49 (copy), v46 (copy), EventNames (copy), ScheduledSquadActionEnum (copy), t2 (copy), ScheduledSquadActionSourceEnum (copy), v44 (copy)
		v49(true)
		v46.fireSquadAnalytics(EventNames.ScheduledSquadAction, {
			actionType = ScheduledSquadActionEnum.ScheduleParty,
			conversationId = t2.conversationId,
			source = ScheduledSquadActionSourceEnum.ChatConversationMoreMenu,
			squadId = v44,
			squadLocation = v46.squadLocation
		})
	end, {
		v46.setSquadPrompt,
		t2.conversationId,
		v44,
		v46.squadLocation,
		v46.fireSquadAnalytics
	})
	local v61 = React.useCallback(function() -- line: 164
		-- upvalues: v44 (copy), t2 (copy), v45 (copy), v41 (copy), leaveSquad (copy), SquadPromptType (copy), v46 (copy), v47 (copy), EventNames (copy), SquadButtonSourceEnum (copy), SquadButtonClickIntentionEnum (copy)
		if v44 and t2.conversationId ~= v45 then
			v41(leaveSquad(SquadPromptType.JoinAnotherSquad, v46.setSquadPrompt, function() -- line: 167
				-- upvalues: t2 (copy)
				t2.navigateToSquadLobby(t2.conversationId)
			end, v46.squadLocation, v47))
		else
			t2.navigateToSquadLobby(t2.conversationId)
		end

		v46.fireSquadAnalytics(EventNames.EnterSquadButtonPressed, {
			conversationId = t2.conversationId,
			squadButtonSource = SquadButtonSourceEnum.ChatConversationMoreMenu,
			squadId = v44,
			squadLocation = v46.squadLocation,
			userIntention = if not t2.conversation or (not t2.conversation.hasGroupUp or t2.conversationId ~= v45) then if not t2.conversation or not t2.conversation.hasGroupUp then SquadButtonClickIntentionEnum.Create else SquadButtonClickIntentionEnum.Join else SquadButtonClickIntentionEnum.View
		})
	end, {
		t2.navigateToSquadLobby,
		t2.conversationId,
		t2.conversation and t2.conversation.hasGroupUp,
		v44,
		v45,
		v46,
		v47
	})
	local v62 = React.useCallback(function(p3) -- line: 199
		-- upvalues: v61 (copy), v60 (copy), v51 (copy)
		if p3 == "createJoinViewParty" then
			v61()
		elseif p3 == "scheduleParty" then
			v60()
		end

		v51(false)
	end, {
		v61,
		v60
	})
	local v63 = React.useCallback(function() -- line: 214
		-- upvalues: v40 (copy), ChatConversationTelemetryEvents (copy), v50 (copy), ConversationActionType (copy), v51 (copy)
		v40.emit(ChatConversationTelemetryEvents.ConversationMoreMenuBtnClicked, {
			action = if not v50 then ConversationActionType.OpenMoreMenu else ConversationActionType.CloseMoreMenu
		})
		v51(not v50)
	end, {
		v50,
		v40
	})
	local v64 = React.useCallback(function() -- line: 222
		-- upvalues: v53 (copy)
		v53(false)
	end, {})
	local v65 = React.useMemo(function() -- line: 227
		-- upvalues: t2 (copy), v45 (copy), v43 (copy), IconName (copy)
		local t3 = {}

		table.insert(t3, {
			icon = "icons/menu/groups",
			id = "createJoinViewParty",
			isDisabled = false,
			isChecked = false,
			text = if not t2.conversation or (not t2.conversation.hasGroupUp or t2.conversationId ~= v45) then if not t2.conversation or not t2.conversation.hasGroupUp then v43.startParty else v43.joinParty else v43.viewParty
		})
		table.insert(t3, {
			id = "scheduleParty",
			isDisabled = false,
			isChecked = false,
			icon = IconName.Calendar,
			text = v43.scheduleAParty
		})

		return t3
	end, {
		t2.conversation and t2.conversation.hasGroupUp,
		t2.conversationId,
		v45
	})
	local v66 = React.useRef(nil)

	return React.createElement(Foundation.View, {
		tag = "auto-xy align-y-center"
	}, {
		MoreMenuButton = React.createElement(Foundation.IconButton, {
			isCircular = true,
			testId = "ChatConversationMoreMenuButton",
			icon = {
				name = Foundation.Enums.IconName.PlusLarge,
				variant = if not v50 then Foundation.Enums.IconVariant.Regular else Foundation.Enums.IconVariant.Filled
			},
			variant = if not v50 then Foundation.Enums.ButtonVariant.Utility else Foundation.Enums.ButtonVariant.Standard,
			LayoutOrder = t2.layoutOrder,
			onActivated = v63,
			size = Foundation.Enums.InputSize.Medium,
			ref = v66
		}),
		ScheduledSquadSheet = React.createElement(ScheduledSquadSheet, {
			conversationId = t2.conversationId,
			isOpen = v48,
			onClose = function() -- line: 289
				-- upvalues: v49 (copy)
				v49(false)
			end
		}),
		Menu = React.createElement(Menu, {
			anchorRef = v66,
			items = v65,
			isOpen = v50,
			onActivated = v62,
			onPressedOutside = v59,
			ref = if not v37 then nil else v56,
			side = PopoverSide.Top
		}),
		Tooltip = React.createElement(Foundation.Popover.Root, {
			isOpen = v52
		}, {
			Anchor = React.createElement(Foundation.Popover.Anchor, {
				anchorRef = v66
			}),
			Content = React.createElement(Foundation.Popover.Content, {
				hasArrow = true,
				align = {
					offset = 0,
					position = PopoverAlign.Start
				},
				backgroundStyle = v42.Inverse.Surface.Surface_0,
				onPressedOutside = v64
			}, {
				TooltipText = React.createElement(Foundation.Text, {
					tag = "auto-xy text-wrap padding-small content-inverse-emphasis text-body-small",
					Text = t2.tooltipText
				})
			})
		})
	})
end)
