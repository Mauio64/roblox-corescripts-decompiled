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
local GetFFlagMomentsCreationGalleryPreviewSwapFix = require(MomentsCreation.Flags.GetFFlagMomentsCreationGalleryPreviewSwapFix)

local function VideoPreviewSurface(t1: {[any]: any}) -- line: 81
	-- upvalues: React (copy), Signals (copy), useCreationMusicSync (copy), getCaptureVideoContent (copy), RunService (copy), View (copy), FFlagLuaAppMomentsInternalVideoUsage (copy), getFitSize (copy), getCropSize (copy)
	local preview = t1.preview
	local capture = t1.capture
	local timeLength = t1.timeLength
	local v27 = React.useRef(nil)
	local v28, v29 = React.useState(Vector2.new(0, 0))
	local v30, v31 = React.useState(Vector2.new(0, 0))
	local v32, v33 = React.useState(preview.playback.getRegion(false))

	React.useEffect(function() -- line: 93
		-- upvalues: Signals (copy), v33 (copy), preview (copy)
		return Signals.createEffect(function(p1) -- line: 94
			-- upvalues: v33 (copy), preview (copy)
			v33(preview.playback.getRegion(p1))
		end)
	end, { preview })

	local v34 = if v32 == nil then timeLength else math.max(0, v32.endTime - v32.startTime)
	local v35 = useCreationMusicSync(preview, v34)
	local audio = v35.audio
	local music = v35.music
	local userMuted = v35.userMuted
	local v39 = React.useRef(nil)

	React.useEffect(function() -- line: 112
		-- upvalues: v39 (copy), music (copy), audio (copy)
		function v39.current() -- line: 113
			-- upvalues: music (copy), audio (copy)
			if music ~= nil then
				audio.timeline.seek(0)
			end
		end
	end, {
		audio.timeline.seek,
		music
	})
	React.useEffect(function() -- line: 122
		-- upvalues: v27 (copy), music (copy), userMuted (copy)
		local current = v27.current

		if current ~= nil then
			current.Volume = music == nil and not userMuted and 1 or 0
		end
	end, {
		music,
		userMuted
	})
	React.useEffect(function() -- line: 129
		-- upvalues: v27 (copy), capture (copy), getCaptureVideoContent (copy), preview (copy), timeLength (copy), RunService (copy), v39 (copy)
		local current = v27.current

		if current == nil then
			return
		end

		if typeof(capture) == "table" then
			local v47 = getCaptureVideoContent(capture)

			if v47 ~= nil then
				current.Video = v47.Uri
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

		local u50 = false

		preview.bindEngine({
			play = function() -- line: 157
				-- upvalues: current (copy)
				current.Playing = true
			end,
			pause = function() -- line: 160
				-- upvalues: current (copy)
				current.Playing = false
			end,
			seek = function(n1: number) -- line: 163
				-- upvalues: current (copy)
				current.TimePosition = n1
			end
		})

		local t2 = {
			current.Loaded:Connect(function() -- line: 169
				-- upvalues: u50 (ref), current (copy), preview (copy)
				u50 = true

				if current.TimeLength > 0 then
					preview.setDuration(current.TimeLength)
					preview.setTimeLength(current.TimeLength)
				end

				current.Playing = true
				preview.setIsPlaying(true)
			end),
			current.Played:Connect(function() -- line: 178
				-- upvalues: u50 (ref), preview (copy)
				u50 = true
				preview.setIsPlaying(true)
			end),
			current.Paused:Connect(function() -- line: 182
				-- upvalues: u50 (ref), preview (copy)
				if u50 then
					preview.setIsPlaying(false)
				end
			end),
			RunService.RenderStepped:Connect(function() -- line: 190
				-- upvalues: preview (copy), current (copy), v39 (copy)
				preview.setPosition(current.TimePosition)

				local v62 = preview.playback.getRegion(false)

				if v62 == nil then
					return
				end

				local currentTimePosition = current.TimePosition

				if currentTimePosition >= v62.endTime - 0.05 or currentTimePosition < v62.startTime - 0.05 then
					current.TimePosition = v62.startTime

					if v39.current ~= nil then
						v39.current()
					end
				end
			end)
		}

		return function() -- line: 210
			-- upvalues: t2 (copy), preview (copy)
			for _, v65 in t2 do
				v65:Disconnect()
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
		onAbsoluteSizeChanged = function(p2) -- line: 221
			-- upvalues: v29 (copy)
			v29(p2.AbsoluteSize)
		end
	}, {
		Media = React.createElement("VideoFrame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			InternalVideoUsage = if not FFlagLuaAppMomentsInternalVideoUsage then nil else Enum.InternalVideoUsage.WatchPage,
			Looped = true,
			Position = UDim2.fromScale(0.5, 0.5),
			Size = if t1.scaleType ~= Enum.ScaleType.Fit then getCropSize(v28, v30) else getFitSize(v28, v30),
			Visible = v30.X > 0 and v30.Y > 0,
			ref = v27,
			[React.Change.Resolution] = function(p3) -- line: 238
				-- upvalues: v31 (copy)
				v31(p3.Resolution)
			end
		}),
		Overlay = React.createElement(View, {
			tag = "size-full",
			ZIndex = 2
		}, t1.children)
	})
