local IXPService = game:GetService("IXPService")
local UserInputService = game:GetService("UserInputService")
local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local ReactOtter = require(SquadsParent.ReactOtter)
local SharedFlags = require(SquadsParent.SharedFlags)

require(Squads.Enums.SquadButtonSourceEnum)

local SquadButtonClickIntentionEnum = require(Squads.Enums.SquadButtonClickIntentionEnum)
local Responsive = require(SquadsParent.Responsive)
local usePreferredInput = Responsive.usePreferredInput
local useIsTvRemoteDevice = require(SquadsParent.RoactUtils).Hooks.useIsTvRemoteDevice
local dependencies = require(Squads.dependencies)
local Foundation = dependencies.Foundation
local React = dependencies.React

require(SquadsParent.SquadsCore.Enums)

local SquadExternalContractContext = require(SquadsParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local SquadState = require(SquadsParent.SquadsCore.Enums).SquadState
local leaveSquad = require(SquadsParent.SquadsCore.Thunks).leaveSquad
local useDispatch = dependencies.Hooks.useDispatch
local useLocalization = dependencies.Hooks.useLocalization
local useSelector = dependencies.Hooks.useSelector
local EventNames = require(SquadsParent.SquadsCore.EventNames)
local SquadPromptType = require(SquadsParent.SquadsCore.Enums).SquadPromptType
local useSquadState = require(SquadsParent.SquadsCore.Hooks).useSquadState
local useTokens = Foundation.Hooks.useTokens
local FFlagPartyDevAPIToRespectThirdPartySettingsEnabled = SharedFlags.FFlagPartyDevAPIToRespectThirdPartySettingsEnabled
local FFlagDebugAppChatEnableDomLocators = SharedFlags.FFlagDebugAppChatEnableDomLocators
local v26 = game:DefineFastFlag("AppChatNewSquadJoinButtonLookIconless", false)
local v27 = game:DefineFastFlag("AppChatSquadButtonColorUpdate", false)
local v28 = game:DefineFastFlag("AppChatSquadButtonColorVariantB", false)
local v29 = game:DefineFastFlag("AppChatSquadButtonColorUpdateIxpEnabled", false)
local v30 = game:DefineFastString("AppChatSquadButtonColorUpdateIxpLayer", "Social.AppChat")
local v31 = game:DefineFastFlag("AppChatSquadButtonHideGamepadIconOnTvRemote", false)
local t1 = {
	dampingRatio = 1,
	frequency = 1
}

return function(t2: {[any]: any}) -- line: 70
	-- upvalues: useLocalization (copy), useDispatch (copy), usePreferredInput (copy), v31 (copy), useIsTvRemoteDevice (copy), useTokens (copy), React (copy), SquadExternalContractContext (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), useSquadState (copy), ReactOtter (copy), t1 (copy), useSelector (copy), SquadButtonClickIntentionEnum (copy), EventNames (copy), leaveSquad (copy), SquadPromptType (copy), v28 (copy), v29 (copy), IXPService (copy), v30 (copy), Foundation (copy), v27 (copy), SquadState (copy), FFlagDebugAppChatEnableDomLocators (copy), v26 (copy), Responsive (copy), UserInputService (copy)
	local v34 = useLocalization({
		joinButtonText = "Feature.Squads.Action.Join",
		startButtonText = "Feature.Squads.Action.Start",
		viewButtonText = "Feature.Squads.Action.View"
	})
	local v35 = useDispatch()
	local v36 = usePreferredInput()
	local v37 = not not v31 and useIsTvRemoteDevice()
	local v38 = useTokens()
	local v39 = React.useContext(SquadExternalContractContext)
	local v40 = v39.useParentChannelHasGroupUp(t2.conversationId)
	local v41 = not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v39.useIsChatEnabled()
	local v42 = useSquadState()
	local u43 = nil
	local v44, v45 = ReactOtter.useAnimatedBinding(1, function(p1) -- line: 93
		-- upvalues: t2 (copy), u43 (ref), ReactOtter (copy), t1 (copy)
		if t2.shouldAnimate then
			task.delay(0.5, function() -- line: 95
				-- upvalues: u43 (ref), ReactOtter (copy), p1 (copy), t1 (copy)
				u43(ReactOtter.spring(p1 ~= 1 and 1 or 0, t1))
			end)
		end
	end)

	u43 = v45
	React.useEffect(function() -- line: 101
		-- upvalues: t2 (copy), u43 (ref), ReactOtter (copy), t1 (copy)
		if t2.shouldAnimate then
			u43(ReactOtter.spring(1, t1))

			return
		end

		u43(ReactOtter.instant(1))
	end, {
		t2.shouldAnimate,
		u43
	})

	local v46 = React.useCallback(function(p2) -- line: 109
		if p2.Squad and p2.Squad.Squad then
			return p2.Squad.Squad.currentSquad
		end

		return nil
	end, {})
	local v47 = useSelector(v46)
	local v48 = React.useMemo(function() -- line: 118
		-- upvalues: v47 (copy), t2 (copy)
		return v47 and v47.parentChannelId == t2.conversationId
	end, {
		v47,
		t2.conversationId
	})
	local v49 = React.useMemo(function() -- line: 122
		-- upvalues: v48 (copy), SquadButtonClickIntentionEnum (copy), v40 (copy)
		if v48 then
			return SquadButtonClickIntentionEnum.View
		end

		if v40 then
			return SquadButtonClickIntentionEnum.Join
		end

		return SquadButtonClickIntentionEnum.Create
	end, {
		v48,
		v40
	})
	local v50 = React.useMemo(function() -- line: 132
		-- upvalues: v48 (copy), v34 (copy), v40 (copy)
		if v48 then
			return v34.viewButtonText
		end

		if v40 then
			return v34.joinButtonText
		end

		return v34.startButtonText
	end, {
		v40,
		v48,
		v34.joinButtonText,
		v34.startButtonText,
		v34.viewButtonText
	})
	local v51 = React.useCallback(function() -- line: 148
		-- upvalues: v39 (copy), EventNames (copy), t2 (copy), v47 (copy), v49 (copy)
		v39.fireSquadAnalytics(EventNames.EnterSquadButtonPressed, {
			conversationId = t2.conversationId,
			squadButtonSource = t2.squadButtonSource,
			squadId = v47 and v47.squadId,
			squadLocation = t2.squadLocation,
			userIntention = v49
		})
	end, {
		v49,
		v47,
		t2.conversationId,
		t2.squadButtonSource,
		t2.squadLocation,
		v39.fireSquadAnalytics
	})
	local v52 = React.useCallback(function() -- line: 165
		-- upvalues: v51 (copy), v48 (copy), v47 (copy), v35 (copy), leaveSquad (copy), SquadPromptType (copy), v39 (copy), t2 (copy), FFlagPartyDevAPIToRespectThirdPartySettingsEnabled (copy), v41 (copy)
		v51()

		if not v48 and v47 then
			v35(leaveSquad(SquadPromptType.JoinAnotherSquad, v39.setSquadPrompt, function() -- line: 172
				-- upvalues: t2 (copy)
				t2.onActivated(t2.conversationId)
			end, v39.squadLocation, not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled or v41))

			return
		end

		t2.onActivated(t2.conversationId)
	end, {
		v47,
		v48,
		t2.onActivated,
		v51,
		v39.setSquadPrompt,
		v39.squadLocation,
		if not FFlagPartyDevAPIToRespectThirdPartySettingsEnabled then nil else v41
	})
	local v53 = React.useMemo(function() -- line: 192
		-- upvalues: v38 (copy), t2 (copy)
		if v38.Config.ColorMode.IsLight == "true" then
			if t2.isInCard then
				return v38.Color.Extended.Gray.Gray_300
			end

			return v38.Color.Extended.Gray.Gray_200
		end

		if t2.isInCard then
			return v38.Color.Extended.Gray.Gray_800
		end

		return v38.Color.Extended.Gray.Gray_900
	end, {
		t2.isInCard,
		v38.Config.ColorMode.IsLight
	})
	local v54 = v49 == SquadButtonClickIntentionEnum.View
	local v55 = v28
	local v56 = not v55

	React.useEffect(function() -- line: 214
		-- upvalues: v29 (copy), IXPService (copy), v30 (copy)
		if v29 then
			IXPService:LogFlagLinkedUserLayerExposure(v30)
		end
	end, {})

	return React.createElement(Foundation.View, {
		tag = not v27 and "row align-x-center align-y-center gap-xsmall stroke-action-standard radius-medium bg-action-standard" or {
			["row align-x-center align-y-center gap-xsmall radius-medium"] = true,
			["bg-action-standard stroke-action-standard"] = not v54,
			["bg-action-soft-emphasis stroke-action-soft-emphasis"] = v54 and v56,
			["bg-action-emphasis stroke-action-emphasis"] = v54 and v55
		},
		AutomaticSize = if not t2.isFullWidth then Enum.AutomaticSize.XY else Enum.AutomaticSize.None,
		Size = UDim2.new(not t2.isFullWidth and 0 or 1, 0, 0, v38.Size.Size_800),
		isDisabled = v42 == SquadState.Initializing,
		onActivated = v52,
		LayoutOrder = t2.layoutOrder,
		padding = {
			left = UDim.new(0, v38.Padding.Small),
			right = UDim.new(0, v38.Padding.Small)
		},
		selection = {
			Selectable = t2.Selectable
		},
		testId = if not FFlagDebugAppChatEnableDomLocators then nil else `{ t2.testId }{ v49 }`
	}, {
		GroupIconContainer = if v26 then nil else React.createElement(Foundation.View, {
			tag = "size-400-400",
			LayoutOrder = 1
		}, {
			GroupIcon = React.createElement(Foundation.Icon, {
				name = Foundation.Enums.IconName.ThreePeople,
				size = Foundation.Enums.IconSize.Small,
				style = v38.Color.ActionStandard.Foreground,
				variant = Foundation.Enums.IconVariant.Regular
			}),
			GreenDot = if not v40 and not v48 then nil else React.createElement(Foundation.View, {
				tag = "radius-circle anchor-top-right",
				ZIndex = 2,
				Size = UDim2.fromOffset(v38.Size.Size_200, v38.Size.Size_200),
				backgroundStyle = v44:map(function(p3) -- line: 258
					-- upvalues: v38 (copy)
					return {
						Color3 = v38.Color.Extended.Green.Green_500.Color3,
						Transparency = 1 + (v38.Color.Extended.Green.Green_500.Transparency - 1) * p3
					}
				end),
				Position = UDim2.new(1, v38.Size.Size_50, 0, -v38.Size.Size_50),
				stroke = {
					Color = v53.Color3,
					Transparency = v44:map(function(p4) -- line: 267
						-- upvalues: v53 (copy)
						return 1 + (v53.Transparency - 1) * p4
					end),
					Thickness = v38.Stroke.Thicker
				}
			})
		}),
		TextLabel = React.createElement(Foundation.Text, {
			LayoutOrder = 2,
			tag = not v27 and "auto-xy text-label-small content-action-standard text-truncate-end text-no-wrap" or {
				["auto-xy text-label-small text-no-wrap text-truncate-end"] = true,
				["content-action-standard"] = not v54,
				["content-action-soft-emphasis"] = v54 and v56,
				["content-action-emphasis"] = v54 and v55
			},
			Text = v50,
			padding = {
				right = UDim.new(0, v38.Padding.XXSmall)
			},
			sizeConstraint = if not t2.isFullWidth then {
				MaxSize = Vector2.new(v38.Size.Size_2800, v38.Size.Size_800)
			} else nil
		}),
		SignifierImage = if not t2.shouldShowSignifier or (v36 ~= Responsive.Input.Directional or v37) then nil else React.createElement(Foundation.Icon, {
			LayoutOrder = 3,
			name = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonX),
			size = Foundation.Enums.IconSize.Small,
			style = if not v27 or not v54 then v38.Color.ActionStandard.Foreground else if not v55 then v38.Color.ActionSoftEmphasis.Foreground else v38.Color.ActionEmphasis.Foreground
		})
	})
end
