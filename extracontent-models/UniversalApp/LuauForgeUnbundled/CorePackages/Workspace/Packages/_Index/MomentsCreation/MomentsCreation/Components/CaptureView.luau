local RunService = game:GetService("RunService")

local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")

local icon = Foundation.Icon
local view = Foundation.View

local useTokens = Foundation.Hooks.useTokens

local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local getCropSize = MomentsCommon.Utils.getCropSize
local getFitSize = MomentsCommon.Utils.getFitSize

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants")
local getCaptureContent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Capture/getCaptureContent")
local getCaptureVideoContent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Capture/getCaptureVideoContent")
local useCreationMusicSync = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useCreationMusicSync")
local GetFFlagMomentsTTSAudioOverlay = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsTTSAudioOverlay")
local getTtsDuckScalar = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Audio/getTtsDuckScalar")
local fadeVolume = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Audio/fadeVolume")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local function VideoPreviewSurface(props)
	local preview = props.preview
	local capture = props.capture
	local timeLength = props.timeLength
	local ref = React.useRef(nil)

	local state, setState = React.useState(Vector2.new(0, 0))
	local state2, setState2 = React.useState(Vector2.new(0, 0))

	local state3, setState3 = React.useState(preview.playback.getRegion(false))
	React.useEffect(function()
		return Signals.createEffect(function(p2)
			setState3(preview.playback.getRegion(p2))
		end)
	end, { preview })

	local v5 = if state3 == nil then timeLength else math.max(0, state3.endTime - state3.startTime)

	local v6 = useCreationMusicSync(preview, v5, props.ttsAudio)
	local audio = v6.audio
	local music = v6.music
	local userMuted = v6.userMuted
	local isDucking = v6.isDucking

	local ref2 = React.useRef(nil)
	React.useEffect(function()
		function ref2.current()
			if music ~= nil then
				audio.timeline.seek(0)
			end
		end
	end, { audio.timeline.seek, music })

	React.useEffect(function()
		local current = ref.current

		if current == nil then
			return
		end

		if not GetFFlagMomentsTTSAudioOverlay then
			current.Volume = music == nil and not userMuted and 1 or 0
		elseif music == nil and not userMuted then
			fadeVolume(current, not isDucking and 1 or 1 * getTtsDuckScalar())
		else
			fadeVolume(current, 0, true)
		end
	end, { music, userMuted, isDucking })

	React.useEffect(function()
		local current = ref.current

		if current == nil then
			return
		end

		if typeof(capture) == "table" then
			local v7 = getCaptureVideoContent(capture)

			if v7 ~= nil then
				current.Video = v7.Uri
			end
		else
			local success, result = pcall(Content.fromObject, capture)

			if success and result then
				current.VideoContent = result
			end
		end

		current.Looped = true

		preview.setDuration(timeLength)
		preview.setTimeLength(timeLength)
		preview.setReadiness("Ready")

		local flag = false

		preview.bindEngine({
			play = function()
				current.Playing = true
			end,
			pause = function()
				current.Playing = false
			end,
			seek = function(timePosition)
				current.TimePosition = timePosition
			end
		})

		local v7 = {
			current.Loaded:Connect(function()
				flag = true

				if current.TimeLength > 0 then
					preview.setDuration(current.TimeLength)
					preview.setTimeLength(current.TimeLength)
				end

				current.Playing = true
				preview.setIsPlaying(true)
			end),
			current.Played:Connect(function()
				flag = true
				preview.setIsPlaying(true)
			end),
			current.Paused:Connect(function()
				if flag then
					preview.setIsPlaying(false)
				end
			end),
			RunService.RenderStepped:Connect(function()
				preview.setPosition(current.TimePosition)

				local region = preview.playback.getRegion(false)

				if region == nil then
					return
				end

				local timePosition = current.TimePosition

				if region.endTime - 0.05 <= timePosition or timePosition < region.startTime - 0.05 then
					current.TimePosition = region.startTime

					if ref2.current ~= nil then
						ref2.current()
					end
				end
			end)
		}

		return function()
			for k, connection in v7 do
				connection:Disconnect()
			end

			preview.bindEngine(nil)
		end
	end, { preview, capture, timeLength })

	local createElement = React.createElement

	local createElement2 = React.createElement
	local v10 = {
		["AnchorPoint"] = nil,
		["AnchorPoint"] = nil,
		["AnchorPoint"] = nil,
		["AnchorPoint"] = nil,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		InternalVideoUsage = Enum.InternalVideoUsage.WatchPage,
		Looped = true,
		Position = UDim2.fromScale(0.5, 0.5)
	}
	local v11 = if props.scaleType == Enum.ScaleType.Fit then getFitSize(state, state2) else getCropSize(state, state2)
	v10.Size = v11

	v10.Visible = state2.X > 0 and state2.Y > 0
	v10.ref = ref
	v10[React.Change.Resolution] = function(p2)
		setState2(p2.Resolution)

		if props.onResolutionChanged ~= nil then
			props.onResolutionChanged(p2.Resolution)
		end
	end

	return createElement(view, {
		tag = "size-full",
		ClipsDescendants = true,
		onAbsoluteSizeChanged = function(p2)
			setState(p2.AbsoluteSize)
		end
	}, {
		Media = createElement2("VideoFrame", v10),
		Overlay = React.createElement(view, { tag = "size-full", ZIndex = 2 }, props.children)
	})
