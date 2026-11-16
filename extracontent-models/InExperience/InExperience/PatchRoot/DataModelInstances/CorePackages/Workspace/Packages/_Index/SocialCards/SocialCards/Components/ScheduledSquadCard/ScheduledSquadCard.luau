local LocalizationService = game:GetService("LocalizationService")

local parent = script:FindFirstAncestor("SocialCards").Parent

local Cryo = require(parent.Cryo)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
require(parent.SquadsCore.Types)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local UserProfiles = require(parent.UserProfiles)

local UserProfileStore = UserProfiles.Stores.UserProfileStore

local AvatarGroup = Foundation.AvatarGroup
local AvatarGroupType = Foundation.Enums.AvatarGroupType
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens

local Enums = require(parent.Squads.Enums)
local ScheduledSquadActionEnum = Enums.ScheduledSquadActionEnum
local Enums2 = require(parent.Squads.Enums)
local ScheduledSquadActionSourceEnum = Enums2.ScheduledSquadActionSourceEnum
local Components = require(parent.Squads.Components)
local ScheduledSquadsMoreInfoSheet = Components.ScheduledSquadsMoreInfoSheet
local Enums3 = require(parent.Squads.Enums)
local SquadButtonSourceEnum = Enums3.SquadButtonSourceEnum
local Components2 = require(parent.Squads.Components)
local SquadComponentAccessWrapper = Components2.SquadComponentAccessWrapper
local Components3 = require(parent.Squads.Components)
local SquadJoinButton = Components3.SquadJoinButton

local Stores = require(parent.SquadsCore.Stores)
local GetScheduledSquadsStore = Stores.GetScheduledSquadsStore
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local EventNames = require(parent.SquadsCore.EventNames)
local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadId = Hooks.useCurrentSquadId
local Hooks2 = require(parent.SquadsCore.Hooks)
local useScheduledSquad = Hooks2.useScheduledSquad

local defineFastInt = game:DefineFastInt("ScheduledSquadJustStartedThreshold", 300)

