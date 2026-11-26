local getStandardSizeAvatarHeadShotRbxthumb = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UserLib").Utils.getStandardSizeAvatarHeadShotRbxthumb
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RobloxAppHooks").useLocalUserId
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Cryo")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/Squads/UserProfiles")

local module3 = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Common/HorizontalFacepileGroup")
local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")
local FFlagIntroduceTopBannerPartyStates = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagIntroduceTopBannerPartyStates")
local FFlagSquadsEnableFoundationTestIds = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadsEnableFoundationTestIds")
require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/SquadActivityEnum")

local foundation = dependencies.Foundation
local react = dependencies.React
local sharedFlags = dependencies.SharedFlags

local squadCoordinationUIChangesExperimentation = dependencies.SocialExperiments.SquadCoordinationUIChangesExperimentation
local useLocalization = dependencies.Hooks.useLocalization

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Constants")

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local useCurrentSquadParentChannelId = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks").useCurrentSquadParentChannelId

local useTokens = foundation.Hooks.useTokens
local view = foundation.View

local fFlagDebugAppChatEnableDomLocators = sharedFlags.FFlagDebugAppChatEnableDomLocators
local getFFlagEnableCrossExpVoice = sharedFlags.GetFFlagEnableCrossExpVoice
local useLastActiveParticipant

if getFFlagEnableCrossExpVoice() then
	useLastActiveParticipant = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/CrossExperienceVoice").Hooks.useLastActiveParticipant
else
	useLastActiveParticipant = nil
end

