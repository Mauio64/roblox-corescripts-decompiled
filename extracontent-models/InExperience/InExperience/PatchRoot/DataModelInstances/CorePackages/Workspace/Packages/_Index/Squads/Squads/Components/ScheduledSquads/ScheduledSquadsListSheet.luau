local LocalizationService = game:GetService("LocalizationService")

local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent

local FFlagSquadsEnableFoundationTestIds = require(Squads.Flags.FFlagSquadsEnableFoundationTestIds)

local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
require(parent.SquadsCore.Types)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local RoactUtils = require(parent.RoactUtils)
local useStore = RoactUtils.Hooks.RoactRodux.useStore

local AvatarGroup = Foundation.AvatarGroup
local AvatarGroupType = Foundation.Enums.AvatarGroupType
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local Loading = Foundation.Loading
local Sheet = Foundation.Sheet
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View

local NetworkRequests = require(parent.SquadsCore.NetworkRequests)
local getSubscribedScheduledSquads = NetworkRequests.getSubscribedScheduledSquads
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local Enums = require(parent.SquadsCore.Enums)
local SquadPromptType = Enums.SquadPromptType
local EventNames = require(parent.SquadsCore.EventNames)
local NetworkRequests2 = require(parent.SquadsCore.NetworkRequests)
local subscribeToScheduledSquad = NetworkRequests2.subscribeToScheduledSquad
local NetworkRequests3 = require(parent.SquadsCore.NetworkRequests)
local unsubscribeFromScheduledSquad = NetworkRequests3.unsubscribeFromScheduledSquad
local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadId = Hooks.useCurrentSquadId

local ScheduledSquadActionEnum = require(Squads.Enums.ScheduledSquadActionEnum)
local ScheduledSquadActionSourceEnum = require(Squads.Enums.ScheduledSquadActionSourceEnum)

