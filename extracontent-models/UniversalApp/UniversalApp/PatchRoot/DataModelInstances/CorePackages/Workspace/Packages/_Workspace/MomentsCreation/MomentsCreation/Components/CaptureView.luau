local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local RunService = game:GetService("RunService")
local BuilderIcons = require(MomentsCreationParent.BuilderIcons)
local Foundation = require(MomentsCreationParent.Foundation)
local React = require(MomentsCreationParent.React)
local SharedFlags = require(MomentsCreationParent.SharedFlags)
local Signals = require(MomentsCreationParent.Signals)
local Icon = Foundation.Icon
local View = Foundation.View
local FFlagLuaAppMomentsInternalVideoUsage = SharedFlags.FFlagLuaAppMomentsInternalVideoUsage
local useTokens = Foundation.Hooks.useTokens
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local getCropSize = MomentsCommon.Utils.getCropSize
local getFitSize = MomentsCommon.Utils.getFitSize
local Constants = require(MomentsCreation.Constants)
local getCaptureContent = require(MomentsCreation.Capture.getCaptureContent)
local getCaptureVideoContent = require(MomentsCreation.Capture.getCaptureVideoContent)
local useCreationMusicSync = require(MomentsCreation.Hooks.useCreationMusicSync)

local function VideoPreviewSurface(t1: {[any]: any}) -- line: 74
	-- upvalues: React (copy), Signals (copy), useCreationMusicSync (copy), getCaptureVideoContent (copy), RunService (copy), View (copy), FFlagLuaAppMomentsInternalVideoUsage (copy), getFitSize (copy), getCropSize (copy)
	local preview = t1.preview
	local capture = t1.capture
	local timeLength = t1.timeLength
	local v26 = React.useRef(nil)
	local v27, v28 = React.useState(Vector2.new(0, 0))
	local v29, v30 = React.useState(Vector2.new(0, 0))
	local v31, v32 = React.useState(preview.playback.getRegion(false))

	React.useEffect(function() -- line: 86
		-- upvalues: Signals (copy), v32 (copy), preview (copy)
		return Signals.createEffect(function(p1) -- line: 87
			-- upvalues: v32 (copy), preview (copy)
			v32(preview.playback.getRegion(p1))
		end)
	end, { preview })

	local v33 = if v31 == nil then timeLength else math.max(0, v31.endTime - v31.startTime)
	local v34 = useCreationMusicSync(preview, v33)
	local audio = v34.audio
	local music = v34.music
	local userMuted = v34.userMuted
	local v38 = React.useRef(nil)

	React.useEffect(function() -- line: 105
		-- upvalues: v38 (copy), music (copy), audio (copy)
		function v38.current() -- line: 106
			-- upvalues: music (copy), audio (copy)
			if music ~= nil then
				audio.timeline.seek(0)
			end
		end
	end, {
		audio.timeline.seek,
		music
	})
	React.useEffect(function() -- line: 115
		-- upvalues: v26 (copy), music (copy), userMuted (copy)
		local current = v26.current

		if current ~= nil then
			current.Volume = music == nil and not userMuted and 1 or 0
		end
	end, {
		music,
		userMuted
	})
	React.useEffect(function() -- line: 122
		-- upvalues: v26 (copy), capture (copy), getCaptureVideoContent (copy), preview (copy), timeLength (copy), RunService (copy), v38 (copy)
		local current = v26.current

		if current == nil then
			return
		end

		if typeof(capture) == "table" then
			local v46 = getCaptureVideoContent(capture)

			if v46 ~= nil then
				current.Video = v46.Uri
			end
		else
			local ok, result = pcall(Content.fromObject, capture)

			if ok and result then
				current.VideoContent = result
			end
		end

		current.Looped = true
		preview.setDuration(timeLength)
		preview.setTimeLength(timeLength)
		preview.setReadiness("Ready")

		local u49 = false

		preview.bindEngine({
			play = function() -- line: 150
				-- upvalues: current (copy)
				current.Playing = true
			end,
			pause = function() -- line: 153
				-- upvalues: current (copy)
				current.Playing = false
			end,
			seek = function(n1: number) -- line: 156
				-- upvalues: current (copy)
				current.TimePosition = n1
			end
		})

		local t2 = {
			current.Loaded:Connect(function() -- line: 162
				-- upvalues: u49 (ref), current (copy), preview (copy)
				u49 = true

				if current.TimeLength > 0 then
					preview.setDuration(current.TimeLength)
					preview.setTimeLength(current.TimeLength)
				end

				current.Playing = true
				preview.setIsPlaying(true)
			end),
			current.Played:Connect(function() -- line: 171
				-- upvalues: u49 (ref), preview (copy)
				u49 = true
				preview.setIsPlaying(true)
			end),
			current.Paused:Connect(function() -- line: 175
				-- upvalues: u49 (ref), preview (copy)
				if u49 then
					preview.setIsPlaying(false)
				end
			end),
			RunService.RenderStepped:Connect(function() -- line: 183
				-- upvalues: preview (copy), current (copy), v38 (copy)
				preview.setPosition(current.TimePosition)

				local v55 = preview.playback.getRegion(false)

				if v55 == nil then
					return
				end

				local currentTimePosition = current.TimePosition

				if currentTimePosition >= v55.endTime - 0.05 or currentTimePosition < v55.startTime - 0.05 then
					current.TimePosition = v55.startTime

					if v38.current ~= nil then
						v38.current()
					end
				end
			end)
		}

		return function() -- line: 203
			-- upvalues: t2 (copy), preview (copy)
			for _, v58 in t2 do
				v58:Disconnect()
			end

			preview.bindEngine(nil)
		end
	end, {
		preview,
		capture,
		timeLength
	})

	return React.createElement(View, {
		tag = "size-full",
		ClipsDescendants = true,
		onAbsoluteSizeChanged = function(p2) -- line: 214
			-- upvalues: v28 (copy)
			v28(p2.AbsoluteSize)
		end
	}, {
		Media = React.createElement("VideoFrame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			InternalVideoUsage = if not FFlagLuaAppMomentsInternalVideoUsage then nil else Enum.InternalVideoUsage.WatchPage,
			Looped = true,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = if t1.scaleType ~= Enum.ScaleType.Fit then getCropSize(v27, v29) else getFitSize(v27, v29),
			Visible = v29.X > 0 and v29.Y > 0,
			ref = v26,
			[React.Change.Resolution] = function(p3) -- line: 231
				-- upvalues: v30 (copy)
				v30(p3.Resolution)
			end
		}),
		Overlay = React.createElement(View, {
			tag = "size-full",
			ZIndex = 2
		}, t1.children)
	})
