local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local View = Foundation.View

local useEffect = React.useEffect
local useMemo = React.useMemo
local useState = React.useState
local useTokens = Foundation.Hooks.useTokens
local useSignalBinding = SignalsReact.useSignalBinding
local useSignalState = SignalsReact.useSignalState

local getCaptureVideoContent = require(MomentsCreation.Capture.getCaptureVideoContent)
local sampleVideoFrames = require(MomentsCreation.Capture.sampleVideoFrames)
local useTimelineSeekController = require(MomentsCreation.Hooks.useTimelineSeekController)
local FFlagMomentsTTSScrubberDragInOverlay = require(MomentsCreation.Flags.FFlagMomentsTTSScrubberDragInOverlay)
local FFlagMomentsScrubberSeekOnRelease = require(MomentsCreation.Flags.FFlagMomentsScrubberSeekOnRelease)

require(MomentsCreation.Types.CreationFlowTypes)

local function VideoTimeline(props)
	local playback = props.playback
	local v = useTokens()
	local height = props.height or 50
	local v2 = not (props.interactive == nil) and props.interactive

	local v3 = useSignalState(playback.getDuration)
	local v4 = useSignalState(playback.getRegion)

	local v5 = useTimelineSeekController(playback, props.onSeek, v2, props.dragOnly == true)
	local containerRef = v5.containerRef
	local dragDetectorRef = v5.dragDetectorRef
	local playheadDragDetectorRef = v5.playheadDragDetectorRef

	local state, setState = useState({})
	useEffect(function()
		if props.capture == nil or v3 <= 0 then
			return
		end

		local v6 = getCaptureVideoContent(props.capture)

		if v6 == nil and typeof(props.capture) ~= "table" then
			local success, result = pcall(Content.fromObject, props.capture)

			if success then
				v6 = result
			end
		end

		if v6 ~= nil then
			sampleVideoFrames(v6, v3, setState, v4 == nil and 0 or v4.startTime)
		end
	end, { props.capture, v3, v4 })

	local v6 = useMemo(function()
		local children = {}

		for i = 1, math.max(1, (math.floor(v3))) do
			local v6 = state[i]
			children["frame_" .. i] = React.createElement(
				View,
				{ LayoutOrder = i, tag = "shrink size-full-full bg-system-neutral" },
				{
					content = React.createElement("ImageLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 1),
						ImageContent = v6 and v6.Image,
						ScaleType = Enum.ScaleType.Crop
					})
				}
			)
		end

		return children
	end, { v3, state })

	local v7 = useSignalBinding((useMemo(function()
		return Signals.createComputed(function(p)
			if FFlagMomentsScrubberSeekOnRelease and v5.getDragFraction ~= nil then
				local dragFraction = v5.getDragFraction(p)

				if dragFraction ~= nil then
					return (math.clamp(dragFraction, 0, 1))
				end
			end

			local duration = playback.getDuration(p)

			if duration <= 0 then
				return 0
			end

			return (math.clamp(playback.getPosition(p) / duration, 0, 1))
		end)
	end, { playback, v5.getDragFraction })))
	local position

	if props.playheadPosition == nil then
		position = v7:map(function(p)
			return UDim2.fromScale(p, 0.5)
		end)
	else
		position = UDim2.fromScale(not (v3 > 0) and 0 or math.clamp(props.playheadPosition / v3, 0, 1), 0.5)
	end

	local createElement = React.createElement
	local v8 = {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, height),
		BackgroundTransparency = 1,
		ref = containerRef
	}
	local dragDetector

	if v2 then
		dragDetector = React.createElement("UIDragDetector", {
			DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
			ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale,
			ref = dragDetectorRef
		})
	end

	local children = {
		DragDetector = dragDetector,
		FilmStrip = React.createElement(
			"CanvasGroup",
			{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 1 },
			{
				Corner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v.Radius.Medium)
				}),
				FrameLayout = React.createElement(View, {
					layout = {
						FillDirection = Enum.FillDirection.Horizontal,
						Padding = UDim.new(0, v.Size.Size_50),
						SortOrder = Enum.SortOrder.LayoutOrder
					},
					tag = "size-full-full"
				}, v6)
			}
		),
		Overlays = 0,
		Playhead = 0,
		PlayheadDragHandle = 0
	}
	local overlays

	if props.children then
		overlays = React.createElement(React.Fragment, nil, props.children)
	end

	children.Overlays = overlays

	children.Playhead = React.createElement(View, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = position,
		Size = UDim2.new(0, 4, 1, 20),
		ZIndex = 3,
		cornerRadius = UDim.new(0, 2),
		backgroundStyle = v.Color.System.Contrast
	})
	local playheadDragHandle

	if v2 and FFlagMomentsTTSScrubberDragInOverlay then
		playheadDragHandle = React.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Position = position,
			Size = UDim2.new(0, 24, 1, 20),
			ZIndex = 3
		}, {
			DragDetector = React.createElement("UIDragDetector", {
				DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
				ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale,
				ref = playheadDragDetectorRef
			})
		})
	end

	children.PlayheadDragHandle = playheadDragHandle
	return createElement("Frame", v8, children)
end

return VideoTimeline
