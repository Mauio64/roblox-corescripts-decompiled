local Parent = script:FindFirstAncestor("MomentsCreationFlow").Parent
local BuilderIcons = require(Parent.BuilderIcons)
local Foundation = require(Parent.Foundation)
local MomentsCommon = require(Parent.MomentsCommon)
local React = require(Parent.React)
local IconButton = Foundation.IconButton
local Slider = Foundation.Slider
local FoundationText = Foundation.Text
local View = Foundation.View
local PlayLarge = BuilderIcons.Icon.PlayLarge
local PauseLarge = BuilderIcons.Icon.PauseLarge
local Speaker = BuilderIcons.Icon.Speaker
local SpeakerSlash = BuilderIcons.Icon.SpeakerSlash
local TwoArrowsFromCenter = BuilderIcons.Icon.TwoArrowsFromCenter
local TwoArrowsToCenter = BuilderIcons.Icon.TwoArrowsToCenter
local GradientBackdrop = MomentsCommon.GradientBackdrop
local useCallback = React.useCallback
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens
local getFormatTime = MomentsCommon.Utils.getFormatTime

local function PlaybackControls(t1: {[any]: any}) -- line: 40
	-- upvalues: useDeviceInsets (copy), useTokens (copy), React (copy), useCallback (copy), View (copy), GradientBackdrop (copy), Slider (copy), Foundation (copy), IconButton (copy), PauseLarge (copy), PlayLarge (copy), SpeakerSlash (copy), Speaker (copy), FoundationText (copy), getFormatTime (copy), TwoArrowsFromCenter (copy), TwoArrowsToCenter (copy)
	local v23 = useDeviceInsets()
	local v24 = useTokens()
	local v25, v26 = React.useBinding(UDim2.fromScale(1, 0))
	local v27 = React.useRef(false)
	local v28 = React.useCallback(function() -- line: 47
		-- upvalues: t1 (copy), v27 (copy)
		if t1.playbackController.playback.isPlaying then
			v27.current = true
		end

		t1.playbackController.playback.pause()
	end, { t1.playbackController.playback.isPlaying })
	local v29 = React.useCallback(function() -- line: 54
		-- upvalues: v27 (copy), t1 (copy)
		if v27.current then
			t1.playbackController.playback.play()
		end

		v27.current = false
	end, {})
	local v30 = React.useCallback(function(n1: number) -- line: 61
		-- upvalues: t1 (copy)
		t1.playbackController.timeline.seek(n1 * t1.playbackController.timeline.duration)
	end, {
		t1.playbackController.timeline.duration,
		t1.playbackController.timeline.seek
	})
	local v31 = React.useCallback(function(p1) -- line: 65
		-- upvalues: v26 (copy)
		v26(UDim2.new(0, p1.AbsoluteSize.X, 1, 0))
	end, {})
	local v32 = useCallback(function() -- line: 69
		-- upvalues: t1 (copy)
		t1.playbackController.playback.toggle()
	end, { t1.playbackController })
	local v33 = useCallback(function() -- line: 73
		-- upvalues: t1 (copy)
		t1.playbackController.volume.toggle()
	end, { t1.playbackController })

	return React.createElement(View, {
		tag = "auto-y size-full-0",
		LayoutOrder = t1.layoutOrder
	}, {
		GradientBackdrop = React.createElement(GradientBackdrop, {
			rotation = 270,
			color3 = v24.Color.Common.Scrim.Color3,
			size = v25
		}),
		Controls = React.createElement(View, {
			LayoutOrder = 1,
			tag = "auto-y col gap-xxsmall size-full-0",
			onAbsoluteSizeChanged = v31
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, v24.Padding.Medium),
				PaddingLeft = UDim.new(0, (math.max(v23.left, v24.Padding.Large))),
				PaddingRight = UDim.new(0, (math.max(v23.right, v24.Padding.Large)))
			}),
			Slider = React.createElement(Slider, {
				LayoutOrder = 1,
				value = t1.playbackController.timeline.elapsed / t1.playbackController.timeline.duration,
				size = Foundation.Enums.InputSize.XSmall,
				knobVisibility = Foundation.Enums.Visibility.None,
				variant = Foundation.Enums.SliderVariant.Standard,
				onValueChanged = v30,
				onDragStarted = v28,
				onDragEnded = v29
			}),
			ControlBar = React.createElement(View, {
				tag = "auto-y size-full-0",
				LayoutOrder = 2
			}, {
				LeftControlButtons = React.createElement(View, {
					tag = "auto-xy row gap-xsmall anchor-top-left position-top-left",
					LayoutOrder = 1
				}, {
					PlaybackToggle = React.createElement(IconButton, {
						LayoutOrder = 1,
						icon = t1.playbackController.playback.isPlaying and PauseLarge or PlayLarge,
						onActivated = v32,
						size = Foundation.Enums.InputSize.Small
					}),
					MuteToggle = React.createElement(IconButton, {
						LayoutOrder = 2,
						icon = t1.playbackController.volume.isMuted and SpeakerSlash or Speaker,
						onActivated = v33,
						size = Foundation.Enums.InputSize.Small
					})
				}),
				DurationDisplay = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "auto-xy anchor-center-center position-center-center text-body-medium content-emphasis",
					Text = `{ getFormatTime(t1.playbackController.timeline.elapsed) } / { getFormatTime(t1.playbackController.timeline.duration) }`
				}),
				RightControlButtons = React.createElement(View, {
					tag = "auto-xy row gap-xsmall anchor-top-right position-top-right",
					LayoutOrder = 3
				}, {
					FitModeToggle = React.createElement(IconButton, {
						LayoutOrder = 1,
						icon = if not t1.isFitMode then TwoArrowsToCenter else TwoArrowsFromCenter,
						onActivated = t1.toggleFitMode,
						size = Foundation.Enums.InputSize.Small
					})
				})
			})
		})
	})
end

return PlaybackControls
