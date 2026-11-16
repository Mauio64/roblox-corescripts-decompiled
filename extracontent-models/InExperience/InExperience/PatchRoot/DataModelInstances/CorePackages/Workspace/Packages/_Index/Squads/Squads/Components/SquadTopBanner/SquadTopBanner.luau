local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent
local UserLib = require(parent.UserLib)
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local Cryo = require(parent.Cryo)
local UserProfiles = require(parent.UserProfiles)

local HorizontalFacepileGroup = require(Squads.Common.HorizontalFacepileGroup)
local dependencies = require(Squads.dependencies)
local FFlagIntroduceTopBannerPartyStates = require(Squads.Flags.FFlagIntroduceTopBannerPartyStates)
local FFlagSquadsEnableFoundationTestIds = require(Squads.Flags.FFlagSquadsEnableFoundationTestIds)
require(Squads.Enums.SquadActivityEnum)

local foundation = dependencies.Foundation
local react = dependencies.React
local sharedFlags = dependencies.SharedFlags

local squadCoordinationUIChangesExperimentation = dependencies.SocialExperiments.SquadCoordinationUIChangesExperimentation
local useLocalization = dependencies.Hooks.useLocalization

local Constants = require(parent.SquadsCore.Constants)

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadParentChannelId = Hooks.useCurrentSquadParentChannelId

local useTokens = foundation.Hooks.useTokens
local view = foundation.View

local fFlagDebugAppChatEnableDomLocators = sharedFlags.FFlagDebugAppChatEnableDomLocators
local getFFlagEnableCrossExpVoice = sharedFlags.GetFFlagEnableCrossExpVoice
local useLastActiveParticipant

if getFFlagEnableCrossExpVoice() then
	local CrossExperienceVoice = require(parent.CrossExperienceVoice)
	useLastActiveParticipant = CrossExperienceVoice.Hooks.useLastActiveParticipant
else
	useLastActiveParticipant = nil
end

