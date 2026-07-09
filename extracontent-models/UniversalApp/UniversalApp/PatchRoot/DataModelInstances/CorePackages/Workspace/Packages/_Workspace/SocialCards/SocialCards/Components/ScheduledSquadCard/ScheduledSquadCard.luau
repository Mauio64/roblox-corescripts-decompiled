local LocalizationService = game:GetService("LocalizationService")
local Parent = script:FindFirstAncestor("SocialCards").Parent
local Cryo = require(Parent.Cryo)
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local SquadExternalContractProvider = require(Parent.SquadsCore.SquadExternalContractProvider)

require(Parent.SquadsCore.Types)

local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useNavigation = require(Parent.Navigation).useNavigation
local UserProfileStore = require(Parent.UserProfiles).Stores.UserProfileStore
local AvatarGroup = Foundation.AvatarGroup
local AvatarGroupType = Foundation.Enums.AvatarGroupType
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens
local ScheduledSquadActionEnum = require(Parent.Squads.Enums).ScheduledSquadActionEnum
local ScheduledSquadActionSourceEnum = require(Parent.Squads.Enums).ScheduledSquadActionSourceEnum
local ScheduledSquadsMoreInfoSheet = require(Parent.Squads.Components).ScheduledSquadsMoreInfoSheet
local SquadButtonSourceEnum = require(Parent.Squads.Enums).SquadButtonSourceEnum
local SquadComponentAccessWrapper = require(Parent.Squads.Components).SquadComponentAccessWrapper
local SquadJoinButton = require(Parent.Squads.Components).SquadJoinButton
local GetScheduledSquadsStore = require(Parent.SquadsCore.Stores).GetScheduledSquadsStore
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local EventNames = require(Parent.SquadsCore.EventNames)
local useCurrentSquadId = require(Parent.SquadsCore.Hooks).useCurrentSquadId
local useScheduledSquad = require(Parent.SquadsCore.Hooks).useScheduledSquad
local v25 = game:DefineFastInt("ScheduledSquadJustStartedThreshold", 300)

