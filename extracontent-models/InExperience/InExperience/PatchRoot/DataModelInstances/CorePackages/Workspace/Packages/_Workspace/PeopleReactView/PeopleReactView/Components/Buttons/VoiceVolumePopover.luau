local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local PeopleService = require(parent.PeopleService)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local View = Foundation.View
local Text = Foundation.Text
local Popover = Foundation.Popover
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign
local Radius = Foundation.Enums.Radius
local useScaledValue = Foundation.Hooks.useScaledValue
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState

local FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted = require(PeopleReactView.Flags.FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted)
local FFlagVoiceChatVolumePerUserMuteVolumeSync = require(PeopleReactView.Flags.FFlagVoiceChatVolumePerUserMuteVolumeSync)

local fFlagPeoplePageDismissVolumePopoverOnScrollOutOfView = PeopleService.getService("Flags").FFlagPeoplePageDismissVolumePopoverOnScrollOutOfView
local useDismissWhenOutOfView = require(PeopleReactView.Hooks.useDismissWhenOutOfView)

local fFlagPeoplePageFlipVolumePopoverToFitViewport = PeopleService.getService("Flags").FFlagPeoplePageFlipVolumePopoverToFitViewport

local usePopoverSideToFitScrollingViewport = require(PeopleReactView.Hooks.usePopoverSideToFitScrollingViewport)

local fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry = PeopleService.getService("Flags").FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local engineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")

local VOICE_VOLUME = PeopleService.getService("Constants").VOICE_CHAT.VOICE_VOLUME
local ENTRY_POINT = PeopleService.getService("Constants").ANALYTICS.ENTRY_POINT
local signal = Signals.createSignal(false)