return function(p)
	local userId = useLocalUserId()
	local v = useNavigation()
	local v2 = useTokens()
	local v3 = useStore()
	local v4 = React.useContext(SquadExternalContractContext)
	local squadId = useCurrentSquadId()

	local v5 = useLocalization({
		editText = "Feature.Squads.Action.Edit",
		goingText = "Feature.Squads.Description.Going",
		interestedText = "Feature.Squads.Description.Interested",
		noScheduledSquadsText = "Feature.Squads.Description.YouHaveNoScheduledParties",
		scheduledPartyText = "Feature.Squads.Label.ScheduledParty",
		upcomingPartiesText = "Feature.Squads.Label.UpcomingParties"
	})

	local state, setState = React.useState(true)
	local state2, setState2 = React.useState({})

	local onClose = React.useCallback(function()
		if p.onClose then
			p.onClose()
		end
	end, { p.onClose })

	React.useEffect(function()
		if p.isOpen then
			getSubscribedScheduledSquads(function(p2)
				setState(false)
				setState2(p2.scheduledGroupUps)
			end, function()
				v4.setSquadPrompt(v3, {
					hideCancelButton = true,
					promptType = SquadPromptType.Error
				})

				onClose()
			end)
		end
	end, {
		getSubscribedScheduledSquads,
		p.isOpen,
		onClose,
		setState,
		setState2,
		v4.setSquadPrompt,
		v3
	})

	local v6 = React.useCallback(function()
		v4.setSquadPrompt(v3, { hideCancelButton = true, promptType = SquadPromptType.Error })
	end, { v4.setSquadPrompt, v3 })

	local v7 = React.useMemo(function()
		local children = {}

		for k, additionalInfo in state2 do
			local v7 = tostring(additionalInfo.initiatorId) == tostring(userId)

			local mapped = Cryo.List.map(additionalInfo.subscribers, function(p2)
				return p2.userId
			end)

			local v8 = v7 or Cryo.List.findWhere(mapped, function(p2): boolean
				return tostring(p2) == tostring(userId)
			end) ~= nil

			local dateTime = DateTime.fromIsoDate(additionalInfo.startTime)
			local formatted = `--social-squad-scheduled-parties-list-sheet--item-{additionalInfo.scheduledGroupUpId}`

			local createElement = React.createElement
			local v9 = {
				LayoutOrder = #children + 1,
				onActivated = function()
					onClose()
					v.navigate("ChatConversation", {
						conversationId = additionalInfo.parentChannelId
					})

					v4.fireSquadAnalytics(EventNames.ScheduledSquadAction, {
						actionType = ScheduledSquadActionEnum.NavigateToAssociatedChat,
						conversationId = additionalInfo.parentChannelId,
						scheduledSquadId = additionalInfo.scheduledGroupUpId,
						source = ScheduledSquadActionSourceEnum.SubscribedScheduledSquadsListSheet,
						squadId = squadId,
						squadLocation = v4.squadLocation
					})
				end,
				tag = "size-full-0 auto-y col gap-xsmall radius-large padding-y-small padding-x-medium",
				testId = 0
			}
			local testId

			if FFlagSquadsEnableFoundationTestIds then
				testId = formatted
			end

			v9.testId = testId

			local createElement2 = React.createElement
			local v10 = {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-title-large text-align-x-left text-truncate-end",
				Text = v5.scheduledPartyText,
				testId = 0
			}
			local testId2

			if FFlagSquadsEnableFoundationTestIds then
				testId2 = `{formatted}--title`
			end

			v10.testId = testId2
			local children2 = {
				TitleText = createElement2(Text, v10),
				DateTimeText = 0,
				SubscribedContainer = 0,
				ActionButton = 0
			}

			local createElement3 = React.createElement
			local v11 = {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-end",
				Text = not dateTime and "" or dateTime:FormatLocalTime("LLL", LocalizationService.RobloxLocaleId),
				testId = 0
			}
			local testId3

			if FFlagSquadsEnableFoundationTestIds then
				testId3 = `{formatted}--date-time`
			end

			v11.testId = testId3
			children2.DateTimeText = createElement3(Text, v11)

			local createElement4 = React.createElement

			local createElement5 = React.createElement
			local v12 = {
				avatars = mapped,
				backplateStyle = {
					Color3 = v2.Color.Shift.Shift_200.Color3,
					Transparency = v2.Color.Shift.Shift_200.Transparency
				},
				LayoutOrder = 1,
				max = 3,
				type = AvatarGroupType.Stacked,
				size = InputSize.XSmall,
				testId = 0
			}
			local testId4

			if FFlagSquadsEnableFoundationTestIds then
				testId4 = `{formatted}--avatar-group`
			end

			v12.testId = testId4
			local children3 = {
				AvatarGroup = createElement5(AvatarGroup, v12),
				NumberSubscribed = 0
			}

			local createElement6 = React.createElement
			local v13 = {
				LayoutOrder = 2,
				tag = "size-full-0 auto-y text-caption-medium text-align-x-left",
				Text = `{v5.goingText}`,
				testId = 0
			}
			local testId5

			if FFlagSquadsEnableFoundationTestIds then
				testId5 = `{formatted}--going-label`
			end

			v13.testId = testId5
			children3.NumberSubscribed = createElement6(Text, v13)
			children2.SubscribedContainer = createElement4(
				View,
				{
					LayoutOrder = 3,
					tag = "size-full-0 auto-y row gap-small padding-y-xsmall align-y-center align-x-left"
				},
				children3
			)

			local createElement7 = React.createElement
			local testId6

			if FFlagSquadsEnableFoundationTestIds then
				testId6 = `{formatted}--action-button`
			end

			local v14 = {
				LayoutOrder = 4,
				testId = testId6,
				onActivated = function()
					if v7 then
						onClose()
						v4.setSquadPrompt(v3, {
							additionalInfo = additionalInfo,
							conversationId = additionalInfo.parentChannelId,
							promptType = SquadPromptType.ScheduleSquad
						})
					elseif v8 then
						unsubscribeFromScheduledSquad(
							{ scheduledGroupUpId = additionalInfo.scheduledGroupUpId },
							function()
								local joined = Cryo.Dictionary.join(additionalInfo, {
									subscribers = Cryo.List.filter(additionalInfo.subscribers, function(p2): boolean
										return tostring(p2.userId) ~= tostring(userId)
									end)
								})

								setState2(Cryo.List.replaceIndex(state2, k, joined))
							end,
							v6
						)
					else
						subscribeToScheduledSquad({
							scheduledGroupUpId = additionalInfo.scheduledGroupUpId
						}, function()
							local joined = Cryo.Dictionary.join(additionalInfo, {
								subscribers = Cryo.List.join(additionalInfo.subscribers, {
									{ userId = userId }
								})
							})

							setState2(Cryo.List.replaceIndex(state2, k, joined))
						end, v6)
					end

					local fireSquadAnalytics = v4.fireSquadAnalytics
					local scheduledSquadAction = EventNames.ScheduledSquadAction
					local actionType

					if v7 then
						actionType = ScheduledSquadActionEnum.Edit
					elseif v8 then
						actionType = ScheduledSquadActionEnum.Unsubscribe
					else
						actionType = ScheduledSquadActionEnum.Subscribe
					end

					fireSquadAnalytics(scheduledSquadAction, {
						actionType = actionType,
						conversationId = additionalInfo.parentChannelId,
						scheduledSquadId = additionalInfo.scheduledGroupUpId,
						source = ScheduledSquadActionSourceEnum.SubscribedScheduledSquadsListSheet,
						squadId = squadId,
						squadLocation = v4.squadLocation
					})
				end,
				text = 0,
				variant = 0,
				width = 0
			}
			local text

			if v7 then
				text = v5.editText
			else
				text = v5.interestedText
			end

			v14.text = text
			local variant

			if v7 or v8 then
				variant = ButtonVariant.Standard
			else
				variant = ButtonVariant.Emphasis
			end

			v14.variant = variant

			v14.width = UDim.new(1, 0)
			children2.ActionButton = createElement7(Button, v14)
			table.insert(children, createElement(View, v9, children2))
		end

		return children
	end, { state2, onClose, v6 })

	local createElement = React.createElement
	local root = Sheet.Root
	local v8 = {
		onClose = onClose,
		isOpen = p.isOpen,
		preferCenterSheet = true,
		snapPoints = { 0.4, 0.7 },
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-parties-list-sheet" or nil
	}

	local v9 = {
		Header = React.createElement(Sheet.Header, {}, {
			Title = React.createElement(Text, {
				LayoutOrder = 1,
				Text = v5.upcomingPartiesText,
				tag = "size-full-0 auto-y text-wrap text-heading-medium text-align-x-left",
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-parties-list-sheet--title" or nil
			})
		}),
		Content = 0
	}

	local createElement2 = React.createElement
	local content = Sheet.Content
	local loading

	if state then
		loading = React.createElement(Loading, {
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-parties-list-sheet--loading" or nil
		})
	end

	local scheduledSquadsList

	if not (state or not (#Cryo.Dictionary.keys(state2) > 0)) then
		scheduledSquadsList = React.createElement(View, {
			tag = "auto-y size-full-0 col gap-xsmall"
		}, unpack(v7))
	end

	local noUpcomingScheduledSquads

	if not (state or #Cryo.Dictionary.keys(state2) ~= 0) then
		noUpcomingScheduledSquads = React.createElement(Text, {
			Text = v5.noScheduledSquadsText,
			tag = "size-full-0 auto-y text-label-medium text-align-x-left",
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-scheduled-parties-list-sheet--empty-label" or nil
		})
	end

	v9.Content = createElement2(content, {}, {
		Loading = loading,
		ScheduledSquadsList = scheduledSquadsList,
		NoUpcomingScheduledSquads = noUpcomingScheduledSquads
	})
	return createElement(root, v8, v9)
end
