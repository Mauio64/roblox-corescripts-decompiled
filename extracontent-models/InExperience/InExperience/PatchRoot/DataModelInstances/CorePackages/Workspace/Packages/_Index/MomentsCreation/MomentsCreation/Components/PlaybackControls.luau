local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local BuilderIcons = require(MomentsCreationParent.BuilderIcons)
local Foundation = require(MomentsCreationParent.Foundation)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local Signals = require(MomentsCreationParent.Signals)
local SignalsReact = require(MomentsCreationParent.SignalsReact)
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
local GradientBackdrop = MomentsCommon.Components.GradientBackdrop
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens
local useSignalBinding = SignalsReact.useSignalBinding
local useSignalState = SignalsReact.useSignalState
local getFormatTime = require(MomentsCreation.Utils.getFormatTime)

local function PlaybackControls(t1: {[any]: any}) -- line: 50
	-- upvalues: useDeviceInsets (copy), useTokens (copy), React (copy), Signals (copy), useSignalBinding (copy), getFormatTime (copy), useSignalState (copy), View (copy), GradientBackdrop (copy), Slider (copy), Foundation (copy), IconButton (copy), PauseLarge (copy), PlayLarge (copy), SpeakerSlash (copy), Speaker (copy), FoundationText (copy), TwoArrowsFromCenter (copy), TwoArrowsToCenter (copy)
	local v27 = useDeviceInsets()
	local v28 = useTokens()
	local playback = t1.preview.playback
	local v30, v31 = React.useBinding(UDim2.fromScale(1, 0))
	local v32 = React.useRef(false)
	local v33 = React.useMemo(function() -- line: 59
		-- upvalues: Signals (copy), playback (copy)
		return Signals.createComputed(function(p1) -- line: 60
			-- upvalues: playback (copy)
			local v48 = playback.getDuration(p1)

			if v48 <= 0 then
				return 0
			end

			return (math.clamp(playback.getPosition(p1) / v48, 0, 1))
		end)
	end, { playback })
	local v34 = useSignalBinding(v33)
	local v35 = React.useMemo(function() -- line: 70
		-- upvalues: Signals (copy), getFormatTime (copy), playback (copy)
		return Signals.createComputed(function(p2) -- line: 71
			-- upvalues: getFormatTime (copy), playback (copy)
			return `{ getFormatTime(playback.getPosition(p2)) } / { getFormatTime(playback.getDuration(p2)) }`
		end)
	end, { playback })
	local v36 = useSignalBinding(v35)
	local v37 = useSignalState(playback.getIsPlaying)
	local v38 = useSignalState(playback.getIsMuted)
	local v39 = React.useCallback(function() -- line: 81
		-- upvalues: playback (copy), v32 (copy)
		if playback.getIsPlaying(false) then
			v32.current = true
			playback.toggle()
		end
	end, { playback })
	local v40 = React.useCallback(function() -- line: 88
		-- upvalues: v32 (copy), playback (copy)
		if v32.current and not playback.getIsPlaying(false) then
			playback.toggle()
		end

		v32.current = false
	end, { playback })
	local v41 = React.useCallback(function(n1: number) -- line: 95
		-- upvalues: playback (copy)
		playback.seek(n1 * playback.getDuration(false))
	end, { playback })
	local v42 = React.useCallback(function(p3) -- line: 99
		-- upvalues: v31 (copy)
		v31(UDim2.new(0, p3.AbsoluteSize.X, 1, 0))
	end, {})
	local v43 = React.useCallback(function() -- line: 103
		-- upvalues: playback (copy)
		playback.toggle()
	end, { playback })
	local v44 = React.useCallback(function() -- line: 107
		-- upvalues: playback (copy)
		playback.toggleMute()
	end, { playback })

	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder
	}, {
		GradientBackdrop = React.createElement(GradientBackdrop, {
			rotation = 270,
			color3 = v28.Color.Common.Scrim.Color3,
			size = v30
		}),
		Controls = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col gap-xxsmall size-full-0 auto-y",
			onAbsoluteSizeChanged = v42,
			padding = {
				bottom = UDim.new(0, v28.Padding.Medium),
				left = UDim.new(0, (math.max(v27.left, v28.Padding.Large))),
				right = UDim.new(0, (math.max(v27.right, v28.Padding.Large)))
			}
		}, {
			Slider = React.createElement(Slider, {
				LayoutOrder = 1,
				value = v34,
				size = Foundation.Enums.InputSize.XSmall,
				knobVisibility = Foundation.Enums.Visibility.None,
				variant = Foundation.Enums.SliderVariant.Standard,
				onValueChanged = v41,
				onDragStarted = v39,
				onDragEnded = v40
			}),
			ControlBar = React.createElement(View, {
				tag = "size-full-0 auto-y",
				LayoutOrder = 2
			}, {
				LeftControlButtons = React.createElement(View, {
					tag = "row gap-xsmall position-top-left anchor-top-left auto-xy",
					LayoutOrder = 1
				}, {
					PlaybackToggle = React.createElement(IconButton, {
						LayoutOrder = 1,
						icon = if not v37 then PlayLarge else PauseLarge,
						onActivated = v43,
						size = Foundation.Enums.InputSize.Small
					}),
					MuteToggle = React.createElement(IconButton, {
						LayoutOrder = 2,
						icon = if not v38 then Speaker else SpeakerSlash,
						onActivated = v44,
						size = Foundation.Enums.InputSize.Small
					})
				}),
				DurationDisplay = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "position-center-center anchor-center-center auto-xy text-body-medium content-emphasis",
					Text = v36
				}),
				RightControlButtons = React.createElement(View, {
					tag = "row gap-xsmall position-top-right anchor-top-right auto-xy",
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
