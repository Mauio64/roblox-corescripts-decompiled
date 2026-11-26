local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SignalsReact")

local view = Foundation.View

local useEffect = React.useEffect
local useMemo = React.useMemo
local useState = React.useState
local useTokens = Foundation.Hooks.useTokens
local useSignalBinding = SignalsReact.useSignalBinding
local useSignalState = SignalsReact.useSignalState

local getCaptureVideoContent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Capture/getCaptureVideoContent")
local sampleVideoFrames = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Capture/sampleVideoFrames")
local useTimelineSeekController = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useTimelineSeekController")
local FFlagMomentsTTSScrubberDragInOverlay = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTTSScrubberDragInOverlay")
local FFlagMomentsScrubberSeekOnRelease = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsScrubberSeekOnRelease")

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")

local function VideoTimeline(props)
	local playback = props.playback
	local v5 = useTokens()
	local height = props.height or 50
	local v6 = not (props.interactive == nil) and props.interactive

	local v7 = useSignalState(playback.getDuration)
	local v8 = useSignalState(playback.getRegion)

	local v9 = useTimelineSeekController(playback, props.onSeek, v6, props.dragOnly == true)
	local containerRef = v9.containerRef
	local dragDetectorRef = v9.dragDetectorRef
	local playheadDragDetectorRef = v9.playheadDragDetectorRef

	local state, setState = useState({})
	useEffect(function()
		if props.capture == nil or v7 <= 0 then
			return
		end

		local v10 = getCaptureVideoContent(props.capture)

		if v10 == nil and typeof(props.capture) ~= "table" then
			local success, result = pcall(Content.fromObject, props.capture)

			if success then
				v10 = result
			end
		end

		if v10 ~= nil then
			sampleVideoFrames(v10, v7, setState, v8 == nil and 0 or v8.startTime)
		end
	end, { props.capture, v7, v8 })

	local v10 = useMemo(function()
		local children = {}

		for i = 1, math.max(1, (math.floor(v7))) do
			local v11 = state[i]
			children["frame_" .. i] = React.createElement(
				view,
				{ LayoutOrder = i, tag = "shrink size-full-full bg-system-neutral" },
				{
					content = React.createElement("ImageLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 1),
						ImageContent = v11 and v11.Image,
						ScaleType = Enum.ScaleType.Crop
					})
				}
			)
		end

		return children
	end, { v7, state })

	local v12 = useSignalBinding((useMemo(function()
		return Signals.createComputed(function(p2)
			if FFlagMomentsScrubberSeekOnRelease and v9.getDragFraction ~= nil then
				local dragFraction = v9.getDragFraction(p2)

				if dragFraction ~= nil then
					return (math.clamp(dragFraction, 0, 1))
				end
			end

			local duration = playback.getDuration(p2)

			if duration <= 0 then
				return 0
			end

			return (math.clamp(playback.getPosition(p2) / duration, 0, 1))
		end)
	end, { playback, v9.getDragFraction })))
	local v13

	if props.playheadPosition == nil then
		v13 = v12:map(function(p2)
			return UDim2.fromScale(p2, 0.5)
		end)
	else
		v13 = UDim2.fromScale(not (v7 > 0) and 0 or math.clamp(props.playheadPosition / v7, 0, 1), 0.5)
	end

	local createElement = React.createElement
	local v15 = {
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, height),
		BackgroundTransparency = 1,
		ref = containerRef
	}

	local v16 = if v6 then React.createElement("UIDragDetector", {
		DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
		ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale,
		ref = dragDetectorRef
	}) else nil
	local children = {
		DragDetector = v16,
		FilmStrip = React.createElement(
			"CanvasGroup",
			{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 1 },
			{
				Corner = React.createElement("UICorner", {
					CornerRadius = UDim.new(0, v5.Radius.Medium)
				}),
				FrameLayout = React.createElement(view, {
					layout = {
						FillDirection = Enum.FillDirection.Horizontal,
						Padding = UDim.new(0, v5.Size.Size_50),
						SortOrder = Enum.SortOrder.LayoutOrder
					},
					tag = "size-full-full"
				}, v10)
			}
		),
		Overlays = 0,
		Playhead = 0,
		PlayheadDragHandle = 0
	}

	local v17 = if props.children then React.createElement(React.Fragment, nil, props.children) else nil
	children.Overlays = v17

	children.Playhead = React.createElement(view, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = v13,
		Size = UDim2.new(0, 4, 1, 20),
		ZIndex = 3,
		cornerRadius = UDim.new(0, 2),
		backgroundStyle = v5.Color.System.Contrast
	})

	local v18 = if v6 and FFlagMomentsTTSScrubberDragInOverlay then React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Position = v13,
		Size = UDim2.new(0, 24, 1, 20),
		ZIndex = 3
	}, {
		DragDetector = React.createElement("UIDragDetector", {
			DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
			ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale,
			ref = playheadDragDetectorRef
		})
	}) else nil
	children.PlayheadDragHandle = v18
	return createElement("Frame", v15, children)
end

return VideoTimeline
