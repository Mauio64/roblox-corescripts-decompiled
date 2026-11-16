local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Foundation = require(parent.Foundation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local React = require(parent.React)
require(parent.ReactFocusNavigation)
local SharedFlags = require(parent.SharedFlags)
local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local ChatConversationTelemetryLayer = require(AppChat.Telemetry.Layers.ChatConversationTelemetryLayer)
local ConversationActionType = require(AppChat.Analytics.Enums.ConversationActionType)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)

local ChatConversationTelemetryEvents = require(script.Parent.ChatConversationTelemetryEvents)

local Thunks = require(parent.SquadsCore.Thunks)
local leaveSquad = Thunks.leaveSquad
local Enums = require(parent.SquadsCore.Enums)
local SquadPromptType = Enums.SquadPromptType
local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadId = Hooks.useCurrentSquadId
local Hooks2 = require(parent.SquadsCore.Hooks)
local useCurrentSquadParentChannelId = Hooks2.useCurrentSquadParentChannelId
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local EventNames = require(parent.SquadsCore.EventNames)

local ScheduledSquadSheet = require(parent.Squads.ScheduledSquadSheet)
local Enums2 = require(parent.Squads.Enums)
local ScheduledSquadActionEnum = Enums2.ScheduledSquadActionEnum
local Enums3 = require(parent.Squads.Enums)
local ScheduledSquadActionSourceEnum = Enums3.ScheduledSquadActionSourceEnum
local Enums4 = require(parent.Squads.Enums)
local SquadButtonClickIntentionEnum = Enums4.SquadButtonClickIntentionEnum
local Enums5 = require(parent.Squads.Enums)
local SquadButtonSourceEnum = Enums5.SquadButtonSourceEnum

local IconName = Foundation.Enums.IconName
local Menu = Foundation.Menu
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local useTokens = Foundation.Hooks.useTokens

local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot

local FFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled

return React.memo(function(props)
	local v = useTelemetry(ChatConversationTelemetryLayer.Context)
	local v2 = useDispatch()
	local v3 = useTokens()
	local v4 = useLocalization({
		joinParty = "Feature.Squads.Label.JoinParty",
		moreText = "CommonUI.Features.Label.More",
		scheduleAParty = "Feature.Squads.Action.ScheduleAParty",
		startParty = "Feature.Squads.Label.StartParty",
		viewParty = "Feature.Squads.Label.ViewParty"
	})

	local squadId = useCurrentSquadId()
	local v5 = useCurrentSquadParentChannelId()
	local v6 = React.useContext(SquadExternalContractContext)

	local v7 = not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v6.useIsChatEnabled()

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)
	local state3, setState3 = React.useState(props.tooltipText and props.tooltipText ~= "")

	local ref = React.useRef(nil)

	local customEventHandlers = React.useMemo(function()
		local v8 = {}
		v8[FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(p)
				p.cancelled = true
				setState2(false)
			end)
		}

		return v8
	end, { setState2 })

	local v8 = useAppFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isFocusable = state2,
		customEventHandlers = customEventHandlers
	})

	local ref3 = React.useCallback(function(current)
		ref.current = current

		if type(v8) == "function" then
			v8(current)
		end
	end, { v8 })

	React.useEffect(function()
		if ref and ref.current then
			ref.current.SelectionBehaviorDown = Enum.SelectionBehavior.Stop
			ref.current.SelectionBehaviorLeft = Enum.SelectionBehavior.Stop
			ref.current.SelectionBehaviorRight = Enum.SelectionBehavior.Stop
			ref.current.SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			ref.current.SelectionGroup = true
		end
	end, { state2 })

	local onPressedOutside = React.useCallback(function()
		setState2(false)
	end, {})

	local v9 = React.useCallback(function()
		setState(true)

		v6.fireSquadAnalytics(EventNames.ScheduledSquadAction, {
			actionType = ScheduledSquadActionEnum.ScheduleParty,
			conversationId = props.conversationId,
			source = ScheduledSquadActionSourceEnum.ChatConversationMoreMenu,
			squadId = squadId,
			squadLocation = v6.squadLocation
		})
	end, {
		v6.setSquadPrompt,
		props.conversationId,
		squadId,
		v6.squadLocation,
		v6.fireSquadAnalytics
	})

	local v10 = React.useCallback(function()
		if squadId and props.conversationId ~= v5 then
			v2(leaveSquad(SquadPromptType.JoinAnotherSquad, v6.setSquadPrompt, function()
				props.navigateToSquadLobby(props.conversationId)
			end, v6.squadLocation, v7))
		else
			props.navigateToSquadLobby(props.conversationId)
		end

		local fireSquadAnalytics = v6.fireSquadAnalytics
		local enterSquadButtonPressed = EventNames.EnterSquadButtonPressed
		local v10 = {
			conversationId = props.conversationId,
			squadButtonSource = SquadButtonSourceEnum.ChatConversationMoreMenu,
			squadId = squadId,
			squadLocation = v6.squadLocation,
			userIntention = 0
		}
		local userIntention

		if props.conversation and props.conversation.hasGroupUp and props.conversationId == v5 then
			userIntention = SquadButtonClickIntentionEnum.View
		elseif props.conversation and props.conversation.hasGroupUp then
			userIntention = SquadButtonClickIntentionEnum.Join
		else
			userIntention = SquadButtonClickIntentionEnum.Create
		end

		v10.userIntention = userIntention
		fireSquadAnalytics(enterSquadButtonPressed, v10)
	end, {
		props.navigateToSquadLobby,
		props.conversationId,
		props.conversation and props.conversation.hasGroupUp,
		squadId,
		v5,
		v6,
		v7
	})

	local onActivated = React.useCallback(function(p)
		if p == "createJoinViewParty" then
			v10()
		elseif p == "scheduleParty" then
			v9()
		end

		setState2(false)
	end, { v10, v9 })

	local onActivated2 = React.useCallback(function()
		local emit = v.emit
		local conversationMoreMenuBtnClicked = ChatConversationTelemetryEvents.ConversationMoreMenuBtnClicked
		local action

		if state2 then
			action = ConversationActionType.CloseMoreMenu
		else
			action = ConversationActionType.OpenMoreMenu
		end

		emit(conversationMoreMenuBtnClicked, { action = action })

		setState2(not state2)
	end, { state2, v })

	local onPressedOutside2 = React.useCallback(function()
		setState3(false)
	end, {})

	local items = React.useMemo(function()
		local v11 = {}
		local text

		if props.conversation and props.conversation.hasGroupUp and props.conversationId == v5 then
			text = v4.viewParty
		elseif props.conversation and props.conversation.hasGroupUp then
			text = v4.joinParty
		else
			text = v4.startParty
		end

		table.insert(v11, {
			icon = "icons/menu/groups",
			id = "createJoinViewParty",
			isDisabled = false,
			isChecked = false,
			text = text
		})

		table.insert(v11, {
			icon = IconName.Calendar,
			id = "scheduleParty",
			isDisabled = false,
			isChecked = false,
			text = v4.scheduleAParty
		})

		return v11
	end, { props.conversation and props.conversation.hasGroupUp, props.conversationId, v5 })

	local ref2 = React.useRef(nil)
	local createElement = React.createElement
	local view = Foundation.View

	local createElement2 = React.createElement
	local iconButton = Foundation.IconButton
	local icon = { name = Foundation.Enums.IconName.PlusLarge, variant = 0 }
	local variant

	if state2 then
		variant = Foundation.Enums.IconVariant.Filled
	else
		variant = Foundation.Enums.IconVariant.Regular
	end

	icon.variant = variant
	local variant2

	if state2 then
		variant2 = Foundation.Enums.ButtonVariant.Standard
	else
		variant2 = Foundation.Enums.ButtonVariant.Utility
	end

	return createElement(view, { tag = "auto-xy align-y-center" }, {
		MoreMenuButton = createElement2(iconButton, {
			icon = icon,
			variant = variant2,
			isCircular = true,
			LayoutOrder = props.layoutOrder,
			onActivated = onActivated2,
			size = Foundation.Enums.InputSize.Medium,
			testId = "ChatConversationMoreMenuButton",
			ref = ref2
		}),
		ScheduledSquadSheet = React.createElement(ScheduledSquadSheet, {
			conversationId = props.conversationId,
			isOpen = state,
			onClose = function()
				setState(false)
			end
		}),
		Menu = React.createElement(Menu, {
			anchorRef = ref2,
			items = items,
			isOpen = state2,
			onActivated = onActivated,
			onPressedOutside = onPressedOutside,
			ref = ref3,
			side = PopoverSide.Top
		}),
		Tooltip = React.createElement(Foundation.Popover.Root, { isOpen = state3 }, {
			Anchor = React.createElement(Foundation.Popover.Anchor, { anchorRef = ref2 }),
			Content = React.createElement(Foundation.Popover.Content, {
				align = { position = PopoverAlign.Start, offset = 0 },
				backgroundStyle = v3.Inverse.Surface.Surface_0,
				hasArrow = true,
				onPressedOutside = onPressedOutside2
			}, {
				TooltipText = React.createElement(Foundation.Text, {
					Text = props.tooltipText,
					tag = "auto-xy text-wrap padding-small content-inverse-emphasis text-body-small"
				})
			})
		})
	})
end)
