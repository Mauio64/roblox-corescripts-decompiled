local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local PeopleService = require(parent.PeopleService)

local InputSize = Foundation.Enums.InputSize
local Popover = Foundation.Popover
local Radius = Foundation.Enums.Radius
local Text = Foundation.Text
local View = Foundation.View

local BaseMenu = Foundation.UNSTABLE.BaseMenu
local useTokens = Foundation.Hooks.useTokens

local FFlagVoiceChatVolumePerUserMuteVolumeSync = require(PeopleReactView.Flags.FFlagVoiceChatVolumePerUserMuteVolumeSync)

local FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted = require(PeopleReactView.Flags.FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted)

local fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry = PeopleService.getService("Flags").FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry
local ENTRY_POINT = PeopleService.getService("Constants").ANALYTICS.ENTRY_POINT

local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local engineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")

local function VoiceVolumeSlider(props)
	local v = useLocalization({ volumeLabel = "CoreScripts.InGameMenu.GameSettings.Volume" })
	local v2, ref

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		v2 = React.useMemo(function()
			return PeopleService.getService("PeopleAnalyticsManager")
		end, {})
		ref = React.useRef(nil)
	else
		v2 = nil
		ref = nil
	end

	local v3 = FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted and props.isMutedByLocalUser == true

	local ref2 = React.useRef(false)
	local v4, v5 = React.useBinding(props.getPlayerVoiceVolume(props.userId))

	React.useEffect(function()
		return props.subscribePlayerVoiceVolume(props.userId, function(p)
			if not ref2.current then
				v5(p)
			end
		end)
	end, { props.userId, props.subscribePlayerVoiceVolume })

	local onValueChanged = React.useCallback(function(p: number)
		v5(p)
		props.setPlayerVoiceVolume(props.userId, p)
	end, { props.userId, props.setPlayerVoiceVolume })

	local useCallback = React.useCallback
	local function fn()
		ref2.current = true

		if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry and v2 and ref then
			local wasMutedAtStart

			if props.getPlayerIsLocalMuted then
				wasMutedAtStart = props.getPlayerIsLocalMuted(props.userId)
			else
				wasMutedAtStart = props.isMutedByLocalUser == true
			end

			ref.current = {
				oldVolume = props.getPlayerVoiceVolume(props.userId),
				wasMutedAtStart = wasMutedAtStart,
				startTimestampMs = DateTime.now().UnixTimestampMillis
			}

			v2:trackPerUserVoiceVolumeSliderTouch(ENTRY_POINT.PEOPLE_CARD)
		end
	end

	local userId

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		userId = props.userId
	end

	local getPlayerVoiceVolume

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		getPlayerVoiceVolume = props.getPlayerVoiceVolume
	end

	local getPlayerIsLocalMuted

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		getPlayerIsLocalMuted = props.getPlayerIsLocalMuted
	end

	local isMutedByLocalUser

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		isMutedByLocalUser = props.isMutedByLocalUser
	end

	local v6

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		v6 = v2
	end

	local v7

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		v7 = ref
	end

	local onDragStarted = useCallback(fn, {
		userId,
		getPlayerVoiceVolume,
		getPlayerIsLocalMuted,
		isMutedByLocalUser,
		v6,
		v7
	})

	local useCallback2 = React.useCallback
	local function fn2()
		ref2.current = false

		if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry and v2 and ref then
			local current = ref.current
			ref.current = nil

			if current then
				local playerVoiceVolume = props.getPlayerVoiceVolume(props.userId)
				local playSessionId

				if engineFeature then
					playSessionId = RbxAnalyticsService:GetPlaySessionId()
				end

				local v8 = {
					entryPoint = ENTRY_POINT.PEOPLE_CARD,
					targetUserId = props.userId,
					oldVolume = current.oldVolume,
					newVolume = playerVoiceVolume,
					wasMutedAtStart = current.wasMutedAtStart,
					playSessionId = playSessionId,
					voiceSessionId = 0,
					dragDurationMs = 0
				}
				local voiceSessionId

				if props.getVoiceSessionId then
					voiceSessionId = props.getVoiceSessionId()
				end

				v8.voiceSessionId = voiceSessionId
				v8.dragDurationMs = math.max(0, DateTime.now().UnixTimestampMillis - current.startTimestampMs)
				v2:trackPerUserVoiceVolumeChanged(v8)
			end
		end

		if FFlagVoiceChatVolumePerUserMuteVolumeSync then
			return
		end

		v5(props.getPlayerVoiceVolume(props.userId))
	end

	local userId2 = props.userId
	local getPlayerVoiceVolume2 = props.getPlayerVoiceVolume
	local getVoiceSessionId

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		getVoiceSessionId = props.getVoiceSessionId
	end

	local v8

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		v8 = v2
	end

	local v9

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		v9 = ref
	end

	local onDragEnded = useCallback2(fn2, {
		userId2,
		getPlayerVoiceVolume2,
		getVoiceSessionId,
		v8,
		v9
	})

	return React.createElement(
		View,
		{
			tag = "col gap-small size-full-0 auto-y padding-x-medium padding-y-small",
			LayoutOrder = props.layoutOrder
		},
		{
			Title = React.createElement(Text, {
				Text = v.volumeLabel,
				tag = {
					["auto-xy text-body-medium content-muted"] = v3,
					["auto-xy text-body-medium content-emphasis"] = not v3
				}
			}),
			VolumeSlider = React.createElement(Foundation.Slider, {
				key = FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted and (v3 and "disabled" or "enabled") or nil,
				value = v4,
				range = NumberRange.new(props.voiceVolumeMin, props.voiceVolumeMax),
				knobVisibility = Foundation.Enums.Visibility.Always,
				isContained = true,
				step = 0.1,
				width = UDim.new(1, 0),
				isDisabled = v3,
				onValueChanged = onValueChanged,
				onDragStarted = onDragStarted,
				onDragEnded = onDragEnded
			})
		}
	)
