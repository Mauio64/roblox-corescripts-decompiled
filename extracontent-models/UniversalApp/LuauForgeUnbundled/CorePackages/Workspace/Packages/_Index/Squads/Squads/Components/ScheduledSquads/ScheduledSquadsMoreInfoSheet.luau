local LocalizationService = game:GetService("LocalizationService")

local FFlagSquadsUseProfileFrameThumbnail = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadsUseProfileFrameThumbnail")
local FFlagSquadsEnableFoundationTestIds = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadsEnableFoundationTestIds")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/React")
local SquadExternalContractProvider = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider")
require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Types")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RoactUtils").Hooks.RoactRodux.useDispatch
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RobloxAppHooks").useLocalUserId
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Localization").Hooks.useLocalization
local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RoactUtils").Hooks.RoactRodux.useStore
local userProfileStore = require("@game/CorePackages/Workspace/Packages/_Index/Squads/UserProfiles").Stores.UserProfileStore

local avatar = Foundation.Avatar
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local sheet = Foundation.Sheet
local text = Foundation.Text
local view = Foundation.View

local deleteScheduledSquad = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Thunks").deleteScheduledSquad
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/EventNames")
local squadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local squadPromptType = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums").SquadPromptType
local subscribeToScheduledSquad = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/NetworkRequests").subscribeToScheduledSquad
local unsubscribeFromScheduledSquad = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/NetworkRequests").unsubscribeFromScheduledSquad
local useCurrentSquadId = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks").useCurrentSquadId

local ScheduledSquadSheet = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/ScheduledSquads/ScheduledSquadSheet")
local ScheduledSquadActionEnum = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/ScheduledSquadActionEnum")
local ScheduledSquadActionSourceEnum = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/ScheduledSquadActionSourceEnum")

