local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")

local CrossExperienceVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/CrossExperienceVoice")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UIBlox")
local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Index/Squads/UserProfiles")
local getStandardSizeAvatarHeadShotRbxthumb = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UserLib").Utils.getStandardSizeAvatarHeadShotRbxthumb
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RobloxAppHooks").useLocalUserId
local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/BuilderIcons")
local Hooks = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks")

local presenceType = dependencies.RoduxPresence.Enums.PresenceType
local foundation = dependencies.Foundation
local react = dependencies.React
local sharedFlags = dependencies.SharedFlags

local useLocalization = dependencies.Hooks.useLocalization
local useSelector = dependencies.Hooks.useSelector

local fFlagSquadsPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Flags").FFlagSquadsPresenceStoreMigration
local FFlagSquadsEnableFoundationTestIds = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadsEnableFoundationTestIds")
local useGetPresenceByUserId

if fFlagSquadsPresenceStoreMigration then
	useGetPresenceByUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/FriendsCommon").Hooks.useGetPresenceByUserId
else
	useGetPresenceByUserId = nil
end

local presenceType2

if fFlagSquadsPresenceStoreMigration then
	presenceType2 = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/DataHydration").Presence.PresenceEnums.PresenceType
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
local useSquadUserDropdownMenuButtons = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Hooks/useSquadUserDropdownMenuButtons")

local useIsLocalPlayerPartyVoiceEligible = Hooks.useIsLocalPlayerPartyVoiceEligible
local useIsUserPartyVoiceEligible = Hooks.useIsUserPartyVoiceEligible
local useIsCurrentSquadPartyVoiceEligible = Hooks.useIsCurrentSquadPartyVoiceEligible

local getFFlagEnableCrossExpVoice = sharedFlags.GetFFlagEnableCrossExpVoice
local iconSize = foundation.Enums.IconSize
local stateLayerAffordance = foundation.Enums.StateLayerAffordance

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Common/ModelTypes")
local SquadUserPartyStatus = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/SquadUserPartyStatus")

local SquadLobbyUserOverflowMenuContainer = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadLobby/SquadLobbyUserOverflowMenu/SquadLobbyUserOverflowMenuContainer")

local defineFastInt = game:DefineFastInt("PartyVoiceActivityIndicatorDebounceMs", 100)
local defineFastInt2 = game:DefineFastInt("PartyVoiceActivityIndicatorAnimationMs", 100)

local fFlagEnablePartyVoiceChangersInLua = sharedFlags.FFlagEnablePartyVoiceChangersInLua
local fFlagEnableBlackbirdCheck = sharedFlags.FFlagEnableBlackbirdCheck
local FFlagSquadMemberJoinDialogAndOverflowMenu = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadMemberJoinDialogAndOverflowMenu")
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber

return function(props)
	local v5 = useLocalization({
		connectingText = "Feature.Squads.Label.Connecting",
		inExperiencePresenceText = "Common.Presence.Label.InExperience",
		invitedText = "Feature.Squads.Description.Invited",
		noResponseText = "Feature.Squads.Description.NoResponse",
		onlinePresenceText = "Common.Presence.Label.Online"
	})

	local v6 = useTokens()

	local v7, v8 = useAnimatedTransparency(1, defineFastInt2, Enum.EasingStyle.Cubic)

	local v10 = if fFlagEnableBlackbirdCheck then tostring(props.user.userId) else nil
	local v11 = useIsRobloxSubscriber(v10)

	local v12 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { (tostring(props.user.userId)) },
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})

	local v13 = not v12.data and "" or UserProfiles.Selectors.getCombinedNameFromId(v12.data, props.user.userId)

	local standardSizeAvatarHeadShotRbxthumb = getStandardSizeAvatarHeadShotRbxthumb((tostring(props.user.userId)))
	local formatted = `--social-squad-lobby-user-card-{props.user.userId}`

	local v14 = react.useCallback(function(p2)
		return p2.Squad.Presence.byUserId[tostring(props.user.userId)]
	end, { props.user.userId })
	local v15

	if fFlagSquadsPresenceStoreMigration then
		v15 = useGetPresenceByUserId((tostring(props.user.userId)))
	else
		v15 = useSelector(v14)
	end

	local v16

	if v15 then
		local userPresenceType = v15.userPresenceType
		local v17 = if fFlagSquadsPresenceStoreMigration then presenceType2.InGame else presenceType.InGame
		v16 = userPresenceType == v17
	else
		v16 = v15
	end

	local v17

	if v16 then
		v17 = if fFlagSquadsPresenceStoreMigration then v15 and v15.lastLocation else v15.lastLocation

		if not v17 or v17 == "" then
			v17 = v5.inExperiencePresenceText
		end
	else
		v17 = v5.onlinePresenceText
	end

	local isConnecting = props.isConnecting
	local v18 = tonumber(useLocalUserId()) or 0
	local v19 = v18 == props.user.userId
	local v20, v21, v22, v23, v24, v25, v26

	if getFFlagEnableCrossExpVoice() then
		local v27 = useIsVoiceConnected()
		local v28 = useIsMicPermissionsError()
		local v29 = useParticipant(props.user.userId)
		v20 = useIsVoiceConnecting() and v19
		v21 = useIsActiveParticipant(props.user.userId)
		local v30 = useIsLocalPlayerPartyVoiceEligible()
		local v31 = useIsUserPartyVoiceEligible(props.user.userId)
		local v32 = useIsCurrentSquadPartyVoiceEligible() == true
		local v33 = useIsParticipantMutedLocally(props.user.userId) == true

		v22 = v31 and v32 and not v19 and v33
		v23 = useIsParticipantMuted(props.user.userId) and not v22
		local v34 = useIsParticipantInOtherAudioContext(v18, props.user.userId) == true

		v24 = v32 and v30 and v31 and (not v27 or not v29 or v34 or v28)

		v25 = v32 and v30 and not v31

		v26 = if fFlagEnablePartyVoiceChangersInLua and v29 then v29.isVoiceChangerActive else false
	else
		v21 = false
		v20 = false
		v22 = false
		v23 = false
		v24 = false
		v25 = false
		v26 = false
	end

	local v27 = react.useMemo(function()
		return CrossExperienceVoice.Utils.debounce(function(p2)
			v8(p2)
		end, defineFastInt)
	end, {})

	react.useEffect(function()
		if getFFlagEnableCrossExpVoice() then
			if v21 then
				v27.cancel()
				v8(0)
			else
				v27.call(1)
			end
		end
	end, { v21 })

	local v28 = react.useMemo(function()
		if props.user.partyStatus == SquadUserPartyStatus.NoResponse then
			return v5.noResponseText
		end

		if props.user.partyStatus == SquadUserPartyStatus.Invited then
			return v5.invitedText
		end

		if isConnecting or v20 then
			return v5.connectingText
		end

		return v17
	end, {
		props.user and props.user.partyStatus,
		v17,
		isConnecting,
		v20,
		v5.noResponse,
		v5.invitedText,
		v5.connectingText
	})

	local v29 = react.useMemo(function()
		if props.user.partyStatus == SquadUserPartyStatus.Invited then
			local createElement = react.createElement
			local view = foundation.View
			local createElement2 = react.createElement
			local loading = foundation.Loading
			local v32 = {
				LayoutOrder = 1,
				size = iconSize.Small,
				Padding = v6.Padding.XSmall,
				testId = 0
			}
			local v33 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--loading` else nil
			v32.testId = v33
			return createElement(view, { tag = "auto-xy" }, {
				LoadingIcon = createElement2(loading, v32)
			})
		end

		if props.user.partyStatus == SquadUserPartyStatus.NoResponse then
			return nil
		end

		if isConnecting or v20 then
			local createElement = react.createElement
			local view = foundation.View
			local createElement2 = react.createElement
			local loading = foundation.Loading
			local v32 = {
				LayoutOrder = 1,
				size = iconSize.Small,
				Padding = v6.Padding.XSmall,
				testId = 0
			}
			local v33 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--loading` else nil
			v32.testId = v33
			return createElement(view, { tag = "auto-xy" }, {
				LoadingIcon = createElement2(loading, v32)
			})
		else
			if not v16 then
				return nil
			end

			local createElement = react.createElement
			local icon = foundation.Icon
			local v30 = {
				LayoutOrder = 1,
				name = "icons/common/play",
				size = iconSize.Small,
				style = v6.Color.Content.Emphasis,
				testId = 0
			}
			local v31 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--in-game-icon` else nil
			v30.testId = v31
			return createElement(icon, v30)
		end
	end, {
		props.user and props.user.partyStatus,
		isConnecting,
		v20,
		v16,
		formatted
	})

	local useMemo = react.useMemo
	local function fn()
		if v13 == "" then
			return nil
		end

		local createElement = react.createElement
		local v31 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}

		local v32 = {
			UIListLayout = react.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v6.Gap.XSmall + 2),
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
		local v33

		if props.isBlocked then
			local createElement2 = react.createElement
			local icon = foundation.Icon
			local v34 = {
				LayoutOrder = 1,
				name = "icons/status/unavailable_small",
				size = iconSize.Small,
				style = v6.Color.Extended.Red.Red_800,
				testId = 0
			}
			local v35 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--blocked-icon` else nil
			v34.testId = v35
			v33 = createElement2(icon, v34)
		end

		v32.BlockedIcon = v33
		local v34

		if v22 then
			local createElement2 = react.createElement
			local icon = foundation.Icon
			local v35 = {
				LayoutOrder = 2,
				name = "icons/controls/voice/microphone_off_small_dark",
				size = iconSize.Small,
				style = v6.Color.Extended.Red.Red_800,
				testId = 0
			}
			local v36 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--muted-locally-icon` else nil
			v35.testId = v36
			v34 = createElement2(icon, v35)
		end

		v32.MutedLocallyIcon = v34
		local v35

		if v23 then
			local createElement2 = react.createElement
			local icon = foundation.Icon
			local v36 = {
				LayoutOrder = 3,
				name = "icons/controls/microphoneMute_small",
				size = iconSize.Small,
				style = v6.Color.Content.Emphasis,
				testId = 0
			}
			local v37 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--muted-icon` else nil
			v36.testId = v37
			v35 = createElement2(icon, v36)
		end

		v32.MutedIcon = v35
		local v36

		if v24 then
			local createElement2 = react.createElement
			local icon = foundation.Icon
			local v37 = {
				LayoutOrder = 4,
				name = "icons/controls/headphoneDeafen_small",
				size = iconSize.Small,
				style = v6.Color.Content.Emphasis,
				testId = 0
			}

			local v38 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--not-voice-participant-icon` else nil
			v37.testId = v38
			v36 = createElement2(icon, v37)
		end

		v32.NotVoiceParticipantIcon = v36
		local v37

		if v25 then
			local createElement2 = react.createElement
			local icon = foundation.Icon
			local v38 = {
				LayoutOrder = 5,
				name = "icons/controls/headphoneDeafen_small",
				size = iconSize.Small,
				style = v6.Color.System.Warning,
				testId = 0
			}

			local v39 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--not-eligible-voice-participant-icon` else nil
			v38.testId = v39
			v37 = createElement2(icon, v38)
		end

		v32.NotEligibleVoiceParticipant = v37
		local v38

		if fFlagEnablePartyVoiceChangersInLua and v26 then
			local createElement2 = react.createElement
			local icon = foundation.Icon
			local v39 = {
				LayoutOrder = 6,
				size = iconSize.Small,
				name = BuilderIcons.Icon.DiamondSimplified,
				style = v6.Color.Content.Emphasis,
				testId = 0
			}
			local v40 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--voice-changer-icon` else nil
			v39.testId = v40
			v38 = createElement2(icon, v39)
		end

		v32.VoiceChangerActiveIcon = v38
		local v39

		if not fFlagEnableBlackbirdCheck then
			local createElement2 = react.createElement
			local text = foundation.Text
			local v40 = {
				AutomaticSize = Enum.AutomaticSize.Y,
				backgroundStyle = v6.Color.None,
				colorstyle = v6.Color.Content.Emphasis,
				fontStyle = v6.Typography.TitleMedium,
				LayoutOrder = fFlagEnablePartyVoiceChangersInLua and 7 or 6,
				Text = v13,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextWrapped = false,
				testId = 0
			}

			local v41 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--name` else nil
			v40.testId = v41
			v39 = createElement2(text, v40, {
				UIFlexItem = react.createElement("UIFlexItem", {
					FlexMode = Enum.UIFlexMode.Fill
				})
			})
		end

		v32.NameTextLabel = v39
		local v40

		if fFlagEnableBlackbirdCheck then
			local createElement2 = react.createElement
			local v42 = {
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(0, 0),
				BackgroundTransparency = 1,
				LayoutOrder = fFlagEnablePartyVoiceChangersInLua and 7 or 6
			}

			local v43 = {
				Layout = react.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, v6.Gap.XSmall),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				FlexFill = react.createElement("UIFlexItem", {
					FlexMode = Enum.UIFlexMode.Fill
				}),
				NameText = 0,
				SubscriptionBadge = 0
			}

			local createElement3 = react.createElement
			local text = foundation.Text
			local v44 = {
				AutomaticSize = Enum.AutomaticSize.XY,
				backgroundStyle = v6.Color.None,
				colorstyle = v6.Color.Content.Emphasis,
				fontStyle = v6.Typography.TitleMedium,
				LayoutOrder = 1,
				Text = v13,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextWrapped = false,
				testId = 0
			}

			local v45 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--name` else nil
			v44.testId = v45
			v43.NameText = createElement3(text, v44, {
				UIFlexItem = react.createElement("UIFlexItem", {
					FlexMode = Enum.UIFlexMode.Shrink
				})
			})
			local v46

			if v11 then
				local createElement4 = react.createElement
				local icon = foundation.Icon
				local v47 = {
					LayoutOrder = 2,
					size = iconSize.Small,
					name = foundation.Enums.IconName.RobloxPlus,
					style = v6.Color.Content.Emphasis,
					testId = 0
				}

				local v48 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--subscription-badge` else nil
				v47.testId = v48
				v46 = createElement4(icon, v47)
			end

			v43.SubscriptionBadge = v46
			v40 = createElement2("Frame", v42, v43)
		end

		v32.NameAndBadge = v40
		return (createElement("Frame", v31, v32))
	end

	local isBlocked = props.isBlocked
	local v36 = if fFlagEnablePartyVoiceChangersInLua then v26 else nil
	local v38 = useMemo(fn, {
		v13,
		v23,
		v22,
		isBlocked,
		v6,
		v24,
		v25,
		v36,
		if fFlagEnableBlackbirdCheck then v11 else nil,
		formatted
	})

	local v39 = react.useMemo(function()
		local createElement = react.createElement
		local v41 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}

		local v42 = {
			UIListLayout = react.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v6.Gap.XSmall),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			PresenceIcon = v29,
			PresenceTextLabel = 0
		}

		local createElement2 = react.createElement
		local text = foundation.Text
		local v43 = {
			AutomaticSize = Enum.AutomaticSize.Y,
			backgroundStyle = v6.Color.None,
			colorstyle = v6.Color.Content.Default,
			fontStyle = v6.Typography.BodyMedium,
			LayoutOrder = 2,
			Text = v28,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextWrapped = false,
			testId = 0
		}

		local v44 = if FFlagSquadsEnableFoundationTestIds then `{formatted}--presence` else nil
		v43.testId = v44
		v42.PresenceTextLabel = createElement2(text, v43, {
			UIFlexItem = react.createElement("UIFlexItem", {
				FlexMode = Enum.UIFlexMode.Fill
			})
		})
		return createElement("Frame", v41, v42)
	end, {
		isConnecting,
		v20,
		v16,
		v5.connectingText,
		v17,
		v6,
		v29,
		v28,
		formatted
	})

	local v40 = useSquadUserDropdownMenuButtons(props.user.userId, props.isInExperience)
	local v41 = #v40 < 1
	local v42, v43

	if FFlagSquadMemberJoinDialogAndOverflowMenu then
		v42 = not v19
		v43 = not (table.find(v40, "JoinButton") == nil)
	else
		v43 = false
		v42 = not (v19 or v41)
	end

	local openSquadVoiceAbuseReport = props.openSquadVoiceAbuseReport

	local v44 = isConnecting
		or v20
		or props.user.partyStatus == SquadUserPartyStatus.Invited
		or props.user.partyStatus == SquadUserPartyStatus.NoResponse

	local v45 = react.useCallback(function()
		if FFlagSquadMemberJoinDialogAndOverflowMenu and not v43 then
			return
		end

		if props.onActivated then
			props.onActivated((tostring(props.user.userId)))
		end
	end, { props.onActivated, props.user.userId, v43 })

	local createElement = react.createElement
	local view = foundation.View
	local v46 = {
		LayoutOrder = props.layoutOrder,
		Size = props.size,
		backgroundStyle = v6.Color.Surface.Surface_200,
		cornerRadius = UDim.new(0, v6.Radius.Medium),
		isDisabled = v44,
		onActivated = 0,
		stateLayer = 0,
		testId = 0
	}

	if not (props.onActivated and v42) then
		v45 = nil
	end

	v46.onActivated = v45
	v46.stateLayer = FFlagSquadMemberJoinDialogAndOverflowMenu and not v43 and { affordance = stateLayerAffordance.None } or nil

	v46.testId = if FFlagSquadsEnableFoundationTestIds then formatted else nil
	local children = {
		AvatarImage = react.createElement(imageSetLabel, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(96, 96),
			BackgroundColor3 = v6.Color.Shift.Shift_300.Color3,
			BackgroundTransparency = v6.Color.Shift.Shift_300.Transparency,
			Image = standardSizeAvatarHeadShotRbxthumb,
			ZIndex = 0
		}, {
			UICorner = react.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
		}),
		GradientFrame = react.createElement("Frame", {
			Size = UDim2.fromScale(1, 0.5),
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = v6.Color.Surface.Surface_100.Color3,
			BackgroundTransparency = v6.Color.Surface.Surface_100.Transparency,
			ZIndex = 1
		}, {
			UICorner = react.createElement("UICorner", {
				CornerRadius = UDim.new(0, v6.Radius.Medium)
			}),
			UIGradient = react.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0)
				})
			}, {})
		}),
		InactiveOverlay = 0,
		TextContainer = 0,
		OverflowMenu = 0,
		ActiveBorder = 0,
		DefaultBorder = 0
	}

	local v48 = if isConnecting or v24 or v20 or props.user.partyStatus == SquadUserPartyStatus.Invited or props.user.partyStatus == SquadUserPartyStatus.NoResponse then react.createElement(foundation.View, {
		tag = "size-full radius-medium",
		backgroundStyle = {
			Color3 = v6.Color.Surface.Surface_100.Color3,
			Transparency = 0.25
		}
	}, {}) else nil
	children.InactiveOverlay = v48

	local createElement2 = react.createElement
	local v50 = {
		AutomaticSize = Enum.AutomaticSize.Y,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		ZIndex = 2
	}

	local v51 = {
		UIListLayout = react.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Bottom
		}),
		UIPadding = react.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, v6.Padding.Medium),
			PaddingLeft = UDim.new(0, v6.Padding.Medium),
			PaddingRight = UDim.new(0, v6.Padding.Medium),
			PaddingTop = UDim.new(0, v6.Padding.Medium)
		}),
		Name = v38,
		Presence = 0
	}

	if props.isBlocked then
		v39 = nil
	end

	v51.Presence = v39
	children.TextContainer = createElement2("Frame", v50, v51)

	local v52 = if FFlagSquadMemberJoinDialogAndOverflowMenu and not v19 and not v44 and openSquadVoiceAbuseReport then react.createElement(SquadLobbyUserOverflowMenuContainer, {
		userId = tostring(props.user.userId),
		isInExperience = props.isInExperience,
		openSquadVoiceAbuseReport = openSquadVoiceAbuseReport
	}) else nil
	children.OverflowMenu = v52

	children.ActiveBorder = react.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, -8, 1, -8),
		BackgroundTransparency = 1,
		ZIndex = 4
	}, {
		UICorner = react.createElement("UICorner", {
			CornerRadius = UDim.new(0, v6.Radius.Medium - 4)
		}),
		UIStroke = react.createElement("UIStroke", {
			Thickness = 4,
			Color = v6.Color.Extended.Green.Green_800.Color3,
			Transparency = v7
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
			CornerRadius = UDim.new(0, v6.Radius.Medium - 1)
		}),
		UIStroke = react.createElement("UIStroke", {
			Thickness = 1,
			Color = v6.Color.Stroke.Default.Color3,
			Transparency = v7:map(function(p2)
				if p2 < 0.9 then
					return 1
				end

				return v6.Color.Stroke.Default.Transparency
			end)
		})
	})
	return createElement(view, v46, children)
end