end
local function ScreenshotPreviewSurface(t3: {[any]: any}) -- line: 261
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

return function(t4: {[any]: any}) -- line: 279
	-- upvalues: useTokens (copy), React (copy), GetFFlagMomentsCreationGalleryPreviewSwapFix (copy), Signals (copy), View (copy), Icon (copy), BuilderIcons (copy), VideoPreviewSurface (copy), ScreenshotPreviewSurface (copy)
	local v42 = useTokens()
	local v43, v44 = React.useState(t4.preview.getCapture(false))

	React.useEffect(function() -- line: 285
		-- upvalues: t4 (copy), GetFFlagMomentsCreationGalleryPreviewSwapFix (copy), Signals (copy), v44 (copy)
		local preview = t4.preview

		if not GetFFlagMomentsCreationGalleryPreviewSwapFix() then
			return Signals.createEffect(function(p4) -- line: 289
				-- upvalues: v44 (copy), preview (copy)
				v44(preview.getCapture(p4))
			end)
		end

		local thread = nil
		local u56 = nil
		local u57 = false

		local function onWindowElapsed() -- line: 303
			-- upvalues: u57 (ref), u56 (ref), v44 (copy), thread (ref), onWindowElapsed (copy)
			if u57 then
				u57 = false

				local v67 = u56

				u56 = nil
				v44(v67)
				thread = task.delay(0.2, onWindowElapsed)

				return
			end

			thread = nil
		end

		local v59 = Signals.createEffect(function(p5) -- line: 315
			-- upvalues: preview (copy), thread (ref), v44 (copy), onWindowElapsed (copy), u56 (ref), u57 (ref)
			local v69 = preview.getCapture(p5)

			if thread == nil then
				v44(v69)
				thread = task.delay(0.2, onWindowElapsed)

				return
			end

			u56 = v69
			u57 = true
		end)

		return function() -- line: 326
			-- upvalues: thread (ref), v59 (copy)
			if thread ~= nil then
				task.cancel(thread)
				thread = nil
			end

			v59()
		end
	end, { t4.preview })

	if v43 == nil then
		return React.createElement(View, {
			tag = "size-full radius-large bg-shift-200",
			onAbsoluteSizeChanged = t4.onAbsoluteSizeChanged
		}, {
			EmptyState = React.createElement(Icon, {
				AnchorPoint = Vector2.new(0.5, 0.5),
				name = BuilderIcons.Icon.Image,
				Position = UDim2.fromScale(0.5, 0.5),
				size = v42.Size.Size_1200,
				style = v42.Color.Shift.Shift_400
			})
		})
	end

	if v43.CaptureType == Enum.CaptureType.Video then
		return React.createElement(View, {
			tag = "size-full",
			onAbsoluteSizeChanged = t4.onAbsoluteSizeChanged
		}, {
			Preview = React.createElement(VideoPreviewSurface, {
				preview = t4.preview,
				capture = v43,
				scaleType = t4.scaleType,
				timeLength = v43.TimeLength or 0
			}, t4.children)
		})
	end

	return React.createElement(ScreenshotPreviewSurface, {
		preview = t4.preview,
		capture = v43,
		scaleType = t4.scaleType,
		onAbsoluteSizeChanged = t4.onAbsoluteSizeChanged
	}, t4.children)
end