local function ScheduledSquadsMoreInfoSheet(props)
	local v5 = useDispatch()
	local v6 = useLocalUserId()
	local v7 = React.useContext(squadExternalContractContext)
	local v8 = useCurrentSquadId()
	local v9 = useStore()
	local v10 = v7.useGetConversationFromId(props.scheduledSquad.parentChannelId)

	local dateTime = DateTime.fromIsoDate(props.scheduledSquad.startTime)
	local v11 = dateTime and dateTime.UnixTimestamp < DateTime.now().UnixTimestamp

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(props.scheduledSquad.subscribers)

	local v12 = React.useMemo(function()
		return Cryo.List.map(state2, function(p2)
			return (tostring(p2.userId))
		end)
	end, { state2 })

	React.useEffect(function()
		setState2(props.scheduledSquad.subscribers)
	end, { props.scheduledSquad.subscribers })

	local v13 = tostring(props.scheduledSquad.initiatorId) == tostring(v6)
	local v14 = React.useMemo(function()
		return v13 or Cryo.List.findWhere(v12, function(p2): boolean
			return p2 == tostring(v6)
		end) ~= nil
	end, { v13, v6, v12 })

	local state3, setState3 = React.useState({})
	local state4, setState4 = React.useState(true)

	local v15 = React.useCallback(function()
		setState(false)

		if props.onClose then
			props.onClose()
		end
	end, { props.onClose })

	local v16 = React.useCallback(function()
		v15()
		v7.setSquadPrompt(v9, {
			hideCancelButton = true,
			promptType = squadPromptType.Error
		})
	end, { v15, v7.setSquadPrompt, v9 })

	local useEffect = React.useEffect
	local function fn()
		setState4(true)
		userProfileStore.get().fetchNamesByUserIds(
			Cryo.List.join(v12, v10 and v10.participants or {}),
			function(p2)
				if p2.status == "success" then
					local v17 = {}

					for k, v18 in p2.data do
						v17[v18.userId] = v18.names.getCombinedName(false)
					end

					setState3(v17)
					setState4(false)
				elseif p2.status == "failed" then
					setState4(false)
					v15()
					v16()
				end
			end
		)
	end

	local setSquadPrompt = v7.setSquadPrompt

	local v18 = if v10 then v10.participants or nil else nil
	useEffect(fn, { v15, v16, setState4, v12, setSquadPrompt, v9, v18 })

	local v19 = useLocalization({
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

	local v20 = React.useMemo(function()
		local children = {}

		for k, v21 in state2 do
			local formatted = `--social-squad-scheduled-party-info-sheet--going-user-{v21.userId}`

			local createElement = React.createElement

			local createElement2 = React.createElement
			local v26 = {
				LayoutOrder = 1,
				userId = v21.userId,
				includeProfileFrame = FFlagSquadsUseProfileFrameThumbnail,
				testId = 0
			}

			local v27 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--avatar` else nil
			v26.testId = v27
			local children2 = { Avatar = createElement2(avatar, v26), DisplayName = 0 }

			local createElement3 = React.createElement
			local v29 = {
				LayoutOrder = 2,
				Text = state3[tostring(v21.userId)],
				tag = "auto-xy fill text-truncate-end text-title-medium text-align-x-left",
				testId = 0
			}

			local v30 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--name` else nil
			v29.testId = v30
			children2.DisplayName = createElement3(text, v29)
			table.insert(children, createElement(view, {
				tag = "size-full-0 auto-y row align-x-left align-y-center gap-small",
				testId = if FFlagSquadsEnableFoundationTestIds then formatted else nil
			}, children2))
		end

		return children
	end, { state3, state2 })

	local v21 = React.useMemo(function()
		local children = {}

		if not (v10 and v10.participants) then
			return children
		end

		local set = Cryo.List.toSet(v12)

		for k, participant in v10.participants do
			if set[tostring(participant)] then
				continue
			end

			local formatted = `--social-squad-scheduled-party-info-sheet--not-going-user-{participant}`

			local createElement = React.createElement

			local createElement2 = React.createElement
			local v26 = {
				LayoutOrder = 1,
				userId = participant,
				includeProfileFrame = FFlagSquadsUseProfileFrameThumbnail,
				testId = 0
			}

			local v27 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--avatar` else nil
			v26.testId = v27
			local children2 = { Avatar = createElement2(avatar, v26), DisplayName = 0 }

			local createElement3 = React.createElement
			local v29 = {
				LayoutOrder = 2,
				Text = state3[tostring(participant)],
				tag = "auto-xy fill text-truncate-end text-title-medium text-align-x-left",
				testId = 0
			}

			local v30 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--name` else nil
			v29.testId = v30
			children2.DisplayName = createElement3(text, v29)
			table.insert(children, createElement(view, {
				tag = "size-full-0 auto-y row align-x-left align-y-center gap-small padding-y-small",
				testId = if FFlagSquadsEnableFoundationTestIds then formatted else nil
			}, children2))
		end

		return children
	end, { state3, v12, v10 and v10.participants })

	local v22 = React.useCallback(function()
		v15()
		v5(deleteScheduledSquad(props.scheduledSquad.scheduledGroupUpId, v7.setSquadPrompt))

		v7.fireSquadAnalytics(EventNames.ScheduledSquadAction, {
			actionType = ScheduledSquadActionEnum.Delete,
			conversationId = props.scheduledSquad.parentChannelId,
			scheduledSquadId = props.scheduledSquad.scheduledGroupUpId,
			source = ScheduledSquadActionSourceEnum.ScheduledSquadsMoreInfoSheet,
			squadId = v8,
			squadLocation = v7.squadLocation
		})
	end, {
		v8,
		v15,
		props.scheduledSquad.parentChannelId,
		props.scheduledSquad.scheduledGroupUpId,
		v7.fireSquadAnalytics,
		v7.setSquadPrompt,
		v7.squadLocation,
		v9
	})

	local function fn2()
		setState2(Cryo.List.filter(state2, function(p2): boolean
			return tostring(p2.userId) ~= tostring(v6)
		end))
	end

	local function fn3()
		setState2(Cryo.List.join(state2, {
			{ userId = tostring(v6) }
		}))
	end

	local v23 = React.useCallback(function()
		if v14 then
			unsubscribeFromScheduledSquad(
				{ scheduledGroupUpId = props.scheduledSquad.scheduledGroupUpId },
				fn2,
				v16
			)
		else
			subscribeToScheduledSquad(
				{ scheduledGroupUpId = props.scheduledSquad.scheduledGroupUpId },
				fn3,
				v16
			)
		end

		v15()
		local fireSquadAnalytics = v7.fireSquadAnalytics
		local scheduledSquadAction = EventNames.ScheduledSquadAction

		local v25 = if v14 then ScheduledSquadActionEnum.Unsubscribe else ScheduledSquadActionEnum.Subscribe
		fireSquadAnalytics(scheduledSquadAction, {
			actionType = v25,
			conversationId = props.scheduledSquad.parentChannelId,
			scheduledSquadId = props.scheduledSquad.scheduledGroupUpId,
			source = ScheduledSquadActionSourceEnum.ScheduledSquadsMoreInfoSheet,
			squadId = v8,
			squadLocation = v7.squadLocation
		})
	end, {
		v14,
		v7.squadLocation,
		v8,
		props.scheduledSquad,
		v7.fireSquadAnalytics,
		v15,
		v16,
		fn2,
		fn3,
		v8
	})

	local v24 = React.useCallback(function()
		setState(true)

		v7.fireSquadAnalytics(EventNames.ScheduledSquadAction, {
			actionType = ScheduledSquadActionEnum.Edit,
			conversationId = props.scheduledSquad.parentChannelId,
			scheduledSquadId = props.scheduledSquad.scheduledGroupUpId,
			source = ScheduledSquadActionSourceEnum.ScheduledSquadsMoreInfoSheet,
			squadId = v8,
			squadLocation = v7.squadLocation
		})
	end, { v8, props.scheduledSquad, v7.fireSquadAnalytics, v7.squadLocation })

	if state then
		return React.createElement(ScheduledSquadSheet, {
			isOpen = props.isOpen,
			onClose = v15,
			scheduledSquad = props.scheduledSquad,
			snapPoints = { 0.4, 0.7 }
		})
	end

	local createElement = React.createElement
	local root = sheet.Root
	local v25 = {
		onClose = v15,
		isOpen = props.isOpen,
		preferCenterSheet = true,
		snapPoints = { 0.4, 0.7 },
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-info-sheet" or nil
	}

	local createElement2 = React.createElement
	local header = sheet.Header
	local createElement3 = React.createElement

	local createElement4 = React.createElement
	local v32

	if v11 or not v14 then
		v32 = if v11 or v14 then v19.partyText else v19.willYouJoinScheduledPartyText
	else
		v32 = v19.usersPartyText
	end

	local children = {
		Header = createElement2(header, {}, {
			View = createElement3(view, { tag = "size-full-0 auto-y col" }, {
				ScheduledSquadTitle = createElement4(text, {
					LayoutOrder = 1,
					Text = v32,
					tag = "size-full-0 auto-y text-heading-medium text-align-x-left text-truncate-end",
					testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-info-sheet--title" or nil
				}),
				DateTime = React.createElement(text, {
					LayoutOrder = 2,
					Text = not dateTime and "" or dateTime:FormatLocalTime(
						"LLL",
						LocalizationService.RobloxLocaleId
					),
					tag = "size-full-0 auto-y text-body-medium text-align-x-left",
					testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-info-sheet--date-time" or nil
				})
			})
		}),
		Content = 0,
		Actions = 0
	}

	local createElement5 = React.createElement
	local content = sheet.Content

	local v35 = if state4 then React.createElement(Foundation.Loading, {
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-info-sheet--loading" or nil
	}) else nil

	local v36 = if not state4 then React.createElement(
		view,
		{ tag = "size-full-0 auto-y col gap-small padding-y-small" },
		{
			SubscribedUsersText = React.createElement(text, {
				LayoutOrder = 1,
				Text = `{v19.goingText}`,
				tag = "size-full-0 auto-y content-emphasis text-align-x-left",
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-info-sheet--going-label" or nil
			}),
			SubscribedUsers = React.createElement(
				view,
				{ LayoutOrder = 2, tag = "size-full-0 auto-y col gap-small" },
				unpack(v20)
			),
			NotSubscribedUsersText = React.createElement(text, {
				LayoutOrder = 3,
				Text = `{v19.notGoingText}`,
				tag = "size-full-0 auto-y content-emphasis text-align-x-left",
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-info-sheet--not-going-label" or nil
			}),
			NotSubscribedUsers = React.createElement(
				view,
				{ LayoutOrder = 4, tag = "size-full-0 auto-y col gap-small" },
				unpack(v21)
			)
		}
	) else nil
	children.Content = createElement5(content, {}, { Loading = v35, View = v36 })
	local v37

	if not v11 then
		local createElement6 = React.createElement
		local actions = sheet.Actions
		local createElement7 = React.createElement

		local v43 = if not (v13 or v14) then React.createElement(button, {
			LayoutOrder = 1,
			onActivated = v23,
			text = v19.joinText,
			variant = buttonVariant.Emphasis,
			width = UDim.new(1, 0),
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-info-sheet--join-button" or nil
		}) else nil

		local v44 = if not (v13 or not v14) then React.createElement(button, {
			LayoutOrder = 2,
			onActivated = v23,
			text = v19.dontJoinText,
			variant = buttonVariant.Standard,
			width = UDim.new(1, 0),
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-info-sheet--dont-join-button" or nil
		}) else nil

		local v45 = if v13 then React.createElement(button, {
			LayoutOrder = 3,
			onActivated = v24,
			text = v19.editText,
			variant = buttonVariant.Standard,
			width = UDim.new(1, 0),
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-info-sheet--edit-button" or nil
		}) else nil

		local v46 = if v13 then React.createElement(button, {
			LayoutOrder = 4,
			onActivated = v22,
			text = v19.deleteText,
			variant = buttonVariant.Alert,
			width = UDim.new(1, 0),
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-party-info-sheet--delete-button" or nil
		}) else nil
		v37 = createElement6(actions, {}, {
			createElement7(view, { tag = "size-full-0 auto-y col gap-small" }, {
				JoinButton = v43,
				DontJoinButton = v44,
				EditButton = v45,
				DeleteButton = v46
			})
		})
	end

	children.Actions = v37
	return createElement(root, v25, children)
end

return ScheduledSquadsMoreInfoSheet