function SquadTopBanner(props)
	react.useEffect(function()
		squadCoordinationUIChangesExperimentation.logExposure()
	end, {})
	local v

	if FFlagIntroduceTopBannerPartyStates and getFFlagEnableCrossExpVoice() then
		v = useLastActiveParticipant()
	end

	local userId = v and v.userId or nil

	local v2 = useTokens()
	local v3

	if not FFlagIntroduceTopBannerPartyStates then
		v3 = useCurrentSquadParentChannelId()
	end

	local v4

	if not FFlagIntroduceTopBannerPartyStates then
		v4 = react.useContext(SquadExternalContractContext)
	end

	local text2 = FFlagIntroduceTopBannerPartyStates and "" or v4.useParentChannelTitleSelector(v3 or "") or ""

	local v5 = useLocalUserId()

	local v6 = react.useMemo(function()
		if
			props.parentChannelType == Constants.CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE
			and props.parentChannelParticipants
		then
			for _, parentChannelParticipant in ipairs(props.parentChannelParticipants) do
				if parentChannelParticipant ~= v5 then
					return parentChannelParticipant
				end
			end
		end

		return ""
	end, { props.parentChannelParticipants, props.parentChannelType, v5 })

	local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
	local userIds

	if v6 == "" then
		userIds = {}
	else
		userIds = { v6 } or {}
	end

	local v7 = useUserProfilesFetch({
		userIds = userIds,
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})

	local combinedName = v7.data and (UserProfiles.Selectors.getCombinedNameFromId(v7.data, v6 or "") or "") or nil

	local v8 = not props.parentChannelType

	if not v8 then
		if props.parentChannelType == Constants.CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE and v6 ~= "" then
			v8 = not combinedName
		else
			v8 = false
		end
	end

	local v9, images

	if FFlagIntroduceTopBannerPartyStates then
		local v10 = useLocalization({
			waitingForOthers = "Feature.Squads.Label.WaitingForOthers",
			numberInTheParty = "Feature.Squads.Label.PartyCountStatus",
			loading = "Feature.Squads.Label.Loading",
			waitingForCombinedName = "Feature.Squads.Label.WaitingForCombinedName"
		})

		v9 = react.useMemo(function()
			if v8 then
				return v10.loading
			end

			if
				props.parentChannelType == Constants.CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE
				and combinedName
				and #props.squadMemberList < 2
			then
				return v10.waitingForCombinedName:gsub("{(.-)}", { combinedName = combinedName })
			end

			if props.parentChannelType == Constants.CONVERSATION_CHANNEL_GROUP_TYPE and #props.squadMemberList < 2 then
				return v10.waitingForOthers
			end

			return v10.numberInTheParty:gsub("{(.-)}", {
				partyCount = tostring(#props.squadMemberList)
			})
		end, { v8, v10, combinedName, props.parentChannelType, props.squadMemberList })

		local v11 = react.useCallback(function()
			local result = {}

			if v5 == "-1" or not props.squadMemberList then
				return result
			end

			for _, squadMember in ipairs(props.squadMemberList) do
				if tostring(squadMember) ~= v5 then
					table.insert(result, (tostring(squadMember)))
				end
			end

			table.insert(result, v5)
			return result
		end, { props.squadMemberList })

		images = react.useMemo(function()
			local v12 = v11()

			return Cryo.List.map(v12, function(p)
				return getStandardSizeAvatarHeadShotRbxthumb(p)
			end)
		end, { v11 })
	end

	local createElement = react.createElement
	local view2 = foundation.View
	local v10 = {
		Size = UDim2.new(1, 0, 1, 0),
		backgroundStyle = v2.Color.None,
		testId = 0,
		layout = 0
	}
	local testId

	if fFlagDebugAppChatEnableDomLocators then
		testId = Constants.SQUAD_TOP_BANNER_TEST_ID
	end

	v10.testId = testId
	v10.layout = {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		Padding = UDim.new(0, v2.Gap.Small),
		VerticalAlignment = Enum.VerticalAlignment.Center
	}
	local icon

	if not FFlagIntroduceTopBannerPartyStates then
		icon = react.createElement(
			"Frame",
			{ Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, LayoutOrder = 1 },
			{ react.createElement(foundation.Icon, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					size = 28,
					name = "three-people",
					style = v2.Color.Extended.Gray.Gray_100,
					testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-top-banner--icon" or nil
				}) }
		)
	end

	local horizontalFacepileGroup

	if FFlagIntroduceTopBannerPartyStates then
		horizontalFacepileGroup = react.createElement(
			view,
			{ tag = "auto-xy", BackgroundTransparency = 1, LayoutOrder = 1 },
			{ react.createElement(HorizontalFacepileGroup, {
					avatarSize = v2.Size.Size_600,
					images = images,
					testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-top-banner--facepile" or nil
				}) }
		)
	end

	local createElement2 = react.createElement
	local text = foundation.Text
	local v11 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		textStyle = v2.Color.Extended.Gray.Gray_100,
		fontStyle = v2.Typography.TitleMedium,
		backgroundStyle = v2.Color.None,
		LayoutOrder = 2,
		Text = 0,
		TextTruncate = 0,
		TextXAlignment = 0,
		testId = 0
	}

	if FFlagIntroduceTopBannerPartyStates then
		text2 = v9
	end

	v11.Text = text2
	v11.TextTruncate = Enum.TextTruncate.AtEnd
	v11.TextXAlignment = Enum.TextXAlignment.Left
	v11.testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-top-banner--title" or nil
	local v12 = {
		Icon = icon,
		HorizontalFacepileGroup = horizontalFacepileGroup,
		Title = createElement2(text, v11, {
			UIFlexItem = react.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill })
		}),
		Avatar = 0
	}
	local avatar

	if not (FFlagIntroduceTopBannerPartyStates or not userId) then
		avatar = react.createElement(foundation.Image, {
			LayoutOrder = 3,
			Size = UDim2.fromOffset(24, 24),
			backgroundStyle = v2.Color.Extended.Gray.Gray_700,
			cornerRadius = UDim.new(0, v2.Radius.Circle),
			Image = getStandardSizeAvatarHeadShotRbxthumb((tostring(userId))),
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-top-banner--last-active-avatar" or nil
		})
	end

	v12.Avatar = avatar
	return createElement(view2, v10, v12)
end

return react.memo(SquadTopBanner)
