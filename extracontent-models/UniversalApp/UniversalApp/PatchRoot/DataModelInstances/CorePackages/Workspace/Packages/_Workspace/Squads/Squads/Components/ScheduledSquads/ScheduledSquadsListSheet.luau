local LocalizationService = game:GetService("LocalizationService")
local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local Cryo = require(SquadsParent.Cryo)
local Foundation = require(SquadsParent.Foundation)
local React = require(SquadsParent.React)
local SquadExternalContractProvider = require(SquadsParent.SquadsCore.SquadExternalContractProvider)

require(SquadsParent.SquadsCore.Types)

local useLocalUserId = require(SquadsParent.RobloxAppHooks).useLocalUserId
local useLocalization = require(SquadsParent.Localization).Hooks.useLocalization
local useNavigation = require(SquadsParent.Navigation).useNavigation
local useStore = require(SquadsParent.RoactUtils).Hooks.RoactRodux.useStore
local AvatarGroup = Foundation.AvatarGroup
local AvatarGroupType = Foundation.Enums.AvatarGroupType
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local Loading = Foundation.Loading
local Sheet = Foundation.Sheet
local FoundationText = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local getSubscribedScheduledSquads = require(SquadsParent.SquadsCore.NetworkRequests).getSubscribedScheduledSquads
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local SquadPromptType = require(SquadsParent.SquadsCore.Enums).SquadPromptType
local EventNames = require(SquadsParent.SquadsCore.EventNames)
local subscribeToScheduledSquad = require(SquadsParent.SquadsCore.NetworkRequests).subscribeToScheduledSquad
local unsubscribeFromScheduledSquad = require(SquadsParent.SquadsCore.NetworkRequests).unsubscribeFromScheduledSquad
local useCurrentSquadId = require(SquadsParent.SquadsCore.Hooks).useCurrentSquadId
local ScheduledSquadActionEnum = require(Squads.Enums.ScheduledSquadActionEnum)
local ScheduledSquadActionSourceEnum = require(Squads.Enums.ScheduledSquadActionSourceEnum)