function LUAUFORGE_MODULE_GLOBALS_huc_SquadTopBanner(props)
	react.useEffect(function()
		squadCoordinationUIChangesExperimentation.logExposure()
	end, {})

	local v5 = if FFlagIntroduceTopBannerPartyStates and getFFlagEnableCrossExpVoice() then useLastActiveParticipant() else nil

	local userId = v5 and v5.userId or nil

	local v6 = useTokens()

	local v7 = if not FFlagIntroduceTopBannerPartyStates then useCurrentSquadParentChannelId() else nil

	local v8 = if not FFlagIntroduceTopBannerPartyStates then react.useContext(squadExternalContractContext) else nil

	local v9 = FFlagIntroduceTopBannerPartyStates and "" or v8.useParentChannelTitleSelector(v7 or "") or ""

	local v10 = useLocalUserId()

	local v12 = react.useMemo(function()
		if
			props.parentChannelType == Constants.CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE
			and props.parentChannelParticipants
		then
			for i, parentChannelParticipant in ipairs(props.parentChannelParticipants) do
				if parentChannelParticipant ~= v10 then
					return parentChannelParticipant
				end
			end
		end

		return ""
	end, { props.parentChannelParticipants, props.parentChannelType, v10 })

	local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
	local v14 = if v12 == "" then {} else { v12 } or {}
	local v15 = useUserProfilesFetch({
		userIds = v14,
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})

	local v16 = v15.data and (UserProfiles.Selectors.getCombinedNameFromId(v15.data, v12 or "") or "") or nil

	local v17 = not props.parentChannelType

	if not v17 then
		if props.parentChannelType == Constants.CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE and v12 ~= "" then
			v17 = not v16
		else
			v17 = false
		end
	end

	local v19, v20

	if FFlagIntroduceTopBannerPartyStates then
		local v21 = useLocalization({
			waitingForOthers = "Feature.Squads.Label.WaitingForOthers",
			numberInTheParty = "Feature.Squads.Label.PartyCountStatus",
			loading = "Feature.Squads.Label.Loading",
			waitingForCombinedName = "Feature.Squads.Label.WaitingForCombinedName"
		})

		v19 = react.useMemo(function()
			if v17 then
				return v21.loading
			end

			if
				props.parentChannelType == Constants.CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE
				and v16
				and #props.squadMemberList < 2
			then
				return v21.waitingForCombinedName:gsub("{(.-)}", { combinedName = v16 })
			end

			if
				props.parentChannelType == Constants.CONVERSATION_CHANNEL_GROUP_TYPE
				and #props.squadMemberList < 2
			then
				return v21.waitingForOthers
			end

			return v21.numberInTheParty:gsub("{(.-)}", {
				partyCount = tostring(#props.squadMemberList)
			})
		end, { v17, v21, v16, props.parentChannelType, props.squadMemberList })

		local v22 = react.useCallback(function()
			local result = {}

			if v10 == "-1" or not props.squadMemberList then
				return result
			end

			for i, squadMember in ipairs(props.squadMemberList) do
				if tostring(squadMember) ~= v10 then
					table.insert(result, (tostring(squadMember)))
				end
			end

			table.insert(result, v10)
			return result
		end, { props.squadMemberList })

		v20 = react.useMemo(function()
			local v23 = v22()

			return Cryo.List.map(v23, function(p2)
				return getStandardSizeAvatarHeadShotRbxthumb(p2)
			end)
		end, { v22 })
	end

	local createElement = react.createElement
	local view2 = foundation.View
	local v21 = {
		Size = UDim2.new(1, 0, 1, 0),
		backgroundStyle = v6.Color.None,
		testId = 0,
		layout = 0
	}
	local v22 = if fFlagDebugAppChatEnableDomLocators then Constants.SQUAD_TOP_BANNER_TEST_ID else nil
	v21.testId = v22
	v21.layout = {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		Padding = UDim.new(0, v6.Gap.Small),
		VerticalAlignment = Enum.VerticalAlignment.Center
	}

	local v24 = if not FFlagIntroduceTopBannerPartyStates then react.createElement(
		"Frame",
		{ Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, LayoutOrder = 1 },
		{ react.createElement(foundation.Icon, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				size = 28,
				name = "three-people",
				style = v6.Color.Extended.Gray.Gray_100,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-top-banner--icon" or nil
			}) }
	) else nil

	local v25 = if FFlagIntroduceTopBannerPartyStates then react.createElement(
		view,
		{ tag = "auto-xy", BackgroundTransparency = 1, LayoutOrder = 1 },
		{ react.createElement(module3, {
				avatarSize = v6.Size.Size_600,
				images = v20,
				testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-top-banner--facepile" or nil
			}) }
	) else nil

	local createElement2 = react.createElement
	local text = foundation.Text
	local v26 = {
		AutomaticSize = Enum.AutomaticSize.XY,
		textStyle = v6.Color.Extended.Gray.Gray_100,
		fontStyle = v6.Typography.TitleMedium,
		backgroundStyle = v6.Color.None,
		LayoutOrder = 2,
		Text = 0,
		TextTruncate = 0,
		TextXAlignment = 0,
		testId = 0
	}

	if FFlagIntroduceTopBannerPartyStates then
		v9 = v19
	end

	v26.Text = v9
	v26.TextTruncate = Enum.TextTruncate.AtEnd
	v26.TextXAlignment = Enum.TextXAlignment.Left
	v26.testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-top-banner--title" or nil
	local v23 = {
		Icon = v24,
		HorizontalFacepileGroup = v25,
		Title = createElement2(text, v26, {
			UIFlexItem = react.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Fill
			})
		}),
		Avatar = 0
	}

	local v27 = if not (FFlagIntroduceTopBannerPartyStates or not userId) then react.createElement(foundation.Image, {
		LayoutOrder = 3,
		Size = UDim2.fromOffset(24, 24),
		backgroundStyle = v6.Color.Extended.Gray.Gray_700,
		cornerRadius = UDim.new(0, v6.Radius.Circle),
		Image = getStandardSizeAvatarHeadShotRbxthumb((tostring(userId))),
		testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-top-banner--last-active-avatar" or nil
	}) else nil
	v23.Avatar = v27
	return createElement(view2, v21, v23)
end

return react.memo(LUAUFORGE_MODULE_GLOBALS_huc_SquadTopBanner)
