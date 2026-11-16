local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local Button = Foundation.Button
local IconButton = Foundation.IconButton
local Text = Foundation.Text
local View = Foundation.View

local PlayLarge = BuilderIcons.Icon.PlayLarge
local PauseLarge = BuilderIcons.Icon.PauseLarge
local Speaker = BuilderIcons.Icon.Speaker
local SpeakerSlash = BuilderIcons.Icon.SpeakerSlash

local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useRef = React.useRef
local useState = React.useState
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState
local useSignalBinding = SignalsReact.useSignalBinding

local DragHandle = require(MomentsCreation.Components.DragHandle)
local TrimTooltip = require(MomentsCreation.Components.TrimTooltip)
local useTrimDragController = require(MomentsCreation.Hooks.useTrimDragController)
local getCaptureVideoContent = require(MomentsCreation.Capture.getCaptureVideoContent)
local sampleVideoFrames = require(MomentsCreation.Capture.sampleVideoFrames)

local DragHandle2 = require(MomentsCreation.Enums.DragHandle)
local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)
require(MomentsCreation.Types.CreationFlowTypes)

return function(p)
	local controller = p.controller
	local playback = controller.preview.playback

	local v = useDeviceInsets()
	local v2 = useTokens()
	local v3 = useCreationFlowStrings()

	local v4 = useSignalState(controller.getSelectedCapture)
	local timeLength2 = useSignalState(playback.getTimeLength)
	local v5 = useSignalState(playback.getIsPlaying)
	local v6 = useSignalState(playback.getIsMuted)

	local v7 = useSignalState((useMemo(function()
		return Signals.createComputed(function(p2)
			local activeSession = controller.getActiveSession(p2)

			if activeSession == nil then
				return nil
			end

			return (activeSession.getDraft(p2))
		end)
	end, { controller })))

	local v8 = useRef(false)
	local v9 = useRef(false)
	local state, setState = useState(nil)

	local state2, setState2 = useState({})
	useEffect(function()
		if v4 == nil or timeLength2 <= 0 then
			return
		end

		local v10 = getCaptureVideoContent(v4)

		if v10 == nil and typeof(v4) ~= "table" then
			local success, result = pcall(Content.fromObject, v4)

			if success then
				v10 = result
			end
		end

		if v10 ~= nil then
			sampleVideoFrames(v10, timeLength2, setState2)
		end
	end, { v4, timeLength2 })

	local v10 = useCallback(function(p2)
		v8.current = playback.getIsPlaying(false)
		v9.current = playback.getIsMuted(false)
		playback.setMuted(true)
		playback.pause()
		setState(p2)
	end, { playback })

	local v11 = useTrimDragController(true, useCallback(function()
		if v8.current then
			playback.play()
		end

		if not v9.current then
			playback.setMuted(false)
		end

		v8.current = false
		v9.current = false
		setState(nil)
	end, { playback }), v10, useCallback(function(p2: number?, value: number?)
		local activeSession = controller.getActiveSession(false)

		if activeSession == nil then
			return
		end

		local draft = activeSession.getDraft(false)
		local timeLength = playback.getTimeLength(false)
		local v11 = p2 or draft and draft.startTime or 0

		if not value then
			if draft then
				value = draft.endTime or timeLength
			else
				value = timeLength
			end
		end

		activeSession.update({
			startTime = math.clamp(v11, 0, timeLength),
			endTime = math.clamp(value, 0, timeLength)
		})

		playback.seek(0)
	end, { controller, playback }), useCallback(function(p2: number)
		playback.seek(p2 * playback.getDuration(false))
	end, { playback }), v7, timeLength2)

	local dragContainerRef = v11.dragContainerRef
	local leftHandleRef = v11.leftHandleRef
	local rightHandleRef = v11.rightHandleRef
	local scrubberDisplayRef = v11.scrubberDisplayRef
	local scrubberRef = v11.scrubberRef
	local segmentRef = v11.segmentRef
	local leftHandlePosition = v11.leftHandlePosition
	local rightHandlePosition = v11.rightHandlePosition

	local onActivated = useCallback(function()
		controller.discardActiveTool()
	end, { controller })

	local onActivated2 = useCallback(function()
		controller.commitActiveTool()
	end, { controller })

	local onActivated3 = useCallback(function()
		playback.toggle()
	end, { playback })

	local onActivated4 = useCallback(function()
		playback.toggleMute()
	end, { playback })

	local v12 = useSignalBinding((useMemo(function()
		return Signals.createComputed(function(p2)
			local duration = playback.getDuration(p2)

			if duration <= 0 then
				return 0
			end

			return (math.clamp(playback.getPosition(p2) / duration, 0, 1))
		end)
	end, { playback })))

	local text = useSignalBinding((useMemo(function()
		return Signals.createComputed(function(p2)
			return `{string.format("%.1f", (math.max(0, playback.getPosition(p2))))} / {string.format("%.1f", playback.getDuration(p2))}`
		end)
	end, { playback })))

	local v13 = useMemo(function()
		local children = {}

		for i = 1, math.floor(timeLength2) do
			local v13 = state2[i]
			children["frame_" .. i] = React.createElement(View, {
				tag = "shrink size-full-full bg-system-neutral"
			}, {
				content = React.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ImageContent = v13 and v13.Image,
					ScaleType = Enum.ScaleType.Crop
				})
			})
		end

		return children
	end, { timeLength2, state2 })

	local createElement = React.createElement
	local v14 = {
		LayoutOrder = p.layoutOrder,
		tag = "col align-x-center align-y-bottom gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y",
		padding = {
			top = UDim.new(0, v2.Padding.Small),
			bottom = UDim.new(0, (math.max(v.bottom, v2.Padding.Small))),
			left = UDim.new(0, (math.max(v.left, v2.Padding.XLarge))),
			right = UDim.new(0, (math.max(v.right, v2.Padding.XLarge)))
		}
	}

	local v15 = {
		Nav = React.createElement(
			View,
			{
				LayoutOrder = 1,
				tag = "row flex-x-between align-x-center align-y-center gap-small size-full-0 auto-y"
			},
			{
				BackButton = React.createElement(Button, {
					fillBehavior = Foundation.Enums.FillBehavior.Fit,
					LayoutOrder = 1,
					text = v3.GeneralCtaBack,
					variant = Foundation.Enums.ButtonVariant.Text,
					onActivated = onActivated,
					size = Foundation.Enums.InputSize.Medium
				}),
				DoneButton = React.createElement(Button, {
					fillBehavior = Foundation.Enums.FillBehavior.Fit,
					LayoutOrder = 2,
					text = v3.GeneralCtaDone,
					variant = Foundation.Enums.ButtonVariant.Text,
					onActivated = onActivated2,
					size = Foundation.Enums.InputSize.Medium
				})
			}
		),
		Trimmer = React.createElement(View, {
			LayoutOrder = 2,
			tag = "size-full-1000 padding-x-small",
			ZIndex = 2
		}, {
			PaddedContainer = React.createElement(
				View,
				{ ref = dragContainerRef, tag = "size-full-full padding-x-medium", ZIndex = 2 },
				{
					TrimmerBar = React.createElement(View, { tag = "size-full" }, {
						TrimTooltip = React.createElement(TrimTooltip, {
							activeHandle = state,
							leftHandlePosition = leftHandlePosition,
							rightHandlePosition = rightHandlePosition,
							timeLength = timeLength2
						}),
						LeftHandle = React.createElement(DragHandle, {
							anchorPoint = Vector2.new(1, 0.5),
							position = leftHandlePosition:map(function(p2)
								return UDim2.fromScale(p2, 0.5)
							end),
							dragDetectorRef = leftHandleRef
						}),
						RightHandle = React.createElement(DragHandle, {
							anchorPoint = Vector2.new(0, 0.5),
							isFlipped = true,
							position = rightHandlePosition:map(function(p2)
								return UDim2.fromScale(p2, 0.5)
							end),
							dragDetectorRef = rightHandleRef
						}),
						Outline = React.createElement(View, {
							Position = leftHandlePosition:map(function(p2)
								return UDim2.fromScale(p2, 0.5)
							end),
							Size = React.joinBindings({
								leftHandlePosition = leftHandlePosition,
								rightHandlePosition = rightHandlePosition
							}):map(function(p2)
								return UDim2.fromScale(p2.rightHandlePosition - p2.leftHandlePosition, 1)
							end),
							tag = "anchor-center-left",
							ZIndex = 2,
							stroke = {
								Color = v2.Color.System.Contrast.Color3,
								Transparency = v2.Color.System.Contrast.Transparency,
								Thickness = v2.Stroke.Thicker
							}
						}, {
							Scrubber = React.createElement(View, {
								ref = scrubberDisplayRef,
								Visible = not state or state == DragHandle2.Scrubber,
								tag = "anchor-center-center size-100-1400 radius-circle bg-system-contrast",
								Position = v12:map(function(p2)
									return UDim2.fromScale(p2, 0.5)
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
						ShadowBlockLeft = React.createElement(View, {
							backgroundStyle = v2.Color.Extended.Black.Black_50,
							Size = leftHandlePosition:map(function(p2)
								return UDim2.fromScale(p2, 1)
							end),
							tag = "position-center-left anchor-center-left",
							ZIndex = 0
						}),
						ShadowBlockRight = React.createElement(View, {
							backgroundStyle = v2.Color.Extended.Black.Black_50,
							Size = rightHandlePosition:map(function(p2)
								return UDim2.fromScale(1 - p2, 1)
							end),
							tag = "position-center-right anchor-center-right",
							ZIndex = 0
						})
					})
				}
			),
			Timeline = React.createElement(View, {
				tag = "size-full-full radius-medium bg-surface-100",
				ZIndex = 1,
				stroke = {
					Color = v2.Color.Surface.Surface_100.Color3,
					Transparency = v2.Color.Surface.Surface_100.Transparency,
					Thickness = v2.Stroke.Thicker
				}
			}, {
				TimelineBar = React.createElement(View, {
					layout = {
						FillDirection = Enum.FillDirection.Horizontal,
						Padding = UDim.new(0, v2.Size.Size_50),
						SortOrder = Enum.SortOrder.LayoutOrder
					},
					tag = "size-full-full padding-x-medium"
				}, v13)
			})
		}),
		VideoControls = 0
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local icon = if v5 then PauseLarge else PlayLarge
	local children = {
		PlaybackToggle = createElement3(IconButton, {
			LayoutOrder = 1,
			icon = icon,
			onActivated = onActivated3,
			size = Foundation.Enums.InputSize.Medium
		}),
		DurationDisplay = React.createElement(Text, {
			LayoutOrder = 2,
			tag = "auto-xy text-label-medium content-default",
			Text = text
		}),
		MuteToggle = 0
	}

	local createElement4 = React.createElement
	local icon2 = if v6 then SpeakerSlash else Speaker
	children.MuteToggle = createElement4(IconButton, {
		LayoutOrder = 3,
		icon = icon2,
		onActivated = onActivated4,
		size = Foundation.Enums.InputSize.Medium
	})
	v15.VideoControls = createElement2(
		View,
		{
			LayoutOrder = 3,
			tag = "row flex-x-between align-x-center align-y-center gap-small size-full-0 auto-y"
		},
		children
	)
	return createElement(View, v14, v15)
end
