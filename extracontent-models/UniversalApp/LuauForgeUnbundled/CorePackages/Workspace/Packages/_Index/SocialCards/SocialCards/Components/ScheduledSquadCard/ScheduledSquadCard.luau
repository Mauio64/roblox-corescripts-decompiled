local LocalizationService = game:GetService("LocalizationService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/React")
local SquadExternalContractProvider = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SquadsCore/SquadExternalContractProvider")
require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SquadsCore/Types")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Localization").Hooks.useLocalization
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCards/Navigation").useNavigation
local userProfileStore = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/UserProfiles").Stores.UserProfileStore

local avatarGroup = Foundation.AvatarGroup
local avatarGroupType = Foundation.Enums.AvatarGroupType
local inputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens

local scheduledSquadActionEnum = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/Squads/Enums").ScheduledSquadActionEnum
local scheduledSquadActionSourceEnum = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/Squads/Enums").ScheduledSquadActionSourceEnum
local scheduledSquadsMoreInfoSheet = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/Squads/Components").ScheduledSquadsMoreInfoSheet
local squadButtonSourceEnum = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/Squads/Enums").SquadButtonSourceEnum
local squadComponentAccessWrapper = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/Squads/Components").SquadComponentAccessWrapper
local squadJoinButton = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/Squads/Components").SquadJoinButton

local getScheduledSquadsStore = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SquadsCore/Stores").GetScheduledSquadsStore
local squadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SquadsCore/EventNames")
local useCurrentSquadId = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SquadsCore/Hooks").useCurrentSquadId
local useScheduledSquad = require("@game/CorePackages/Workspace/Packages/_Index/SocialCards/SquadsCore/Hooks").useScheduledSquad

local defineFastInt = game:DefineFastInt("ScheduledSquadJustStartedThreshold", 300)

