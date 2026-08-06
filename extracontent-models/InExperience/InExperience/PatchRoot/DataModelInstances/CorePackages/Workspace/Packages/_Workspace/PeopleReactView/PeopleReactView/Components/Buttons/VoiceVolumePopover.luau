local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local React = require(PeopleReactViewParent.React)
local Foundation = require(PeopleReactViewParent.Foundation)
local PeopleService = require(PeopleReactViewParent.PeopleService)
local Signals = require(PeopleReactViewParent.Signals)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)
local useLocalization = require(PeopleReactViewParent.Localization).Hooks.useLocalization
local View = Foundation.View
local FoundationText = Foundation.Text
local Popover = Foundation.Popover
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local EnumsRadius = Foundation.Enums.Radius
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState
local FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted = require(PeopleReactView.Flags.FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted)
local FFlagVoiceChatVolumePerUserMuteVolumeSync = require(PeopleReactView.Flags.FFlagVoiceChatVolumePerUserMuteVolumeSync)
local FFlagPeoplePageDismissVolumePopoverOnScrollOutOfView = PeopleService.getService("Flags").FFlagPeoplePageDismissVolumePopoverOnScrollOutOfView
local useDismissWhenOutOfView = require(PeopleReactView.Hooks.useDismissWhenOutOfView)
local FFlagPeoplePageFlipVolumePopoverToFitViewport = PeopleService.getService("Flags").FFlagPeoplePageFlipVolumePopoverToFitViewport
local usePopoverSideToFitScrollingViewport = require(PeopleReactView.Hooks.usePopoverSideToFitScrollingViewport)
local FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry = PeopleService.getService("Flags").FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local EngineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")
local VOICE_VOLUME = PeopleService.getService("Constants").VOICE_CHAT.VOICE_VOLUME
local ENTRY_POINT = PeopleService.getService("Constants").ANALYTICS.ENTRY_POINT
local v29 = Signals.createSignal(false)

