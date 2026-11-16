local Squads = script:FindFirstAncestor("Squads")

local dependencies = require(Squads.dependencies)

local parent = Squads.Parent
local CrossExperienceVoice = require(parent.CrossExperienceVoice)
local UIBlox = require(parent.UIBlox)
local UserProfiles = require(parent.UserProfiles)
local UserLib = require(parent.UserLib)
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local BuilderIcons = require(parent.BuilderIcons)
local Hooks = require(parent.SquadsCore.Hooks)

local presenceType = dependencies.RoduxPresence.Enums.PresenceType
local foundation = dependencies.Foundation
local react = dependencies.React
local sharedFlags = dependencies.SharedFlags

local useLocalization = dependencies.Hooks.useLocalization
local useSelector = dependencies.Hooks.useSelector

local Flags = require(parent.SquadsCore.Flags)
local FFlagSquadsPresenceStoreMigration = Flags.FFlagSquadsPresenceStoreMigration
local FFlagSquadsEnableFoundationTestIds = require(Squads.Flags.FFlagSquadsEnableFoundationTestIds)
local useGetPresenceByUserId

if FFlagSquadsPresenceStoreMigration then
	local FriendsCommon = require(parent.FriendsCommon)
	useGetPresenceByUserId = FriendsCommon.Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

local presenceType2

if FFlagSquadsPresenceStoreMigration then
	local DataHydration = require(parent.DataHydration)
	presenceType2 = DataHydration.Presence.PresenceEnums.PresenceType
else
	presenceType2 = nil
end

local useParticipant = CrossExperienceVoice.Hooks.useParticipant
local useIsVoiceConnected = CrossExperienceVoice.Hooks.useIsVoiceConnected
local useIsActiveParticipant = CrossExperienceVoice.Hooks.useIsActiveParticipant
local useAnimatedTransparency = CrossExperienceVoice.Hooks.useAnimatedTransparency
local useIsParticipantMuted = CrossExperienceVoice.Hooks.useIsParticipantMuted
local useIsVoiceConnecting = CrossExperienceVoice.Hooks.useIsVoiceConnecting
local useIsMicPermissionsError = CrossExperienceVoice.Hooks.useIsMicPermissionsError
local useIsParticipantInOtherAudioContext = CrossExperienceVoice.Hooks.useIsParticipantInOtherAudioContext
local useIsParticipantMutedLocally = CrossExperienceVoice.Hooks.useIsParticipantMutedLocally
local useTokens = foundation.Hooks.useTokens
local useSquadUserDropdownMenuButtons = require(Squads.Hooks.useSquadUserDropdownMenuButtons)

local useIsLocalPlayerPartyVoiceEligible = Hooks.useIsLocalPlayerPartyVoiceEligible
local useIsUserPartyVoiceEligible = Hooks.useIsUserPartyVoiceEligible
local useIsCurrentSquadPartyVoiceEligible = Hooks.useIsCurrentSquadPartyVoiceEligible

local getFFlagEnableCrossExpVoice = sharedFlags.GetFFlagEnableCrossExpVoice
local iconSize = foundation.Enums.IconSize
local stateLayerAffordance = foundation.Enums.StateLayerAffordance

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

require(Squads.Common.ModelTypes)
local SquadUserPartyStatus = require(Squads.Enums.SquadUserPartyStatus)

local SquadLobbyUserOverflowMenuContainer = require(Squads.Components.SquadLobby.SquadLobbyUserOverflowMenu.SquadLobbyUserOverflowMenuContainer)

local defineFastInt = game:DefineFastInt("PartyVoiceActivityIndicatorDebounceMs", 100)
local defineFastInt2 = game:DefineFastInt("PartyVoiceActivityIndicatorAnimationMs", 100)

local fFlagEnablePartyVoiceChangersInLua = sharedFlags.FFlagEnablePartyVoiceChangersInLua
local fFlagEnableBlackbirdCheck = sharedFlags.FFlagEnableBlackbirdCheck
local FFlagSquadMemberJoinDialogAndOverflowMenu = require(Squads.Flags.FFlagSquadMemberJoinDialogAndOverflowMenu)
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber

