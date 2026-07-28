local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Foundation = require(AppChatParent.Foundation)
local FocusNavigationUtils = require(AppChatParent.FocusNavigationUtils)
local InputHandlers = require(AppChatParent.InputHandlers)
local React = require(AppChatParent.React)

require(AppChatParent.ReactFocusNavigation)

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
local FFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled

return React.memo(function(t1: {[any]: any}) -- line: 59
	-- upvalues: useTelemetry (copy), ChatConversationTelemetryLayer (copy), useDispatch (copy), useTokens (copy), useLocalization (copy), useCurrentSquadId (copy), useCurrentSquadParentChannelId (copy), React (copy), SquadExternalContractContext (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), useAppFocusRoot (copy), FocusNavigableSurfaceIdentifierEnum (copy), EventNames (copy), ScheduledSquadActionEnum (copy), ScheduledSquadActionSourceEnum (copy), leaveSquad (copy), SquadPromptType (copy), SquadButtonSourceEnum (copy), SquadButtonClickIntentionEnum (copy), ChatConversationTelemetryEvents (copy), ConversationActionType (copy), IconName (copy), Foundation (copy), ScheduledSquadSheet (copy), Menu (copy), PopoverSide (copy), PopoverAlign (copy)
	local v36 = useTelemetry(ChatConversationTelemetryLayer.Context)
	local v37 = useDispatch()
	local v38 = useTokens()
	local v39 = useLocalization({
		joinParty = "Feature.Squads.Label.JoinParty",
		moreText = "CommonUI.Features.Label.More",
		scheduleAParty = "Feature.Squads.Action.ScheduleAParty",
		startParty = "Feature.Squads.Label.StartParty",
		viewParty = "Feature.Squads.Label.ViewParty"
	})
	local v40 = useCurrentSquadId()
	local v41 = useCurrentSquadParentChannelId()
	local v42 = React.useContext(SquadExternalContractContext)
	local v43 = not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v42.useIsChatEnabled()
	local v44, v45 = React.useState(false)
	local v46, v47 = React.useState(false)
	local v48, v49 = React.useState(t1.tooltipText and t1.tooltipText ~= "")
	local v50 = React.useRef(nil)
	local v51 = React.useMemo(function() -- line: 83
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), v47 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p1) -- line: 86
					-- upvalues: v47 (copy)
					p1.cancelled = true
					v47(false)
				end)
			}
		}
	end, { v47 })
	local v52 = useAppFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isFocusable = v46,
		customEventHandlers = v51
	})
	local v53 = React.useCallback(function(p2) -- line: 101
		-- upvalues: v50 (copy), v52 (copy)
		v50.current = p2

		if type(v52) == "function" then
			v52(p2)
		end
	end, { v52 })

	React.useEffect(function() -- line: 108
		-- upvalues: v50 (copy)
		if v50 and v50.current then
			v50.current.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			v50.current.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
			v50.current.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
			v50.current.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			v50.current.SelectionGroup = true
		end
	end, { v46 })

	local v54 = React.useCallback(function() -- line: 119
		-- upvalues: v47 (copy)
		v47(false)
	end, {})
	local v55 = React.useCallback(function() -- line: 124
		-- upvalues: v45 (copy), v42 (copy), EventNames (copy), ScheduledSquadActionEnum (copy), t1 (copy), ScheduledSquadActionSourceEnum (copy), v40 (copy)
		v45(true)
		v42.fireSquadAnalytics(EventNames.ScheduledSquadAction, {
			actionType = ScheduledSquadActionEnum.ScheduleParty,
			conversationId = t1.conversationId,
			source = ScheduledSquadActionSourceEnum.ChatConversationMoreMenu,
			squadId = v40,
			squadLocation = v42.squadLocation
		})
	end, {
		v42.setSquadPrompt,
		t1.conversationId,
		v40,
		v42.squadLocation,
		v42.fireSquadAnalytics
	})
	local v56 = React.useCallback(function() -- line: 145
		-- upvalues: v40 (copy), t1 (copy), v41 (copy), v37 (copy), leaveSquad (copy), SquadPromptType (copy), v42 (copy), v43 (copy), EventNames (copy), SquadButtonSourceEnum (copy), SquadButtonClickIntentionEnum (copy)
		if v40 and t1.conversationId ~= v41 then
			v37(leaveSquad(SquadPromptType.JoinAnotherSquad, v42.setSquadPrompt, function() -- line: 148
				-- upvalues: t1 (copy)
				t1.navigateToSquadLobby(t1.conversationId)
			end, v42.squadLocation, v43))
		else
			t1.navigateToSquadLobby(t1.conversationId)
		end

		v42.fireSquadAnalytics(EventNames.EnterSquadButtonPressed, {
			conversationId = t1.conversationId,
			squadButtonSource = SquadButtonSourceEnum.ChatConversationMoreMenu,
			squadId = v40,
			squadLocation = v42.squadLocation,
			userIntention = if not t1.conversation or (not t1.conversation.hasGroupUp or t1.conversationId ~= v41) then if not t1.conversation or not t1.conversation.hasGroupUp then SquadButtonClickIntentionEnum.Create else SquadButtonClickIntentionEnum.Join else SquadButtonClickIntentionEnum.View
		})
	end, {
		t1.navigateToSquadLobby,
		t1.conversationId,
		t1.conversation and t1.conversation.hasGroupUp,
		v40,
		v41,
		v42,
		v43
	})
	local v57 = React.useCallback(function(p3) -- line: 180
		-- upvalues: v56 (copy), v55 (copy), v47 (copy)
		if p3 == "createJoinViewParty" then
			v56()
		elseif p3 == "scheduleParty" then
			v55()
		end

		v47(false)
	end, {
		v56,
		v55
	})
	local v58 = React.useCallback(function() -- line: 195
		-- upvalues: v36 (copy), ChatConversationTelemetryEvents (copy), v46 (copy), ConversationActionType (copy), v47 (copy)
		v36.emit(ChatConversationTelemetryEvents.ConversationMoreMenuBtnClicked, {
			action = if not v46 then ConversationActionType.OpenMoreMenu else ConversationActionType.CloseMoreMenu
		})
		v47(not v46)
	end, {
		v46,
		v36
	})
	local v59 = React.useCallback(function() -- line: 203
		-- upvalues: v49 (copy)
		v49(false)
	end, {})
	local v60 = React.useMemo(function() -- line: 208
		-- upvalues: t1 (copy), v41 (copy), v39 (copy), IconName (copy)
		local t2 = {}

		table.insert(t2, {
			icon = "icons/menu/groups",
			id = "createJoinViewParty",
			isDisabled = false,
			isChecked = false,
			text = if not t1.conversation or (not t1.conversation.hasGroupUp or t1.conversationId ~= v41) then if not t1.conversation or not t1.conversation.hasGroupUp then v39.startParty else v39.joinParty else v39.viewParty
		})
		table.insert(t2, {
			id = "scheduleParty",
			isDisabled = false,
			isChecked = false,
			icon = IconName.Calendar,
			text = v39.scheduleAParty
		})

		return t2
	end, {
		t1.conversation and t1.conversation.hasGroupUp,
		t1.conversationId,
		v41
	})
	local v61 = React.useRef(nil)

	return React.createElement(Foundation.View, {
		tag = "auto-xy align-y-center"
	}, {
		MoreMenuButton = React.createElement(Foundation.IconButton, {
			isCircular = true,
			testId = "ChatConversationMoreMenuButton",
			icon = {
				name = Foundation.Enums.IconName.PlusLarge,
				variant = if not v46 then Foundation.Enums.IconVariant.Regular else Foundation.Enums.IconVariant.Filled
			},
			variant = if not v46 then Foundation.Enums.ButtonVariant.Utility else Foundation.Enums.ButtonVariant.Standard,
			LayoutOrder = t1.layoutOrder,
			onActivated = v58,
			size = Foundation.Enums.InputSize.Medium,
			ref = v61
		}),
		ScheduledSquadSheet = React.createElement(ScheduledSquadSheet, {
			conversationId = t1.conversationId,
			isOpen = v44,
			onClose = function() -- line: 270
				-- upvalues: v45 (copy)
				v45(false)
			end
		}),
		Menu = React.createElement(Menu, {
			anchorRef = v61,
			items = v60,
			isOpen = v46,
			onActivated = v57,
			onPressedOutside = v54,
			ref = v53,
			side = PopoverSide.Top
		}),
		Tooltip = React.createElement(Foundation.Popover.Root, {
			isOpen = v48
		}, {
			Anchor = React.createElement(Foundation.Popover.Anchor, {
				anchorRef = v61
			}),
			Content = React.createElement(Foundation.Popover.Content, {
				hasArrow = true,
				align = {
					offset = 0,
					position = PopoverAlign.Start
				},
				backgroundStyle = v38.Inverse.Surface.Surface_0,
				onPressedOutside = v59
			}, {
				TooltipText = React.createElement(Foundation.Text, {
					tag = "auto-xy text-wrap padding-small content-inverse-emphasis text-body-small",
					Text = t1.tooltipText
				})
			})
		})
	})
end)
