local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local VideoService = game:GetService("VideoService")

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local Button = Foundation.Button
local IconButton = Foundation.IconButton
local Text = Foundation.Text
local View = Foundation.View

local PlayLarge = BuilderIcons.Icon.PlayLarge
local PauseLarge = BuilderIcons.Icon.PauseLarge
local Speaker = BuilderIcons.Icon.Speaker
local SpeakerSlash = BuilderIcons.Icon.SpeakerSlash

local DragHandle = require(MomentsCreationFlow.Components.DragHandle)
local TrimTooltip = require(MomentsCreationFlow.Components.TrimTooltip)

local useCallback = React.useCallback
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens
local useTrimDragController = require(MomentsCreationFlow.Hooks.useTrimDragController)

local CreationFlowContext = require(MomentsCreationFlow.Context.CreationFlowContext)
local getContentFromCapture = require(MomentsCreationFlow.Utils.getContentFromCapture)

local DragHandle2 = require(MomentsCreationFlow.Enums.DragHandle)

local CreationFlowLocalization = require(MomentsCreationFlow.Enums.CreationFlowLocalization)

return function(props)
	local v = useDeviceInsets()
	local v2 = useTokens()
	local v3 = React.useContext(CreationFlowContext)

	local ref = React.useRef(false)
	local ref2 = React.useRef(false)
	local state, setState = React.useState(nil)

	local ref3 = React.useRef(nil)
	local contentFromCapture = getContentFromCapture(props.selectedCapture)

	local state2, setState2 = React.useState({})
	React.useEffect(function()
		task.spawn(function()
			local success, result = pcall(function()
				ref3.current = VideoService:CreateVideoSamplerAsync(contentFromCapture)
			end)

			if not success then
				warn("Failed to create VideoSampler:", result)

				return
			end

			local v4 = {}

			for i = 0, math.floor(props.playbackController.timeline.timeLength) - 1 do
				table.insert(v4, i)
			end

			setState2(ref3.current:GetSamplesAtTimesAsync(v4))
		end)
	end, { props.selectedCapture })

	local v4 = useCallback(function(p)
		ref.current = props.playbackController.playback.isPlaying
		ref2.current = props.playbackController.volume.isMuted
		props.playbackController.volume.mute()
		props.playbackController.playback.pause()
		setState(p)
	end, { props.playbackController.playback.isPlaying, props.playbackController.volume.isMuted })

	local v5 = useTrimDragController(true, useCallback(function()
		if ref.current then
			props.playbackController.playback.play()
		end

		if not ref2.current then
			props.playbackController.volume.unmute()
		end

		ref.current = false
		ref2.current = false
		setState(nil)
	end, {}), v4, useCallback(function(p: number?, p2: number?)
		local v5 = p or props.trimEdit and props.trimEdit.startTime or 0

		local v6 = p2 or props.trimEdit and props.trimEdit.endTime or props.playbackController.timeline.timeLength

		local startTime = math.clamp(v5, 0, props.playbackController.timeline.timeLength)
		local endTime = math.clamp(v6, 0, props.playbackController.timeline.timeLength)

		props.onTrimUpdate({ startTime = startTime, endTime = endTime })

		props.playbackController.timeline.seek(0)
	end, { props.onTrimUpdate, props.trimEdit, props.playbackController.timeline.timeLength }), useCallback(function(p: number)
		props.playbackController.timeline.seek(p * props.playbackController.timeline.duration)
	end, { props.playbackController.timeline.seek, props.playbackController.timeline.duration }), props.trimEdit, props.playbackController.timeline.timeLength)

	local dragContainerRef = v5.dragContainerRef
	local leftHandleRef = v5.leftHandleRef
	local rightHandleRef = v5.rightHandleRef
	local scrubberDisplayRef = v5.scrubberDisplayRef
	local scrubberRef = v5.scrubberRef
	local segmentRef = v5.segmentRef
	local leftHandlePosition = v5.leftHandlePosition
	local rightHandlePosition = v5.rightHandlePosition

	local onActivated = useCallback(function()
		if props.onTrimDiscard then
			props.onTrimDiscard()
		end
	end, { props.onTrimDiscard })

	local onActivated2 = useCallback(function()
		if props.onTrimSave then
			props.onTrimSave()
		end
	end, { props.onTrimSave })

	local onActivated3 = useCallback(function()
		props.playbackController.playback.toggle()
	end, { props.playbackController })

	local onActivated4 = useCallback(function()
		props.playbackController.volume.toggle()
	end, { props.playbackController })

	local v6 = React.useMemo(function()
		local children = {}

		for i = 1, math.floor(props.playbackController.timeline.timeLength) do
			children[i] = React.createElement(View, {
				tag = "size-full-full bg-system-neutral shrink"
			}, {
				content = React.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ImageContent = state2[i] and state2[i].Image,
					ScaleType = Enum.ScaleType.Crop
				})
			})
		end

		return children
	end, { props.playbackController.timeline.timeLength, state2 })

	local createElement = React.createElement
	local v7 = {
		LayoutOrder = props.layoutOrder,
		tag = "align-x-center auto-y align-y-bottom anchor-bottom-center col gap-large position-bottom-center size-full-0"
	}

	local children = {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v2.Padding.Small),
			PaddingBottom = UDim.new(0, (math.max(v.bottom, v2.Padding.Small))),
			PaddingLeft = UDim.new(0, (math.max(v.left, v2.Padding.XLarge))),
			PaddingRight = UDim.new(0, (math.max(v.right, v2.Padding.XLarge)))
		}),
		Nav = React.createElement(
			View,
			{
				LayoutOrder = 1,
				tag = "align-x-center align-y-center auto-y gap-small row size-full-0 flex-x-between"
			},
			{
				BackButton = React.createElement(Button, {
					fillBehavior = Foundation.Enums.FillBehavior.Fit,
					LayoutOrder = 1,
					text = v3.getLocalization(CreationFlowLocalization.GeneralCtaBack),
					variant = Foundation.Enums.ButtonVariant.Text,
					onActivated = onActivated,
					size = Foundation.Enums.InputSize.Medium
				}),
				DoneButton = React.createElement(Button, {
					fillBehavior = Foundation.Enums.FillBehavior.Fit,
					LayoutOrder = 2,
					text = v3.getLocalization(CreationFlowLocalization.GeneralCtaDone),
					variant = Foundation.Enums.ButtonVariant.Text,
					onActivated = onActivated2,
					size = Foundation.Enums.InputSize.Medium
				})
			}
		),
		Trimmer = 0,
		VideoControls = 0
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement

	local createElement4 = React.createElement

	local children2 = {
		TrimTooltip = React.createElement(TrimTooltip, {
			activeHandle = state,
			leftHandlePosition = leftHandlePosition,
			rightHandlePosition = rightHandlePosition,
			timeLength = props.playbackController.timeline.timeLength
		}),
		LeftHandle = React.createElement(DragHandle, {
			anchorPoint = Vector2.new(1, 0.5),
			position = leftHandlePosition:map(function(p)
				return UDim2.fromScale(p, 0.5)
			end),
			dragDetectorRef = leftHandleRef
		}),
		RightHandle = React.createElement(DragHandle, {
			anchorPoint = Vector2.new(0, 0.5),
			isFlipped = true,
			position = rightHandlePosition:map(function(p)
				return UDim2.fromScale(p, 0.5)
			end),
			dragDetectorRef = rightHandleRef
		}),
		Outline = 0,
		ShadowBlockLeft = 0,
		ShadowBlockRight = 0
	}

	local createElement5 = React.createElement
	local v8 = {
		Position = leftHandlePosition:map(function(p)
			return UDim2.fromScale(p, 0.5)
		end),
		Size = React.joinBindings({
			leftHandlePosition = leftHandlePosition,
			rightHandlePosition = rightHandlePosition
		}):map(function(p)
			local leftHandlePosition2 = p.leftHandlePosition
			local rightHandlePosition2 = p.rightHandlePosition
			return UDim2.fromScale(rightHandlePosition2 - leftHandlePosition2, 1)
		end),
		tag = "anchor-center-left",
		ZIndex = 2
	}

	local v9 = {
		OutlineStroke = React.createElement("UIStroke", {
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = v2.Color.System.Contrast.Color3,
			Transparency = v2.Color.System.Contrast.Transparency,
			Thickness = v2.Stroke.Thicker
		}),
		Scrubber = 0,
		DragDetector = 0
	}
	local scrubber

	if not (state and state ~= DragHandle2.Scrubber) then
		scrubber = React.createElement(View, {
			ref = scrubberDisplayRef,
			tag = "anchor-center-center bg-system-contrast size-100-1400 radius-circle",
			Position = UDim2.fromScale(
				props.playbackController.timeline.elapsed / props.playbackController.timeline.duration,
				0.5
			)
		}, {
			DragDetector = React.createElement("UIDragDetector", {
				DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
				ref = scrubberRef,
				ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale
			})
		})
	end

	v9.Scrubber = scrubber

	v9.DragDetector = React.createElement("UIDragDetector", {
		DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
		ref = segmentRef,
		ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale
	})
	children2.Outline = createElement5(View, v8, v9)

	children2.ShadowBlockLeft = React.createElement(View, {
		backgroundStyle = v2.Color.Extended.Black.Black_50,
		Size = leftHandlePosition:map(function(p)
			return UDim2.fromScale(p, 1)
		end),
		tag = "anchor-center-left position-center-left",
		ZIndex = 0
	})

	children2.ShadowBlockRight = React.createElement(View, {
		backgroundStyle = v2.Color.Extended.Black.Black_50,
		Size = rightHandlePosition:map(function(p)
			return UDim2.fromScale(1 - p, 1)
		end),
		tag = "anchor-center-right position-center-right",
		ZIndex = 0
	})
	children.Trimmer = createElement2(View, {
		LayoutOrder = 2,
		tag = "padding-x-small size-full-1000",
		ZIndex = 2
	}, {
		PaddedContainer = createElement3(
			View,
			{ ref = dragContainerRef, tag = "padding-x-medium size-full-full", ZIndex = 2 },
			{
				TrimmerBar = createElement4(View, { tag = "size-full" }, children2)
			}
		),
		Timeline = React.createElement(View, {
			tag = "bg-surface-100 radius-medium size-full-full",
			ZIndex = 1
		}, {
			OutlineStroke = React.createElement("UIStroke", {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = v2.Color.Surface.Surface_100.Color3,
				Transparency = v2.Color.Surface.Surface_100.Transparency,
				Thickness = v2.Stroke.Thicker
			}),
			TimelineBar = React.createElement(View, {
				layout = { Padding = UDim.new(0, v2.Size.Size_50) },
				tag = "padding-x-medium size-full-full row"
			}, v6)
		})
	})

	children.VideoControls = React.createElement(
		View,
		{
			LayoutOrder = 3,
			tag = "align-x-center align-y-center auto-y gap-small row size-full-0 flex-x-between"
		},
		{
			PlaybackToggle = React.createElement(IconButton, {
				LayoutOrder = 1,
				icon = props.playbackController.playback.isPlaying and PauseLarge or PlayLarge,
				onActivated = onActivated3,
				size = Foundation.Enums.InputSize.Medium
			}),
			DurationDisplay = React.createElement(Text, {
				LayoutOrder = 2,
				tag = "auto-xy text-label-medium content-default",
				Text = `{string.format("%.1f", (math.max(0, props.playbackController.timeline.elapsed)))} / {string.format("%.1f", props.playbackController.timeline.duration)}`
			}),
			MuteToggle = React.createElement(IconButton, {
				LayoutOrder = 3,
				icon = props.playbackController.volume.isMuted and SpeakerSlash or Speaker,
				onActivated = onActivated4,
				size = Foundation.Enums.InputSize.Medium
			})
		}
	)
	return createElement(View, v7, children)
end
