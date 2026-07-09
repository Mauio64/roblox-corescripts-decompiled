local LocalizationService = game:GetService("LocalizationService")
local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local Cryo = require(SquadsParent.Cryo)
local Foundation = require(SquadsParent.Foundation)
local React = require(SquadsParent.React)
local SquadExternalContractProvider = require(SquadsParent.SquadsCore.SquadExternalContractProvider)

require(SquadsParent.SquadsCore.Types)

local useDispatch = require(SquadsParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useLocalUserId = require(SquadsParent.RobloxAppHooks).useLocalUserId
local useLocalization = require(SquadsParent.Localization).Hooks.useLocalization
local useStore = require(SquadsParent.RoactUtils).Hooks.RoactRodux.useStore
local UserProfileStore = require(SquadsParent.UserProfiles).Stores.UserProfileStore
local Avatar = Foundation.Avatar
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local Sheet = Foundation.Sheet
local FoundationText = Foundation.Text
local View = Foundation.View
local deleteScheduledSquad = require(SquadsParent.SquadsCore.Thunks).deleteScheduledSquad
local EventNames = require(SquadsParent.SquadsCore.EventNames)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local SquadPromptType = require(SquadsParent.SquadsCore.Enums).SquadPromptType
local subscribeToScheduledSquad = require(SquadsParent.SquadsCore.NetworkRequests).subscribeToScheduledSquad
local unsubscribeFromScheduledSquad = require(SquadsParent.SquadsCore.NetworkRequests).unsubscribeFromScheduledSquad
local useCurrentSquadId = require(SquadsParent.SquadsCore.Hooks).useCurrentSquadId
local ScheduledSquadSheet = require(Squads.Components.ScheduledSquads.ScheduledSquadSheet)
local ScheduledSquadActionEnum = require(Squads.Enums.ScheduledSquadActionEnum)
local ScheduledSquadActionSourceEnum = require(Squads.Enums.ScheduledSquadActionSourceEnum)

local function ScheduledSquadsMoreInfoSheet(t1: {[any]: any}) -- line: 47
	-- upvalues: useDispatch (copy), useLocalUserId (copy), React (copy), SquadExternalContractContext (copy), useCurrentSquadId (copy), useStore (copy), Cryo (copy), SquadPromptType (copy), UserProfileStore (copy), useLocalization (copy), View (copy), Avatar (copy), FoundationText (copy), deleteScheduledSquad (copy), EventNames (copy), ScheduledSquadActionEnum (copy), ScheduledSquadActionSourceEnum (copy), unsubscribeFromScheduledSquad (copy), subscribeToScheduledSquad (copy), ScheduledSquadSheet (copy), Sheet (copy), LocalizationService (copy), Foundation (copy), Button (copy), ButtonVariant (copy)
	local v31 = useDispatch()
	local v32 = useLocalUserId()
	local v33 = React.useContext(SquadExternalContractContext)
	local v34 = useCurrentSquadId()
	local v35 = useStore()
	local v36 = v33.useGetConversationFromId(t1.scheduledSquad.parentChannelId)
	local dateTime = DateTime.fromIsoDate(t1.scheduledSquad.startTime)
	local v38 = dateTime and dateTime.UnixTimestamp < DateTime.now().UnixTimestamp
	local v39, v40 = React.useState(false)
	local v41, v42 = React.useState(t1.scheduledSquad.subscribers)
	local v43 = React.useMemo(function() -- line: 61
		-- upvalues: Cryo (copy), v41 (copy)
		return Cryo.List.map(v41, function(p1) -- line: 62
			return (tostring(p1.userId))
		end)
	end, { v41 })

	React.useEffect(function() -- line: 67
		-- upvalues: v42 (copy), t1 (copy)
		v42(t1.scheduledSquad.subscribers)
	end, { t1.scheduledSquad.subscribers })

	local v44 = tostring(t1.scheduledSquad.initiatorId) == tostring(v32)
	local v45 = React.useMemo(function() -- line: 72
		-- upvalues: v44 (copy), Cryo (copy), v43 (copy), v32 (copy)
		return v44 or Cryo.List.findWhere(v43, function(p2) -- line: 74
			-- upvalues: v32 (copy)
			return p2 == tostring(v32)
		end) ~= nil
	end, {
		v44,
		v32,
		v43
	})
	local v46, v47 = React.useState({})
	local v48, v49 = React.useState(true)
	local v50 = React.useCallback(function() -- line: 83
		-- upvalues: v40 (copy), t1 (copy)
		v40(false)

		if t1.onClose then
			t1.onClose()
		end
	end, { t1.onClose })
	local v51 = React.useCallback(function() -- line: 90
		-- upvalues: v50 (copy), v33 (copy), v35 (copy), SquadPromptType (copy)
		v50()
		v33.setSquadPrompt(v35, {
			hideCancelButton = true,
			promptType = SquadPromptType.Error
		})
	end, {
		v50,
		v33.setSquadPrompt,
		v35
	})

	React.useEffect(function() -- line: 99
		-- upvalues: v49 (copy), UserProfileStore (copy), Cryo (copy), v43 (copy), v36 (copy), v47 (copy), v50 (copy), v51 (copy)
		v49(true)
		UserProfileStore.get().fetchNamesByUserIds(Cryo.List.join(v43, v36 and v36.participants or {}), function(p3) -- line: 102
			-- upvalues: v47 (copy), v49 (copy), v50 (copy), v51 (copy)
			if p3.status == "success" then
				local t2 = {}

				for _, v72 in p3.data do
					t2[v72.userId] = v72.names.getCombinedName(false)
				end

				v47(t2)
				v49(false)

				return
			end

			if p3.status == "failed" then
				v49(false)
				v50()
				v51()
			end
		end)
	end, {
		v50,
		v51,
		v49,
		v43,
		v33.setSquadPrompt,
		v35,
		v36 and v36.participants or nil
	})

	local v52 = useLocalization({
		deleteText = "Feature.Squads.Action.Delete",
		dontJoinText = "Feature.Squads.Action.DontJoin",
		editText = "Feature.Squads.Action.Edit",
		goingText = "Feature.Squads.Description.Going",
		joinText = "Feature.Squads.Action.Join",
		notGoingText = "Feature.Squads.Description.NotGoing",
		partyText = "Feature.Squads.Label.Party",
		usersPartyText = {
			"Feature.Squads.Label.UsersParty",
			displayName = v46[tostring(t1.scheduledSquad.initiatorId)]
		},
		willYouJoinScheduledPartyText = {
			"Feature.Squads.Label.WillYouJoinScheduledParty",
			displayName = v46[tostring(t1.scheduledSquad.initiatorId)]
		}
	})
	local v53 = React.useMemo(function() -- line: 146
		-- upvalues: v41 (copy), React (copy), View (copy), Avatar (copy), FoundationText (copy), v46 (copy)
		local t3 = {}

		for _, v62 in v41 do
			table.insert(t3, React.createElement(View, {
				tag = "size-full-0 auto-y row align-x-left align-y-center gap-small"
			}, {
				Avatar = React.createElement(Avatar, {
					LayoutOrder = 1,
					userId = v62.userId
				}),
				DisplayName = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "auto-xy fill text-truncate-end text-title-medium text-align-x-left",
					Text = v46[tostring(v62.userId)]
				})
			}))
		end

		return t3
	end, {
		v46,
		v41
	})
	local v54 = React.useMemo(function() -- line: 171
		-- upvalues: v36 (copy), Cryo (copy), v43 (copy), React (copy), View (copy), Avatar (copy), FoundationText (copy), v46 (copy)
		local t4 = {}

		if v36 and v36.participants then
			local v64 = Cryo.List.toSet(v43)

			for _, v66 in v36.participants do
				if not v64[tostring(v66)] then
					table.insert(t4, React.createElement(View, {
						tag = "size-full-0 auto-y row align-x-left align-y-center gap-small padding-y-small"
					}, {
						Avatar = React.createElement(Avatar, {
							LayoutOrder = 1,
							userId = v66
						}),
						DisplayName = React.createElement(FoundationText, {
							LayoutOrder = 2,
							tag = "auto-xy fill text-truncate-end text-title-medium text-align-x-left",
							Text = v46[tostring(v66)]
						})
					}))
				end
			end
		end

		return t4
	end, {
		v46,
		v43,
		v36 and v36.participants
	})
	local v55 = React.useCallback(function() -- line: 203
		-- upvalues: v50 (copy), v31 (copy), deleteScheduledSquad (copy), t1 (copy), v33 (copy), EventNames (copy), ScheduledSquadActionEnum (copy), ScheduledSquadActionSourceEnum (copy), v34 (copy)
		v50()
		v31(deleteScheduledSquad(t1.scheduledSquad.scheduledGroupUpId, v33.setSquadPrompt))
		v33.fireSquadAnalytics(EventNames.ScheduledSquadAction, {
			actionType = ScheduledSquadActionEnum.Delete,
			conversationId = t1.scheduledSquad.parentChannelId,
			scheduledSquadId = t1.scheduledSquad.scheduledGroupUpId,
			source = ScheduledSquadActionSourceEnum.ScheduledSquadsMoreInfoSheet,
			squadId = v34,
			squadLocation = v33.squadLocation
		})
	end, {
		v34,
		v50,
		t1.scheduledSquad.parentChannelId,
		t1.scheduledSquad.scheduledGroupUpId,
		v33.fireSquadAnalytics,
		v33.setSquadPrompt,
		v33.squadLocation,
		v35
	})

	local function v56() -- line: 228
		-- upvalues: v42 (copy), Cryo (copy), v41 (copy), v32 (copy)
		v42(Cryo.List.filter(v41, function(p4) -- line: 229
			-- upvalues: v32 (copy)
			return tostring(p4.userId) ~= tostring(v32)
		end))
	end
	local function v57() -- line: 234
		-- upvalues: v42 (copy), Cryo (copy), v41 (copy), v32 (copy)
		v42(Cryo.List.join(v41, {{
			userId = tostring(v32)
		}}))
	end

	local v58 = React.useCallback(function() -- line: 239
		-- upvalues: v45 (copy), unsubscribeFromScheduledSquad (copy), t1 (copy), v56 (copy), v51 (copy), subscribeToScheduledSquad (copy), v57 (copy), v50 (copy), v33 (copy), EventNames (copy), ScheduledSquadActionEnum (copy), ScheduledSquadActionSourceEnum (copy), v34 (copy)
		if v45 then
			unsubscribeFromScheduledSquad({
				scheduledGroupUpId = t1.scheduledSquad.scheduledGroupUpId
			}, v56, v51)
		else
			subscribeToScheduledSquad({
				scheduledGroupUpId = t1.scheduledSquad.scheduledGroupUpId
			}, v57, v51)
		end

		v50()
		v33.fireSquadAnalytics(EventNames.ScheduledSquadAction, {
			actionType = if not v45 then ScheduledSquadActionEnum.Subscribe else ScheduledSquadActionEnum.Unsubscribe,
			conversationId = t1.scheduledSquad.parentChannelId,
			scheduledSquadId = t1.scheduledSquad.scheduledGroupUpId,
			source = ScheduledSquadActionSourceEnum.ScheduledSquadsMoreInfoSheet,
			squadId = v34,
			squadLocation = v33.squadLocation
		})
	end, {
		v45,
		v33.squadLocation,
		v34,
		t1.scheduledSquad,
		v33.fireSquadAnalytics,
		v50,
		v51,
		v56,
		v57,
		v34
	})
	local v59 = React.useCallback(function() -- line: 281
		-- upvalues: v40 (copy), v33 (copy), EventNames (copy), ScheduledSquadActionEnum (copy), t1 (copy), ScheduledSquadActionSourceEnum (copy), v34 (copy)
		v40(true)
		v33.fireSquadAnalytics(EventNames.ScheduledSquadAction, {
			actionType = ScheduledSquadActionEnum.Edit,
			conversationId = t1.scheduledSquad.parentChannelId,
			scheduledSquadId = t1.scheduledSquad.scheduledGroupUpId,
			source = ScheduledSquadActionSourceEnum.ScheduledSquadsMoreInfoSheet,
			squadId = v34,
			squadLocation = v33.squadLocation
		})
	end, {
		v34,
		t1.scheduledSquad,
		v33.fireSquadAnalytics,
		v33.squadLocation
	})

	if v39 then
		return React.createElement(ScheduledSquadSheet, {
			isOpen = t1.isOpen,
			onClose = v50,
			scheduledSquad = t1.scheduledSquad,
			snapPoints = {
				0.4,
				0.7
			}
		})
	end

	return (React.createElement(Sheet.Root, {
		preferCenterSheet = true,
		onClose = v50,
		isOpen = t1.isOpen,
		snapPoints = {
			0.4,
			0.7
		}
	}, {
		Header = React.createElement(Sheet.Header, {}, {
			View = React.createElement(View, {
				tag = "size-full-0 auto-y col"
			}, {
				ScheduledSquadTitle = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y text-heading-medium text-align-x-left text-truncate-end",
					Text = if v38 or not v45 then if v38 or v45 then v52.partyText else v52.willYouJoinScheduledPartyText else v52.usersPartyText
				}),
				DateTime = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "size-full-0 auto-y text-body-medium text-align-x-left",
					Text = not dateTime and "" or dateTime:FormatLocalTime("LLL", LocalizationService.RobloxLocaleId)
				})
			})
		}),
		Content = React.createElement(Sheet.Content, {}, {
			Loading = if not v48 then nil else React.createElement(Foundation.Loading, {}),
			View = if v48 then nil else React.createElement(View, {
				tag = "size-full-0 auto-y col gap-small padding-y-small"
			}, {
				SubscribedUsersText = React.createElement(FoundationText, {
					LayoutOrder = 1,
					tag = "size-full-0 auto-y content-emphasis text-align-x-left",
					Text = `{ v52.goingText }`
				}),
				SubscribedUsers = React.createElement(View, {
					LayoutOrder = 2,
					tag = "size-full-0 auto-y col gap-small"
				}, unpack(v53)),
				NotSubscribedUsersText = React.createElement(FoundationText, {
					LayoutOrder = 3,
					tag = "size-full-0 auto-y content-emphasis text-align-x-left",
					Text = `{ v52.notGoingText }`
				}),
				NotSubscribedUsers = React.createElement(View, {
					LayoutOrder = 4,
					tag = "size-full-0 auto-y col gap-small"
				}, unpack(v54))
			})
		}),
		Actions = if v38 then nil else React.createElement(Sheet.Actions, {}, { React.createElement(View, {
			tag = "size-full-0 auto-y col gap-small"
		}, {
			JoinButton = if v44 or v45 then nil else React.createElement(Button, {
				LayoutOrder = 1,
				onActivated = v58,
				text = v52.joinText,
				variant = ButtonVariant.Emphasis,
				width = UDim.new(1, 0)
			}),
			DontJoinButton = if v44 or not v45 then nil else React.createElement(Button, {
				LayoutOrder = 2,
				onActivated = v58,
				text = v52.dontJoinText,
				variant = ButtonVariant.Standard,
				width = UDim.new(1, 0)
			}),
			EditButton = if not v44 then nil else React.createElement(Button, {
				LayoutOrder = 3,
				onActivated = v59,
				text = v52.editText,
				variant = ButtonVariant.Standard,
				width = UDim.new(1, 0)
			}),
			DeleteButton = if not v44 then nil else React.createElement(Button, {
				LayoutOrder = 4,
				onActivated = v55,
				text = v52.deleteText,
				variant = ButtonVariant.Alert,
				width = UDim.new(1, 0)
			})
		}) })
	}))
end

return ScheduledSquadsMoreInfoSheet