end

local function CardMenuWithVoiceVolume(props)
	local v = useTokens()
	local standard = v.Stroke.Standard
	local padding = {
		left = UDim.new(0, v.Size.Size_250),
		right = UDim.new(0, v.Size.Size_250),
		top = UDim.new(0, v.Padding.XSmall),
		bottom = UDim.new(0, v.Padding.XSmall)
	}

	local children = {}

	for k, menuGroup in props.menuGroups do
		local children2 = {}

		for k2, item in menuGroup.items do
			children2[tostring(item.id)] = React.createElement(BaseMenu.Item, {
				LayoutOrder = k2,
				id = item.id,
				text = item.text,
				icon = item.icon,
				onActivated = item.onActivated
			})
		end

		if menuGroup.title ~= nil then
			children2.SectionTitle = React.createElement(
				View,
				{
					LayoutOrder = 0,
					tag = "row align-y-center size-full-0 auto-y",
					padding = padding
				},
				{
					Label = React.createElement(Text, {
						Text = menuGroup.title,
						tag = "fill auto-xy text-align-x-left text-truncate-end text-caption-small content-muted"
					})
				}
			)
		end

		if menuGroup.showVolumeSlider then
			local createElement = React.createElement
			local v2 = {
				userId = props.userId,
				voiceVolumeMin = props.voiceVolumeMin,
				voiceVolumeMax = props.voiceVolumeMax,
				getPlayerVoiceVolume = props.getPlayerVoiceVolume,
				subscribePlayerVoiceVolume = props.subscribePlayerVoiceVolume,
				setPlayerVoiceVolume = props.setPlayerVoiceVolume,
				isMutedByLocalUser = props.isMutedByLocalUser,
				getPlayerIsLocalMuted = 0,
				getVoiceSessionId = 0,
				layoutOrder = 0
			}
			local getPlayerIsLocalMuted

			if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
				getPlayerIsLocalMuted = props.getPlayerIsLocalMuted
			end

			v2.getPlayerIsLocalMuted = getPlayerIsLocalMuted
			local getVoiceSessionId

			if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
				getVoiceSessionId = props.getVoiceSessionId
			end

			v2.getVoiceSessionId = getVoiceSessionId

			v2.layoutOrder = #menuGroup.items + 1
			children2.VoiceVolumeSlider = createElement(VoiceVolumeSlider, v2)
		end

		children[`Group_{k}`] = React.createElement(BaseMenu.Group, { LayoutOrder = k }, children2)
	end

	return React.createElement(Popover.Root, { isOpen = props.isOpen, testId = "--foundation-menu" }, {
		Anchor = React.createElement(Popover.Anchor, nil, props.children),
		Content = React.createElement(Popover.Content, {
			side = {
				position = Foundation.Enums.PopoverSide.Bottom,
				offset = standard + v.Padding.Small
			},
			align = Foundation.Enums.PopoverAlign.Start,
			hasArrow = false,
			onPressedOutside = props.onPressedOutside,
			backgroundStyle = v.Color.Surface.Surface_200,
			radius = Radius.Medium
		}, {
			Menu = React.createElement(
				BaseMenu.Root,
				{
					size = InputSize.Medium,
					onNestedLeafActivated = props.onPressedOutside,
					radius = Radius.Medium
				},
				children
			)
		})
	})
end

return React.memo(CardMenuWithVoiceVolume)