local function VoiceVolumePopover(t1: {[any]: any}) -- line: 66
	-- upvalues: useTokens (copy), useLocalization (copy), React (copy), PeopleService (copy), FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry (copy), ENTRY_POINT (copy), FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted (copy), useSignalState (copy), v29 (copy), useScaledValue (copy), FFlagPeoplePageFlipVolumePopoverToFitViewport (copy), VOICE_VOLUME (copy), EngineFeature (copy), RbxAnalyticsService (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), FFlagPeoplePageDismissVolumePopoverOnScrollOutOfView (copy), useDismissWhenOutOfView (copy), usePopoverSideToFitScrollingViewport (copy), PopoverSide (copy), Popover (copy), View (copy), PopoverAlign (copy), EnumsRadius (copy), FoundationText (copy), Foundation (copy)
	local v32 = useTokens()
	local v33 = useLocalization({
		voiceChatVolume = "CoreScripts.InGameMenu.VoiceChatVolumeLower"
	})
	local v34 = React.useMemo(function() -- line: 72
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("PeopleVoiceChatStore")
	end, {})
	local u35 = nil
	local u36 = nil
	local u37 = nil
	local u38 = nil

	if FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		u35 = React.useMemo(function() -- line: 81
			-- upvalues: PeopleService (copy)
			return PeopleService.getService("PeopleAnalyticsManager")
		end, {})
		u36 = t1.entryPoint or ENTRY_POINT.PEOPLE_LIST

		local getPlayerIsLocalMuted = v34.getPlayerIsLocalMuted

		u37 = React.useCallback(function() -- line: 86
			-- upvalues: t1 (copy), getPlayerIsLocalMuted (copy)
			if t1.userId and getPlayerIsLocalMuted then
				return getPlayerIsLocalMuted(t1.userId)(false)
			end

			return false
		end, {
			t1.userId,
			getPlayerIsLocalMuted
		})
		u38 = React.useRef(nil)
	end

	local v40 = false

	if FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted then
		v40 = useSignalState(t1.isMutedByLocalUser or v29)
	end

	local v41 = FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted and v40
	local v42 = useScaledValue(260)
	local v43 = if not FFlagPeoplePageFlipVolumePopoverToFitViewport then nil else v32.Size.Size_2800
	local v44 = React.useRef(false)
	local v45 = React.useCallback(function() -- line: 109
		-- upvalues: t1 (copy), v34 (copy), VOICE_VOLUME (copy)
		if t1.userId and v34.getPlayerVoiceVolume then
			return v34.getPlayerVoiceVolume(t1.userId)
		end

		return VOICE_VOLUME.DEFAULT
	end, {
		t1.userId,
		v34
	})
	local v46, v47 = React.useBinding(v45())

	React.useEffect(function() -- line: 118
		-- upvalues: t1 (copy), v44 (copy), FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry (copy), u38 (ref), v47 (copy), v45 (copy), v34 (copy)
		if not t1.isOpen or not t1.userId then
			v44.current = false

			if FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry and u38 then
				u38.current = nil
			end

			return
		end

		v47(v45())

		if v34.subscribePlayerVoiceVolume then
			return v34.subscribePlayerVoiceVolume(t1.userId, function(p1) -- line: 129
				-- upvalues: v44 (copy), v47 (copy)
				if not v44.current then
					v47(p1)
				end
			end)
		end
	end, {
		t1.isOpen,
		t1.userId,
		v45,
		v34
	})

	local v48 = React.useCallback(function(n1: number) -- line: 138
		-- upvalues: v47 (copy), t1 (copy), v34 (copy)
		v47(n1)

		if t1.userId and v34.setPlayerVoiceVolume then
			v34.setPlayerVoiceVolume(t1.userId, n1)
		end
	end, {
		t1.userId,
		v34
	})
	local v49 = if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then React.useCallback(function() -- line: 159
		-- upvalues: v44 (copy)
		v44.current = true
	end, {}) else React.useCallback(function() -- line: 147
		-- upvalues: v44 (copy), u35 (ref), u38 (ref), u37 (ref), u36 (ref), v45 (copy)
		v44.current = true

		if u35 and (u38 and u37 and u36) then
			u38.current = {
				oldVolume = v45(),
				wasMutedAtStart = u37(),
				startTimestampMs = DateTime.now().UnixTimestampMillis
			}
			u35:trackPerUserVoiceVolumeSliderTouch(u36)
		end
	end, {
		v45,
		u37,
		u35,
		u36,
		u38
	})
	local v50 = if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then React.useCallback(function() -- line: 211
		-- upvalues: v44 (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), v47 (copy), v45 (copy)
		v44.current = false

		if FFlagVoiceChatVolumePerUserMuteVolumeSync then
			return
		end

		v47(v45())
	end, { v45 }) else React.useCallback(function() -- line: 167
		-- upvalues: v44 (copy), u35 (ref), t1 (copy), u38 (ref), u36 (ref), v45 (copy), EngineFeature (copy), RbxAnalyticsService (copy), v34 (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), v47 (copy)
		v44.current = false

		if u35 and (t1.userId and u38 and u36) then
			local current = u38.current

			u38.current = nil

			if current then
				local v62 = v45()
				local v63 = if not EngineFeature then nil else RbxAnalyticsService:GetPlaySessionId()

				u35:trackPerUserVoiceVolumeChanged({
					entryPoint = u36,
					targetUserId = t1.userId,
					oldVolume = current.oldVolume,
					newVolume = v62,
					wasMutedAtStart = current.wasMutedAtStart,
					playSessionId = v63,
					voiceSessionId = if not v34.getVoiceSessionId then nil else v34.getVoiceSessionId(),
					dragDurationMs = math.max(0, DateTime.now().UnixTimestampMillis - current.startTimestampMs)
				})
			end
		end

		if FFlagVoiceChatVolumePerUserMuteVolumeSync then
			return
		end

		v47(v45())
	end, {
		v45,
		u35,
		t1.userId,
		u36,
		u38,
		v34
	})
	local v51 = React.useCallback(function() -- line: 220
		-- upvalues: t1 (copy)
		if t1.onClose then
			t1.onClose()
		end
	end, { t1.onClose })
	local v52 = nil

	if FFlagPeoplePageDismissVolumePopoverOnScrollOutOfView or FFlagPeoplePageFlipVolumePopoverToFitViewport then
		v52 = React.useRef(nil)
	end

	if FFlagPeoplePageDismissVolumePopoverOnScrollOutOfView then
		useDismissWhenOutOfView(t1.isOpen, v51, v52)
	end

	local u53 = nil
	local u54 = nil
	local v55 = nil
	local v56 = nil

	if FFlagPeoplePageFlipVolumePopoverToFitViewport then
		u53 = React.useRef(nil)

		local v57, v58 = React.useState(0)

		u54 = v58
		v55 = React.useCallback(function(p2) -- line: 245
			-- upvalues: u53 (ref), u54 (ref)
			local v65 = u53

			if v65.current then
				v65.current:Disconnect()
				v65.current = nil
			end

			local v66 = u54

			if p2 == nil then
				v66(0)

				return
			end

			v66(p2.AbsoluteSize.Y)
			v65.current = p2:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- line: 259
				-- upvalues: v66 (copy), p2 (copy)
				v66(p2.AbsoluteSize.Y)
			end)
		end, {})
		React.useEffect(function() -- line: 264
			-- upvalues: u53 (ref)
			return function() -- line: 265
				-- upvalues: u53 (ref)
				local v68 = u53

				if v68.current then
					v68.current:Disconnect()
					v68.current = nil
				end
			end
		end, {})

		local v59 = math.max(v43, v57)

		v56 = usePopoverSideToFitScrollingViewport(t1.isOpen, PopoverSide.Top, v52, v59, v32.Stroke.Standard + v32.Padding.Small)
	end

	return React.createElement(Popover.Root, {
		isOpen = t1.isOpen
	}, {
		Anchor = React.createElement(Popover.Anchor, nil, {
			Pill = React.createElement(View, {
				tag = "row gap-xxsmall",
				Size = UDim2.fromOffset(t1.pillWidth, t1.pillHeight),
				LayoutOrder = t1.layoutOrder,
				ref = if not FFlagPeoplePageDismissVolumePopoverOnScrollOutOfView and not FFlagPeoplePageFlipVolumePopoverToFitViewport then nil else v52
			}, {
				MuteHalf = t1.muteHalf,
				ChevronHalf = t1.chevronHalf
			})
		}),
		Content = React.createElement(Popover.Content, {
			hasArrow = false,
			side = {
				position = if not FFlagPeoplePageFlipVolumePopoverToFitViewport then PopoverSide.Top else v56,
				offset = v32.Stroke.Standard + v32.Padding.Small
			},
			align = {
				position = PopoverAlign.Start,
				offset = t1.alignOffset or 0
			},
			onPressedOutside = v51,
			backgroundStyle = {
				Transparency = 1,
				Color3 = v32.Color.Surface.Surface_100.Color3
			},
			radius = EnumsRadius.Medium
		}, {
			Container = React.createElement(View, {
				tag = "col gap-medium auto-y padding-large stroke-standard stroke-default radius-medium bg-surface-100",
				Size = UDim2.new(0, v42, 0, 0),
				ref = if not FFlagPeoplePageFlipVolumePopoverToFitViewport then nil else v55
			}, {
				Content = React.createElement(View, {
					tag = "col gap-medium size-full-0 auto-y padding-x-medium padding-y-small"
				}, {
					Title = React.createElement(FoundationText, {
						Text = v33.voiceChatVolume,
						tag = {
							["auto-xy text-body-medium content-muted"] = v41,
							["auto-xy text-body-medium content-emphasis"] = not v41
						}
					}),
					VolumeSlider = React.createElement(Foundation.Slider, {
						isContained = true,
						step = 0.1,
						key = if not FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted then nil else not v41 and "enabled" or "disabled",
						value = v46,
						range = NumberRange.new(VOICE_VOLUME.MIN, VOICE_VOLUME.MAX),
						knobVisibility = Foundation.Enums.Visibility.Always,
						isDisabled = v41,
						onValueChanged = v48,
						onDragStarted = v49,
						onDragEnded = v50
					})
				})
			})
		})
	})
end

return VoiceVolumePopover
