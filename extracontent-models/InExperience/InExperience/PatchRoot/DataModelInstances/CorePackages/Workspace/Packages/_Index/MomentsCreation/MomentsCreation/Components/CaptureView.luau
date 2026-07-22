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
local GetFFlagMomentsScreenshotMusicScrubber = require(MomentsCreation.Flags.GetFFlagMomentsScreenshotMusicScrubber)
local GetFFlagMomentsCreationGalleryPreviewSwapFix = require(MomentsCreation.Flags.GetFFlagMomentsCreationGalleryPreviewSwapFix)

local function VideoPreviewSurface(t1: {[any]: any}) -- line: 85
	-- upvalues: React (copy), Signals (copy), useCreationMusicSync (copy), getCaptureVideoContent (copy), RunService (copy), View (copy), FFlagLuaAppMomentsInternalVideoUsage (copy), getFitSize (copy), getCropSize (copy)
	local preview = t1.preview
	local capture = t1.capture
	local timeLength = t1.timeLength
	local v28 = React.useRef(nil)
	local v29, v30 = React.useState(Vector2.new(0, 0))
	local v31, v32 = React.useState(Vector2.new(0, 0))
	local v33, v34 = React.useState(preview.playback.getRegion(false))

	React.useEffect(function() -- line: 97
		-- upvalues: Signals (copy), v34 (copy), preview (copy)
		return Signals.createEffect(function(p1) -- line: 98
			-- upvalues: v34 (copy), preview (copy)
			v34(preview.playback.getRegion(p1))
		end)
	end, { preview })

	local v35 = if v33 == nil then timeLength else math.max(0, v33.endTime - v33.startTime)
	local v36 = useCreationMusicSync(preview, v35)
	local audio = v36.audio
	local music = v36.music
	local userMuted = v36.userMuted
	local v40 = React.useRef(nil)

	React.useEffect(function() -- line: 116
		-- upvalues: v40 (copy), music (copy), audio (copy)
		function v40.current() -- line: 117
			-- upvalues: music (copy), audio (copy)
			if music ~= nil then
				audio.timeline.seek(0)
			end
		end
	end, {
		audio.timeline.seek,
		music
	})
	React.useEffect(function() -- line: 126
		-- upvalues: v28 (copy), music (copy), userMuted (copy)
		local current = v28.current

		if current ~= nil then
			current.Volume = music == nil and not userMuted and 1 or 0
		end
	end, {
		music,
		userMuted
	})
	React.useEffect(function() -- line: 133
		-- upvalues: v28 (copy), capture (copy), getCaptureVideoContent (copy), preview (copy), timeLength (copy), RunService (copy), v40 (copy)
		local current = v28.current

		if current == nil then
			return
		end

		if typeof(capture) == "table" then
			local v53 = getCaptureVideoContent(capture)

			if v53 ~= nil then
				current.Video = v53.Uri
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

		local u56 = false

		preview.bindEngine({
			play = function() -- line: 161
				-- upvalues: current (copy)
				current.Playing = true
			end,
			pause = function() -- line: 164
				-- upvalues: current (copy)
				current.Playing = false
			end,
			seek = function(n1: number) -- line: 167
				-- upvalues: current (copy)
				current.TimePosition = n1
			end
		})

		local t2 = {
			current.Loaded:Connect(function() -- line: 173
				-- upvalues: u56 (ref), current (copy), preview (copy)
				u56 = true

				if current.TimeLength > 0 then
					preview.setDuration(current.TimeLength)
					preview.setTimeLength(current.TimeLength)
				end

				current.Playing = true
				preview.setIsPlaying(true)
			end),
			current.Played:Connect(function() -- line: 182
				-- upvalues: u56 (ref), preview (copy)
				u56 = true
				preview.setIsPlaying(true)
			end),
			current.Paused:Connect(function() -- line: 186
				-- upvalues: u56 (ref), preview (copy)
				if u56 then
					preview.setIsPlaying(false)
				end
			end),
			RunService.RenderStepped:Connect(function() -- line: 194
				-- upvalues: preview (copy), current (copy), v40 (copy)
				preview.setPosition(current.TimePosition)

				local v68 = preview.playback.getRegion(false)

				if v68 == nil then
					return
				end

				local currentTimePosition = current.TimePosition

				if currentTimePosition >= v68.endTime - 0.05 or currentTimePosition < v68.startTime - 0.05 then
					current.TimePosition = v68.startTime

					if v40.current ~= nil then
						v40.current()
					end
				end
			end)
		}

		return function() -- line: 214
			-- upvalues: t2 (copy), preview (copy)
			for _, v71 in t2 do
				v71:Disconnect()
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
		onAbsoluteSizeChanged = function(p2) -- line: 225
			-- upvalues: v30 (copy)
			v30(p2.AbsoluteSize)
		end
	}, {
		Media = React.createElement("VideoFrame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			InternalVideoUsage = if not FFlagLuaAppMomentsInternalVideoUsage then nil else Enum.InternalVideoUsage.WatchPage,
			Looped = true,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = if t1.scaleType ~= Enum.ScaleType.Fit then getCropSize(v29, v31) else getFitSize(v29, v31),
			Visible = v31.X > 0 and v31.Y > 0,
			ref = v28,
			[React.Change.Resolution] = function(p3) -- line: 242
				-- upvalues: v32 (copy), t1 (copy)
				v32(p3.Resolution)

				if t1.onResolutionChanged ~= nil then
					t1.onResolutionChanged(p3.Resolution)
				end
			end
		}),
		Overlay = React.createElement(View, {
			tag = "size-full",
			ZIndex = 2
		}, t1.children)
	})
