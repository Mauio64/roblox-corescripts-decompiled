local LocalizationService = game:GetService("LocalizationService")

local FFlagSquadsEnableFoundationTestIds = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadsEnableFoundationTestIds")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/React")
local SquadExternalContractProvider = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider")
require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Types")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RobloxAppHooks").useLocalUserId
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Navigation").useNavigation
local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RoactUtils").Hooks.RoactRodux.useStore

local avatarGroup = Foundation.AvatarGroup
local avatarGroupType = Foundation.Enums.AvatarGroupType
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local loading = Foundation.Loading
local sheet = Foundation.Sheet
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View

local getSubscribedScheduledSquads = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/NetworkRequests").getSubscribedScheduledSquads
local squadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local squadPromptType = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums").SquadPromptType
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/EventNames")
local subscribeToScheduledSquad = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/NetworkRequests").subscribeToScheduledSquad
local unsubscribeFromScheduledSquad = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/NetworkRequests").unsubscribeFromScheduledSquad
local useCurrentSquadId = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks").useCurrentSquadId

local ScheduledSquadActionEnum = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/ScheduledSquadActionEnum")
local ScheduledSquadActionSourceEnum = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/ScheduledSquadActionSourceEnum")

return function(p2)
	local v5 = useLocalUserId()
	local v6 = useNavigation()
	local v7 = useTokens()
	local v8 = useStore()
	local v9 = React.useContext(squadExternalContractContext)
	local v10 = useCurrentSquadId()

	local v11 = useLocalization({
		editText = "Feature.Squads.Action.Edit",
		goingText = "Feature.Squads.Description.Going",
		interestedText = "Feature.Squads.Description.Interested",
		noScheduledSquadsText = "Feature.Squads.Description.YouHaveNoScheduledParties",
		scheduledPartyText = "Feature.Squads.Label.ScheduledParty",
		upcomingPartiesText = "Feature.Squads.Label.UpcomingParties"
	})

	local state, setState = React.useState(true)
	local state2, setState2 = React.useState({})

	local v12 = React.useCallback(function()
		if p2.onClose then
			p2.onClose()
		end
	end, { p2.onClose })

	React.useEffect(function()
		if p2.isOpen then
			getSubscribedScheduledSquads(function(p3)
				setState(false)
				setState2(p3.scheduledGroupUps)
			end, function()
				v9.setSquadPrompt(v8, {
					hideCancelButton = true,
					promptType = squadPromptType.Error
				})

				v12()
			end)
		end
	end, {
		getSubscribedScheduledSquads,
		p2.isOpen,
		v12,
		setState,
		setState2,
		v9.setSquadPrompt,
		v8
	})

	local v13 = React.useCallback(function()
		v9.setSquadPrompt(v8, {
			hideCancelButton = true,
			promptType = squadPromptType.Error
		})
	end, { v9.setSquadPrompt, v8 })

	local v14 = React.useMemo(function()
		local children = {}

		for k, v15 in state2 do
			local v16 = tostring(v15.initiatorId) == tostring(v5)

			local mapped = Cryo.List.map(v15.subscribers, function(p3)
				return p3.userId
			end)

			local v17 = v16 or Cryo.List.findWhere(mapped, function(p3): boolean
				return tostring(p3) == tostring(v5)
			end) ~= nil

			local dateTime = DateTime.fromIsoDate(v15.startTime)
			local formatted = `--social-squad-scheduled-parties-list-sheet--item-{v15.scheduledGroupUpId}`

			local createElement = React.createElement
			local v19 = {
				LayoutOrder = #children + 1,
				onActivated = function()
					v12()
					v6.navigate("ChatConversation", {
						conversationId = v15.parentChannelId
					})

					v9.fireSquadAnalytics(EventNames.ScheduledSquadAction, {
						actionType = ScheduledSquadActionEnum.NavigateToAssociatedChat,
						conversationId = v15.parentChannelId,
						scheduledSquadId = v15.scheduledGroupUpId,
						source = ScheduledSquadActionSourceEnum.SubscribedScheduledSquadsListSheet,
						squadId = v10,
						squadLocation = v9.squadLocation
					})
				end,
				tag = "size-full-0 auto-y col gap-xsmall radius-large padding-y-small padding-x-medium",
				testId = if FFlagSquadsEnableFoundationTestIds then formatted else nil
			}

			local createElement2 = React.createElement
			local v22 = {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-title-large text-align-x-left text-truncate-end",
				Text = v11.scheduledPartyText,
				testId = 0
			}
			local v23 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--title` else nil
			v22.testId = v23
			local children2 = {
				TitleText = createElement2(text, v22),
				DateTimeText = 0,
				SubscribedContainer = 0,
				ActionButton = 0
			}

			local createElement3 = React.createElement
			local v25 = {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-end",
				Text = not dateTime and "" or dateTime:FormatLocalTime(
					"LLL",
					LocalizationService.RobloxLocaleId
				),
				testId = 0
			}

			local v26 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--date-time` else nil
			v25.testId = v26
			children2.DateTimeText = createElement3(text, v25)

			local createElement4 = React.createElement

			local createElement5 = React.createElement
			local v30 = {
				avatars = mapped,
				backplateStyle = {
					Color3 = v7.Color.Shift.Shift_200.Color3,
					Transparency = v7.Color.Shift.Shift_200.Transparency
				},
				LayoutOrder = 1,
				max = 3,
				type = avatarGroupType.Stacked,
				size = inputSize.XSmall,
				testId = 0
			}
			local v31 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--avatar-group` else nil
			v30.testId = v31
			local children3 = {
				AvatarGroup = createElement5(avatarGroup, v30),
				NumberSubscribed = 0
			}

			local createElement6 = React.createElement
			local v33 = {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-caption-medium text-align-x-left",
				Text = `{v11.goingText}`,
				testId = 0
			}
			local v34 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--going-label` else nil
			v33.testId = v34
			children3.NumberSubscribed = createElement6(text, v33)
			children2.SubscribedContainer = createElement4(
				view,
				{
					LayoutOrder = 3,
					tag = "size-full-0 auto-y row gap-small padding-y-xsmall align-y-center align-x-left"
				},
				children3
			)

			local createElement7 = React.createElement

			local v37 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--action-button` else nil
			local v36 = {
				LayoutOrder = 4,
				testId = v37,
				onActivated = function()
					if v16 then
						v12()
						v9.setSquadPrompt(v8, {
							additionalInfo = v15,
							conversationId = v15.parentChannelId,
							promptType = squadPromptType.ScheduleSquad
						})
					elseif v17 then
						unsubscribeFromScheduledSquad(
							{ scheduledGroupUpId = v15.scheduledGroupUpId },
							function()
								local joined = Cryo.Dictionary.join(v15, {
									subscribers = Cryo.List.filter(v15.subscribers, function(p3): boolean
										return tostring(p3.userId) ~= tostring(v5)
									end)
								})

								setState2(Cryo.List.replaceIndex(state2, k, joined))
							end,
							v13
						)
					else
						subscribeToScheduledSquad(
							{ scheduledGroupUpId = v15.scheduledGroupUpId },
							function()
								local joined = Cryo.Dictionary.join(v15, {
									subscribers = Cryo.List.join(v15.subscribers, {
										{ userId = v5 }
									})
								})

								setState2(Cryo.List.replaceIndex(state2, k, joined))
							end,
							v13
						)
					end

					local fireSquadAnalytics = v9.fireSquadAnalytics
					local scheduledSquadAction = EventNames.ScheduledSquadAction

					local v39 = if v16 then ScheduledSquadActionEnum.Edit elseif v17 then ScheduledSquadActionEnum.Unsubscribe else ScheduledSquadActionEnum.Subscribe
					fireSquadAnalytics(scheduledSquadAction, {
						actionType = v39,
						conversationId = v15.parentChannelId,
						scheduledSquadId = v15.scheduledGroupUpId,
						source = ScheduledSquadActionSourceEnum.SubscribedScheduledSquadsListSheet,
						squadId = v10,
						squadLocation = v9.squadLocation
					})
				end,
				text = 0,
				variant = 0,
				width = 0
			}
			local v38 = if v16 then v11.editText else v11.interestedText
			v36.text = v38

			local v39 = if v16 or v17 then buttonVariant.Standard else buttonVariant.Emphasis
			v36.variant = v39

			v36.width = UDim.new(1, 0)
			children2.ActionButton = createElement7(button, v36)
			table.insert(children, createElement(view, v19, children2))
		end

		return children
	end, { state2, v12, v13 })

	local createElement = React.createElement
	local root = sheet.Root
	local v15 = {
		onClose = v12,
		isOpen = p2.isOpen,
		preferCenterSheet = true,
		snapPoints = { 0.4, 0.7 },
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-parties-list-sheet" or nil
	}

	local v16 = {
		Header = React.createElement(sheet.Header, {}, {
			Title = React.createElement(text, {
				LayoutOrder = 1,
				Text = v11.upcomingPartiesText,
				tag = "size-full-0 auto-y text-wrap text-heading-medium text-align-x-left",
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-parties-list-sheet--title" or nil
			})
		}),
		Content = 0
	}

	local createElement2 = React.createElement
	local content = sheet.Content

	local v19 = if state then React.createElement(loading, {
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-parties-list-sheet--loading" or nil
	}) else nil

	local v20 = if not state and #Cryo.Dictionary.keys(state2) > 0 then React.createElement(
		view,
		{ tag = "auto-y size-full-0 col gap-xsmall" },
		unpack(v14)
	) else nil

	local v21 = if not state and #Cryo.Dictionary.keys(state2) == 0 then React.createElement(text, {
		Text = v11.noScheduledSquadsText,
		tag = "size-full-0 auto-y text-label-medium text-align-x-left",
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-parties-list-sheet--empty-label" or nil
	}) else nil
	v16.Content = createElement2(content, {}, {
		Loading = v19,
		ScheduledSquadsList = v20,
		NoUpcomingScheduledSquads = v21
	})
	return createElement(root, v15, v16)
end
