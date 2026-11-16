local LocalizationService = game:GetService("LocalizationService")

local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent
local FFlagSquadsUseProfileFrameThumbnail = require(Squads.Flags.FFlagSquadsUseProfileFrameThumbnail)
local FFlagSquadsEnableFoundationTestIds = require(Squads.Flags.FFlagSquadsEnableFoundationTestIds)

local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
require(parent.SquadsCore.Types)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local RoactUtils2 = require(parent.RoactUtils)
local useStore = RoactUtils2.Hooks.RoactRodux.useStore
local UserProfiles = require(parent.UserProfiles)

local UserProfileStore = UserProfiles.Stores.UserProfileStore

local Avatar = Foundation.Avatar
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local Sheet = Foundation.Sheet
local Text = Foundation.Text
local View = Foundation.View

local Thunks = require(parent.SquadsCore.Thunks)
local deleteScheduledSquad = Thunks.deleteScheduledSquad
local EventNames = require(parent.SquadsCore.EventNames)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local Enums = require(parent.SquadsCore.Enums)
local SquadPromptType = Enums.SquadPromptType
local NetworkRequests = require(parent.SquadsCore.NetworkRequests)
local subscribeToScheduledSquad = NetworkRequests.subscribeToScheduledSquad
local NetworkRequests2 = require(parent.SquadsCore.NetworkRequests)
local unsubscribeFromScheduledSquad = NetworkRequests2.unsubscribeFromScheduledSquad
local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadId = Hooks.useCurrentSquadId

local ScheduledSquadSheet = require(Squads.Components.ScheduledSquads.ScheduledSquadSheet)
local ScheduledSquadActionEnum = require(Squads.Enums.ScheduledSquadActionEnum)
local ScheduledSquadActionSourceEnum = require(Squads.Enums.ScheduledSquadActionSourceEnum)