return function(props)
	local v5 = useTokens()
	local v6 = useNavigation()
	local v7 = React.useContext(squadExternalContractContext)
	local v8 = useCurrentSquadId()

	local v9 = props.startTime == nil
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(true)
	local state3, setState3 = React.useState(true)
	local state4, setState4 = React.useState("")
	local v10 = useScheduledSquad(props.scheduledGroupUpId)

	local v11 = React.useMemo(function()
		if props.startTime then
			return (DateTime.fromIsoDate(props.startTime))
		end

		return nil
	end, { props.startTime })
	local v12 = React.useMemo(function()
		return v11 and v11.UnixTimestamp < DateTime.now().UnixTimestamp
	end, { v11 })
	local v13 = React.useMemo(function()
		local v14 = v11

		if v14 then
			if v11.UnixTimestamp <= DateTime.now().UnixTimestamp then
				v14 = DateTime.now().UnixTimestamp - v11.UnixTimestamp < defineFastInt
			else
				v14 = false
			end
		end

		return v14
	end, { v11 })

	local v14 = React.useMemo(function()
		return Cryo.List.map((v10 or props).subscribers, function(p2)
			return p2.userId
		end)
	end, { v10, props })

	React.useEffect(function()
		if v9 or v12 then
			setState3(false)
		else
			getScheduledSquadsStore(false).fetchAndCacheScheduledSquadStatus(
				props.scheduledGroupUpId,
				function()
					setState3(false)
				end
			)
		end
	end, { v9, v12, props.scheduledGroupUpId })

	React.useEffect(function()
		if v9 or v12 then
			setState2(false)
			return
		end

		local fetchNamesByUserIds = userProfileStore.get().fetchNamesByUserIds
		local v16 = if v10 then v10.initiatorId else props.initiatorId
		fetchNamesByUserIds({ (tostring(v16)) }, function(p2)
			local status = p2.status
			local data = p2.data

			if status == "success" then
				setState4(data[1].names.getDisplayName(false))
				setState2(false)
			elseif status == "failed" then
				setState2(false)
			end
		end)
	end, {
		props and props.initiatorId,
		v9,
		v12,
		v10 and v10.initiatorId
	})

	local v15 = useLocalization({
		deletedScheduledPartyText = "Feature.Squads.Label.DeletedScheduledParty",
		goingText = "Feature.Squads.Description.Going",
		partyText = "Feature.Squads.Label.Party",
		scheduledPartyText = "Feature.Squads.Label.ScheduledParty",
		usersPartyText = {
			"Feature.Squads.Label.UsersParty",
			displayName = state4
		}
	})

	local v16 = not v11 and "" or v11:FormatLocalTime("llll", LocalizationService.RobloxLocaleId)

	local v17 = React.useCallback(function()
		setState(true)

		local fireSquadAnalytics = v7.fireSquadAnalytics
		local scheduledSquadAction = EventNames.ScheduledSquadAction
		local v18 = {
			actionType = scheduledSquadActionEnum.SeeMoreDetails,
			conversationId = props.parentChannelId,
			scheduledSquadId = 0,
			source = 0,
			squadId = 0,
			squadLocation = 0
		}

		local v19 = if v10 then v10.scheduledGroupUpId else props.scheduledGroupUpId
		v18.scheduledSquadId = v19

		v18.source = scheduledSquadActionSourceEnum.ScheduledSquadCard
		v18.squadId = v8
		v18.squadLocation = v7.squadLocation
		fireSquadAnalytics(scheduledSquadAction, v18)
	end, {
		v8,
		props and props.scheduledGroupUpId,
		props.parentChannelId,
		v10 and v10.scheduledGroupUpId,
		setState,
		v7.fireSquadAnalytics,
		v7.squadLocation
	})

	local v18 = React.useCallback(function()
		setState(false)
	end, { setState })

	local v19 = React.useCallback(function()
		v6.navigate("SquadLobby", {
			conversationId = props.parentChannelId,
			extraParams = {
				scheduledGroupUpId = tostring(props.scheduledGroupUpId)
			}
		})
	end, { v6.navigate, props.parentChannelId, props.scheduledGroupUpId })

	if state2 or state3 then
		return React.createElement(Foundation.View, { tag = "size-full-800" }, {
			Skeleton = React.createElement(Foundation.Skeleton, {
				Size = UDim2.new(0, 280, 0, v5.Size.Size_2500),
				radius = Foundation.Enums.Radius.Large
			})
		})
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v20 = {
		onActivated = v17,
		Size = UDim2.new(0, 280, 0, 0),
		tag = "auto-y bg-shift-200 radius-large col padding-y-medium padding-x-large align-x-center gap-medium flex-fill"
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local createElement3 = React.createElement
	local text = Foundation.Text
	local v25

	if v9 then
		v25 = v15.deletedScheduledPartyText
	else
		v25 = if v12 then v15.partyText else v15.usersPartyText
	end

	local v23 = {
		Title = createElement3(text, {
			LayoutOrder = 1,
			tag = "auto-y size-full-0 text-title-large text-align-x-left content-emphasis text-wrap",
			Text = v25
		}),
		Date = 0
	}

	local v26 = if not v9 then React.createElement(Foundation.Text, {
		LayoutOrder = 2,
		tag = "auto-y size-full-0 text-body-medium text-align-x-left content-default text-wrap",
		Text = v16
	}) else nil
	v23.Date = v26
	local v21 = {
		TextContainer = createElement2(
			view2,
			{ LayoutOrder = 1, tag = "auto-y size-full-0 col gap-xsmall" },
			v23
		),
		Interested = 0,
		JoinButton = 0,
		Sheet = 0
	}

	local v27 = if not v9 then React.createElement(
		Foundation.View,
		{
			LayoutOrder = 2,
			tag = "row size-full-0 auto-y gap-small align-x-left align-y-center"
		},
		{
			AvatarGroup = React.createElement(avatarGroup, {
				avatars = v14,
				backplateStyle = {
					Color3 = v5.Color.Shift.Shift_200.Color3,
					Transparency = v5.Color.Shift.Shift_200.Transparency
				},
				LayoutOrder = 1,
				max = 4,
				size = inputSize.XSmall,
				type = avatarGroupType.Stacked
			}),
			InterestedCount = React.createElement(Foundation.Text, {
				LayoutOrder = 2,
				tag = "auto-xy text-body-medium content-default",
				Text = `{v15.goingText}`
			})
		}
	) else nil
	v21.Interested = v27

	local v28 = if v13 then React.createElement(
		squadComponentAccessWrapper,
		{ parentChannelId = props.parentChannelId },
		{ React.createElement(squadJoinButton, {
				conversationId = props.parentChannelId,
				isFullWidth = true,
				isInCard = true,
				layoutOrder = 3,
				onActivated = v19,
				shouldAnimate = false,
				squadButtonSource = squadButtonSourceEnum.ScheduledSquadCard,
				squadLocation = v7.squadLocation
			}) }
	) else nil
	v21.JoinButton = v28

	local v29 = if not v9 then React.createElement(scheduledSquadsMoreInfoSheet, {
		isOpen = state,
		onClose = v18,
		scheduledSquad = v10 or props
	}) else nil
	v21.Sheet = v29
	return createElement(view, v20, v21)
end
