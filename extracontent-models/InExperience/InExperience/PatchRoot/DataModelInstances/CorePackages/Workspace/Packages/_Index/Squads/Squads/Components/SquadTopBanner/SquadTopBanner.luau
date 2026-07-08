local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local getStandardSizeAvatarHeadShotRbxthumb = require(SquadsParent.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb
local useLocalUserId = require(SquadsParent.RobloxAppHooks).useLocalUserId
local Cryo = require(SquadsParent.Cryo)
local UserProfiles = require(SquadsParent.UserProfiles)
local HorizontalFacepileGroup = require(Squads.Common.HorizontalFacepileGroup)
local dependencies = require(Squads.dependencies)
local FFlagIntroduceTopBannerPartyStates = require(Squads.Flags.FFlagIntroduceTopBannerPartyStates)

require(Squads.Enums.SquadActivityEnum)

local Foundation = dependencies.Foundation
local React = dependencies.React
local SharedFlags = dependencies.SharedFlags
local SquadCoordinationUIChangesExperimentation = dependencies.SocialExperiments.SquadCoordinationUIChangesExperimentation
local useLocalization = dependencies.Hooks.useLocalization
local Constants = require(SquadsParent.SquadsCore.Constants)
local SquadExternalContractContext = require(SquadsParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local useCurrentSquadParentChannelId = require(SquadsParent.SquadsCore.Hooks).useCurrentSquadParentChannelId
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local FFlagDebugAppChatEnableDomLocators = SharedFlags.FFlagDebugAppChatEnableDomLocators
local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local useLastActiveParticipant = nil

if GetFFlagEnableCrossExpVoice() then
	useLastActiveParticipant = require(SquadsParent.CrossExperienceVoice).Hooks.useLastActiveParticipant
end

function SquadTopBanner(t1: {[any]: any}) -- line: 53
	-- upvalues: React (copy), SquadCoordinationUIChangesExperimentation (copy), FFlagIntroduceTopBannerPartyStates (copy), GetFFlagEnableCrossExpVoice (copy), useLastActiveParticipant (ref), useTokens (copy), useCurrentSquadParentChannelId (copy), SquadExternalContractContext (copy), useLocalUserId (copy), Constants (copy), UserProfiles (copy), useLocalization (copy), Cryo (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), Foundation (copy), FFlagDebugAppChatEnableDomLocators (copy), View (copy), HorizontalFacepileGroup (copy)
	React.useEffect(function() -- line: 54
		-- upvalues: SquadCoordinationUIChangesExperimentation (copy)
		if SquadCoordinationUIChangesExperimentation.isLogExposureEnabled then
			SquadCoordinationUIChangesExperimentation.logExposure()
		end
	end, {})

	local v24 = if not FFlagIntroduceTopBannerPartyStates or not GetFFlagEnableCrossExpVoice() then nil else useLastActiveParticipant()
	local v25 = v24 and v24.userId or nil
	local v26 = useTokens()
	local v27 = if not FFlagIntroduceTopBannerPartyStates then useCurrentSquadParentChannelId() else nil
	local v28 = if not FFlagIntroduceTopBannerPartyStates then React.useContext(SquadExternalContractContext) else nil
	local v29 = if not FFlagIntroduceTopBannerPartyStates then v28.useParentChannelTitleSelector(v27 or "") or "" else ""
	local v30 = useLocalUserId()
	local u31 = nil
	local v32 = React.useMemo(function() -- line: 81
		-- upvalues: t1 (copy), Constants (copy), v30 (copy)
		if t1.parentChannelType == Constants.CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE and t1.parentChannelParticipants then
			for _, v in ipairs(t1.parentChannelParticipants) do
				if v ~= v30 then
					return v
				end
			end
		end

		return ""
	end, {
		t1.parentChannelParticipants,
		t1.parentChannelType,
		v30
	})
	local v33 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = v32 ~= "" and { v32 } or {},
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})

	if v33.data then
		u31 = UserProfiles.Selectors.getCombinedNameFromId(v33.data, v32 or "") or ""
	end

	local u34 = not t1.parentChannelType or t1.parentChannelType == Constants.CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE and (v32 ~= "" and not u31)
	local v35 = nil
	local v36 = nil

	if FFlagIntroduceTopBannerPartyStates then
		local v37 = useLocalization({
			waitingForOthers = "Feature.Squads.Label.WaitingForOthers",
			numberInTheParty = "Feature.Squads.Label.PartyCountStatus",
			loading = "Feature.Squads.Label.Loading",
			waitingForCombinedName = "Feature.Squads.Label.WaitingForCombinedName"
		})

		v35 = React.useMemo(function() -- line: 122
			-- upvalues: u34 (ref), v37 (copy), t1 (copy), Constants (copy), u31 (ref)
			if u34 then
				return v37.loading
			end

			if t1.parentChannelType == Constants.CONVERSATION_CHANNEL_ONE_TO_ONE_TYPE and u31 and #t1.squadMemberList < 2 then
				return v37.waitingForCombinedName:gsub("{(.-)}", {
					combinedName = u31
				})
			end

			if t1.parentChannelType == Constants.CONVERSATION_CHANNEL_GROUP_TYPE and #t1.squadMemberList < 2 then
				return v37.waitingForOthers
			end

			return v37.numberInTheParty:gsub("{(.-)}", {
				partyCount = tostring(#t1.squadMemberList)
			})
		end, {
			u34,
			v37,
			u31,
			t1.parentChannelType,
			t1.squadMemberList
		})

		local v38 = React.useCallback(function() -- line: 148
			-- upvalues: v30 (copy), t1 (copy)
			local t2 = {}

			if v30 == "-1" or not t1.squadMemberList then
				return t2
			end

			for _, v in ipairs(t1.squadMemberList) do
				if tostring(v) ~= v30 then
					table.insert(t2, (tostring(v)))
				end
			end

			table.insert(t2, v30)

			return t2
		end, { t1.squadMemberList })

		v36 = React.useMemo(function() -- line: 166
			-- upvalues: v38 (copy), Cryo (copy), getStandardSizeAvatarHeadShotRbxthumb (copy)
			local v44 = v38()

			return Cryo.List.map(v44, function(p1) -- line: 169
				-- upvalues: getStandardSizeAvatarHeadShotRbxthumb (copy)
				return getStandardSizeAvatarHeadShotRbxthumb(p1)
			end)
		end, { v38 })
	end

	return React.createElement(Foundation.View, {
		Size = UDim2.new(1, 0, 1, 0),
		backgroundStyle = v26.Color.None,
		testId = if not FFlagDebugAppChatEnableDomLocators then nil else Constants.SQUAD_TOP_BANNER_TEST_ID,
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v26.Gap.Small),
			VerticalAlignment = Enum.VerticalAlignment.Center
		}
	}, {
		Icon = if FFlagIntroduceTopBannerPartyStates then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.fromOffset(20, 20)
		}, { React.createElement(Foundation.Icon, {
			size = 28,
			name = "three-people",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			style = v26.Color.Extended.Gray.Gray_100
		}) }),
		HorizontalFacepileGroup = if not FFlagIntroduceTopBannerPartyStates then nil else React.createElement(View, {
			tag = "auto-xy",
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}, { React.createElement(HorizontalFacepileGroup, {
			avatarSize = v26.Size.Size_600,
			images = v36
		}) }),
		Title = React.createElement(Foundation.Text, {
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.XY,
			textStyle = v26.Color.Extended.Gray.Gray_100,
			fontStyle = v26.Typography.TitleMedium,
			backgroundStyle = v26.Color.None,
			Text = if not FFlagIntroduceTopBannerPartyStates then v29 else v35,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left
		}, {
			UIFlexItem = React.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Fill
			})
		}),
		Avatar = if FFlagIntroduceTopBannerPartyStates or not v25 then nil else React.createElement(Foundation.Image, {
			LayoutOrder = 3,
			Size = UDim2.fromOffset(24, 24),
			backgroundStyle = v26.Color.Extended.Gray.Gray_700,
			cornerRadius = UDim.new(0, v26.Radius.Circle),
			Image = getStandardSizeAvatarHeadShotRbxthumb((tostring(v25)))
		})
	})
end

return React.memo(SquadTopBanner)