end
local function ScreenshotPreviewSurface(t3: {[any]: any}) -- line: 268
	-- upvalues: useCreationMusicSync (copy), Constants (copy), React (copy), GetFFlagMomentsScreenshotMusicScrubber (copy), View (copy), getCaptureContent (copy)
	local preview = t3.preview
	local capture = t3.capture
	local v44 = useCreationMusicSync(preview, Constants.ScreenshotMusicDuration)
	local music = v44.music
	local elapsed = v44.audio.timeline.elapsed

	React.useEffect(function() -- line: 281
		-- upvalues: preview (copy), Constants (copy)
		preview.bindEngine(nil)
		preview.setDuration(Constants.ScreenshotMusicDuration)
		preview.setTimeLength(Constants.ScreenshotMusicDuration)
		preview.setPosition(0)
		preview.setReadiness("Ready")
	end, {
		preview,
		capture
	})
	React.useEffect(function() -- line: 293
		-- upvalues: GetFFlagMomentsScreenshotMusicScrubber (copy), preview (copy), music (copy), elapsed (copy), Constants (copy)
		if not GetFFlagMomentsScreenshotMusicScrubber() then
			return
		end

		preview.setPosition(music == nil and 0 or math.clamp(elapsed, 0, Constants.ScreenshotMusicDuration))
	end, {
		preview,
		music,
		elapsed
	})

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

return function(t4: {[any]: any}) -- line: 315
	-- upvalues: useTokens (copy), React (copy), GetFFlagMomentsCreationGalleryPreviewSwapFix (copy), Signals (copy), View (copy), Icon (copy), BuilderIcons (copy), VideoPreviewSurface (copy), ScreenshotPreviewSurface (copy)
	local v48 = useTokens()
	local v49, v50 = React.useState(t4.preview.getCapture(false))

	React.useEffect(function() -- line: 321
		-- upvalues: t4 (copy), GetFFlagMomentsCreationGalleryPreviewSwapFix (copy), Signals (copy), v50 (copy)
		local preview = t4.preview

		if not GetFFlagMomentsCreationGalleryPreviewSwapFix() then
			return Signals.createEffect(function(p4) -- line: 325
				-- upvalues: v50 (copy), preview (copy)
				v50(preview.getCapture(p4))
			end)
		end

		local thread = nil
		local u62 = nil
		local u63 = false

		local function onWindowElapsed() -- line: 339
			-- upvalues: u63 (ref), u62 (ref), v50 (copy), thread (ref), onWindowElapsed (copy)
			if u63 then
				u63 = false

				local v73 = u62

				u62 = nil
				v50(v73)
				thread = task.delay(0.2, onWindowElapsed)

				return
			end

			thread = nil
		end

		local v65 = Signals.createEffect(function(p5) -- line: 351
			-- upvalues: preview (copy), thread (ref), v50 (copy), onWindowElapsed (copy), u62 (ref), u63 (ref)
			local v75 = preview.getCapture(p5)

			if thread == nil then
				v50(v75)
				thread = task.delay(0.2, onWindowElapsed)

				return
			end

			u62 = v75
			u63 = true
		end)

		return function() -- line: 362
			-- upvalues: thread (ref), v65 (copy)
			if thread ~= nil then
				task.cancel(thread)
				thread = nil
			end

			v65()
		end
	end, { t4.preview })

	if v49 == nil then
		return React.createElement(View, {
			tag = "size-full radius-large bg-shift-200",
			onAbsoluteSizeChanged = t4.onAbsoluteSizeChanged
		}, {
			EmptyState = React.createElement(Icon, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				name = BuilderIcons.Icon.Image,
				Position = UDim2.fromScale(0.5, 0.5),
				size = v48.Size.Size_1200,
				style = v48.Color.Shift.Shift_400
			})
		})
	end

	if v49.CaptureType == Enum.CaptureType.Video then
		return React.createElement(View, {
			tag = "size-full",
			onAbsoluteSizeChanged = t4.onAbsoluteSizeChanged
		}, {
			Preview = React.createElement(VideoPreviewSurface, {
				preview = t4.preview,
				capture = v49,
				scaleType = t4.scaleType,
				timeLength = v49.TimeLength or 0,
				onResolutionChanged = t4.onResolutionChanged
			}, t4.children)
		})
	end

	return React.createElement(ScreenshotPreviewSurface, {
		preview = t4.preview,
		capture = v49,
		scaleType = t4.scaleType,
		onAbsoluteSizeChanged = t4.onAbsoluteSizeChanged
	}, t4.children)
end