end
local function ScreenshotPreviewSurface(t3: {[any]: any}) -- line: 254
	-- upvalues: useCreationMusicSync (copy), Constants (copy), React (copy), View (copy), getCaptureContent (copy)
	useCreationMusicSync(t3.preview, Constants.ScreenshotMusicDuration)

	return React.createElement(View, {
		tag = "size-full",
		onAbsoluteSizeChanged = t3.onAbsoluteSizeChanged
	}, {
		Overlay = React.createElement(React.Fragment, {}, t3.children),
		Media = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			ImageContent = getCaptureContent(t3.capture),
			ScaleType = t3.scaleType,
			Size = UDim2.fromScale(1, 1)
		})
	})
end

return function(t4: {[any]: any}) -- line: 272
	-- upvalues: useTokens (copy), React (copy), Signals (copy), View (copy), Icon (copy), BuilderIcons (copy), VideoPreviewSurface (copy), ScreenshotPreviewSurface (copy)
	local v41 = useTokens()
	local v42, v43 = React.useState(t4.preview.getCapture(false))

	React.useEffect(function() -- line: 278
		-- upvalues: Signals (copy), v43 (copy), t4 (copy)
		return Signals.createEffect(function(p4) -- line: 279
			-- upvalues: v43 (copy), t4 (copy)
			v43(t4.preview.getCapture(p4))
		end)
	end, { t4.preview })

	if v42 == nil then
		return React.createElement(View, {
			tag = "size-full radius-large bg-shift-200",
			onAbsoluteSizeChanged = t4.onAbsoluteSizeChanged
		}, {
			EmptyState = React.createElement(Icon, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				name = BuilderIcons.Icon.Image,
				Position = UDim2.fromScale(0.5, 0.5),
				size = v41.Size.Size_1200,
				style = v41.Color.Shift.Shift_400
			})
		})
	end

	if v42.CaptureType == Enum.CaptureType.Video then
		return React.createElement(View, {
			tag = "size-full",
			onAbsoluteSizeChanged = t4.onAbsoluteSizeChanged
		}, {
			Preview = React.createElement(VideoPreviewSurface, {
				preview = t4.preview,
				capture = v42,
				scaleType = t4.scaleType,
				timeLength = v42.TimeLength or 0
			}, t4.children)
		})
	end

	return React.createElement(ScreenshotPreviewSurface, {
		preview = t4.preview,
		capture = v42,
		scaleType = t4.scaleType,
		onAbsoluteSizeChanged = t4.onAbsoluteSizeChanged
	}, t4.children)
end
