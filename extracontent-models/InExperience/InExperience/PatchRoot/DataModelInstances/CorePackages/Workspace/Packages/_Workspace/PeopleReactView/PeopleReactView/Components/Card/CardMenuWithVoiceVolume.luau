local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local React = require(PeopleReactViewParent.React)
local Foundation = require(PeopleReactViewParent.Foundation)
local useLocalization = require(PeopleReactViewParent.Localization).Hooks.useLocalization
local PeopleService = require(PeopleReactViewParent.PeopleService)
local InputSize = Foundation.Enums.InputSize
local Popover = Foundation.Popover
local EnumsRadius = Foundation.Enums.Radius
local FoundationText = Foundation.Text
local View = Foundation.View
local BaseMenu = Foundation.UNSTABLE.BaseMenu
local useTokens = Foundation.Hooks.useTokens
local Flags = Foundation.Utility.Flags
local FFlagVoiceChatVolumePerUserMuteVolumeSync = require(PeopleReactView.Flags.FFlagVoiceChatVolumePerUserMuteVolumeSync)
local FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted = require(PeopleReactView.Flags.FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted)
local FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry = PeopleService.getService("Flags").FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry
local ENTRY_POINT = PeopleService.getService("Constants").ANALYTICS.ENTRY_POINT
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local EngineFeature = game:GetEngineFeature("RbxAnalyticsServiceExposePlaySessionId")

local function VoiceVolumeSlider(t1: {[any]: any}) -- line: 75
	-- upvalues: useLocalization (copy), FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry (copy), React (copy), PeopleService (copy), FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted (copy), ENTRY_POINT (copy), EngineFeature (copy), RbxAnalyticsService (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), View (copy), FoundationText (copy), Foundation (copy)
	local v24 = useLocalization({
		volumeLabel = "CoreScripts.InGameMenu.GameSettings.Volume"
	})
	local u25 = nil
	local u26 = nil

	if FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		u25 = React.useMemo(function() -- line: 83
			-- upvalues: PeopleService (copy)
			return PeopleService.getService("PeopleAnalyticsManager")
		end, {})
		u26 = React.useRef(nil)
	end

	local v27 = FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted and t1.isMutedByLocalUser == true
	local v28 = React.useRef(false)
	local v29, v30 = React.useBinding(t1.getPlayerVoiceVolume(t1.userId))

	React.useEffect(function() -- line: 95
		-- upvalues: t1 (copy), v28 (copy), v30 (copy)
		return t1.subscribePlayerVoiceVolume(t1.userId, function(p1) -- line: 96
			-- upvalues: v28 (copy), v30 (copy)
			if not v28.current then
				v30(p1)
			end
		end)
	end, {
		t1.userId,
		t1.subscribePlayerVoiceVolume
	})

	local v31 = React.useCallback(function(n1: number) -- line: 103
		-- upvalues: v30 (copy), t1 (copy)
		v30(n1)
		t1.setPlayerVoiceVolume(t1.userId, n1)
	end, {
		t1.userId,
		t1.setPlayerVoiceVolume
	})
	local v32 = React.useCallback(function() -- line: 109
		-- upvalues: v28 (copy), FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry (copy), u25 (ref), u26 (ref), t1 (copy), ENTRY_POINT (copy)
		v28.current = true

		if FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry and (u25 and u26) then
			local v45 = if not t1.getPlayerIsLocalMuted then t1.isMutedByLocalUser == true else t1.getPlayerIsLocalMuted(t1.userId)

			u26.current = {
				oldVolume = t1.getPlayerVoiceVolume(t1.userId),
				wasMutedAtStart = v45,
				startTimestampMs = DateTime.now().UnixTimestampMillis
			}
			u25:trackPerUserVoiceVolumeSliderTouch(ENTRY_POINT.PEOPLE_CARD)
		end
	end, {
		if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then nil else t1.userId,
		if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then nil else t1.getPlayerVoiceVolume,
		if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then nil else t1.getPlayerIsLocalMuted,
		if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then nil else t1.isMutedByLocalUser,
		if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then nil else u25,
		if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then nil else u26
	})
	local v33 = React.useCallback(function() -- line: 140
		-- upvalues: v28 (copy), FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry (copy), u25 (ref), u26 (ref), t1 (copy), EngineFeature (copy), RbxAnalyticsService (copy), ENTRY_POINT (copy), FFlagVoiceChatVolumePerUserMuteVolumeSync (copy), v30 (copy)
		v28.current = false

		if FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry and (u25 and u26) then
			local current = u26.current

			u26.current = nil

			if current then
				local v47 = t1.getPlayerVoiceVolume(t1.userId)
				local v48 = if not EngineFeature then nil else RbxAnalyticsService:GetPlaySessionId()

				u25:trackPerUserVoiceVolumeChanged({
					entryPoint = ENTRY_POINT.PEOPLE_CARD,
					targetUserId = t1.userId,
					oldVolume = current.oldVolume,
					newVolume = v47,
					wasMutedAtStart = current.wasMutedAtStart,
					playSessionId = v48,
					voiceSessionId = if not t1.getVoiceSessionId then nil else t1.getVoiceSessionId(),
					dragDurationMs = math.max(0, DateTime.now().UnixTimestampMillis - current.startTimestampMs)
				})
			end
		end

		if FFlagVoiceChatVolumePerUserMuteVolumeSync then
			return
		end

		v30(t1.getPlayerVoiceVolume(t1.userId))
	end, {
		t1.userId,
		t1.getPlayerVoiceVolume,
		if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then nil else t1.getVoiceSessionId,
		if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then nil else u25,
		if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then nil else u26
	})

	return React.createElement(View, {
		tag = "col gap-small size-full-0 auto-y padding-x-medium padding-y-small",
		LayoutOrder = t1.layoutOrder
	}, {
		Title = React.createElement(FoundationText, {
			Text = v24.volumeLabel,
			tag = {
				["auto-xy text-body-medium content-muted"] = v27,
				["auto-xy text-body-medium content-emphasis"] = not v27
			}
		}),
		VolumeSlider = React.createElement(Foundation.Slider, {
			isContained = true,
			step = 0.1,
			key = if not FFlagVoiceChatVolumePerUserDisableInteractionWhenMuted then nil else not v27 and "enabled" or "disabled",
			value = v29,
			range = NumberRange.new(t1.voiceVolumeMin, t1.voiceVolumeMax),
			knobVisibility = Foundation.Enums.Visibility.Always,
			width = UDim.new(1, 0),
			isDisabled = v27,
			onValueChanged = v31,
			onDragStarted = v32,
			onDragEnded = v33
		})
	})
