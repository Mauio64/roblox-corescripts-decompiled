local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InputHandlers")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")
local SquadExternalContractProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/SquadExternalContractProvider")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization

local ChatDetailsTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatDetailsTelemetryLayer")
local ConversationActionType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/Enums/ConversationActionType")
local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")

local ChatConversationTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/ChatConversationTelemetryEvents")

local leaveSquad = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Thunks").leaveSquad
local squadPromptType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Enums").SquadPromptType
local useCurrentSquadId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Hooks").useCurrentSquadId
local useCurrentSquadParentChannelId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Hooks").useCurrentSquadParentChannelId
local squadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/EventNames")

local module12 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/ScheduledSquadSheet")
local scheduledSquadActionEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/Enums").ScheduledSquadActionEnum
local scheduledSquadActionSourceEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/Enums").ScheduledSquadActionSourceEnum
local squadButtonClickIntentionEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/Enums").SquadButtonClickIntentionEnum
local squadButtonSourceEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Squads/Enums").SquadButtonSourceEnum

local iconName = Foundation.Enums.IconName
local menu = Foundation.Menu
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide
local useTokens = Foundation.Hooks.useTokens

local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot

local fFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled

return React.memo(function(props)
	local v5 = useTelemetry(ChatDetailsTelemetryLayer.Context)
	local v6 = useDispatch()
	local v7 = useTokens()
	local v8 = useLocalization({
		joinParty = "Feature.Squads.Label.JoinParty",
		moreText = "CommonUI.Features.Label.More",
		scheduleAParty = "Feature.Squads.Action.ScheduleAParty",
		startParty = "Feature.Squads.Label.StartParty",
		viewParty = "Feature.Squads.Label.ViewParty"
	})

	local v9 = useCurrentSquadId()
	local v10 = useCurrentSquadParentChannelId()
	local v11 = React.useContext(squadExternalContractContext)

	local v12 = not fFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v11.useIsChatEnabled()

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(props.tooltipText and props.tooltipText ~= "")

	local ref = React.useRef(nil)

	local v13 = React.useMemo(function()
		local v14 = {}
		v14[focusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(p2)
				p2.cancelled = true
				setState2(false)
			end)
		}

		return v14
	end, { setState2 })

	local v14 = useAppFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isFocusable = state2,
		customEventHandlers = v13
	})

	local v15 = React.useCallback(function(current)
		ref.current = current

		if type(v14) == "function" then
			v14(current)
		end
	end, { v14 })

	React.useEffect(function()
		if ref and ref.current then
			ref.current.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			ref.current.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
			ref.current.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
			ref.current.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			ref.current.SelectionGroup = true
		end
	end, { state2 })

	local v16 = React.useCallback(function()
		setState2(false)
	end, {})

	local v17 = React.useCallback(function()
		setState(true)

		v11.fireSquadAnalytics(EventNames.ScheduledSquadAction, {
			actionType = scheduledSquadActionEnum.ScheduleParty,
			conversationId = props.conversationId,
			source = scheduledSquadActionSourceEnum.ChatConversationMoreMenu,
			squadId = v9,
			squadLocation = v11.squadLocation
		})
	end, {
		v11.setSquadPrompt,
		props.conversationId,
		v9,
		v11.squadLocation,
		v11.fireSquadAnalytics
	})

	local v18 = React.useCallback(function()
		if v9 and props.conversationId ~= v10 then
			v6(leaveSquad(squadPromptType.JoinAnotherSquad, v11.setSquadPrompt, function()
				props.navigateToSquadLobby(props.conversationId)
			end, v11.squadLocation, v12))
		else
			props.navigateToSquadLobby(props.conversationId)
		end

		local fireSquadAnalytics = v11.fireSquadAnalytics
		local enterSquadButtonPressed = EventNames.EnterSquadButtonPressed
		local v19 = {
			conversationId = props.conversationId,
			squadButtonSource = squadButtonSourceEnum.ChatConversationMoreMenu,
			squadId = v9,
			squadLocation = v11.squadLocation,
			userIntention = 0
		}
		local v20

		if props.conversation and props.conversation.hasGroupUp and props.conversationId == v10 then
			v20 = squadButtonClickIntentionEnum.View
		elseif props.conversation and props.conversation.hasGroupUp then
			v20 = squadButtonClickIntentionEnum.Join
		else
			v20 = squadButtonClickIntentionEnum.Create
		end

		v19.userIntention = v20
		fireSquadAnalytics(enterSquadButtonPressed, v19)
	end, {
		props.navigateToSquadLobby,
		props.conversationId,
		props.conversation and props.conversation.hasGroupUp,
		v9,
		v10,
		v11,
		v12
	})

	local v19 = React.useCallback(function(p2)
		if p2 == "createJoinViewParty" then
			v18()
		elseif p2 == "scheduleParty" then
			v17()
		end

		setState2(false)
	end, { v18, v17 })

	local v20 = React.useCallback(function()
		local emit = v5.emit
		local conversationMoreMenuBtnClicked = ChatConversationTelemetryEvents.ConversationMoreMenuBtnClicked
		local v22 = if state2 then ConversationActionType.CloseMoreMenu else ConversationActionType.OpenMoreMenu
		emit(conversationMoreMenuBtnClicked, { action = v22 })

		setState2(not state2)
	end, { state2, v5 })

	local v21 = React.useCallback(function()
		setState3(false)
	end, {})

	local v22 = React.useMemo(function()
		local v23 = {}
		local v25

		if props.conversation and props.conversation.hasGroupUp and props.conversationId == v10 then
			v25 = v8.viewParty
		elseif props.conversation and props.conversation.hasGroupUp then
			v25 = v8.joinParty
		else
			v25 = v8.startParty
		end

		table.insert(v23, {
			icon = "icons/menu/groups",
			id = "createJoinViewParty",
			isDisabled = false,
			isChecked = false,
			text = v25
		})

		table.insert(v23, {
			icon = iconName.Calendar,
			id = "scheduleParty",
			isDisabled = false,
			isChecked = false,
			text = v8.scheduleAParty
		})

		return v23
	end, { props.conversation and props.conversation.hasGroupUp, props.conversationId, v10 })

	local ref2 = React.useRef(nil)
	local createElement = React.createElement
	local view = Foundation.View

	local createElement2 = React.createElement
	local iconButton = Foundation.IconButton
	local v25 = { name = Foundation.Enums.IconName.PlusLarge, variant = 0 }

	local v26 = if state2 then Foundation.Enums.IconVariant.Filled else Foundation.Enums.IconVariant.Regular
	v25.variant = v26

	local v27 = if state2 then Foundation.Enums.ButtonVariant.Standard else Foundation.Enums.ButtonVariant.Utility
	return createElement(view, { tag = "auto-xy align-y-center" }, {
		MoreMenuButton = createElement2(iconButton, {
			icon = v25,
			variant = v27,
			isCircular = true,
			LayoutOrder = props.layoutOrder,
			onActivated = v20,
			size = Foundation.Enums.InputSize.Medium,
			testId = "ChatConversationMoreMenuButton",
			ref = ref2
		}),
		ScheduledSquadSheet = React.createElement(module12, {
			conversationId = props.conversationId,
			isOpen = state,
			onClose = function()
				setState(false)
			end
		}),
		Menu = React.createElement(menu, {
			anchorRef = ref2,
			items = v22,
			isOpen = state2,
			onActivated = v19,
			onPressedOutside = v16,
			ref = v15,
			side = popoverSide.Top
		}),
		Tooltip = React.createElement(Foundation.Popover.Root, { isOpen = state3 }, {
			Anchor = React.createElement(Foundation.Popover.Anchor, { anchorRef = ref2 }),
			Content = React.createElement(Foundation.Popover.Content, {
				align = { position = popoverAlign.Start, offset = 0 },
				backgroundStyle = v7.Inverse.Surface.Surface_0,
				hasArrow = true,
				onPressedOutside = v21
			}, {
				TooltipText = React.createElement(Foundation.Text, {
					Text = props.tooltipText,
					tag = "auto-xy text-wrap padding-small content-inverse-emphasis text-body-small"
				})
			})
		})
	})
end)
