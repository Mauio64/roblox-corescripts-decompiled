local RunService = game:GetService("RunService")

local parent = script.Parent.Parent
local parent2 = parent.Parent

local Foundation = require(parent2.Foundation)
local React = require(parent2.React)

local ButtonSize = Foundation.Enums.ButtonSize
local Enums = Foundation.Enums
local IconButton = Foundation.IconButton
local StateLayerAffordance = Enums.StateLayerAffordance
local Image = Foundation.Image
local Text = Foundation.Text
local View = Foundation.View

local LoadableVideo = require(parent.Components.LoadableVideo)
local ProgressBar = require(parent.Components.ProgressBar)

local function getCurrent(videoRef) -- 7 equivalent calls inferred from this helper
	if typeof(videoRef) == "table" and videoRef.current ~= nil then
		return videoRef.current
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
		local current = getCurrent(props.videoRef) -- inferred equivalent call

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

	local onLoaded = React.useCallback(function(p)
		local current = getCurrent(props.videoRef) -- inferred equivalent call

		if not current then
			return
		end

		setState2(current.TimeLength)
		props.onLoaded(p)
	end, { props.onLoaded, props.videoRef })

	local onActivated = React.useCallback(function()
		setState6(not state6)
	end, { state6 })

	local onPlayButtonActivated = React.useCallback(function()
		local current = getCurrent(props.videoRef) -- inferred equivalent call

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

	local onActivated2 = React.useCallback(function()
		if props.onExpandCallback then
			props.onExpandCallback()
		end

		setState5(not state5)
	end, { state5, props.onExpandCallback })

	local onProgressBarActivated = React.useCallback(function(p)
		local current = getCurrent(props.videoRef) -- inferred equivalent call

		if not current then
			return
		end

		current.TimePosition = current.TimeLength * p
	end, { props.videoRef })

	local onMuteButtonActivated = React.useCallback(function()
		if props.onMuteCallback then
			props.onMuteCallback()
		end

		local current = getCurrent(props.videoRef) -- inferred equivalent call

		if not current then
			return
		end

		current.Volume = state4 and 1 or 0
		setState4(not state4)
	end, { state4, props.onMuteCallback, props.videoRef })

	local v = not props.Playing

	if v then
		if props.thumbnailImage == nil then
			v = false
		else
			v = props.thumbnailImage ~= ""
		end
	end

	local playing = (props.Video or props.VideoContent)
		and (props.Playing ~= nil and props.Playing or not props.thumbnailImage)

	local createElement = React.createElement
	local v2 = {
		tag = "shrink size-full",
		onActivated = onActivated,
		stateLayer = { affordance = StateLayerAffordance.None },
		ZIndex = props.ZIndex
	}

	local current = getCurrent(props.videoRef) -- inferred equivalent call
	local headerBarContainer

	if not (current == nil or not props.onExpandCallback or props.isZooming or state6 or props.isOverlayDisabled) then
		headerBarContainer = React.createElement(
			View,
			{
				tag = "anchor-top-center position-top-center size-full-0 auto-y padding-medium row align-x-right",
				ZIndex = 3
			},
			{
				ExpandButton = React.createElement(IconButton, {
					icon = state5 and "icons/actions/previewShrink" or "icons/actions/previewExpand",
					isDisabled = false,
					LayoutOrder = 1,
					onActivated = onActivated2,
					size = ButtonSize.Medium
				})
			}
		)
	end

	local videoPreview

	if playing then
		videoPreview = React.createElement(LoadableVideo, {
			AnchorPoint = props.AnchorPoint,
			BackgroundTransparency = props.BackgroundTransparency,
			cornerRadius = props.cornerRadius,
			Looped = props.Looped,
			onLoaded = onLoaded,
			Playing = props.Playing,
			Position = props.Position,
			renderOnFailed = props.renderOnFailed,
			scaleType = props.scaleType,
			Size = props.Size,
			Video = props.Video,
			VideoContent = props.VideoContent,
			videoRef = props.videoRef
		})
	else
		videoPreview = React.createElement(
			View,
			{ tag = "align-x-center align-y-center auto-xy items-center gap-medium" },
			{
				Text = React.createElement(Text, { Text = "No video to display", tag = "auto-xy" })
			}
		)
	end

	local current2 = getCurrent(props.videoRef) -- inferred equivalent call
	local progressBarContainer

	if not (current2 == nil or props.isZooming or state6 or props.isOverlayDisabled) then
		progressBarContainer = React.createElement(
			View,
			{ tag = "anchor-bottom-center position-bottom-center size-full-0 auto-y", ZIndex = 3 },
			{
				ProgressBar = React.createElement(ProgressBar, {
					isMuted = state4,
					isPlaying = not state3,
					isTimeHidden = props.isTimeHidden,
					onMuteButtonActivated = onMuteButtonActivated,
					onPlayButtonActivated = onPlayButtonActivated,
					onProgressBarActivated = onProgressBarActivated,
					timePosition = state,
					timeLength = state2
				})
			}
		)
	end

	local shadowBlock

	if not (state6 or props.isOverlayDisabled) then
		shadowBlock = React.createElement(View, {
			backgroundStyle = { Color3 = Color3.fromRGB(0, 0, 0), Transparency = 0.4 },
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			tag = "size-full-full",
			ZIndex = 2
		})
	end

	local thumbnailImage

	if v then
		local createElement2 = React.createElement
		local v3 = { Image = props.thumbnailImage, Size = UDim2.fromScale(1, 1), ZIndex = 2 }
		local uiCorner

		if props.cornerRadius then
			uiCorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, props.cornerRadius)
			})
		end

		thumbnailImage = createElement2(Image, v3, { UICorner = uiCorner })
	end

	return createElement(View, v2, {
		HeaderBarContainer = headerBarContainer,
		VideoPreview = videoPreview,
		ProgressBarContainer = progressBarContainer,
		ShadowBlock = shadowBlock,
		ThumbnailImage = thumbnailImage
	})
end

return MediaPlayer