local function VoiceVolumePopover(props)
	local v = useTokens()
	local v2 = useLocalization({ voiceChatVolume = "CoreScripts.InGameMenu.VoiceChatVolumeLower" })

	local v3 = React.useMemo(function()
		return PeopleService.getService("PeopleVoiceChatStore")
	end, {})
	local v4, entryPoint, v5, ref

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		v4 = React.useMemo(function()
			return PeopleService.getService("PeopleAnalyticsManager")
		end, {})
		entryPoint = props.entryPoint or ENTRY_POINT.PEOPLE_LIST
		local getPlayerIsLocalMuted = v3.getPlayerIsLocalMuted
		v5 = React.useCallback(function()
			if props.userId and getPlayerIsLocalMuted then
				return getPlayerIsLocalMuted(props.userId)(false)
			end

			return false
		end, { props.userId, getPlayerIsLocalMuted })
		ref = React.useRef(nil)
	else
		ref = nil
		v4 = nil
		v5 = nil
		entryPoint = nil
	end

	local v6

	if FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted then
		v6 = useSignalState(props.isMutedByLocalUser or signal)
	else
		v6 = false
	end

	local v7 = FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted and v6

	local v8 = useScaledValue(260)
	local size_2800

	if fFlagPeoplePageFlipVolumePopoverToFitViewport then
		size_2800 = v.Size.Size_2800
	end

	local ref2 = React.useRef(false)

	local v9 = React.useCallback(function()
		if props.userId and v3.getPlayerVoiceVolume then
			return v3.getPlayerVoiceVolume(props.userId)
		end

		return VOICE_VOLUME.DEFAULT
	end, { props.userId, v3 })

	local v10, v11 = React.useBinding(v9())

	React.useEffect(function()
		if props.isOpen and props.userId then
			v11(v9())

			if v3.subscribePlayerVoiceVolume then
				return v3.subscribePlayerVoiceVolume(props.userId, function(p)
					if not ref2.current then
						v11(p)
					end
				end)
			end
		else
			ref2.current = false

			if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry and ref then
				ref.current = nil
			end
		end
	end, { props.isOpen, props.userId, v9, v3 })

	local onValueChanged = React.useCallback(function(p: number)
		v11(p)

		if props.userId and v3.setPlayerVoiceVolume then
			v3.setPlayerVoiceVolume(props.userId, p)
		end
	end, { props.userId, v3 })
	local onDragStarted

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		onDragStarted = React.useCallback(function()
			ref2.current = true

			if v4 and ref and v5 and entryPoint then
				ref.current = {
					oldVolume = v9(),
					wasMutedAtStart = v5(),
					startTimestampMs = DateTime.now().UnixTimestampMillis
				}

				v4:trackPerUserVoiceVolumeSliderTouch(entryPoint)
			end
		end, { v9, v5, v4, entryPoint, ref })
	else
		onDragStarted = React.useCallback(function()
			ref2.current = true
		end, {})
	end

	local onDragEnded

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		onDragEnded = React.useCallback(function()
			ref2.current = false

			if v4 and props.userId and ref and entryPoint then
				local current = ref.current
				ref.current = nil

				if current then
					local newVolume = v9()
					local playSessionId

					if engineFeature then
						playSessionId = RbxAnalyticsService:GetPlaySessionId()
					end

					local v12 = {
						entryPoint = entryPoint,
						targetUserId = props.userId,
						oldVolume = current.oldVolume,
						newVolume = newVolume,
						wasMutedAtStart = current.wasMutedAtStart,
						playSessionId = playSessionId,
						voiceSessionId = 0,
						dragDurationMs = 0
					}
					local voiceSessionId

					if v3.getVoiceSessionId then
						voiceSessionId = v3.getVoiceSessionId()
					end

					v12.voiceSessionId = voiceSessionId

					v12.dragDurationMs = math.max(0, DateTime.now().UnixTimestampMillis - current.startTimestampMs)
					v4:trackPerUserVoiceVolumeChanged(v12)
				end
			end

			if FFlagVoiceChatVolumePerUserMuteVolumeSync then
				return
			end

			v11(v9())
		end, { v9, v4, props.userId, entryPoint, ref, v3 })
	else
		onDragEnded = React.useCallback(function()
			ref2.current = false

			if FFlagVoiceChatVolumePerUserMuteVolumeSync then
				return
			end

			v11(v9())
		end, { v9 })
	end

	local onPressedOutside = React.useCallback(function()
		if props.onClose then
			props.onClose()
		end
	end, { props.onClose })
	local ref3

	if fFlagPeoplePageDismissVolumePopoverOnScrollOutOfView or fFlagPeoplePageFlipVolumePopoverToFitViewport then
		ref3 = React.useRef(nil)
	end

	if fFlagPeoplePageDismissVolumePopoverOnScrollOutOfView then
		useDismissWhenOutOfView(props.isOpen, onPressedOutside, ref3)
	end

	local ref4 = nil

	local v12 = nil
	local ref5, position

	if fFlagPeoplePageFlipVolumePopoverToFitViewport then
		ref4 = React.useRef(nil)
		local state, setState = React.useState(0)
		v12 = setState

		ref5 = React.useCallback(function(instance)
			local v13 = ref4

			if v13.current then
				v13.current:Disconnect()
				v13.current = nil
			end

			local v14 = v12

			if instance == nil then
				v14(0)
				return
			end

			v14(instance.AbsoluteSize.Y)
			v13.current = instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				v14(instance.AbsoluteSize.Y)
			end)
		end, {})

		React.useEffect(function()
			return function()
				local v13 = ref4

				if v13.current then
					v13.current:Disconnect()
					v13.current = nil
				end
			end
		end, {})

		local v13 = math.max(size_2800, state)
		position = usePopoverSideToFitScrollingViewport(
			props.isOpen,
			PopoverSide.Top,
			ref3,
			v13,
			v.Stroke.Standard + v.Padding.Small
		)
	end

	local createElement = React.createElement
	local root = Popover.Root
	local v13 = { isOpen = props.isOpen }

	local createElement2 = React.createElement
	local anchor = Popover.Anchor
	local createElement3 = React.createElement
	local v14 = {
		tag = "row gap-xxsmall",
		Size = UDim2.fromOffset(props.pillWidth, props.pillHeight),
		LayoutOrder = props.layoutOrder,
		ref = 0
	}

	if not (fFlagPeoplePageDismissVolumePopoverOnScrollOutOfView or fFlagPeoplePageFlipVolumePopoverToFitViewport) then
		ref3 = nil
	end

	v14.ref = ref3
	local children = {
		Anchor = createElement2(anchor, nil, {
			Pill = createElement3(View, v14, {
				MuteHalf = props.muteHalf,
				ChevronHalf = props.chevronHalf
			})
		}),
		Content = 0
	}

	local createElement4 = React.createElement
	local content = Popover.Content

	if not fFlagPeoplePageFlipVolumePopoverToFitViewport then
		position = PopoverSide.Top
	end

	local v15 = {
		side = {
			position = position,
			offset = v.Stroke.Standard + v.Padding.Small
		},
		align = {
			position = PopoverAlign.Start,
			offset = props.alignOffset or 0
		},
		hasArrow = false,
		onPressedOutside = onPressedOutside,
		backgroundStyle = { Color3 = v.Color.Surface.Surface_100.Color3, Transparency = 1 },
		radius = Radius.Medium
	}

	local createElement5 = React.createElement
	local v16 = {
		tag = "col gap-medium auto-y padding-large stroke-standard stroke-default radius-medium bg-surface-100",
		Size = UDim2.new(0, v8, 0, 0),
		ref = 0
	}

	if not fFlagPeoplePageFlipVolumePopoverToFitViewport then
		ref5 = nil
	end

	v16.ref = ref5
	children.Content = createElement4(content, v15, {
		Container = createElement5(View, v16, {
			Content = React.createElement(
				View,
				{ tag = "col gap-medium size-full-0 auto-y padding-x-medium padding-y-small" },
				{
					Title = React.createElement(Text, {
						Text = v2.voiceChatVolume,
						tag = {
							["auto-xy text-body-medium content-muted"] = v7,
							["auto-xy text-body-medium content-emphasis"] = not v7
						}
					}),
					VolumeSlider = React.createElement(Foundation.Slider, {
						key = FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted and (v7 and "disabled" or "enabled") or nil,
						value = v10,
						range = NumberRange.new(VOICE_VOLUME.MIN, VOICE_VOLUME.MAX),
						knobVisibility = Foundation.Enums.Visibility.Always,
						isContained = true,
						step = 0.1,
						isDisabled = v7,
						onValueChanged = onValueChanged,
						onDragStarted = onDragStarted,
						onDragEnded = onDragEnded
					})
				}
			)
		})
	})
	return createElement(root, v13, children)
end

return VoiceVolumePopover