local function ScheduledSquadsMoreInfoSheet(props)
	local v = useDispatch()
	local v2 = useLocalUserId()
	local v3 = React.useContext(SquadExternalContractContext)
	local squadId = useCurrentSquadId()
	local v4 = useStore()
	local v5 = v3.useGetConversationFromId(props.scheduledSquad.parentChannelId)

	local dateTime = DateTime.fromIsoDate(props.scheduledSquad.startTime)
	local v6 = dateTime and dateTime.UnixTimestamp < DateTime.now().UnixTimestamp

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(props.scheduledSquad.subscribers)

	local v7 = React.useMemo(function()
		return Cryo.List.map(state2, function(p)
			return (tostring(p.userId))
		end)
	end, { state2 })

	React.useEffect(function()
		setState2(props.scheduledSquad.subscribers)
	end, { props.scheduledSquad.subscribers })

	local v8 = tostring(props.scheduledSquad.initiatorId) == tostring(v2)
	local v9 = React.useMemo(function()
		return v8 or Cryo.List.findWhere(v7, function(p): boolean
			return p == tostring(v2)
		end) ~= nil
	end, { v8, v2, v7 })

	local state3, setState3 = React.useState({})
	local state4, setState4 = React.useState(true)

	local onClose = React.useCallback(function()
		setState(false)

		if props.onClose then
			props.onClose()
		end
	end, { props.onClose })

	local v10 = React.useCallback(function()
		onClose()
		v3.setSquadPrompt(v4, { hideCancelButton = true, promptType = SquadPromptType.Error })
	end, { onClose, v3.setSquadPrompt, v4 })

	local useEffect = React.useEffect
	local function fn()
		setState4(true)
		UserProfileStore.get().fetchNamesByUserIds(Cryo.List.join(v7, v5 and v5.participants or {}), function(p)
			if p.status == "success" then
				local v11 = {}

				for _, v12 in p.data do
					v11[v12.userId] = v12.names.getCombinedName(false)
				end

				setState3(v11)
				setState4(false)
			elseif p.status == "failed" then
				setState4(false)
				onClose()
				v10()
			end
		end)
	end

	local setSquadPrompt = v3.setSquadPrompt
	local v11

	if v5 then
		v11 = v5.participants or nil
	end

	useEffect(fn, { onClose, v10, setState4, v7, setSquadPrompt, v4, v11 })

	local v12 = useLocalization({
		deleteText = "Feature.Squads.Action.Delete",
		dontJoinText = "Feature.Squads.Action.DontJoin",
		editText = "Feature.Squads.Action.Edit",
		goingText = "Feature.Squads.Description.Going",
		joinText = "Feature.Squads.Action.Join",
		notGoingText = "Feature.Squads.Description.NotGoing",
		partyText = "Feature.Squads.Label.Party",
		usersPartyText = {
			"Feature.Squads.Label.UsersParty",
			displayName = state3[tostring(props.scheduledSquad.initiatorId)]
		},
		willYouJoinScheduledPartyText = {
			"Feature.Squads.Label.WillYouJoinScheduledParty",
			displayName = state3[tostring(props.scheduledSquad.initiatorId)]
		}
	})

	local v13 = React.useMemo(function()
		local children = {}

		for _, v13 in state2 do
			local formatted = `--social-squad-scheduled-party-info-sheet--going-user-{v13.userId}`

			local createElement = React.createElement
			local testId

			if FFlagSquadsEnableFoundationTestIds then
				testId = formatted
			end

			local createElement2 = React.createElement
			local v14 = {
				LayoutOrder = 1,
				userId = v13.userId,
				includeProfileFrame = FFlagSquadsUseProfileFrameThumbnail,
				testId = 0
			}
			local testId2

			if FFlagSquadsEnableFoundationTestIds then
				testId2 = `{formatted}--avatar`
			end

			v14.testId = testId2
			local children2 = { Avatar = createElement2(Avatar, v14), DisplayName = 0 }

			local createElement3 = React.createElement
			local v15 = {
				LayoutOrder = 2,
				Text = state3[tostring(v13.userId)],
				tag = "auto-xy fill text-truncate-end text-title-medium text-align-x-left",
				testId = 0
			}
			local testId3

			if FFlagSquadsEnableFoundationTestIds then
				testId3 = `{formatted}--name`
			end

			v15.testId = testId3
			children2.DisplayName = createElement3(Text, v15)
			table.insert(
				children,
				createElement(
					View,
					{
						tag = "size-full-0 auto-y row align-x-left align-y-center gap-small",
						testId = testId
					},
					children2
				)
			)
		end

		return children
	end, { state3, state2 })

	local v14 = React.useMemo(function()
		local children = {}

		if not (v5 and v5.participants) then
			return children
		end

		local set = Cryo.List.toSet(v7)

		for _, participant in v5.participants do
			if set[tostring(participant)] then
				continue
			end

			local formatted = `--social-squad-scheduled-party-info-sheet--not-going-user-{participant}`

			local createElement = React.createElement
			local testId

			if FFlagSquadsEnableFoundationTestIds then
				testId = formatted
			end

			local createElement2 = React.createElement
			local v14 = {
				LayoutOrder = 1,
				userId = participant,
				includeProfileFrame = FFlagSquadsUseProfileFrameThumbnail,
				testId = 0
			}
			local testId2

			if FFlagSquadsEnableFoundationTestIds then
				testId2 = `{formatted}--avatar`
			end

			v14.testId = testId2
			local children2 = { Avatar = createElement2(Avatar, v14), DisplayName = 0 }

			local createElement3 = React.createElement
			local v15 = {
				LayoutOrder = 2,
				Text = state3[tostring(participant)],
				tag = "auto-xy fill text-truncate-end text-title-medium text-align-x-left",
				testId = 0
			}
			local testId3

			if FFlagSquadsEnableFoundationTestIds then
				testId3 = `{formatted}--name`
			end

			v15.testId = testId3
			children2.DisplayName = createElement3(Text, v15)
			table.insert(
				children,
				createElement(
					View,
					{
						tag = "size-full-0 auto-y row align-x-left align-y-center gap-small padding-y-small",
						testId = testId
					},
					children2
				)
			)
		end

		return children
	end, { state3, v7, v5 and v5.participants })

	local onActivated = React.useCallback(function()
		onClose()
		v(deleteScheduledSquad(props.scheduledSquad.scheduledGroupUpId, v3.setSquadPrompt))

		v3.fireSquadAnalytics(EventNames.ScheduledSquadAction, {
			actionType = ScheduledSquadActionEnum.Delete,
			conversationId = props.scheduledSquad.parentChannelId,
			scheduledSquadId = props.scheduledSquad.scheduledGroupUpId,
			source = ScheduledSquadActionSourceEnum.ScheduledSquadsMoreInfoSheet,
			squadId = squadId,
			squadLocation = v3.squadLocation
		})
	end, {
		squadId,
		onClose,
		props.scheduledSquad.parentChannelId,
		props.scheduledSquad.scheduledGroupUpId,
		v3.fireSquadAnalytics,
		v3.setSquadPrompt,
		v3.squadLocation,
		v4
	})

	local function fn2()
		setState2(Cryo.List.filter(state2, function(p): boolean
			return tostring(p.userId) ~= tostring(v2)
		end))
	end

	local function fn3()
		setState2(Cryo.List.join(state2, {
			{ userId = tostring(v2) }
		}))
	end

	local onActivated2 = React.useCallback(function()
		if v9 then
			unsubscribeFromScheduledSquad({
				scheduledGroupUpId = props.scheduledSquad.scheduledGroupUpId
			}, fn2, v10)
		else
			subscribeToScheduledSquad({
				scheduledGroupUpId = props.scheduledSquad.scheduledGroupUpId
			}, fn3, v10)
		end

		onClose()
		local fireSquadAnalytics = v3.fireSquadAnalytics
		local scheduledSquadAction = EventNames.ScheduledSquadAction
		local actionType

		if v9 then
			actionType = ScheduledSquadActionEnum.Unsubscribe
		else
			actionType = ScheduledSquadActionEnum.Subscribe
		end

		fireSquadAnalytics(scheduledSquadAction, {
			actionType = actionType,
			conversationId = props.scheduledSquad.parentChannelId,
			scheduledSquadId = props.scheduledSquad.scheduledGroupUpId,
			source = ScheduledSquadActionSourceEnum.ScheduledSquadsMoreInfoSheet,
			squadId = squadId,
			squadLocation = v3.squadLocation
		})
	end, {
		v9,
		v3.squadLocation,
		squadId,
		props.scheduledSquad,
		v3.fireSquadAnalytics,
		onClose,
		v10,
		fn2,
		fn3,
		squadId
	})

	local onActivated3 = React.useCallback(function()
		setState(true)

		v3.fireSquadAnalytics(EventNames.ScheduledSquadAction, {
			actionType = ScheduledSquadActionEnum.Edit,
			conversationId = props.scheduledSquad.parentChannelId,
			scheduledSquadId = props.scheduledSquad.scheduledGroupUpId,
			source = ScheduledSquadActionSourceEnum.ScheduledSquadsMoreInfoSheet,
			squadId = squadId,
			squadLocation = v3.squadLocation
		})
	end, { squadId, props.scheduledSquad, v3.fireSquadAnalytics, v3.squadLocation })

	if state then
		return React.createElement(ScheduledSquadSheet, {
			isOpen = props.isOpen,
			onClose = onClose,
			scheduledSquad = props.scheduledSquad,
			snapPoints = { 0.4, 0.7 }
		})
	end

	local createElement = React.createElement
	local root = Sheet.Root
	local v15 = {
		onClose = onClose,
		isOpen = props.isOpen,
		preferCenterSheet = true,
		snapPoints = { 0.4, 0.7 },
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-info-sheet" or nil
	}

	local createElement2 = React.createElement
	local header = Sheet.Header
	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local text

	if v6 or not v9 then
		if v6 or v9 then
			text = v12.partyText
		else
			text = v12.willYouJoinScheduledPartyText
		end
	else
		text = v12.usersPartyText
	end

	local children = {
		Header = createElement2(header, {}, {
			View = createElement3(View, { tag = "size-full-0 auto-y col" }, {
				ScheduledSquadTitle = createElement4(Text, {
					LayoutOrder = 1,
					Text = text,
					tag = "size-full-0 auto-y text-heading-medium text-align-x-left text-truncate-end",
					testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-info-sheet--title" or nil
				}),
				DateTime = React.createElement(Text, {
					LayoutOrder = 2,
					Text = not dateTime and "" or dateTime:FormatLocalTime("LLL", LocalizationService.RobloxLocaleId),
					tag = "size-full-0 auto-y text-body-medium text-align-x-left",
					testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-info-sheet--date-time" or nil
				})
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement5 = React.createElement
	local content = Sheet.Content
	local loading

	if state4 then
		loading = React.createElement(Foundation.Loading, {
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-info-sheet--loading" or nil
		})
	end

	local view

	if not state4 then
		view = React.createElement(View, {
			tag = "size-full-0 auto-y col gap-small padding-y-small"
		}, {
			SubscribedUsersText = React.createElement(Text, {
				LayoutOrder = 1,
				Text = `{v12.goingText}`,
				tag = "size-full-0 auto-y content-emphasis text-align-x-left",
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-info-sheet--going-label" or nil
			}),
			SubscribedUsers = React.createElement(
				View,
				{ LayoutOrder = 2, tag = "size-full-0 auto-y col gap-small" },
				unpack(v13)
			),
			NotSubscribedUsersText = React.createElement(Text, {
				LayoutOrder = 3,
				Text = `{v12.notGoingText}`,
				tag = "size-full-0 auto-y content-emphasis text-align-x-left",
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-info-sheet--not-going-label" or nil
			}),
			NotSubscribedUsers = React.createElement(
				View,
				{ LayoutOrder = 4, tag = "size-full-0 auto-y col gap-small" },
				unpack(v14)
			)
		})
	end

	children.Content = createElement5(content, {}, { Loading = loading, View = view })
	local actions2

	if not v6 then
		local createElement6 = React.createElement
		local actions = Sheet.Actions
		local createElement7 = React.createElement
		local joinButton

		if not (v8 or v9) then
			joinButton = React.createElement(Button, {
				LayoutOrder = 1,
				onActivated = onActivated2,
				text = v12.joinText,
				variant = ButtonVariant.Emphasis,
				width = UDim.new(1, 0),
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-info-sheet--join-button" or nil
			})
		end

		local dontJoinButton

		if not (v8 or not v9) then
			dontJoinButton = React.createElement(Button, {
				LayoutOrder = 2,
				onActivated = onActivated2,
				text = v12.dontJoinText,
				variant = ButtonVariant.Standard,
				width = UDim.new(1, 0),
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-info-sheet--dont-join-button" or nil
			})
		end

		local editButton

		if v8 then
			editButton = React.createElement(Button, {
				LayoutOrder = 3,
				onActivated = onActivated3,
				text = v12.editText,
				variant = ButtonVariant.Standard,
				width = UDim.new(1, 0),
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-info-sheet--edit-button" or nil
			})
		end

		local deleteButton

		if v8 then
			deleteButton = React.createElement(Button, {
				LayoutOrder = 4,
				onActivated = onActivated,
				text = v12.deleteText,
				variant = ButtonVariant.Alert,
				width = UDim.new(1, 0),
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-info-sheet--delete-button" or nil
			})
		end

		actions2 = createElement6(actions, {}, {
			createElement7(View, { tag = "size-full-0 auto-y col gap-small" }, {
				JoinButton = joinButton,
				DontJoinButton = dontJoinButton,
				EditButton = editButton,
				DeleteButton = deleteButton
			})
		})
	end

	children.Actions = actions2
	return (createElement(root, v15, children))
end

return ScheduledSquadsMoreInfoSheet