return function(p1) -- line: 40
	-- upvalues: useTokens (copy), useNavigation (copy), React (copy), SquadExternalContractContext (copy), useCurrentSquadId (copy), useScheduledSquad (copy), v25 (copy), Cryo (copy), GetScheduledSquadsStore (copy), UserProfileStore (copy), useLocalization (copy), LocalizationService (copy), EventNames (copy), ScheduledSquadActionEnum (copy), ScheduledSquadActionSourceEnum (copy), Foundation (copy), AvatarGroup (copy), InputSize (copy), AvatarGroupType (copy), SquadComponentAccessWrapper (copy), SquadJoinButton (copy), SquadButtonSourceEnum (copy), ScheduledSquadsMoreInfoSheet (copy)
	local v27 = useTokens()
	local v28 = useNavigation()
	local v29 = React.useContext(SquadExternalContractContext)
	local v30 = useCurrentSquadId()
	local v31 = p1.startTime == nil
	local v32, v33 = React.useState(false)
	local v34, v35 = React.useState(true)
	local v36, v37 = React.useState(true)
	local v38, v39 = React.useState("")
	local v40 = useScheduledSquad(p1.scheduledGroupUpId)
	local v41 = v34 or v36
	local v42 = React.useMemo(function() -- line: 59
		-- upvalues: p1 (copy)
		if p1.startTime then
			return (DateTime.fromIsoDate(p1.startTime))
		end

		return nil
	end, { p1.startTime })
	local v43 = React.useMemo(function() -- line: 62
		-- upvalues: v42 (copy)
		return v42 and v42.UnixTimestamp < DateTime.now().UnixTimestamp
	end, { v42 })
	local v44 = React.useMemo(function() -- line: 65
		-- upvalues: v42 (copy), v25 (copy)
		return v42 and (v42.UnixTimestamp <= DateTime.now().UnixTimestamp and DateTime.now().UnixTimestamp - v42.UnixTimestamp < v25)
	end, { v42 })
	local v45 = React.useMemo(function() -- line: 71
		-- upvalues: v40 (copy), p1 (copy), Cryo (copy)
		local v51 = v40 or p1

		return Cryo.List.map(v51.subscribers, function(p2) -- line: 73
			return p2.userId
		end)
	end, {
		v40,
		p1
	})

	React.useEffect(function() -- line: 79
		-- upvalues: v31 (copy), v43 (copy), GetScheduledSquadsStore (copy), p1 (copy), v37 (copy)
		if not v31 and not v43 then
			GetScheduledSquadsStore(false).fetchAndCacheScheduledSquadStatus(p1.scheduledGroupUpId, function() -- line: 81
				-- upvalues: v37 (copy)
				v37(false)
			end)

			return
		end

		v37(false)
	end, {
		v31,
		v43,
		p1.scheduledGroupUpId
	})
	React.useEffect(function() -- line: 90
		-- upvalues: v31 (copy), v43 (copy), v35 (copy), UserProfileStore (copy), v40 (copy), p1 (copy), v39 (copy)
		if v31 or v43 then
			v35(false)

			return
		end

		UserProfileStore.get().fetchNamesByUserIds({ (tostring(if not v40 then p1.initiatorId else v40.initiatorId)) }, function(p3) -- line: 96
			-- upvalues: v39 (copy), v35 (copy)
			local status = p3.status
			local data = p3.data

			if status == "success" then
				v39(data[1].names.getDisplayName(false))
				v35(false)

				return
			end

			if status == "failed" then
				v35(false)
			end
		end)
	end, {
		p1 and p1.initiatorId,
		v31,
		v43,
		v40 and v40.initiatorId
	})

	local v46 = useLocalization({
		deletedScheduledPartyText = "Feature.Squads.Label.DeletedScheduledParty",
		goingText = "Feature.Squads.Description.Going",
		partyText = "Feature.Squads.Label.Party",
		scheduledPartyText = "Feature.Squads.Label.ScheduledParty",
		usersPartyText = {
			"Feature.Squads.Label.UsersParty",
			displayName = v38
		}
	})
	local v47 = not v42 and "" or v42:FormatLocalTime("llll", LocalizationService.RobloxLocaleId)
	local v48 = React.useCallback(function() -- line: 128
		-- upvalues: v33 (copy), v29 (copy), EventNames (copy), ScheduledSquadActionEnum (copy), p1 (copy), v40 (copy), p1 (copy), ScheduledSquadActionSourceEnum (copy), v30 (copy)
		v33(true)
		v29.fireSquadAnalytics(EventNames.ScheduledSquadAction, {
			actionType = ScheduledSquadActionEnum.SeeMoreDetails,
			conversationId = p1.parentChannelId,
			scheduledSquadId = if not v40 then p1.scheduledGroupUpId else v40.scheduledGroupUpId,
			source = ScheduledSquadActionSourceEnum.ScheduledSquadCard,
			squadId = v30,
			squadLocation = v29.squadLocation
		})
	end, {
		v30,
		p1 and p1.scheduledGroupUpId,
		p1.parentChannelId,
		v40 and v40.scheduledGroupUpId,
		v33,
		v29.fireSquadAnalytics,
		v29.squadLocation
	})
	local v49 = React.useCallback(function() -- line: 153
		-- upvalues: v33 (copy)
		v33(false)
	end, { v33 })
	local v50 = React.useCallback(function() -- line: 157
		-- upvalues: v28 (copy), p1 (copy)
		v28.navigate("SquadLobby", {
			conversationId = p1.parentChannelId,
			extraParams = {
				scheduledGroupUpId = tostring(p1.scheduledGroupUpId)
			}
		})
	end, {
		v28.navigate,
		p1.parentChannelId,
		p1.scheduledGroupUpId
	})

	if v41 then
		return React.createElement(Foundation.View, {
			tag = "size-full-800"
		}, {
			Skeleton = React.createElement(Foundation.Skeleton, {
				Size = UDim2.new(0, 280, 0, v27.Size.Size_2500),
				radius = Foundation.Enums.Radius.Large
			})
		})
	end

	return React.createElement(Foundation.View, {
		tag = "auto-y bg-shift-200 radius-large col padding-y-medium padding-x-large align-x-center gap-medium flex-fill",
		onActivated = v48,
		Size = UDim2.new(0, 280, 0, 0)
	}, {
		TextContainer = React.createElement(Foundation.View, {
			LayoutOrder = 1,
			tag = "auto-y size-full-0 col gap-xsmall"
		}, {
			Title = React.createElement(Foundation.Text, {
				LayoutOrder = 1,
				tag = "auto-y size-full-0 text-title-large text-align-x-left content-emphasis text-wrap",
				Text = if not v31 then if not v43 then v46.usersPartyText else v46.partyText else v46.deletedScheduledPartyText
			}),
			Date = if v31 then nil else React.createElement(Foundation.Text, {
				LayoutOrder = 2,
				tag = "auto-y size-full-0 text-body-medium text-align-x-left content-default text-wrap",
				Text = v47
			})
		}),
		Interested = if v31 then nil else React.createElement(Foundation.View, {
			LayoutOrder = 2,
			tag = "row size-full-0 auto-y gap-small align-x-left align-y-center"
		}, {
			AvatarGroup = React.createElement(AvatarGroup, {
				LayoutOrder = 1,
				max = 4,
				avatars = v45,
				backplateStyle = {
					Color3 = v27.Color.Shift.Shift_200.Color3,
					Transparency = v27.Color.Shift.Shift_200.Transparency
				},
				size = InputSize.XSmall,
				type = AvatarGroupType.Stacked
			}),
			InterestedCount = React.createElement(Foundation.Text, {
				LayoutOrder = 2,
				tag = "auto-xy text-body-medium content-default",
				Text = `{ v46.goingText }`
			})
		}),
		JoinButton = if not v44 then nil else React.createElement(SquadComponentAccessWrapper, {
			parentChannelId = p1.parentChannelId
		}, { React.createElement(SquadJoinButton, {
			isFullWidth = true,
			isInCard = true,
			layoutOrder = 3,
			shouldAnimate = false,
			conversationId = p1.parentChannelId,
			onActivated = v50,
			squadButtonSource = SquadButtonSourceEnum.ScheduledSquadCard,
			squadLocation = v29.squadLocation
		}) }),
		Sheet = if v31 then nil else React.createElement(ScheduledSquadsMoreInfoSheet, {
			isOpen = v32,
			onClose = v49,
			scheduledSquad = v40 or p1
		})
	})
end