end

local function ScreenshotPreviewSurface(props)
	local preview = props.preview
	local capture = props.capture

	local v5 = useCreationMusicSync(preview, Constants.ScreenshotMusicDuration, props.ttsAudio)
	local music = v5.music

	local elapsed = v5.audio.timeline.elapsed

	React.useEffect(function()
		preview.bindEngine(nil)
		preview.setDuration(Constants.ScreenshotMusicDuration)
		preview.setTimeLength(Constants.ScreenshotMusicDuration)
		preview.setPosition(0)
		preview.setReadiness("Ready")
	end, { preview, capture })

	React.useEffect(function()
		preview.setPosition(music == nil and 0 or math.clamp(elapsed, 0, Constants.ScreenshotMusicDuration))
	end, { preview, music, elapsed })

	return React.createElement(
		view,
		{ tag = "size-full", onAbsoluteSizeChanged = props.onAbsoluteSizeChanged },
		{
			Overlay = React.createElement(React.Fragment, {}, props.children),
			Media = React.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				ImageContent = getCaptureContent(props.capture),
				ScaleType = props.scaleType,
				Size = UDim2.fromScale(1, 1)
			})
		}
	)
end

return function(props)
	local v5 = useTokens()

	local state, setState = React.useState(props.preview.getCapture(false))
	React.useEffect(function()
		local preview = props.preview

		local thread = nil
		local v6 = nil
		local v7 = false
		local function onWindowElapsed()
			if not v7 then
				thread = nil

				return
			end

			v7 = false
			local v8 = v6
			v6 = nil
			setState(v8)
			thread = task.delay(0.2, onWindowElapsed)
		end

		local effect = Signals.createEffect(function(p2)
			local capture = preview.getCapture(p2)

			if thread == nil then
				setState(capture)
				thread = task.delay(0.2, onWindowElapsed)
			else
				v6 = capture
				v7 = true
			end
		end)

		return function()
			if thread ~= nil then
				task.cancel(thread)
				thread = nil
			end

			effect()
		end
	end, { props.preview })

	if state == nil then
		return React.createElement(
			view,
			{
				tag = "size-full radius-large bg-shift-200",
				onAbsoluteSizeChanged = props.onAbsoluteSizeChanged
			},
			{
				EmptyState = React.createElement(icon, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					name = BuilderIcons.Icon.Image,
					Position = UDim2.fromScale(0.5, 0.5),
					size = v5.Size.Size_1200,
					style = v5.Color.Shift.Shift_400
				})
			}
		)
	end

	if state.CaptureType == Enum.CaptureType.Video then
		return React.createElement(
			view,
			{ tag = "size-full", onAbsoluteSizeChanged = props.onAbsoluteSizeChanged },
			{
				Preview = React.createElement(VideoPreviewSurface, {
					preview = props.preview,
					capture = state,
					scaleType = props.scaleType,
					timeLength = state.TimeLength or 0,
					onResolutionChanged = props.onResolutionChanged,
					ttsAudio = props.ttsAudio
				}, props.children)
			}
		)
	end

	return React.createElement(ScreenshotPreviewSurface, {
		preview = props.preview,
		capture = state,
		scaleType = props.scaleType,
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
		ttsAudio = props.ttsAudio
	}, props.children)
end
