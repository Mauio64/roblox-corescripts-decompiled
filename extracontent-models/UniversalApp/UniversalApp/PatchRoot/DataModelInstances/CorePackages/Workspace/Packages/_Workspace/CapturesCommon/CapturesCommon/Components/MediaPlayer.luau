local RunService = game:GetService("RunService")
local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Foundation = require(ParentParentParent.Foundation)
local React = require(ParentParentParent.React)
local ButtonSize = Foundation.Enums.ButtonSize
local Enums = Foundation.Enums
local IconButton = Foundation.IconButton
local StateLayerAffordance = Enums.StateLayerAffordance
local FoundationImage = Foundation.Image
local FoundationText = Foundation.Text
local View = Foundation.View
local LoadableVideo = require(ParentParent.Components.LoadableVideo)
local ProgressBar = require(ParentParent.Components.ProgressBar)

local function getCurrent(p1) -- line: 49
	if typeof(p1) == "table" and p1.current ~= nil then
		return p1.current
	end

	return nil
end
local function MediaPlayer(t1: {[any]: any}) -- line: 56
	-- upvalues: React (copy), RunService (copy), View (copy), StateLayerAffordance (copy), IconButton (copy), ButtonSize (copy), LoadableVideo (copy), FoundationText (copy), ProgressBar (copy), Foundation (copy), FoundationImage (copy)
	local v19, v20 = React.useState(0)
	local v21, v22 = React.useState(0)
	local v23, v24 = React.useState(false)
	local v25, v26 = React.useState(false)
	local v27, v28 = React.useState(false)
	local v29, v30 = React.useState(true)

	React.useEffect(function() -- line: 64
		-- upvalues: t1 (copy), v24 (copy), RunService (copy), v20 (copy)
		local videoRef = t1.videoRef
		local v46 = if typeof(videoRef) ~= "table" or videoRef.current == nil then nil else videoRef.current

		if not v46 then
			return
		end

		local connection = v46.Played:Connect(function() -- line: 70
			-- upvalues: v24 (copy)
			v24(false)
		end)
		local connection2 = v46.Ended:Connect(function() -- line: 74
			-- upvalues: v24 (copy)
			v24(true)
		end)
		local connection3 = RunService.RenderStepped:Connect(function() -- line: 78
			-- upvalues: v20 (copy), v46 (copy)
			v20(v46.TimePosition)
		end)

		return function() -- line: 82
			-- upvalues: connection3 (copy), connection (copy), connection2 (copy)
			connection3:Disconnect()
			connection:Disconnect()
			connection2:Disconnect()
		end
	end, {
		t1.videoRef,
		v29,
		v23
	})

	local v31 = React.useCallback(function(p2) -- line: 89
		-- upvalues: t1 (copy), v22 (copy)
		local videoRef = t1.videoRef
		local v52 = if typeof(videoRef) ~= "table" or videoRef.current == nil then nil else videoRef.current

		if not v52 then
			return
		end

		v22(v52.TimeLength)
		t1.onLoaded(p2)
	end, {
		t1.onLoaded,
		t1.videoRef
	})
	local v32 = React.useCallback(function() -- line: 99
		-- upvalues: v30 (copy), v29 (copy)
		v30(not v29)
	end, { v29 })
	local v33 = React.useCallback(function() -- line: 103
		-- upvalues: t1 (copy), v23 (copy), v24 (copy), v19 (copy), v21 (copy)
		local videoRef = t1.videoRef
		local v54 = if typeof(videoRef) ~= "table" or videoRef.current == nil then nil else videoRef.current

		if not v54 then
			return
		end

		if not v23 then
			v54:Pause()
			v24(true)

			return
		end

		if math.abs(v19 - v21) <= 0.1 then
			v54.TimePosition = 0
		end

		v54:Play()
		v24(false)
	end, {
		v23,
		t1.videoRef,
		v19,
		v21
	})
	local v34 = React.useCallback(function() -- line: 121
		-- upvalues: t1 (copy), v28 (copy), v27 (copy)
		if t1.onExpandCallback then
			t1.onExpandCallback()
		end

		v28(not v27)
	end, {
		v27,
		t1.onExpandCallback
	})
	local v35 = React.useCallback(function(p3) -- line: 129
		-- upvalues: t1 (copy)
		local videoRef = t1.videoRef
		local v57 = if typeof(videoRef) ~= "table" or videoRef.current == nil then nil else videoRef.current

		if not v57 then
			return
		end

		v57.TimePosition = v57.TimeLength * p3
	end, { t1.videoRef })
	local v36 = React.useCallback(function() -- line: 138
		-- upvalues: t1 (copy), v25 (copy), v26 (copy)
		if t1.onMuteCallback then
			t1.onMuteCallback()
		end

		local videoRef = t1.videoRef
		local v59 = if typeof(videoRef) ~= "table" or videoRef.current == nil then nil else videoRef.current

		if not v59 then
			return
		end

		v59.Volume = not v25 and 0 or 1
		v26(not v25)
	end, {
		v25,
		t1.onMuteCallback,
		t1.videoRef
	})
	local v37 = not t1.Playing and (t1.thumbnailImage ~= nil and t1.thumbnailImage ~= "")
	local v38 = (t1.Video or t1.VideoContent) and (t1.Playing ~= nil and t1.Playing or not t1.thumbnailImage)
	local createElement = React.createElement
	local v40 = View
	local t2 = {
		tag = "shrink size-full",
		onActivated = v32,
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		ZIndex = t1.ZIndex
	}
	local t3 = {}
	local videoRef = t1.videoRef

	t3.HeaderBarContainer = if ((if typeof(videoRef) ~= "table" or videoRef.current == nil then nil else videoRef.current)) == nil or (not t1.onExpandCallback or (t1.isZooming or (v29 or t1.isOverlayDisabled))) then nil else React.createElement(View, {
		tag = "anchor-top-center position-top-center size-full-0 auto-y padding-medium row align-x-right",
		ZIndex = 3
	}, {
		ExpandButton = React.createElement(IconButton, {
			isDisabled = false,
			LayoutOrder = 1,
			icon = not v27 and "icons/actions/previewExpand" or "icons/actions/previewShrink",
			onActivated = v34,
			size = ButtonSize.Medium
		})
	})
	t3.VideoPreview = if not v38 then React.createElement(View, {
		tag = "align-x-center align-y-center auto-xy items-center gap-medium"
	}, {
		Text = React.createElement(FoundationText, {
			Text = "No video to display",
			tag = "auto-xy"
		})
	}) else React.createElement(LoadableVideo, {
		AnchorPoint = t1.AnchorPoint,
		BackgroundTransparency = t1.BackgroundTransparency,
		cornerRadius = t1.cornerRadius,
		Looped = t1.Looped,
		onLoaded = v31,
		Playing = t1.Playing,
		Position = t1.Position,
		renderOnFailed = t1.renderOnFailed,
		scaleType = t1.scaleType,
		Size = t1.Size,
		Video = t1.Video,
		VideoContent = t1.VideoContent,
		videoRef = t1.videoRef
	})

	local videoRef2 = t1.videoRef

	t3.ProgressBarContainer = if ((if typeof(videoRef2) ~= "table" or videoRef2.current == nil then nil else videoRef2.current)) == nil or (t1.isZooming or (v29 or t1.isOverlayDisabled)) then nil else React.createElement(View, {
		tag = "anchor-bottom-center position-bottom-center size-full-0 auto-y",
		ZIndex = 3
	}, {
		ProgressBar = React.createElement(ProgressBar, {
			isMuted = v25,
			isPlaying = not v23,
			isTimeHidden = t1.isTimeHidden,
			onMuteButtonActivated = v36,
			onPlayButtonActivated = v33,
			onProgressBarActivated = v35,
			timePosition = v19,
			timeLength = v21
		})
	})
	t3.ShadowBlock = if v29 or t1.isOverlayDisabled then nil else React.createElement(View, {
		tag = "size-full-full",
		ZIndex = 2,
		backgroundStyle = {
			Transparency = 0.4,
			Color3 = Color3.fromRGB(0, 0, 0)
		},
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		}
	})
	t3.ThumbnailImage = if not v37 then nil else React.createElement(FoundationImage, {
		ZIndex = 2,
		Image = t1.thumbnailImage,
		Size = UDim2.fromScale(1, 1)
	}, {
		UICorner = if not t1.cornerRadius then nil else React.createElement("UICorner", {
			CornerRadius = UDim.new(0, t1.cornerRadius)
		})
	})

	return createElement(v40, t2, t3)
end

return MediaPlayer