return function(props)
	local v = useTokens()
	local v2 = useNavigation()
	local v3 = React.useContext(SquadExternalContractContext)
	local squadId = useCurrentSquadId()

	local v4 = props.startTime == nil
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(true)
	local state3, setState3 = React.useState(true)
	local state4, setState4 = React.useState("")
	local v5 = useScheduledSquad(props.scheduledGroupUpId)

	local v6 = React.useMemo(function()
		if props.startTime then
			return (DateTime.fromIsoDate(props.startTime))
		end

		return nil
	end, { props.startTime })
	local v7 = React.useMemo(function()
		return v6 and v6.UnixTimestamp < DateTime.now().UnixTimestamp
	end, { v6 })
	local v8 = React.useMemo(function()
		local v8 = v6

		if v8 then
			if v6.UnixTimestamp <= DateTime.now().UnixTimestamp then
				return DateTime.now().UnixTimestamp - v6.UnixTimestamp < defineFastInt
			end

			return false
		end

		return v8
	end, { v6 })

	local avatars = React.useMemo(function()
		return Cryo.List.map((v5 or props).subscribers, function(p)
			return p.userId
		end)
	end, { v5, props })

	React.useEffect(function()
		if v4 or v7 then
			setState3(false)
		else
			GetScheduledSquadsStore(false).fetchAndCacheScheduledSquadStatus(props.scheduledGroupUpId, function()
				setState3(false)
			end)
		end
	end, { v4, v7, props.scheduledGroupUpId })

	React.useEffect(function()
		if v4 or v7 then
			setState2(false)
			return
		end

		local fetchNamesByUserIds = UserProfileStore.get().fetchNamesByUserIds
		local v9 = if v5 then v5.initiatorId else props.initiatorId
		fetchNamesByUserIds({ (tostring(v9)) }, function(p)
			local status = p.status
			local data = p.data

			if status == "success" then
				setState4(data[1].names.getDisplayName(false))
				setState2(false)
			elseif status == "failed" then
				setState2(false)
			end
		end)
	end, {
		props and props.initiatorId,
		v4,
		v7,
		v5 and v5.initiatorId
	})

	local v9 = useLocalization({
		deletedScheduledPartyText = "Feature.Squads.Label.DeletedScheduledParty",
		goingText = "Feature.Squads.Description.Going",
		partyText = "Feature.Squads.Label.Party",
		scheduledPartyText = "Feature.Squads.Label.ScheduledParty",
		usersPartyText = {
			"Feature.Squads.Label.UsersParty",
			displayName = state4
		}
	})

	local text2 = not v6 and "" or v6:FormatLocalTime("llll", LocalizationService.RobloxLocaleId)

	local onActivated = React.useCallback(function()
		setState(true)

		local fireSquadAnalytics = v3.fireSquadAnalytics
		local scheduledSquadAction = EventNames.ScheduledSquadAction
		local v10 = {
			actionType = ScheduledSquadActionEnum.SeeMoreDetails,
			conversationId = props.parentChannelId,
			scheduledSquadId = 0,
			source = 0,
			squadId = 0,
			squadLocation = 0
		}
		local scheduledSquadId

		if v5 then
			scheduledSquadId = v5.scheduledGroupUpId
		else
			scheduledSquadId = props.scheduledGroupUpId
		end

		v10.scheduledSquadId = scheduledSquadId

		v10.source = ScheduledSquadActionSourceEnum.ScheduledSquadCard
		v10.squadId = squadId
		v10.squadLocation = v3.squadLocation
		fireSquadAnalytics(scheduledSquadAction, v10)
	end, {
		squadId,
		props and props.scheduledGroupUpId,
		props.parentChannelId,
		v5 and v5.scheduledGroupUpId,
		setState,
		v3.fireSquadAnalytics,
		v3.squadLocation
	})

	local onClose = React.useCallback(function()
		setState(false)
	end, { setState })

	local onActivated2 = React.useCallback(function()
		v2.navigate("SquadLobby", {
			conversationId = props.parentChannelId,
			extraParams = {
				scheduledGroupUpId = tostring(props.scheduledGroupUpId)
			}
		})
	end, { v2.navigate, props.parentChannelId, props.scheduledGroupUpId })

	if state2 or state3 then
		return React.createElement(Foundation.View, { tag = "size-full-800" }, {
			Skeleton = React.createElement(Foundation.Skeleton, {
				Size = UDim2.new(0, 280, 0, v.Size.Size_2500),
				radius = Foundation.Enums.Radius.Large
			})
		})
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v10 = {
		onActivated = onActivated,
		Size = UDim2.new(0, 280, 0, 0),
		tag = "auto-y bg-shift-200 radius-large col padding-y-medium padding-x-large align-x-center gap-medium flex-fill"
	}

	local createElement2 = React.createElement
	local view2 = Foundation.View

	local createElement3 = React.createElement
	local text = Foundation.Text
	local text3

	if v4 then
		text3 = v9.deletedScheduledPartyText
	else
		text3 = if v7 then v9.partyText else v9.usersPartyText
	end

	local v11 = {
		Title = createElement3(text, {
			LayoutOrder = 1,
			tag = "auto-y size-full-0 text-title-large text-align-x-left content-emphasis text-wrap",
			Text = text3
		}),
		Date = 0
	}
	local date

	if not v4 then
		date = React.createElement(Foundation.Text, {
			LayoutOrder = 2,
			tag = "auto-y size-full-0 text-body-medium text-align-x-left content-default text-wrap",
			Text = text2
		})
	end

	v11.Date = date
	local v12 = {
		TextContainer = createElement2(view2, {
			LayoutOrder = 1,
			tag = "auto-y size-full-0 col gap-xsmall"
		}, v11),
		Interested = 0,
		JoinButton = 0,
		Sheet = 0
	}
	local interested

	if not v4 then
		interested = React.createElement(
			Foundation.View,
			{
				LayoutOrder = 2,
				tag = "row size-full-0 auto-y gap-small align-x-left align-y-center"
			},
			{
				AvatarGroup = React.createElement(AvatarGroup, {
					avatars = avatars,
					backplateStyle = {
						Color3 = v.Color.Shift.Shift_200.Color3,
						Transparency = v.Color.Shift.Shift_200.Transparency
					},
					LayoutOrder = 1,
					max = 4,
					size = InputSize.XSmall,
					type = AvatarGroupType.Stacked
				}),
				InterestedCount = React.createElement(Foundation.Text, {
					LayoutOrder = 2,
					tag = "auto-xy text-body-medium content-default",
					Text = `{v9.goingText}`
				})
			}
		)
	end

	v12.Interested = interested
	local joinButton

	if v8 then
		joinButton = React.createElement(SquadComponentAccessWrapper, {
			parentChannelId = props.parentChannelId
		}, {
			React.createElement(SquadJoinButton, {
				conversationId = props.parentChannelId,
				isFullWidth = true,
				isInCard = true,
				layoutOrder = 3,
				onActivated = onActivated2,
				shouldAnimate = false,
				squadButtonSource = SquadButtonSourceEnum.ScheduledSquadCard,
				squadLocation = v3.squadLocation
			})
		})
	end

	v12.JoinButton = joinButton
	local sheet

	if not v4 then
		sheet = React.createElement(ScheduledSquadsMoreInfoSheet, {
			isOpen = state,
			onClose = onClose,
			scheduledSquad = v5 or props
		})
	end

	v12.Sheet = sheet
	return createElement(view, v10, v12)
end
