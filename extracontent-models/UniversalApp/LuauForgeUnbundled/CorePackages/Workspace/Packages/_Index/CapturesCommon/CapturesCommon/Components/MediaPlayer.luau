local RunService = game:GetService("RunService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/React")

local buttonSize = Foundation.Enums.ButtonSize
local enums = Foundation.Enums
local iconButton = Foundation.IconButton
local stateLayerAffordance = enums.StateLayerAffordance
local image = Foundation.Image
local text = Foundation.Text
local view = Foundation.View

local LoadableVideo = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Components/LoadableVideo")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Components/ProgressBar")

local function getCurrent(p2)
	if typeof(p2) == "table" and p2.current ~= nil then
		return p2.current
	end

	return nil
end

local function MediaPlayer(props)
	local state, setState = React.useState(0)
	local state2, setState2 = React.useState(0)
	local state3, setState3 = React.useState(false)
	local state4, setState4 = React.useState(false)
	local state5, setState5 = React.useState(false)
	local state6, setState6 = React.useState(true)

	React.useEffect(function()
		local videoRef = props.videoRef
		local current = if typeof(videoRef) == "table" and videoRef.current ~= nil then videoRef.current else nil

		if not current then
			return
		end

		local playedConnection = current.Played:Connect(function()
			setState3(false)
		end)

		local endedConnection = current.Ended:Connect(function()
			setState3(true)
		end)

		local renderSteppedConnection = RunService.RenderStepped:Connect(function()
			setState(current.TimePosition)
		end)

		return function()
			renderSteppedConnection:Disconnect()
			playedConnection:Disconnect()
			endedConnection:Disconnect()
		end
	end, { props.videoRef, state6, state3 })

	local v5 = React.useCallback(function(p2)
		local videoRef = props.videoRef
		local current = if typeof(videoRef) == "table" and videoRef.current ~= nil then videoRef.current else nil

		if not current then
			return
		end

		setState2(current.TimeLength)
		props.onLoaded(p2)
	end, { props.onLoaded, props.videoRef })

	local v6 = React.useCallback(function()
		setState6(not state6)
	end, { state6 })

	local v7 = React.useCallback(function()
		local videoRef = props.videoRef
		local current = if typeof(videoRef) == "table" and videoRef.current ~= nil then videoRef.current else nil

		if not current then
			return
		end

		if state3 then
			if math.abs(state - state2) <= 0.1 then
				current.TimePosition = 0
			end

			current:Play()
			setState3(false)
		else
			current:Pause()
			setState3(true)
		end
	end, { state3, props.videoRef, state, state2 })

	local v8 = React.useCallback(function()
		if props.onExpandCallback then
			props.onExpandCallback()
		end

		setState5(not state5)
	end, { state5, props.onExpandCallback })

	local v9 = React.useCallback(function(p2)
		local videoRef = props.videoRef
		local current = if typeof(videoRef) == "table" and videoRef.current ~= nil then videoRef.current else nil

		if not current then
			return
		end

		current.TimePosition = current.TimeLength * p2
	end, { props.videoRef })

	local v10 = React.useCallback(function()
		if props.onMuteCallback then
			props.onMuteCallback()
		end

		local videoRef = props.videoRef
		local current = if typeof(videoRef) == "table" and videoRef.current ~= nil then videoRef.current else nil

		if not current then
			return
		end

		current.Volume = state4 and 1 or 0
		setState4(not state4)
	end, { state4, props.onMuteCallback, props.videoRef })

	local v11 = not props.Playing

	if v11 then
		v11 = not (props.thumbnailImage == nil) and props.thumbnailImage ~= ""
	end

	local playing = (props.Video or props.VideoContent)
		and (props.Playing ~= nil and props.Playing or not props.thumbnailImage)

	local createElement = React.createElement
	local v13 = {
		tag = "shrink size-full",
		onActivated = v6,
		stateLayer = { affordance = stateLayerAffordance.None },
		ZIndex = props.ZIndex
	}

	local videoRef = props.videoRef
	local current = if typeof(videoRef) == "table" and videoRef.current ~= nil then videoRef.current else nil

	local v15 = if current ~= nil and not not props.onExpandCallback and not props.isZooming and not state6 and not props.isOverlayDisabled then React.createElement(
		view,
		{
			tag = "anchor-top-center position-top-center size-full-0 auto-y padding-medium row align-x-right",
			ZIndex = 3
		},
		{
			ExpandButton = React.createElement(iconButton, {
				icon = state5 and "icons/actions/previewShrink" or "icons/actions/previewExpand",
				isDisabled = false,
				LayoutOrder = 1,
				onActivated = v8,
				size = buttonSize.Medium
			})
		}
	) else nil

	local v16 = if playing then React.createElement(LoadableVideo, {
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = props.BackgroundTransparency,
		cornerRadius = props.cornerRadius,
		Looped = props.Looped,
		onLoaded = v5,
		Playing = props.Playing,
		Position = props.Position,
		renderOnFailed = props.renderOnFailed,
		scaleType = props.scaleType,
		Size = props.Size,
		Video = props.Video,
		VideoContent = props.VideoContent,
		videoRef = props.videoRef
	}) else React.createElement(
		view,
		{ tag = "align-x-center align-y-center auto-xy items-center gap-medium" },
		{
			Text = React.createElement(text, {
				Text = "No video to display",
				tag = "auto-xy"
			})
		}
	)

	local videoRef2 = props.videoRef
	local current2

	if typeof(videoRef2) == "table" and videoRef2.current ~= nil then
		current2 = videoRef2.current
	end

	local v17 = if current2 ~= nil and not props.isZooming and not state6 and not props.isOverlayDisabled then React.createElement(
		view,
		{
			tag = "anchor-bottom-center position-bottom-center size-full-0 auto-y",
			ZIndex = 3
		},
		{
			ProgressBar = React.createElement(module4, {
				isMuted = state4,
				isPlaying = not state3,
				isTimeHidden = props.isTimeHidden,
				onMuteButtonActivated = v10,
				onPlayButtonActivated = v7,
				onProgressBarActivated = v9,
				timePosition = state,
				timeLength = state2
			})
		}
	) else nil

	local v18 = if not (state6 or props.isOverlayDisabled) then React.createElement(view, {
		backgroundStyle = { Color3 = Color3.fromRGB(0, 0, 0), Transparency = 0.4 },
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		tag = "size-full-full",
		ZIndex = 2
	}) else nil
	local v19

	if v11 then
		local createElement2 = React.createElement
		local v21 = {
			Image = props.thumbnailImage,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 2
		}

		local v23 = if props.cornerRadius then React.createElement("UICorner", {
			CornerRadius = UDim.new(0, props.cornerRadius)
		}) else nil
		v19 = createElement2(image, v21, { UICorner = v23 })
	end

	return createElement(view, v13, {
		HeaderBarContainer = v15,
		VideoPreview = v16,
		ProgressBarContainer = v17,
		ShadowBlock = v18,
		ThumbnailImage = v19
	})
end

return MediaPlayer