return function(props)
	local v = useLocalization({
		connectingText = "Feature.Squads.Label.Connecting",
		inExperiencePresenceText = "Common.Presence.Label.InExperience",
		invitedText = "Feature.Squads.Description.Invited",
		noResponseText = "Feature.Squads.Description.NoResponse",
		onlinePresenceText = "Common.Presence.Label.Online"
	})

	local v2 = useTokens()

	local transparency, v3 = useAnimatedTransparency(1, defineFastInt2, Enum.EasingStyle.Cubic)
	local v4

	if fFlagEnableBlackbirdCheck then
		v4 = tostring(props.user.userId)
	end

	local v5 = useIsRobloxSubscriber(v4)

	local v6 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { (tostring(props.user.userId)) },
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})

	local text2 = not v6.data and "" or UserProfiles.Selectors.getCombinedNameFromId(v6.data, props.user.userId)

	local standardSizeAvatarHeadShotRbxthumb = getStandardSizeAvatarHeadShotRbxthumb((tostring(props.user.userId)))
	local formatted = `--social-squad-lobby-user-card-{props.user.userId}`

	local v7 = react.useCallback(function(p)
		return p.Squad.Presence.byUserId[tostring(props.user.userId)]
	end, { props.user.userId })
	local v8

	if FFlagSquadsPresenceStoreMigration then
		v8 = useGetPresenceByUserId((tostring(props.user.userId)))
	else
		v8 = useSelector(v7)
	end

	local v9

	if v8 then
		local userPresenceType = v8.userPresenceType
		local v10

		if FFlagSquadsPresenceStoreMigration then
			v10 = presenceType2.InGame
		else
			v10 = presenceType.InGame
		end

		v9 = userPresenceType == v10
	else
		v9 = v8
	end

	local v10

	if v9 then
		if FFlagSquadsPresenceStoreMigration then
			v10 = v8 and v8.lastLocation
		else
			v10 = v8.lastLocation
		end

		if not v10 or v10 == "" then
			v10 = v.inExperiencePresenceText
		end
	else
		v10 = v.onlinePresenceText
	end

	local isConnecting = props.isConnecting
	local v11 = tonumber(useLocalUserId()) or 0
	local v12 = v11 == props.user.userId
	local v13, v14, v15, v16, v17, v18, v19

	if getFFlagEnableCrossExpVoice() then
		local v20 = useIsVoiceConnected()
		local v21 = useIsMicPermissionsError()
		local v22 = useParticipant(props.user.userId)
		v13 = useIsVoiceConnecting() and v12
		v14 = useIsActiveParticipant(props.user.userId)
		local v23 = useIsLocalPlayerPartyVoiceEligible()
		local v24 = useIsUserPartyVoiceEligible(props.user.userId)
		local v25 = useIsCurrentSquadPartyVoiceEligible() == true
		local v26 = useIsParticipantMutedLocally(props.user.userId) == true

		v15 = v24 and v25 and not v12 and v26
		v16 = useIsParticipantMuted(props.user.userId) and not v15
		local v27 = useIsParticipantInOtherAudioContext(v11, props.user.userId) == true

		v17 = v25 and v23 and v24 and (not v20 or not v22 or v27 or v21)

		v18 = v25 and v23 and not v24

		if fFlagEnablePartyVoiceChangersInLua and v22 then
			v19 = v22.isVoiceChangerActive
		else
			v19 = false
		end
	else
		v14 = false
		v13 = false
		v15 = false
		v16 = false
		v17 = false
		v18 = false
		v19 = false
	end

	local v20 = react.useMemo(function()
		return CrossExperienceVoice.Utils.debounce(function(p: number)
			v3(p)
		end, defineFastInt)
	end, {})

	react.useEffect(function()
		if getFFlagEnableCrossExpVoice() then
			if v14 then
				v20.cancel()
				v3(0)
			else
				v20.call(1)
			end
		end
	end, { v14 })

	local text3 = react.useMemo(function()
		if props.user.partyStatus == SquadUserPartyStatus.NoResponse then
			return v.noResponseText
		end

		if props.user.partyStatus == SquadUserPartyStatus.Invited then
			return v.invitedText
		end

		return if isConnecting or v13 then v.connectingText else v10
	end, {
		props.user and props.user.partyStatus,
		v10,
		isConnecting,
		v13,
		v.noResponse,
		v.invitedText,
		v.connectingText
	})

	local presenceIcon = react.useMemo(function()
		if props.user.partyStatus == SquadUserPartyStatus.Invited then
			local createElement = react.createElement
			local view = foundation.View
			local createElement2 = react.createElement
			local loading = foundation.Loading
			local v21 = {
				LayoutOrder = 1,
				size = iconSize.Small,
				Padding = v2.Padding.XSmall,
				testId = 0
			}
			local testId

			if FFlagSquadsEnableFoundationTestIds then
				testId = `{formatted}--loading`
			end

			v21.testId = testId
			return createElement(view, { tag = "auto-xy" }, {
				LoadingIcon = createElement2(loading, v21)
			})
		end

		if props.user.partyStatus == SquadUserPartyStatus.NoResponse then
			return nil
		end

		if isConnecting or v13 then
			local createElement = react.createElement
			local view = foundation.View
			local createElement2 = react.createElement
			local loading = foundation.Loading
			local v21 = {
				LayoutOrder = 1,
				size = iconSize.Small,
				Padding = v2.Padding.XSmall,
				testId = 0
			}
			local testId

			if FFlagSquadsEnableFoundationTestIds then
				testId = `{formatted}--loading`
			end

			v21.testId = testId
			return createElement(view, { tag = "auto-xy" }, {
				LoadingIcon = createElement2(loading, v21)
			})
		else
			if not v9 then
				return nil
			end

			local createElement = react.createElement
			local icon = foundation.Icon
			local v21 = {
				LayoutOrder = 1,
				name = "icons/common/play",
				size = iconSize.Small,
				style = v2.Color.Content.Emphasis,
				testId = 0
			}
			local testId

			if FFlagSquadsEnableFoundationTestIds then
				testId = `{formatted}--in-game-icon`
			end

			v21.testId = testId
			return createElement(icon, v21)
		end
	end, {
		props.user and props.user.partyStatus,
		isConnecting,
		v13,
		v9,
		formatted
	})

	local useMemo = react.useMemo
	local function fn()
		if text2 == "" then
			return nil
		end

		local createElement = react.createElement
		local v21 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}

		local v22 = {
			UIListLayout = react.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v2.Gap.XSmall + 2),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			BlockedIcon = 0,
			MutedLocallyIcon = 0,
			MutedIcon = 0,
			NotVoiceParticipantIcon = 0,
			NotEligibleVoiceParticipant = 0,
			VoiceChangerActiveIcon = 0,
			NameTextLabel = 0,
			NameAndBadge = 0
		}
		local blockedIcon

		if props.isBlocked then
			local createElement2 = react.createElement
			local icon = foundation.Icon
			local v23 = {
				LayoutOrder = 1,
				name = "icons/status/unavailable_small",
				size = iconSize.Small,
				style = v2.Color.Extended.Red.Red_800,
				testId = 0
			}
			local testId

			if FFlagSquadsEnableFoundationTestIds then
				testId = `{formatted}--blocked-icon`
			end

			v23.testId = testId
			blockedIcon = createElement2(icon, v23)
		end

		v22.BlockedIcon = blockedIcon
		local mutedLocallyIcon

		if v15 then
			local createElement2 = react.createElement
			local icon = foundation.Icon
			local v23 = {
				LayoutOrder = 2,
				name = "icons/controls/voice/microphone_off_small_dark",
				size = iconSize.Small,
				style = v2.Color.Extended.Red.Red_800,
				testId = 0
			}
			local testId

			if FFlagSquadsEnableFoundationTestIds then
				testId = `{formatted}--muted-locally-icon`
			end

			v23.testId = testId
			mutedLocallyIcon = createElement2(icon, v23)
		end

		v22.MutedLocallyIcon = mutedLocallyIcon
		local mutedIcon

		if v16 then
			local createElement2 = react.createElement
			local icon = foundation.Icon
			local v23 = {
				LayoutOrder = 3,
				name = "icons/controls/microphoneMute_small",
				size = iconSize.Small,
				style = v2.Color.Content.Emphasis,
				testId = 0
			}
			local testId

			if FFlagSquadsEnableFoundationTestIds then
				testId = `{formatted}--muted-icon`
			end

			v23.testId = testId
			mutedIcon = createElement2(icon, v23)
		end

		v22.MutedIcon = mutedIcon
		local notVoiceParticipantIcon

		if v17 then
			local createElement2 = react.createElement
			local icon = foundation.Icon
			local v23 = {
				LayoutOrder = 4,
				name = "icons/controls/headphoneDeafen_small",
				size = iconSize.Small,
				style = v2.Color.Content.Emphasis,
				testId = 0
			}
			local testId

			if FFlagSquadsEnableFoundationTestIds then
				testId = `{formatted}--not-voice-participant-icon`
			end

			v23.testId = testId
			notVoiceParticipantIcon = createElement2(icon, v23)
		end

		v22.NotVoiceParticipantIcon = notVoiceParticipantIcon
		local notEligibleVoiceParticipant

		if v18 then
			local createElement2 = react.createElement
			local icon = foundation.Icon
			local v23 = {
				LayoutOrder = 5,
				name = "icons/controls/headphoneDeafen_small",
				size = iconSize.Small,
				style = v2.Color.System.Warning,
				testId = 0
			}
			local testId

			if FFlagSquadsEnableFoundationTestIds then
				testId = `{formatted}--not-eligible-voice-participant-icon`
			end

			v23.testId = testId
			notEligibleVoiceParticipant = createElement2(icon, v23)
		end

		v22.NotEligibleVoiceParticipant = notEligibleVoiceParticipant
		local voiceChangerActiveIcon

		if fFlagEnablePartyVoiceChangersInLua and v19 then
			local createElement2 = react.createElement
			local icon = foundation.Icon
			local v23 = {
				LayoutOrder = 6,
				size = iconSize.Small,
				name = BuilderIcons.Icon.DiamondSimplified,
				style = v2.Color.Content.Emphasis,
				testId = 0
			}
			local testId

			if FFlagSquadsEnableFoundationTestIds then
				testId = `{formatted}--voice-changer-icon`
			end

			v23.testId = testId
			voiceChangerActiveIcon = createElement2(icon, v23)
		end

		v22.VoiceChangerActiveIcon = voiceChangerActiveIcon
		local nameTextLabel

		if not fFlagEnableBlackbirdCheck then
			local createElement2 = react.createElement
			local text = foundation.Text
			local v23 = {
				AutomaticSize = Enum.AutomaticSize.Y,
				backgroundStyle = v2.Color.None,
				colorstyle = v2.Color.Content.Emphasis,
				fontStyle = v2.Typography.TitleMedium,
				LayoutOrder = fFlagEnablePartyVoiceChangersInLua and 7 or 6,
				Text = text2,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextWrapped = false,
				testId = 0
			}
			local testId

			if FFlagSquadsEnableFoundationTestIds then
				testId = `{formatted}--name`
			end

			v23.testId = testId
			nameTextLabel = createElement2(text, v23, {
				UIFlexItem = react.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill })
			})
		end

		v22.NameTextLabel = nameTextLabel
		local nameAndBadge

		if fFlagEnableBlackbirdCheck then
			local createElement2 = react.createElement
			local v23 = {
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(0, 0),
				BackgroundTransparency = 1,
				LayoutOrder = fFlagEnablePartyVoiceChangersInLua and 7 or 6
			}

			local v24 = {
				Layout = react.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, v2.Gap.XSmall),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				FlexFill = react.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill }),
				NameText = 0,
				SubscriptionBadge = 0
			}

			local createElement3 = react.createElement
			local text = foundation.Text
			local v25 = {
				AutomaticSize = Enum.AutomaticSize.XY,
				backgroundStyle = v2.Color.None,
				colorstyle = v2.Color.Content.Emphasis,
				fontStyle = v2.Typography.TitleMedium,
				LayoutOrder = 1,
				Text = text2,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextWrapped = false,
				testId = 0
			}
			local testId

			if FFlagSquadsEnableFoundationTestIds then
				testId = `{formatted}--name`
			end

			v25.testId = testId
			v24.NameText = createElement3(text, v25, {
				UIFlexItem = react.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Shrink })
			})
			local subscriptionBadge

			if v5 then
				local createElement4 = react.createElement
				local icon = foundation.Icon
				local v26 = {
					LayoutOrder = 2,
					size = iconSize.Small,
					name = foundation.Enums.IconName.RobloxPlus,
					style = v2.Color.Content.Emphasis,
					testId = 0
				}
				local testId2

				if FFlagSquadsEnableFoundationTestIds then
					testId2 = `{formatted}--subscription-badge`
				end

				v26.testId = testId2
				subscriptionBadge = createElement4(icon, v26)
			end

			v24.SubscriptionBadge = subscriptionBadge
			nameAndBadge = createElement2("Frame", v23, v24)
		end

		v22.NameAndBadge = nameAndBadge
		return (createElement("Frame", v21, v22))
	end

	local isBlocked = props.isBlocked
	local v21

	if fFlagEnablePartyVoiceChangersInLua then
		v21 = v19
	end

	local v22

	if fFlagEnableBlackbirdCheck then
		v22 = v5
	end

	local name = useMemo(fn, {
		text2,
		v16,
		v15,
		isBlocked,
		v2,
		v17,
		v18,
		v21,
		v22,
		formatted
	})

	local presence = react.useMemo(function()
		local createElement = react.createElement
		local v23 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}

		local v24 = {
			UIListLayout = react.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v2.Gap.XSmall),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			PresenceIcon = presenceIcon,
			PresenceTextLabel = 0
		}

		local createElement2 = react.createElement
		local text = foundation.Text
		local v25 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			backgroundStyle = v2.Color.None,
			colorstyle = v2.Color.Content.Default,
			fontStyle = v2.Typography.BodyMedium,
			LayoutOrder = 2,
			Text = text3,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextWrapped = false,
			testId = 0
		}
		local testId

		if FFlagSquadsEnableFoundationTestIds then
			testId = `{formatted}--presence`
		end

		v25.testId = testId
		v24.PresenceTextLabel = createElement2(text, v25, {
			UIFlexItem = react.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill })
		})
		return createElement("Frame", v23, v24)
	end, {
		isConnecting,
		v13,
		v9,
		v.connectingText,
		v10,
		v2,
		presenceIcon,
		text3,
		formatted
	})

	local v23 = useSquadUserDropdownMenuButtons(props.user.userId, props.isInExperience)
	local v24 = #v23 < 1
	local v25, v26

	if FFlagSquadMemberJoinDialogAndOverflowMenu then
		v25 = not v12
		v26 = not (table.find(v23, "JoinButton") == nil)
	else
		v26 = false
		v25 = not (v12 or v24)
	end

	local openSquadVoiceAbuseReport = props.openSquadVoiceAbuseReport

	local isDisabled = isConnecting
		or v13
		or props.user.partyStatus == SquadUserPartyStatus.Invited
		or props.user.partyStatus == SquadUserPartyStatus.NoResponse

	local onActivated = react.useCallback(function()
		if FFlagSquadMemberJoinDialogAndOverflowMenu and not v26 then
			return
		end

		if props.onActivated then
			props.onActivated((tostring(props.user.userId)))
		end
	end, { props.onActivated, props.user.userId, v26 })

	local createElement = react.createElement
	local view = foundation.View
	local v27 = {
		LayoutOrder = props.layoutOrder,
		Size = props.size,
		backgroundStyle = v2.Color.Surface.Surface_200,
		cornerRadius = UDim.new(0, v2.Radius.Medium),
		isDisabled = isDisabled,
		onActivated = 0,
		stateLayer = 0,
		testId = 0
	}

	if not (props.onActivated and v25) then
		onActivated = nil
	end

	v27.onActivated = onActivated
	v27.stateLayer = FFlagSquadMemberJoinDialogAndOverflowMenu
		and not v26
		and { affordance = stateLayerAffordance.None }
		or nil
	local testId

	if FFlagSquadsEnableFoundationTestIds then
		testId = formatted
	end

	v27.testId = testId
	local children = {
		AvatarImage = react.createElement(ImageSetLabel, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(96, 96),
			BackgroundColor3 = v2.Color.Shift.Shift_300.Color3,
			BackgroundTransparency = v2.Color.Shift.Shift_300.Transparency,
			Image = standardSizeAvatarHeadShotRbxthumb,
			ZIndex = 0
		}, {
			UICorner = react.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
		}),
		GradientFrame = react.createElement("Frame", {
			Size = UDim2.fromScale(1, 0.5),
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = v2.Color.Surface.Surface_100.Color3,
			BackgroundTransparency = v2.Color.Surface.Surface_100.Transparency,
			ZIndex = 1
		}, {
			UICorner = react.createElement("UICorner", {
				CornerRadius = UDim.new(0, v2.Radius.Medium)
			}),
			UIGradient = react.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) })
			}, {})
		}),
		InactiveOverlay = 0,
		TextContainer = 0,
		OverflowMenu = 0,
		ActiveBorder = 0,
		DefaultBorder = 0
	}
	local inactiveOverlay

	if
		isConnecting
		or v17
		or v13
		or props.user.partyStatus == SquadUserPartyStatus.Invited
		or props.user.partyStatus == SquadUserPartyStatus.NoResponse
	then
		inactiveOverlay = react.createElement(foundation.View, {
			tag = "size-full radius-medium",
			backgroundStyle = { Color3 = v2.Color.Surface.Surface_100.Color3, Transparency = 0.25 }
		}, {})
	end

	children.InactiveOverlay = inactiveOverlay

	local createElement2 = react.createElement
	local v28 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		ZIndex = 2
	}

	local v29 = {
		UIListLayout = react.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom
		}),
		UIPadding = react.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, v2.Padding.Medium),
			PaddingLeft = UDim.new(0, v2.Padding.Medium),
			PaddingRight = UDim.new(0, v2.Padding.Medium),
			PaddingTop = UDim.new(0, v2.Padding.Medium)
		}),
		Name = name,
		Presence = 0
	}

	if props.isBlocked then
		presence = nil
	end

	v29.Presence = presence
	children.TextContainer = createElement2("Frame", v28, v29)
	local overflowMenu

	if FFlagSquadMemberJoinDialogAndOverflowMenu and not v12 and not isDisabled and openSquadVoiceAbuseReport then
		overflowMenu = react.createElement(SquadLobbyUserOverflowMenuContainer, {
			userId = tostring(props.user.userId),
			isInExperience = props.isInExperience,
			openSquadVoiceAbuseReport = openSquadVoiceAbuseReport
		})
	end

	children.OverflowMenu = overflowMenu

	children.ActiveBorder = react.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, -8, 1, -8),
		BackgroundTransparency = 1,
		ZIndex = 4
	}, {
		UICorner = react.createElement("UICorner", {
			CornerRadius = UDim.new(0, v2.Radius.Medium - 4)
		}),
		UIStroke = react.createElement("UIStroke", {
			Thickness = 4,
			Color = v2.Color.Extended.Green.Green_800.Color3,
			Transparency = transparency
		})
	})

	children.DefaultBorder = react.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, -2, 1, -2),
		BackgroundTransparency = 1,
		ZIndex = 3
	}, {
		UICorner = react.createElement("UICorner", {
			CornerRadius = UDim.new(0, v2.Radius.Medium - 1)
		}),
		UIStroke = react.createElement("UIStroke", {
			Thickness = 1,
			Color = v2.Color.Stroke.Default.Color3,
			Transparency = transparency:map(function(p)
				if p < 0.9 then
					return 1
				end

				return v2.Color.Stroke.Default.Transparency
			end)
		})
	})
	return createElement(view, v27, children)
end
