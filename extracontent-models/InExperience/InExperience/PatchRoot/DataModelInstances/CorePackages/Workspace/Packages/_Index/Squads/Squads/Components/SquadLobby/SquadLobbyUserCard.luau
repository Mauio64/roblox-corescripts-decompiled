local Squads = script:FindFirstAncestor("Squads")
local dependencies = require(Squads.dependencies)
local SquadsParent = Squads.Parent
local CrossExperienceVoice = require(SquadsParent.CrossExperienceVoice)
local UIBlox = require(SquadsParent.UIBlox)
local UserProfiles = require(SquadsParent.UserProfiles)
local getStandardSizeAvatarHeadShotRbxthumb = require(SquadsParent.UserLib).Utils.getStandardSizeAvatarHeadShotRbxthumb
local useLocalUserId = require(SquadsParent.RobloxAppHooks).useLocalUserId
local BuilderIcons = require(SquadsParent.BuilderIcons)
local Hooks = require(SquadsParent.SquadsCore.Hooks)
local PresenceType = dependencies.RoduxPresence.Enums.PresenceType
local Foundation = dependencies.Foundation
local React = dependencies.React
local SharedFlags = dependencies.SharedFlags
local useLocalization = dependencies.Hooks.useLocalization
local useSelector = dependencies.Hooks.useSelector
local FFlagSquadsPresenceStoreMigration = require(SquadsParent.SquadsCore.Flags).FFlagSquadsPresenceStoreMigration
local v18 = if not FFlagSquadsPresenceStoreMigration then nil else require(SquadsParent.FriendsCommon).Hooks.useGetPresenceByUserId
local v19 = if not FFlagSquadsPresenceStoreMigration then nil else require(SquadsParent.DataHydration).Presence.PresenceEnums.PresenceType
local useParticipant = CrossExperienceVoice.Hooks.useParticipant
local useIsVoiceConnected = CrossExperienceVoice.Hooks.useIsVoiceConnected
local useIsActiveParticipant = CrossExperienceVoice.Hooks.useIsActiveParticipant
local useAnimatedTransparency = CrossExperienceVoice.Hooks.useAnimatedTransparency
local useIsParticipantMuted = CrossExperienceVoice.Hooks.useIsParticipantMuted
local useIsVoiceConnecting = CrossExperienceVoice.Hooks.useIsVoiceConnecting
local useIsMicPermissionsError = CrossExperienceVoice.Hooks.useIsMicPermissionsError
local useIsParticipantInOtherAudioContext = CrossExperienceVoice.Hooks.useIsParticipantInOtherAudioContext
local useIsParticipantMutedLocally = CrossExperienceVoice.Hooks.useIsParticipantMutedLocally
local useTokens = Foundation.Hooks.useTokens
local useSquadUserDropdownMenuButtons = require(Squads.Hooks.useSquadUserDropdownMenuButtons)
local useIsLocalPlayerPartyVoiceEligible = Hooks.useIsLocalPlayerPartyVoiceEligible
local useIsUserPartyVoiceEligible = Hooks.useIsUserPartyVoiceEligible
local useIsCurrentSquadPartyVoiceEligible = Hooks.useIsCurrentSquadPartyVoiceEligible
local GetFFlagEnableCrossExpVoice = SharedFlags.GetFFlagEnableCrossExpVoice
local FFlagEnableSquadUserCardHoverFix = SharedFlags.FFlagEnableSquadUserCardHoverFix
local IconSize = Foundation.Enums.IconSize
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

require(Squads.Common.ModelTypes)

local SquadUserPartyStatus = require(Squads.Enums.SquadUserPartyStatus)
local v39 = game:DefineFastInt("PartyVoiceActivityIndicatorDebounceMs", 100)
local v40 = game:DefineFastInt("PartyVoiceActivityIndicatorAnimationMs", 100)
local FFlagEnablePartyVoiceChangersInLua = SharedFlags.FFlagEnablePartyVoiceChangersInLua
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber

return function(t1: {[any]: any}) -- line: 84
	-- upvalues: useLocalization (copy), useTokens (copy), useAnimatedTransparency (copy), v40 (copy), useIsRobloxSubscriber (copy), FFlagEnableBlackbirdCheck (copy), UserProfiles (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), React (copy), FFlagSquadsPresenceStoreMigration (copy), v18 (copy), useSelector (copy), v19 (copy), PresenceType (copy), useLocalUserId (copy), GetFFlagEnableCrossExpVoice (copy), useIsVoiceConnected (copy), useIsMicPermissionsError (copy), useParticipant (copy), useIsVoiceConnecting (copy), useIsActiveParticipant (copy), useIsLocalPlayerPartyVoiceEligible (copy), useIsUserPartyVoiceEligible (copy), useIsCurrentSquadPartyVoiceEligible (copy), useIsParticipantMutedLocally (copy), useIsParticipantMuted (copy), useIsParticipantInOtherAudioContext (copy), FFlagEnablePartyVoiceChangersInLua (copy), CrossExperienceVoice (copy), v39 (copy), SquadUserPartyStatus (copy), Foundation (copy), IconSize (copy), BuilderIcons (copy), FFlagEnableSquadUserCardHoverFix (copy), useSquadUserDropdownMenuButtons (copy), ImageSetLabel (copy)
	local v45 = useLocalization({
		connectingText = "Feature.Squads.Label.Connecting",
		inExperiencePresenceText = "Common.Presence.Label.InExperience",
		invitedText = "Feature.Squads.Description.Invited",
		noResponseText = "Feature.Squads.Description.NoResponse",
		onlinePresenceText = "Common.Presence.Label.Online"
	})
	local v46 = useTokens()
	local v47, v48 = useAnimatedTransparency(1, v40, Enum.EasingStyle.Cubic)
	local v49 = useIsRobloxSubscriber(if not FFlagEnableBlackbirdCheck then nil else tostring(t1.user.userId))
	local v50 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { (tostring(t1.user.userId)) },
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})
	local s1 = ""

	if v50.data then
		s1 = UserProfiles.Selectors.getCombinedNameFromId(v50.data, t1.user.userId)
	end

	local v52 = getStandardSizeAvatarHeadShotRbxthumb((tostring(t1.user.userId)))
	local v53 = React.useCallback(function(p1) -- line: 111
		-- upvalues: t1 (copy)
		return p1.Squad.Presence.byUserId[tostring(t1.user.userId)]
	end, { t1.user.userId })
	local v54 = if not FFlagSquadsPresenceStoreMigration then useSelector(v53) else v18((tostring(t1.user.userId)))
	local v55 = v54 and v54.userPresenceType == if not FFlagSquadsPresenceStoreMigration then PresenceType.InGame else v19.InGame
	local u57

	if v55 then
		local v56 = if not FFlagSquadsPresenceStoreMigration then v54.lastLocation else v54 and v54.lastLocation

		u57 = if not v56 or v56 == "" then v45.inExperiencePresenceText else v56
	else
		u57 = v45.onlinePresenceText
	end

	local isConnecting = t1.isConnecting
	local v59 = tonumber(useLocalUserId()) or 0
	local v60 = v59 == t1.user.userId
	local u61 = false
	local u62 = false
	local u63 = false
	local u64 = false
	local u65 = false
	local u66 = false
	local u67 = false

	if GetFFlagEnableCrossExpVoice() then
		local v68 = useIsVoiceConnected()
		local v69 = useIsMicPermissionsError()
		local v70 = useParticipant(t1.user.userId)

		u65 = useIsVoiceConnecting() and v60
		u61 = useIsActiveParticipant(t1.user.userId)

		local v71 = useIsLocalPlayerPartyVoiceEligible()
		local v72 = useIsUserPartyVoiceEligible(t1.user.userId)
		local v73 = useIsCurrentSquadPartyVoiceEligible() == true
		local v74 = useIsParticipantMutedLocally(t1.user.userId) == true

		u66 = v72 and (v73 and (not v60 and v74))
		u64 = useIsParticipantMuted(t1.user.userId) and not u66

		local v75 = useIsParticipantInOtherAudioContext(v59, t1.user.userId) == true

		u62 = v73 and (v71 and (v72 and (not v68 or (not v70 or (v75 or v69)))))
		u63 = v73 and (v71 and not v72)
		u67 = not not FFlagEnablePartyVoiceChangersInLua and (not not v70 and v70.isVoiceChangerActive)
	end

	local v76 = React.useMemo(function() -- line: 186
		-- upvalues: CrossExperienceVoice (copy), v48 (copy), v39 (copy)
		return CrossExperienceVoice.Utils.debounce(function(n1: number) -- line: 187
			-- upvalues: v48 (copy)
			v48(n1)
		end, v39)
	end, {})

	React.useEffect(function() -- line: 192
		-- upvalues: GetFFlagEnableCrossExpVoice (copy), u61 (ref), v76 (copy), v48 (copy)
		if GetFFlagEnableCrossExpVoice() then
			if u61 then
				v76.cancel()
				v48(0)

				return
			end

			v76.call(1)
		end
	end, { u61 })

	local v77 = React.useMemo(function() -- line: 204
		-- upvalues: t1 (copy), SquadUserPartyStatus (copy), v45 (copy), isConnecting (copy), u65 (ref), u57 (ref)
		if t1.user.partyStatus == SquadUserPartyStatus.NoResponse then
			return v45.noResponseText
		end

		if t1.user.partyStatus == SquadUserPartyStatus.Invited then
			return v45.invitedText
		end

		if isConnecting or u65 then
			return v45.connectingText
		end

		return u57
	end, {
		t1.user and t1.user.partyStatus,
		u57,
		isConnecting,
		u65,
		v45.noResponse,
		v45.invitedText,
		v45.connectingText
	})
	local v78 = React.useMemo(function() -- line: 226
		-- upvalues: t1 (copy), SquadUserPartyStatus (copy), React (copy), Foundation (copy), IconSize (copy), v46 (copy), isConnecting (copy), u65 (ref), v55 (copy)
		if t1.user.partyStatus == SquadUserPartyStatus.Invited then
			return React.createElement(Foundation.View, {
				tag = "auto-xy"
			}, {
				LoadingIcon = React.createElement(Foundation.Loading, {
					LayoutOrder = 1,
					size = IconSize.Small,
					Padding = v46.Padding.XSmall
				})
			})
		end

		if t1.user.partyStatus == SquadUserPartyStatus.NoResponse then
			return nil
		end

		if isConnecting or u65 then
			return React.createElement(Foundation.View, {
				tag = "auto-xy"
			}, {
				LoadingIcon = React.createElement(Foundation.Loading, {
					LayoutOrder = 1,
					size = IconSize.Small,
					Padding = v46.Padding.XSmall
				})
			})
		end

		if v55 then
			return React.createElement(Foundation.Icon, {
				LayoutOrder = 1,
				name = "icons/common/play",
				size = IconSize.Small,
				style = v46.Color.Content.Emphasis
			})
		end

		return nil
	end, {
		t1.user and t1.user.partyStatus,
		isConnecting,
		u65,
		v55
	})
	local v79 = React.useMemo(function() -- line: 258
		-- upvalues: s1 (ref), React (copy), v46 (copy), t1 (copy), Foundation (copy), IconSize (copy), u66 (ref), u64 (ref), u62 (ref), u63 (ref), FFlagEnablePartyVoiceChangersInLua (copy), u67 (ref), BuilderIcons (copy), FFlagEnableBlackbirdCheck (copy), v49 (copy)
		if s1 ~= "" then
			return (React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, v46.Gap.XSmall + 2),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				BlockedIcon = if not t1.isBlocked then nil else React.createElement(Foundation.Icon, {
					LayoutOrder = 1,
					name = "icons/status/unavailable_small",
					size = IconSize.Small,
					style = v46.Color.Extended.Red.Red_800
				}),
				MutedLocallyIcon = if not u66 then nil else React.createElement(Foundation.Icon, {
					LayoutOrder = 2,
					name = "icons/controls/voice/microphone_off_small_dark",
					size = IconSize.Small,
					style = v46.Color.Extended.Red.Red_800
				}),
				MutedIcon = if not u64 then nil else React.createElement(Foundation.Icon, {
					LayoutOrder = 3,
					name = "icons/controls/microphoneMute_small",
					size = IconSize.Small,
					style = v46.Color.Content.Emphasis
				}),
				NotVoiceParticipantIcon = if not u62 then nil else React.createElement(Foundation.Icon, {
					LayoutOrder = 4,
					name = "icons/controls/headphoneDeafen_small",
					size = IconSize.Small,
					style = v46.Color.Content.Emphasis
				}),
				NotEligibleVoiceParticipant = if not u63 then nil else React.createElement(Foundation.Icon, {
					LayoutOrder = 5,
					name = "icons/controls/headphoneDeafen_small",
					size = IconSize.Small,
					style = v46.Color.System.Warning
				}),
				VoiceChangerActiveIcon = if not FFlagEnablePartyVoiceChangersInLua or not u67 then nil else React.createElement(Foundation.Icon, {
					LayoutOrder = 6,
					size = IconSize.Small,
					name = BuilderIcons.Icon.DiamondSimplified,
					style = v46.Color.Content.Emphasis
				}),
				NameTextLabel = if FFlagEnableBlackbirdCheck then nil else React.createElement(Foundation.Text, {
					TextWrapped = false,
					AutomaticSize = Enum.AutomaticSize.Y,
					backgroundStyle = v46.Color.None,
					colorstyle = v46.Color.Content.Emphasis,
					fontStyle = v46.Typography.TitleMedium,
					LayoutOrder = not FFlagEnablePartyVoiceChangersInLua and 6 or 7,
					Text = s1,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					TextTruncate = Enum.TextTruncate.AtEnd
				}, {
					UIFlexItem = React.createElement("UIFlexItem", {
						FlexMode = Enum.UIFlexMode.Fill
					})
				}),
				NameAndBadge = if not FFlagEnableBlackbirdCheck then nil else React.createElement("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.fromScale(0, 0),
					LayoutOrder = not FFlagEnablePartyVoiceChangersInLua and 6 or 7
				}, {
					Layout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Horizontal,
						Padding = UDim.new(0, v46.Gap.XSmall),
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Center
					}),
					FlexFill = React.createElement("UIFlexItem", {
						FlexMode = Enum.UIFlexMode.Fill
					}),
					NameText = React.createElement(Foundation.Text, {
						LayoutOrder = 1,
						TextWrapped = false,
						AutomaticSize = Enum.AutomaticSize.XY,
						backgroundStyle = v46.Color.None,
						colorstyle = v46.Color.Content.Emphasis,
						fontStyle = v46.Typography.TitleMedium,
						Text = s1,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						TextTruncate = Enum.TextTruncate.AtEnd
					}, {
						UIFlexItem = React.createElement("UIFlexItem", {
							FlexMode = Enum.UIFlexMode.Shrink
						})
					}),
					SubscriptionBadge = if not v49 then nil else React.createElement(Foundation.Icon, {
						LayoutOrder = 2,
						size = IconSize.Small,
						name = Foundation.Enums.IconName.RobloxPlus,
						style = v46.Color.Content.Emphasis
					})
				})
			}))
		end

		return nil
	end, {
		s1,
		u64,
		u66,
		t1.isBlocked,
		v46,
		u62,
		u63,
		if not FFlagEnablePartyVoiceChangersInLua then nil else u67,
		if not FFlagEnableBlackbirdCheck then nil else v49
	})
	local v80 = React.useMemo(function() -- line: 394
		-- upvalues: React (copy), v46 (copy), v78 (copy), Foundation (copy), v77 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v46.Gap.XSmall),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			PresenceIcon = v78,
			PresenceTextLabel = React.createElement(Foundation.Text, {
				LayoutOrder = 2,
				TextWrapped = false,
				AutomaticSize = Enum.AutomaticSize.Y,
				backgroundStyle = v46.Color.None,
				colorstyle = v46.Color.Content.Default,
				fontStyle = v46.Typography.BodyMedium,
				Text = v77,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd
			}, {
				UIFlexItem = React.createElement("UIFlexItem", {
					FlexMode = Enum.UIFlexMode.Fill
				})
			})
		})
	end, {
		isConnecting,
		u65,
		v55,
		v45.connectingText,
		u57,
		v46,
		v78,
		v77
	})
	local v82

	if FFlagEnableSquadUserCardHoverFix then
		local v81 = #useSquadUserDropdownMenuButtons(t1.user.userId, t1.isInExperience) < 1

		v82 = not v60 and not v81
	else
		v82 = not v60
	end

	local v83 = React.useCallback(function() -- line: 447
		-- upvalues: t1 (copy)
		if t1.onActivated then
			t1.onActivated((tostring(t1.user.userId)))
		end
	end, {
		t1.onActivated,
		t1.user.userId
	})

	return React.createElement(Foundation.View, {
		LayoutOrder = t1.layoutOrder,
		Size = t1.size,
		backgroundStyle = v46.Color.Surface.Surface_200,
		cornerRadius = UDim.new(0, v46.Radius.Medium),
		isDisabled = isConnecting or (u65 or (t1.user.partyStatus == SquadUserPartyStatus.Invited or t1.user.partyStatus == SquadUserPartyStatus.NoResponse)),
		onActivated = if not t1.onActivated or not v82 then nil else v83
	}, {
		AvatarImage = React.createElement(ImageSetLabel, {
			ZIndex = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(96, 96),
			BackgroundColor3 = v46.Color.Shift.Shift_300.Color3,
			BackgroundTransparency = v46.Color.Shift.Shift_300.Transparency,
			Image = v52
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			})
		}),
		GradientFrame = React.createElement("Frame", {
			ZIndex = 1,
			Size = UDim2.fromScale(1, 0.5),
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = v46.Color.Surface.Surface_100.Color3,
			BackgroundTransparency = v46.Color.Surface.Surface_100.Transparency
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v46.Radius.Medium)
			}),
			UIGradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0)
				})
			}, {})
		}),
		InactiveOverlay = if not isConnecting and (not u62 and (not u65 and (t1.user.partyStatus ~= SquadUserPartyStatus.Invited and t1.user.partyStatus ~= SquadUserPartyStatus.NoResponse))) then nil else React.createElement(Foundation.View, {
			tag = "size-full radius-medium",
			backgroundStyle = {
				Transparency = 0.25,
				Color3 = v46.Color.Surface.Surface_100.Color3
			}
		}, {}),
		TextContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.fromScale(1, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Bottom
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, v46.Padding.Medium),
				PaddingLeft = UDim.new(0, v46.Padding.Medium),
				PaddingRight = UDim.new(0, v46.Padding.Medium),
				PaddingTop = UDim.new(0, v46.Padding.Medium)
			}),
			Name = v79,
			Presence = if t1.isBlocked then nil else v80
		}),
		ActiveBorder = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 4,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, -8, 1, -8)
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v46.Radius.Medium - 4)
			}),
			UIStroke = React.createElement("UIStroke", {
				Thickness = 4,
				Color = v46.Color.Extended.Green.Green_800.Color3,
				Transparency = v47
			})
		}),
		DefaultBorder = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 3,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, -2, 1, -2)
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v46.Radius.Medium - 1)
			}),
			UIStroke = React.createElement("UIStroke", {
				Thickness = 1,
				Color = v46.Color.Stroke.Default.Color3,
				Transparency = v47:map(function(p2) -- line: 571
					-- upvalues: v46 (copy)
					if p2 < 0.9 then
						return 1
					end

					return v46.Color.Stroke.Default.Transparency
				end)
			})
		})
	})
end
