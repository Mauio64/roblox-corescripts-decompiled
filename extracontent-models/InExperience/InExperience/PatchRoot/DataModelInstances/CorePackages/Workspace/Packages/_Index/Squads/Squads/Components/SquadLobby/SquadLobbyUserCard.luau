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
local v36 = game:DefineFastInt("PartyVoiceActivityIndicatorDebounceMs", 100)
local v37 = game:DefineFastInt("PartyVoiceActivityIndicatorAnimationMs", 100)
local FFlagEnablePartyVoiceChangersInLua = SharedFlags.FFlagEnablePartyVoiceChangersInLua
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local useIsRobloxSubscriber = UserProfiles.Hooks.useIsRobloxSubscriber

return function(t1: {[any]: any}) -- line: 76
	-- upvalues: useLocalization (copy), useTokens (copy), useAnimatedTransparency (copy), v37 (copy), useIsRobloxSubscriber (copy), FFlagEnableBlackbirdCheck (copy), UserProfiles (copy), getStandardSizeAvatarHeadShotRbxthumb (copy), React (copy), useSelector (copy), PresenceType (copy), useLocalUserId (copy), GetFFlagEnableCrossExpVoice (copy), useIsVoiceConnected (copy), useIsMicPermissionsError (copy), useParticipant (copy), useIsVoiceConnecting (copy), useIsActiveParticipant (copy), useIsLocalPlayerPartyVoiceEligible (copy), useIsUserPartyVoiceEligible (copy), useIsCurrentSquadPartyVoiceEligible (copy), useIsParticipantMutedLocally (copy), useIsParticipantMuted (copy), useIsParticipantInOtherAudioContext (copy), FFlagEnablePartyVoiceChangersInLua (copy), CrossExperienceVoice (copy), v36 (copy), SquadUserPartyStatus (copy), Foundation (copy), IconSize (copy), BuilderIcons (copy), FFlagEnableSquadUserCardHoverFix (copy), useSquadUserDropdownMenuButtons (copy), ImageSetLabel (copy)
	local v42 = useLocalization({
		connectingText = "Feature.Squads.Label.Connecting",
		inExperiencePresenceText = "Common.Presence.Label.InExperience",
		invitedText = "Feature.Squads.Description.Invited",
		noResponseText = "Feature.Squads.Description.NoResponse",
		onlinePresenceText = "Common.Presence.Label.Online"
	})
	local v43 = useTokens()
	local v44, v45 = useAnimatedTransparency(1, v37, Enum.EasingStyle.Cubic)
	local v46 = useIsRobloxSubscriber(if not FFlagEnableBlackbirdCheck then nil else tostring(t1.user.userId))
	local v47 = UserProfiles.Hooks.useUserProfilesFetch({
		userIds = { (tostring(t1.user.userId)) },
		query = UserProfiles.Queries.userProfilesCombinedNameByUserIds
	})
	local s1 = ""

	if v47.data then
		s1 = UserProfiles.Selectors.getCombinedNameFromId(v47.data, t1.user.userId)
	end

	local v49 = getStandardSizeAvatarHeadShotRbxthumb((tostring(t1.user.userId)))
	local v50 = React.useCallback(function(p1) -- line: 103
		-- upvalues: t1 (copy)
		return p1.Squad.Presence.byUserId[tostring(t1.user.userId)]
	end, { t1.user.userId })
	local v51 = useSelector(v50)
	local v52 = v51 and v51.userPresenceType == PresenceType.InGame
	local u53 = if not v52 then v42.onlinePresenceText else if not v51.lastLocation or v51.lastLocation == "" then v42.inExperiencePresenceText else v51.lastLocation
	local isConnecting = t1.isConnecting
	local v55 = tonumber(useLocalUserId()) or 0
	local v56 = v55 == t1.user.userId
	local u57 = false
	local u58 = false
	local u59 = false
	local u60 = false
	local u61 = false
	local u62 = false
	local u63 = false

	if GetFFlagEnableCrossExpVoice() then
		local v64 = useIsVoiceConnected()
		local v65 = useIsMicPermissionsError()
		local v66 = useParticipant(t1.user.userId)

		u61 = useIsVoiceConnecting() and v56
		u57 = useIsActiveParticipant(t1.user.userId)

		local v67 = useIsLocalPlayerPartyVoiceEligible()
		local v68 = useIsUserPartyVoiceEligible(t1.user.userId)
		local v69 = useIsCurrentSquadPartyVoiceEligible() == true
		local v70 = useIsParticipantMutedLocally(t1.user.userId) == true

		u62 = v68 and (v69 and (not v56 and v70))
		u60 = useIsParticipantMuted(t1.user.userId) and not u62

		local v71 = useIsParticipantInOtherAudioContext(v55, t1.user.userId) == true

		u58 = v69 and (v67 and (v68 and (not v64 or (not v66 or (v71 or v65)))))
		u59 = v69 and (v67 and not v68)
		u63 = not not FFlagEnablePartyVoiceChangersInLua and (not not v66 and v66.isVoiceChangerActive)
	end

	local v72 = React.useMemo(function() -- line: 170
		-- upvalues: CrossExperienceVoice (copy), v45 (copy), v36 (copy)
		return CrossExperienceVoice.Utils.debounce(function(n1: number) -- line: 171
			-- upvalues: v45 (copy)
			v45(n1)
		end, v36)
	end, {})

	React.useEffect(function() -- line: 176
		-- upvalues: GetFFlagEnableCrossExpVoice (copy), u57 (ref), v72 (copy), v45 (copy)
		if GetFFlagEnableCrossExpVoice() then
			if u57 then
				v72.cancel()
				v45(0)

				return
			end

			v72.call(1)
		end
	end, { u57 })

	local v73 = React.useMemo(function() -- line: 188
		-- upvalues: t1 (copy), SquadUserPartyStatus (copy), v42 (copy), isConnecting (copy), u61 (ref), u53 (ref)
		if t1.user.partyStatus == SquadUserPartyStatus.NoResponse then
			return v42.noResponseText
		end

		if t1.user.partyStatus == SquadUserPartyStatus.Invited then
			return v42.invitedText
		end

		if isConnecting or u61 then
			return v42.connectingText
		end

		return u53
	end, {
		t1.user and t1.user.partyStatus,
		u53,
		isConnecting,
		u61,
		v42.noResponse,
		v42.invitedText,
		v42.connectingText
	})
	local v74 = React.useMemo(function() -- line: 210
		-- upvalues: t1 (copy), SquadUserPartyStatus (copy), React (copy), Foundation (copy), IconSize (copy), v43 (copy), isConnecting (copy), u61 (ref), v52 (copy)
		if t1.user.partyStatus == SquadUserPartyStatus.Invited then
			return React.createElement(Foundation.View, {
				tag = "auto-xy"
			}, {
				LoadingIcon = React.createElement(Foundation.Loading, {
					LayoutOrder = 1,
					size = IconSize.Small,
					Padding = v43.Padding.XSmall
				})
			})
		end

		if t1.user.partyStatus == SquadUserPartyStatus.NoResponse then
			return nil
		end

		if isConnecting or u61 then
			return React.createElement(Foundation.View, {
				tag = "auto-xy"
			}, {
				LoadingIcon = React.createElement(Foundation.Loading, {
					LayoutOrder = 1,
					size = IconSize.Small,
					Padding = v43.Padding.XSmall
				})
			})
		end

		if v52 then
			return React.createElement(Foundation.Icon, {
				LayoutOrder = 1,
				name = "icons/common/play",
				size = IconSize.Small,
				style = v43.Color.Content.Emphasis
			})
		end

		return nil
	end, {
		t1.user and t1.user.partyStatus,
		isConnecting,
		u61,
		v52
	})
	local v75 = React.useMemo(function() -- line: 242
		-- upvalues: s1 (ref), React (copy), v43 (copy), t1 (copy), Foundation (copy), IconSize (copy), u62 (ref), u60 (ref), u58 (ref), u59 (ref), FFlagEnablePartyVoiceChangersInLua (copy), u63 (ref), BuilderIcons (copy), FFlagEnableBlackbirdCheck (copy), v46 (copy)
		if s1 ~= "" then
			return (React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0)
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					Padding = UDim.new(0, v43.Gap.XSmall + 2),
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Center
				}),
				BlockedIcon = if not t1.isBlocked then nil else React.createElement(Foundation.Icon, {
					LayoutOrder = 1,
					name = "icons/status/unavailable_small",
					size = IconSize.Small,
					style = v43.Color.Extended.Red.Red_800
				}),
				MutedLocallyIcon = if not u62 then nil else React.createElement(Foundation.Icon, {
					LayoutOrder = 2,
					name = "icons/controls/voice/microphone_off_small_dark",
					size = IconSize.Small,
					style = v43.Color.Extended.Red.Red_800
				}),
				MutedIcon = if not u60 then nil else React.createElement(Foundation.Icon, {
					LayoutOrder = 3,
					name = "icons/controls/microphoneMute_small",
					size = IconSize.Small,
					style = v43.Color.Content.Emphasis
				}),
				NotVoiceParticipantIcon = if not u58 then nil else React.createElement(Foundation.Icon, {
					LayoutOrder = 4,
					name = "icons/controls/headphoneDeafen_small",
					size = IconSize.Small,
					style = v43.Color.Content.Emphasis
				}),
				NotEligibleVoiceParticipant = if not u59 then nil else React.createElement(Foundation.Icon, {
					LayoutOrder = 5,
					name = "icons/controls/headphoneDeafen_small",
					size = IconSize.Small,
					style = v43.Color.System.Warning
				}),
				VoiceChangerActiveIcon = if not FFlagEnablePartyVoiceChangersInLua or not u63 then nil else React.createElement(Foundation.Icon, {
					LayoutOrder = 6,
					size = IconSize.Small,
					name = BuilderIcons.Icon.DiamondSimplified,
					style = v43.Color.Content.Emphasis
				}),
				NameTextLabel = if FFlagEnableBlackbirdCheck then nil else React.createElement(Foundation.Text, {
					TextWrapped = false,
					AutomaticSize = Enum.AutomaticSize.Y,
					backgroundStyle = v43.Color.None,
					colorstyle = v43.Color.Content.Emphasis,
					fontStyle = v43.Typography.TitleMedium,
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
						Padding = UDim.new(0, v43.Gap.XSmall),
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
						backgroundStyle = v43.Color.None,
						colorstyle = v43.Color.Content.Emphasis,
						fontStyle = v43.Typography.TitleMedium,
						Text = s1,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Center,
						TextTruncate = Enum.TextTruncate.AtEnd
					}, {
						UIFlexItem = React.createElement("UIFlexItem", {
							FlexMode = Enum.UIFlexMode.Shrink
						})
					}),
					SubscriptionBadge = if not v46 then nil else React.createElement(Foundation.Icon, {
						LayoutOrder = 2,
						size = IconSize.Small,
						name = Foundation.Enums.IconName.RobloxPlus,
						style = v43.Color.Content.Emphasis
					})
				})
			}))
		end

		return nil
	end, {
		s1,
		u60,
		u62,
		t1.isBlocked,
		v43,
		u58,
		u59,
		if not FFlagEnablePartyVoiceChangersInLua then nil else u63,
		if not FFlagEnableBlackbirdCheck then nil else v46
	})
	local v76 = React.useMemo(function() -- line: 378
		-- upvalues: React (copy), v43 (copy), v74 (copy), Foundation (copy), v73 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v43.Gap.XSmall),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			PresenceIcon = v74,
			PresenceTextLabel = React.createElement(Foundation.Text, {
				LayoutOrder = 2,
				TextWrapped = false,
				AutomaticSize = Enum.AutomaticSize.Y,
				backgroundStyle = v43.Color.None,
				colorstyle = v43.Color.Content.Default,
				fontStyle = v43.Typography.BodyMedium,
				Text = v73,
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
		u61,
		v52,
		v42.connectingText,
		u53,
		v43,
		v74,
		v73
	})
	local v78

	if FFlagEnableSquadUserCardHoverFix then
		local v77 = #useSquadUserDropdownMenuButtons(t1.user.userId, t1.isInExperience) < 1

		v78 = not v56 and not v77
	else
		v78 = not v56
	end

	local v79 = React.useCallback(function() -- line: 431
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
		backgroundStyle = v43.Color.Surface.Surface_200,
		cornerRadius = UDim.new(0, v43.Radius.Medium),
		isDisabled = isConnecting or (u61 or (t1.user.partyStatus == SquadUserPartyStatus.Invited or t1.user.partyStatus == SquadUserPartyStatus.NoResponse)),
		onActivated = if not t1.onActivated or not v78 then nil else v79
	}, {
		AvatarImage = React.createElement(ImageSetLabel, {
			ZIndex = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(96, 96),
			BackgroundColor3 = v43.Color.Shift.Shift_300.Color3,
			BackgroundTransparency = v43.Color.Shift.Shift_300.Transparency,
			Image = v49
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
			BackgroundColor3 = v43.Color.Surface.Surface_100.Color3,
			BackgroundTransparency = v43.Color.Surface.Surface_100.Transparency
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v43.Radius.Medium)
			}),
			UIGradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0)
				})
			}, {})
		}),
		InactiveOverlay = if not isConnecting and (not u58 and (not u61 and (t1.user.partyStatus ~= SquadUserPartyStatus.Invited and t1.user.partyStatus ~= SquadUserPartyStatus.NoResponse))) then nil else React.createElement(Foundation.View, {
			tag = "size-full radius-medium",
			backgroundStyle = {
				Transparency = 0.25,
				Color3 = v43.Color.Surface.Surface_100.Color3
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
				PaddingBottom = UDim.new(0, v43.Padding.Medium),
				PaddingLeft = UDim.new(0, v43.Padding.Medium),
				PaddingRight = UDim.new(0, v43.Padding.Medium),
				PaddingTop = UDim.new(0, v43.Padding.Medium)
			}),
			Name = v75,
			Presence = if t1.isBlocked then nil else v76
		}),
		ActiveBorder = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 4,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.new(1, -8, 1, -8)
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v43.Radius.Medium - 4)
			}),
			UIStroke = React.createElement("UIStroke", {
				Thickness = 4,
				Color = v43.Color.Extended.Green.Green_800.Color3,
				Transparency = v44
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
				CornerRadius = UDim.new(0, v43.Radius.Medium - 1)
			}),
			UIStroke = React.createElement("UIStroke", {
				Thickness = 1,
				Color = v43.Color.Stroke.Default.Color3,
				Transparency = v44:map(function(p2) -- line: 555
					-- upvalues: v43 (copy)
					if p2 < 0.9 then
						return 1
					end

					return v43.Color.Stroke.Default.Transparency
				end)
			})
		})
	})
end
