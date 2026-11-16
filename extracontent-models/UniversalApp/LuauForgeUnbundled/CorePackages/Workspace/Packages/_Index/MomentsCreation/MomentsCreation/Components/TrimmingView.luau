local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SignalsReact")

local button = Foundation.Button
local iconButton = Foundation.IconButton
local text = Foundation.Text
local view = Foundation.View

local playLarge = BuilderIcons.Icon.PlayLarge
local pauseLarge = BuilderIcons.Icon.PauseLarge
local speaker = BuilderIcons.Icon.Speaker
local speakerSlash = BuilderIcons.Icon.SpeakerSlash

local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useRef = React.useRef
local useState = React.useState
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState
local useSignalBinding = SignalsReact.useSignalBinding

local DragHandle = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/DragHandle")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/TrimTooltip")
local useTrimDragController = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useTrimDragController")
local getCaptureVideoContent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Capture/getCaptureVideoContent")
local sampleVideoFrames = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Capture/sampleVideoFrames")

local module12 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/DragHandle")
local useCreationFlowStrings = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useCreationFlowStrings")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

return function(p2)
	local controller = p2.controller
	local playback = controller.preview.playback

	local v5 = useDeviceInsets()
	local v6 = useTokens()
	local v7 = useCreationFlowStrings()

	local v8 = useSignalState(controller.getSelectedCapture)
	local v9 = useSignalState(playback.getTimeLength)
	local v10 = useSignalState(playback.getIsPlaying)
	local v11 = useSignalState(playback.getIsMuted)

	local v13 = useSignalState((useMemo(function()
		return Signals.createComputed(function(p3)
			local activeSession = controller.getActiveSession(p3)

			if activeSession == nil then
				return nil
			end

			return (activeSession.getDraft(p3))
		end)
	end, { controller })))

	local v14 = useRef(false)
	local v15 = useRef(false)
	local state, setState = useState(nil)

	local state2, setState2 = useState({})
	useEffect(function()
		if v8 == nil or v9 <= 0 then
			return
		end

		local v16 = getCaptureVideoContent(v8)

		if v16 == nil and typeof(v8) ~= "table" then
			local success, result = pcall(Content.fromObject, v8)

			if success then
				v16 = result
			end
		end

		if v16 ~= nil then
			sampleVideoFrames(v16, v9, setState2)
		end
	end, { v8, v9 })

	local v16 = useCallback(function(p3)
		v14.current = playback.getIsPlaying(false)
		v15.current = playback.getIsMuted(false)
		playback.setMuted(true)
		playback.pause()
		setState(p3)
	end, { playback })

	local v20 = useTrimDragController(true, useCallback(function()
		if v14.current then
			playback.play()
		end

		if not v15.current then
			playback.setMuted(false)
		end

		v14.current = false
		v15.current = false
		setState(nil)
	end, { playback }), v16, useCallback(function(p3, value)
		local activeSession = controller.getActiveSession(false)

		if activeSession == nil then
			return
		end

		local draft = activeSession.getDraft(false)
		local timeLength = playback.getTimeLength(false)
		local v19 = p3 or draft and draft.startTime or 0

		if not value then
			value = if draft then draft.endTime or timeLength else timeLength
		end

		activeSession.update({
			startTime = math.clamp(v19, 0, timeLength),
			endTime = math.clamp(value, 0, timeLength)
		})

		playback.seek(0)
	end, { controller, playback }), useCallback(function(p3)
		playback.seek(p3 * playback.getDuration(false))
	end, { playback }), v13, v9)

	local dragContainerRef = v20.dragContainerRef
	local leftHandleRef = v20.leftHandleRef
	local rightHandleRef = v20.rightHandleRef
	local scrubberDisplayRef = v20.scrubberDisplayRef
	local scrubberRef = v20.scrubberRef
	local segmentRef = v20.segmentRef
	local leftHandlePosition = v20.leftHandlePosition
	local rightHandlePosition = v20.rightHandlePosition

	local v21 = useCallback(function()
		controller.discardActiveTool()
	end, { controller })

	local v22 = useCallback(function()
		controller.commitActiveTool()
	end, { controller })

	local v23 = useCallback(function()
		playback.toggle()
	end, { playback })

	local v24 = useCallback(function()
		playback.toggleMute()
	end, { playback })

	local v26 = useSignalBinding((useMemo(function()
		return Signals.createComputed(function(p3)
			local duration = playback.getDuration(p3)

			if duration <= 0 then
				return 0
			end

			return (math.clamp(playback.getPosition(p3) / duration, 0, 1))
		end)
	end, { playback })))

	local v28 = useSignalBinding((useMemo(function()
		return Signals.createComputed(function(p3)
			return `{string.format("%.1f", (math.max(0, playback.getPosition(p3))))} / {string.format("%.1f", playback.getDuration(p3))}`
		end)
	end, { playback })))

	local v29 = useMemo(function()
		local children = {}

		for i = 1, math.floor(v9) do
			local v30 = state2[i]
			children["frame_" .. i] = React.createElement(
				view,
				{ tag = "shrink size-full-full bg-system-neutral" },
				{
					content = React.createElement("ImageLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 1),
						ImageContent = v30 and v30.Image,
						ScaleType = Enum.ScaleType.Crop
					})
				}
			)
		end

		return children
	end, { v9, state2 })

	return React.createElement(view, {
		LayoutOrder = p2.layoutOrder,
		tag = "col align-x-center align-y-bottom gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y",
		padding = {
			top = UDim.new(0, v6.Padding.Small),
			bottom = UDim.new(0, (math.max(v5.bottom, v6.Padding.Small))),
			left = UDim.new(0, (math.max(v5.left, v6.Padding.XLarge))),
			right = UDim.new(0, (math.max(v5.right, v6.Padding.XLarge)))
		}
	}, {
		Nav = React.createElement(
			view,
			{
				LayoutOrder = 1,
				tag = "row flex-x-between align-x-center align-y-center gap-small size-full-0 auto-y"
			},
			{
				BackButton = React.createElement(button, {
					fillBehavior = Foundation.Enums.FillBehavior.Fit,
					LayoutOrder = 1,
					text = v7.GeneralCtaBack,
					variant = Foundation.Enums.ButtonVariant.Text,
					onActivated = v21,
					size = Foundation.Enums.InputSize.Medium
				}),
				DoneButton = React.createElement(button, {
					fillBehavior = Foundation.Enums.FillBehavior.Fit,
					LayoutOrder = 2,
					text = v7.GeneralCtaDone,
					variant = Foundation.Enums.ButtonVariant.Text,
					onActivated = v22,
					size = Foundation.Enums.InputSize.Medium
				})
			}
		),
		Trimmer = React.createElement(
			view,
			{ LayoutOrder = 2, tag = "size-full-1000 padding-x-small", ZIndex = 2 },
			{
				PaddedContainer = React.createElement(
					view,
					{
						ref = dragContainerRef,
						tag = "size-full-full padding-x-medium",
						ZIndex = 2
					},
					{
						TrimmerBar = React.createElement(view, { tag = "size-full" }, {
							TrimTooltip = React.createElement(module8, {
								activeHandle = state,
								leftHandlePosition = leftHandlePosition,
								rightHandlePosition = rightHandlePosition,
								timeLength = v9
							}),
							LeftHandle = React.createElement(DragHandle, {
								anchorPoint = Vector2.new(1, 0.5),
								position = leftHandlePosition:map(function(p3)
									return UDim2.fromScale(p3, 0.5)
								end),
								dragDetectorRef = leftHandleRef
							}),
							RightHandle = React.createElement(DragHandle, {
								anchorPoint = Vector2.new(0, 0.5),
								isFlipped = true,
								position = rightHandlePosition:map(function(p3)
									return UDim2.fromScale(p3, 0.5)
								end),
								dragDetectorRef = rightHandleRef
							}),
							Outline = React.createElement(view, {
								Position = leftHandlePosition:map(function(p3)
									return UDim2.fromScale(p3, 0.5)
								end),
								Size = React.joinBindings({
									leftHandlePosition = leftHandlePosition,
									rightHandlePosition = rightHandlePosition
								}):map(function(p3)
									return UDim2.fromScale(
										p3.rightHandlePosition - p3.leftHandlePosition,
										1
									)
								end),
								tag = "anchor-center-left",
								ZIndex = 2,
								stroke = {
									Color = v6.Color.System.Contrast.Color3,
									Transparency = v6.Color.System.Contrast.Transparency,
									Thickness = v6.Stroke.Thicker
								}
							}, {
								Scrubber = React.createElement(view, {
									ref = scrubberDisplayRef,
									Visible = not state or state == module12.Scrubber,
									tag = "anchor-center-center size-100-1400 radius-circle bg-system-contrast",
									Position = v26:map(function(p3)
										return UDim2.fromScale(p3, 0.5)
									end)
								}, {
									DragDetector = React.createElement("UIDragDetector", {
										DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
										ref = scrubberRef,
										ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale
									})
								}),
								DragDetector = React.createElement("UIDragDetector", {
									DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
									ref = segmentRef,
									ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale
								})
							}),
							ShadowBlockLeft = React.createElement(view, {
								backgroundStyle = v6.Color.Extended.Black.Black_50,
								Size = leftHandlePosition:map(function(p3)
									return UDim2.fromScale(p3, 1)
								end),
								tag = "position-center-left anchor-center-left",
								ZIndex = 0
							}),
							ShadowBlockRight = React.createElement(view, {
								backgroundStyle = v6.Color.Extended.Black.Black_50,
								Size = rightHandlePosition:map(function(p3)
									return UDim2.fromScale(1 - p3, 1)
								end),
								tag = "position-center-right anchor-center-right",
								ZIndex = 0
							})
						})
					}
				),
				Timeline = React.createElement(view, {
					tag = "size-full-full radius-medium bg-surface-100",
					ZIndex = 1,
					stroke = {
						Color = v6.Color.Surface.Surface_100.Color3,
						Transparency = v6.Color.Surface.Surface_100.Transparency,
						Thickness = v6.Stroke.Thicker
					}
				}, {
					TimelineBar = React.createElement(view, {
						layout = {
							FillDirection = Enum.FillDirection.Horizontal,
							Padding = UDim.new(0, v6.Size.Size_50),
							SortOrder = Enum.SortOrder.LayoutOrder
						},
						tag = "size-full-full padding-x-medium"
					}, v29)
				})
			}
		),
		VideoControls = React.createElement(
			view,
			{
				LayoutOrder = 3,
				tag = "row flex-x-between align-x-center align-y-center gap-small size-full-0 auto-y"
			},
			{
				PlaybackToggle = React.createElement(iconButton, {
					LayoutOrder = 1,
					icon = if v10 then pauseLarge else playLarge,
					onActivated = v23,
					size = Foundation.Enums.InputSize.Medium
				}),
				DurationDisplay = React.createElement(text, {
					LayoutOrder = 2,
					tag = "auto-xy text-label-medium content-default",
					Text = v28
				}),
				MuteToggle = React.createElement(iconButton, {
					LayoutOrder = 3,
					icon = if v11 then speakerSlash else speaker,
					onActivated = v24,
					size = Foundation.Enums.InputSize.Medium
				})
			}
		)
	})
end