end
local function CardMenuWithVoiceVolume(t2: {[any]: any}) -- line: 211
	-- upvalues: useTokens (copy), Flags (copy), React (copy), BaseMenu (copy), View (copy), FoundationText (copy), VoiceVolumeSlider (copy), FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry (copy), Popover (copy), Foundation (copy), EnumsRadius (copy), InputSize (copy)
	local v35 = useTokens()
	local Standard = v35.Stroke.Standard
	local v37 = if not Flags.FoundationBaseMenuBeta then {
		left = UDim.new(0, v35.Padding.Medium),
		right = UDim.new(0, v35.Padding.Medium),
		top = UDim.new(0, v35.Padding.XSmall),
		bottom = UDim.new(0, v35.Padding.XSmall)
	} else {
		left = UDim.new(0, v35.Size.Size_250),
		right = UDim.new(0, v35.Size.Size_250),
		top = UDim.new(0, v35.Padding.XSmall),
		bottom = UDim.new(0, v35.Padding.XSmall)
	}
	local t3 = {}

	for v39, v40 in t2.menuGroups do
		local t4 = {}

		for v42, v43 in v40.items do
			t4[tostring(v43.id)] = React.createElement(BaseMenu.Item, {
				LayoutOrder = v42,
				id = v43.id,
				text = v43.text,
				icon = v43.icon,
				onActivated = v43.onActivated
			})
		end

		if v40.title ~= nil then
			t4.SectionTitle = React.createElement(View, {
				LayoutOrder = 0,
				tag = "row align-y-center size-full-0 auto-y",
				padding = v37
			}, {
				Label = React.createElement(FoundationText, {
					tag = "fill auto-xy text-align-x-left text-truncate-end text-caption-small content-muted",
					Text = v40.title
				})
			})
		end

		if v40.showVolumeSlider then
			t4.VoiceVolumeSlider = React.createElement(VoiceVolumeSlider, {
				userId = t2.userId,
				voiceVolumeMin = t2.voiceVolumeMin,
				voiceVolumeMax = t2.voiceVolumeMax,
				getPlayerVoiceVolume = t2.getPlayerVoiceVolume,
				subscribePlayerVoiceVolume = t2.subscribePlayerVoiceVolume,
				setPlayerVoiceVolume = t2.setPlayerVoiceVolume,
				isMutedByLocalUser = t2.isMutedByLocalUser,
				getPlayerIsLocalMuted = if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then nil else t2.getPlayerIsLocalMuted,
				getVoiceSessionId = if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then nil else t2.getVoiceSessionId,
				layoutOrder = #v40.items + 1
			})
		end

		t3[`Group_{ v39 }`] = React.createElement(BaseMenu.Group, {
			LayoutOrder = v39
		}, t4)
	end

	return React.createElement(Popover.Root, {
		testId = "--foundation-menu",
		isOpen = t2.isOpen
	}, {
		Anchor = React.createElement(Popover.Anchor, nil, t2.children),
		Content = React.createElement(Popover.Content, {
			hasArrow = false,
			side = {
				position = Foundation.Enums.PopoverSide.Bottom,
				offset = Standard + v35.Padding.Small
			},
			align = Foundation.Enums.PopoverAlign.Start,
			onPressedOutside = t2.onPressedOutside,
			backgroundStyle = if not Flags.FoundationBaseMenuBeta then v35.Color.Surface.Surface_100 else v35.Color.Surface.Surface_200,
			radius = EnumsRadius.Medium
		}, {
			Menu = React.createElement(BaseMenu.Root, {
				size = InputSize.Medium,
				onNestedLeafActivated = t2.onPressedOutside,
				radius = EnumsRadius.Medium
			}, t3)
		})
	})
end

return React.memo(CardMenuWithVoiceVolume)