return function(t1: {[any]: any}) -- line: 45
	-- upvalues: useLocalUserId (copy), useNavigation (copy), useTokens (copy), useStore (copy), React (copy), SquadExternalContractContext (copy), useCurrentSquadId (copy), useLocalization (copy), getSubscribedScheduledSquads (copy), SquadPromptType (copy), Cryo (copy), View (copy), EventNames (copy), ScheduledSquadActionEnum (copy), ScheduledSquadActionSourceEnum (copy), FoundationText (copy), LocalizationService (copy), AvatarGroup (copy), AvatarGroupType (copy), InputSize (copy), Button (copy), unsubscribeFromScheduledSquad (copy), subscribeToScheduledSquad (copy), ButtonVariant (copy), Sheet (copy), Loading (copy)
	local v32 = useLocalUserId()
	local v33 = useNavigation()
	local v34 = useTokens()
	local v35 = useStore()
	local v36 = React.useContext(SquadExternalContractContext)
	local v37 = useCurrentSquadId()
	local v38 = useLocalization({
		editText = "Feature.Squads.Action.Edit",
		goingText = "Feature.Squads.Description.Going",
		interestedText = "Feature.Squads.Description.Interested",
		noScheduledSquadsText = "Feature.Squads.Description.YouHaveNoScheduledParties",
		scheduledPartyText = "Feature.Squads.Label.ScheduledParty",
		upcomingPartiesText = "Feature.Squads.Label.UpcomingParties"
	})
	local v39, v40 = React.useState(true)
	local v41, v42 = React.useState({})
	local v43 = React.useCallback(function() -- line: 65
		-- upvalues: t1 (copy)
		if t1.onClose then
			t1.onClose()
		end
	end, { t1.onClose })

	React.useEffect(function() -- line: 72
		-- upvalues: t1 (copy), getSubscribedScheduledSquads (copy), v40 (copy), v42 (copy), v36 (copy), v35 (copy), SquadPromptType (copy), v43 (copy)
		if t1.isOpen then
			getSubscribedScheduledSquads(function(p1) -- line: 74
				-- upvalues: v40 (copy), v42 (copy)
				v40(false)
				v42(p1.scheduledGroupUps)
			end, function() -- line: 77
				-- upvalues: v36 (copy), v35 (copy), SquadPromptType (copy), v43 (copy)
				v36.setSquadPrompt(v35, {
					hideCancelButton = true,
					promptType = SquadPromptType.Error
				})
				v43()
			end)
		end
	end, {
		getSubscribedScheduledSquads,
		t1.isOpen,
		v43,
		v40,
		v42,
		v36.setSquadPrompt,
		v35
	})

	local v44 = React.useCallback(function() -- line: 97
		-- upvalues: v36 (copy), v35 (copy), SquadPromptType (copy)
		v36.setSquadPrompt(v35, {
			hideCancelButton = true,
			promptType = SquadPromptType.Error
		})
	end, {
		v36.setSquadPrompt,
		v35
	})
	local v45 = React.useMemo(function() -- line: 104
		-- upvalues: v41 (copy), v32 (copy), Cryo (copy), React (copy), View (copy), v43 (copy), v33 (copy), v36 (copy), EventNames (copy), ScheduledSquadActionEnum (copy), ScheduledSquadActionSourceEnum (copy), v37 (copy), FoundationText (copy), v38 (copy), LocalizationService (copy), AvatarGroup (copy), v34 (copy), AvatarGroupType (copy), InputSize (copy), Button (copy), v35 (copy), SquadPromptType (copy), unsubscribeFromScheduledSquad (copy), v42 (copy), v44 (copy), subscribeToScheduledSquad (copy), ButtonVariant (copy)
		local t2 = {}

		for v47, v48 in v41 do
			local v49 = tostring(v48.initiatorId) == tostring(v32)
			local v50 = Cryo.List.map(v48.subscribers, function(p2) -- line: 110
				return p2.userId
			end)
			local v51 = v49 or Cryo.List.findWhere(v50, function(p3) -- line: 115
				-- upvalues: v32 (copy)
				return tostring(p3) == tostring(v32)
			end) ~= nil
			local dateTime = DateTime.fromIsoDate(v48.startTime)

			table.insert(t2, React.createElement(View, {
				tag = "size-full-0 auto-y col gap-xsmall radius-large padding-y-small padding-x-medium",
				LayoutOrder = #t2 + 1,
				onActivated = function() -- line: 126
					-- upvalues: v43 (copy), v33 (copy), v48 (copy), v36 (copy), EventNames (copy), ScheduledSquadActionEnum (copy), ScheduledSquadActionSourceEnum (copy), v37 (copy)
					v43()
					v33.navigate("ChatConversation", {
						conversationId = v48.parentChannelId
					})
					v36.fireSquadAnalytics(EventNames.ScheduledSquadAction, {
						actionType = ScheduledSquadActionEnum.NavigateToAssociatedChat,
						conversationId = v48.parentChannelId,
						scheduledSquadId = v48.scheduledGroupUpId,
						source = ScheduledSquadActionSourceEnum.SubscribedScheduledSquadsListSheet,
						squadId = v37,
						squadLocation = v36.squadLocation
					})
				end
			}, {
				TitleText = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y text-title-large text-align-x-left text-truncate-end",
					Text = v38.scheduledPartyText
				}),
				DateTimeText = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "size-full-0 auto-y text-body-medium text-align-x-left text-truncate-end",
					Text = not dateTime and "" or dateTime:FormatLocalTime("LLL", LocalizationService.RobloxLocaleId)
				}),
				SubscribedContainer = React.createElement(View, {
					LayoutOrder = 3,
					tag = "size-full-0 auto-y row gap-small padding-y-xsmall align-y-center align-x-left"
				}, {
					AvatarGroup = React.createElement(AvatarGroup, {
						LayoutOrder = 1,
						max = 3,
						avatars = v50,
						backplateStyle = {
							Color3 = v34.Color.Shift.Shift_200.Color3,
							Transparency = v34.Color.Shift.Shift_200.Transparency
						},
						type = AvatarGroupType.Stacked,
						size = InputSize.XSmall
					}),
					NumberSubscribed = React.createElement(FoundationText, {
						LayoutOrder = 2,
						tag = "size-full-0 auto-y text-caption-medium text-align-x-left",
						Text = `{ v38.goingText }`
					})
				}),
				ActionButton = React.createElement(Button, {
					LayoutOrder = 4,
					onActivated = function() -- line: 176
						-- upvalues: v49 (copy), v43 (copy), v36 (copy), v35 (copy), v48 (copy), SquadPromptType (copy), v51 (copy), unsubscribeFromScheduledSquad (copy), Cryo (copy), v32 (copy), v42 (copy), v41 (copy), v47 (copy), v44 (copy), subscribeToScheduledSquad (copy), EventNames (copy), ScheduledSquadActionEnum (copy), ScheduledSquadActionSourceEnum (copy), v37 (copy)
						if v49 then
							v43()
							v36.setSquadPrompt(v35, {
								additionalInfo = v48,
								conversationId = v48.parentChannelId,
								promptType = SquadPromptType.ScheduleSquad
							})
						elseif v51 then
							unsubscribeFromScheduledSquad({
								scheduledGroupUpId = v48.scheduledGroupUpId
							}, function() -- line: 190
								-- upvalues: Cryo (copy), v48 (copy), v32 (copy), v42 (copy), v41 (copy), v47 (copy)
								local v56 = Cryo.Dictionary.join(v48, {
									subscribers = Cryo.List.filter(v48.subscribers, function(p4) -- line: 194
										-- upvalues: v32 (copy)
										return tostring(p4.userId) ~= tostring(v32)
									end)
								})

								v42(Cryo.List.replaceIndex(v41, v47, v56))
							end, v44)
						else
							subscribeToScheduledSquad({
								scheduledGroupUpId = v48.scheduledGroupUpId
							}, function() -- line: 208
								-- upvalues: Cryo (copy), v48 (copy), v32 (copy), v42 (copy), v41 (copy), v47 (copy)
								local v57 = Cryo.Dictionary.join(v48, {
									subscribers = Cryo.List.join(v48.subscribers, {{
										userId = v32
									}})
								})

								v42(Cryo.List.replaceIndex(v41, v47, v57))
							end, v44)
						end

						v36.fireSquadAnalytics(EventNames.ScheduledSquadAction, {
							actionType = if not v49 then if not v51 then ScheduledSquadActionEnum.Subscribe else ScheduledSquadActionEnum.Unsubscribe else ScheduledSquadActionEnum.Edit,
							conversationId = v48.parentChannelId,
							scheduledSquadId = v48.scheduledGroupUpId,
							source = ScheduledSquadActionSourceEnum.SubscribedScheduledSquadsListSheet,
							squadId = v37,
							squadLocation = v36.squadLocation
						})
					end,
					text = if not v49 then v38.interestedText else v38.editText,
					variant = if not v49 and not v51 then ButtonVariant.Emphasis else ButtonVariant.Standard,
					width = UDim.new(1, 0)
				})
			}))
		end

		return t2
	end, {
		v41,
		v43,
		v44
	})

	return React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		onClose = v43,
		isOpen = t1.isOpen,
		snapPoints = {
			0.4,
			0.7
		}
	}, {
		Header = React.createElement(Sheet.Header, {}, {
			Title = React.createElement(FoundationText, {
				LayoutOrder = 1,
				tag = "size-full-0 auto-y text-wrap text-heading-medium text-align-x-left",
				Text = v38.upcomingPartiesText
			})
		}),
		Content = React.createElement(Sheet.Content, {}, {
			Loading = if not v39 then nil else React.createElement(Loading, {}),
			ScheduledSquadsList = if v39 or not (#Cryo.Dictionary.keys(v41) > 0) then nil else React.createElement(View, {
				tag = "auto-y size-full-0 col gap-xsmall"
			}, unpack(v45)),
			NoUpcomingScheduledSquads = if v39 or #Cryo.Dictionary.keys(v41) ~= 0 then nil else React.createElement(FoundationText, {
				tag = "size-full-0 auto-y text-label-medium text-align-x-left",
				Text = v38.noScheduledSquadsText
			})
		})
	})
end
