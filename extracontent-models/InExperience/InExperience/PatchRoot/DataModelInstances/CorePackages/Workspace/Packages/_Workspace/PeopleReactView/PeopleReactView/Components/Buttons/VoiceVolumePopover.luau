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
local VOICE_VOLUME = PeopleService.getService("Constants").VOICE_CHAT.VOICE_VOLUME
local v21 = Signals.createSignal(false)

local function VoiceVolumePopover(t1: {[any]: any}) -- line: 47
	-- upvalues: useTokens (copy), useLocalization (copy), React (copy), PeopleService (copy), FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted (copy), useSignalState (copy), v21 (copy), useScaledValue (copy), VOICE_VOLUME (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), Popover (copy), PopoverSide (copy), PopoverAlign (copy), EnumsRadius (copy), View (copy), FoundationText (copy), Foundation (copy)
	local v24 = useTokens()
	local v25 = useLocalization({
		voiceChatVolume = "CoreScripts.InGameMenu.VoiceChatVolumeLower"
	})
	local v26 = React.useMemo(function() -- line: 53
		-- upvalues: PeopleService (copy)
		return PeopleService.getService("PeopleVoiceChatStore")
	end, {})
	local v27 = false

	if FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted then
		v27 = useSignalState(t1.isMutedByLocalUser or v21)
	end

	local v28 = FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted and v27
	local v29 = useScaledValue(260)
	local v30 = React.useRef(false)
	local v31 = React.useCallback(function() -- line: 68
		-- upvalues: t1 (copy), v26 (copy), VOICE_VOLUME (copy)
		if t1.userId and v26.getPlayerVoiceVolume then
			return v26.getPlayerVoiceVolume(t1.userId)
		end

		return VOICE_VOLUME.DEFAULT
	end, {
		t1.userId,
		v26
	})
	local v32, v33 = React.useBinding(v31())

	React.useEffect(function() -- line: 77
		-- upvalues: t1 (copy), v30 (copy), v33 (copy), v31 (copy), v26 (copy)
		if not t1.isOpen or not t1.userId then
			v30.current = false

			return
		end

		v33(v31())

		if v26.subscribePlayerVoiceVolume then
			return v26.subscribePlayerVoiceVolume(t1.userId, function(p1) -- line: 85
				-- upvalues: v30 (copy), v33 (copy)
				if not v30.current then
					v33(p1)
				end
			end)
		end
	end, {
		t1.isOpen,
		t1.userId,
		v31,
		v26
	})

	local v34 = React.useCallback(function(n1: number) -- line: 94
		-- upvalues: v33 (copy), t1 (copy), v26 (copy)
		v33(n1)

		if t1.userId and v26.setPlayerVoiceVolume then
			v26.setPlayerVoiceVolume(t1.userId, n1)
		end
	end, {
		t1.userId,
		v26
	})
	local v35 = React.useCallback(function() -- line: 101
		-- upvalues: v30 (copy)
		v30.current = true
	end, {})
	local v36 = React.useCallback(function() -- line: 105
		-- upvalues: v30 (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), v33 (copy), v31 (copy)
		v30.current = false

		if FFlagVoiceChatVolumePerUserMuteVolumeSync then
			return
		end

		v33(v31())
	end, { v31 })
	local v37 = React.useCallback(function() -- line: 113
		-- upvalues: t1 (copy)
		if t1.onClose then
			t1.onClose()
		end
	end, { t1.onClose })

	return React.createElement(Popover.Root, {
		isOpen = t1.isOpen
	}, {
		Anchor = React.createElement(Popover.Anchor, nil, {
			Pill = React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(t1.pillWidth, t1.pillHeight),
				LayoutOrder = t1.layoutOrder
			}, {
				[t1.muteHalfKey] = t1.muteHalf,
				[t1.volumeHalfKey] = t1.chevronHalf
			})
		}),
		Content = React.createElement(Popover.Content, {
			hasArrow = false,
			side = {
				position = PopoverSide.Top,
				offset = v24.Stroke.Standard + v24.Padding.Small
			},
			align = {
				position = PopoverAlign.Start,
				offset = t1.alignOffset or 0
			},
			onPressedOutside = v37,
			backgroundStyle = {
				Transparency = 1,
				Color3 = v24.Color.Surface.Surface_100.Color3
			},
			radius = EnumsRadius.Medium
		}, {
			Container = React.createElement(View, {
				tag = "col gap-medium auto-y padding-large stroke-standard stroke-default radius-medium bg-surface-100",
				Size = UDim2.new(0, v29, 0, 0)
			}, {
				Content = React.createElement(View, {
					tag = "col gap-medium size-full-0 auto-y padding-x-medium padding-y-small"
				}, {
					Title = React.createElement(FoundationText, {
						Text = v25.voiceChatVolume,
						tag = {
							["auto-xy text-body-medium content-muted"] = v28,
							["auto-xy text-body-medium content-emphasis"] = not v28
						}
					}),
					VolumeSlider = React.createElement(Foundation.Slider, {
						step = 0.1,
						key = if not FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted then nil else not v28 and "enabled" or "disabled",
						value = v32,
						range = NumberRange.new(VOICE_VOLUME.MIN, VOICE_VOLUME.MAX),
						knobVisibility = Foundation.Enums.Visibility.Always,
						width = UDim.new(1, 0),
						isDisabled = v28,
						onValueChanged = v34,
						onDragStarted = v35,
						onDragEnded = v36
					})
				})
			})
		})
	})
end

return VoiceVolumePopover
