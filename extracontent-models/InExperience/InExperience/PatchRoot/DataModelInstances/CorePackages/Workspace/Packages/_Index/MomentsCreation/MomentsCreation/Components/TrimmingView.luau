local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local BuilderIcons = require(MomentsCreationParent.BuilderIcons)
local Foundation = require(MomentsCreationParent.Foundation)
local MomentsCommon = require(MomentsCreationParent.MomentsCommon)
local React = require(MomentsCreationParent.React)
local Signals = require(MomentsCreationParent.Signals)
local SignalsReact = require(MomentsCreationParent.SignalsReact)
local Button = Foundation.Button
local IconButton = Foundation.IconButton
local FoundationText = Foundation.Text
local View = Foundation.View
local PlayLarge = BuilderIcons.Icon.PlayLarge
local PauseLarge = BuilderIcons.Icon.PauseLarge
local Speaker = BuilderIcons.Icon.Speaker
local SpeakerSlash = BuilderIcons.Icon.SpeakerSlash
local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useRef = React.useRef
local useState = React.useState
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens
local useSignalState = SignalsReact.useSignalState
local useSignalBinding = SignalsReact.useSignalBinding
local DragHandle = require(MomentsCreation.Components.DragHandle)
local TrimTooltip = require(MomentsCreation.Components.TrimTooltip)
local useTrimDragController = require(MomentsCreation.Hooks.useTrimDragController)
local getCaptureVideoContent = require(MomentsCreation.Capture.getCaptureVideoContent)
local sampleVideoFrames = require(MomentsCreation.Capture.sampleVideoFrames)
local DragHandle2 = require(MomentsCreation.Enums.DragHandle)
local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)

require(MomentsCreation.Types.CreationFlowTypes)

return function(t1: {[any]: any}) -- line: 70
	-- upvalues: useDeviceInsets (copy), useTokens (copy), useCreationFlowStrings (copy), useSignalState (copy), useMemo (copy), Signals (copy), useRef (copy), useState (copy), useEffect (copy), getCaptureVideoContent (copy), sampleVideoFrames (copy), useCallback (copy), useTrimDragController (copy), useSignalBinding (copy), React (copy), View (copy), Button (copy), Foundation (copy), TrimTooltip (copy), DragHandle (copy), DragHandle2 (copy), IconButton (copy), PauseLarge (copy), PlayLarge (copy), FoundationText (copy), SpeakerSlash (copy), Speaker (copy)
	local controller = t1.controller
	local playback = controller.preview.playback
	local v36 = useDeviceInsets()
	local v37 = useTokens()
	local v38 = useCreationFlowStrings()
	local v39 = useSignalState(controller.getSelectedCapture)
	local v40 = useSignalState(playback.getTimeLength)
	local v41 = useSignalState(playback.getIsPlaying)
	local v42 = useSignalState(playback.getIsMuted)
	local v43 = useMemo(function() -- line: 85
		-- upvalues: Signals (copy), controller (copy)
		return Signals.createComputed(function(p1) -- line: 86
			-- upvalues: controller (copy)
			local v96 = controller.getActiveSession(p1)

			if v96 ~= nil then
				return (v96.getDraft(p1))
			end

			return nil
		end)
	end, { controller })
	local v44 = useSignalState(v43)
	local v45 = useRef(false)
	local v46 = useRef(false)
	local v47, v48 = useState(nil)
	local v49, v50 = useState({})

	useEffect(function() -- line: 98
		-- upvalues: v39 (copy), v40 (copy), getCaptureVideoContent (copy), sampleVideoFrames (copy), v50 (copy)
		if v39 == nil or v40 <= 0 then
			return
		end

		local v73 = getCaptureVideoContent(v39)

		if v73 == nil and typeof(v39) ~= "table" then
			local ok, result = pcall(Content.fromObject, v39)

			if ok then
				v73 = result
			end
		end

		if v73 ~= nil then
			sampleVideoFrames(v73, v40, v50)
		end
	end, {
		v39,
		v40
	})

	local v51 = useCallback(function(p2) -- line: 116
		-- upvalues: v45 (copy), playback (copy), v46 (copy), v48 (copy)
		v45.current = playback.getIsPlaying(false)
		v46.current = playback.getIsMuted(false)
		playback.setMuted(true)
		playback.pause()
		v48(p2)
	end, { playback })
	local v52 = useCallback(function() -- line: 124
		-- upvalues: v45 (copy), playback (copy), v46 (copy), v48 (copy)
		if v45.current then
			playback.play()
		end

		if not v46.current then
			playback.setMuted(false)
		end

		v45.current = false
		v46.current = false
		v48(nil)
	end, { playback })
	local v53 = useCallback(function(n1: number?, n2: number?) -- line: 136
		-- upvalues: controller (copy), playback (copy)
		local v79 = controller.getActiveSession(false)

		if v79 == nil then
			return
		end

		local v80 = v79.getDraft(false)
		local v81 = playback.getTimeLength(false)
		local v82 = n1 or (v80 and v80.startTime or 0)
		local v83 = n2 or (v80 and v80.endTime or v81)

		v79.update({
			startTime = math.clamp(v82, 0, v81),
			endTime = math.clamp(v83, 0, v81)
		})
		playback.seek(0)
	end, {
		controller,
		playback
	})
	local v54 = useCallback(function(n3: number) -- line: 153
		-- upvalues: playback (copy)
		playback.seek(n3 * playback.getDuration(false))
	end, { playback })
	local v55 = useTrimDragController(true, v52, v51, v53, v54, v44, v40)
	local dragContainerRef = v55.dragContainerRef
	local leftHandleRef = v55.leftHandleRef
	local rightHandleRef = v55.rightHandleRef
	local scrubberDisplayRef = v55.scrubberDisplayRef
	local scrubberRef = v55.scrubberRef
	local segmentRef = v55.segmentRef
	local leftHandlePosition = v55.leftHandlePosition
	local rightHandlePosition = v55.rightHandlePosition
	local v64 = useCallback(function() -- line: 169
		-- upvalues: controller (copy)
		controller.discardActiveTool()
	end, { controller })
	local v65 = useCallback(function() -- line: 173
		-- upvalues: controller (copy)
		controller.commitActiveTool()
	end, { controller })
	local v66 = useCallback(function() -- line: 177
		-- upvalues: playback (copy)
		playback.toggle()
	end, { playback })
	local v67 = useCallback(function() -- line: 181
		-- upvalues: playback (copy)
		playback.toggleMute()
	end, { playback })
	local v68 = useMemo(function() -- line: 187
		-- upvalues: Signals (copy), playback (copy)
		return Signals.createComputed(function(p3) -- line: 188
			-- upvalues: playback (copy)
			local v98 = playback.getDuration(p3)

			if v98 <= 0 then
				return 0
			end

			return (math.clamp(playback.getPosition(p3) / v98, 0, 1))
		end)
	end, { playback })
	local v69 = useSignalBinding(v68)
	local v70 = useMemo(function() -- line: 198
		-- upvalues: Signals (copy), playback (copy)
		return Signals.createComputed(function(p4) -- line: 199
			-- upvalues: playback (copy)
			return `{ string.format("%.1f", (math.max(0, playback.getPosition(p4)))) } / { string.format("%.1f", playback.getDuration(p4)) }`
		end)
	end, { playback })
	local v71 = useSignalBinding(v70)
	local v72 = useMemo(function() -- line: 208
		-- upvalues: v40 (copy), v49 (copy), React (copy), View (copy)
		local t2 = {}

		for i = 1, math.floor(v40) do
			local v87 = v49[i]

			t2["frame_" .. i] = React.createElement(View, {
				tag = "shrink size-full-full bg-system-neutral"
			}, {
				content = React.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ImageContent = v87 and v87.Image,
					ScaleType = Enum.ScaleType.Crop
				})
			})
		end

		return t2
	end, {
		v40,
		v49
	})

	return React.createElement(View, {
		tag = "col align-x-center align-y-bottom gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder,
		padding = {
			top = UDim.new(0, v37.Padding.Small),
			bottom = UDim.new(0, (math.max(v36.bottom, v37.Padding.Small))),
			left = UDim.new(0, (math.max(v36.left, v37.Padding.XLarge))),
			right = UDim.new(0, (math.max(v36.right, v37.Padding.XLarge)))
		}
	}, {
		Nav = React.createElement(View, {
			LayoutOrder = 1,
			tag = "row flex-x-between align-x-center align-y-center gap-small size-full-0 auto-y"
		}, {
			BackButton = React.createElement(Button, {
				LayoutOrder = 1,
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				text = v38.GeneralCtaBack,
				variant = Foundation.Enums.ButtonVariant.Text,
				onActivated = v64,
				size = Foundation.Enums.InputSize.Medium
			}),
			DoneButton = React.createElement(Button, {
				LayoutOrder = 2,
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				text = v38.GeneralCtaDone,
				variant = Foundation.Enums.ButtonVariant.Text,
				onActivated = v65,
				size = Foundation.Enums.InputSize.Medium
			})
		}),
		Trimmer = React.createElement(View, {
			LayoutOrder = 2,
			tag = "size-full-1000 padding-x-small",
			ZIndex = 2
		}, {
			PaddedContainer = React.createElement(View, {
				tag = "size-full-full padding-x-medium",
				ZIndex = 2,
				ref = dragContainerRef
			}, {
				TrimmerBar = React.createElement(View, {
					tag = "size-full"
				}, {
					TrimTooltip = React.createElement(TrimTooltip, {
						activeHandle = v47,
						leftHandlePosition = leftHandlePosition,
						rightHandlePosition = rightHandlePosition,
						timeLength = v40
					}),
					LeftHandle = React.createElement(DragHandle, {
						anchorPoint = Vector2.new(1, 0.5),
						position = leftHandlePosition:map(function(p5) -- line: 281
							return UDim2.fromScale(p5, 0.5)
						end),
						dragDetectorRef = leftHandleRef
					}),
					RightHandle = React.createElement(DragHandle, {
						isFlipped = true,
						anchorPoint = Vector2.new(0, 0.5),
						position = rightHandlePosition:map(function(p6) -- line: 290
							return UDim2.fromScale(p6, 0.5)
						end),
						dragDetectorRef = rightHandleRef
					}),
					Outline = React.createElement(View, {
						tag = "anchor-center-left",
						ZIndex = 2,
						Position = leftHandlePosition:map(function(p7) -- line: 297
							return UDim2.fromScale(p7, 0.5)
						end),
						Size = React.joinBindings({
							leftHandlePosition = leftHandlePosition,
							rightHandlePosition = rightHandlePosition
						}):map(function(t3: {[any]: any}) -- line: 303
							return UDim2.fromScale(t3.rightHandlePosition - t3.leftHandlePosition, 1)
						end),
						stroke = {
							Color = v37.Color.System.Contrast.Color3,
							Transparency = v37.Color.System.Contrast.Transparency,
							Thickness = v37.Stroke.Thicker
						}
					}, {
						Scrubber = React.createElement(View, {
							tag = "anchor-center-center size-100-1400 radius-circle bg-system-contrast",
							ref = scrubberDisplayRef,
							Visible = not v47 or v47 == DragHandle2.Scrubber,
							Position = v69:map(function(p8) -- line: 321
								return UDim2.fromScale(p8, 0.5)
							end)
						}, {
							DragDetector = React.createElement("UIDragDetector", {
								DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
								ref = scrubberRef,
								ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale
							})
						}),
						DragDetector = React.createElement("UIDragDetector", {
							DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
							ref = segmentRef,
							ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomScale
						})
					}),
					ShadowBlockLeft = React.createElement(View, {
						tag = "position-center-left anchor-center-left",
						ZIndex = 0,
						backgroundStyle = v37.Color.Extended.Black.Black_50,
						Size = leftHandlePosition:map(function(p9) -- line: 341
							return UDim2.fromScale(p9, 1)
						end)
					}),
					ShadowBlockRight = React.createElement(View, {
						tag = "position-center-right anchor-center-right",
						ZIndex = 0,
						backgroundStyle = v37.Color.Extended.Black.Black_50,
						Size = rightHandlePosition:map(function(p10) -- line: 350
							return UDim2.fromScale(1 - p10, 1)
						end)
					})
				})
			}),
			Timeline = React.createElement(View, {
				tag = "size-full-full radius-medium bg-surface-100",
				ZIndex = 1,
				stroke = {
					Color = v37.Color.Surface.Surface_100.Color3,
					Transparency = v37.Color.Surface.Surface_100.Transparency,
					Thickness = v37.Stroke.Thicker
				}
			}, {
				TimelineBar = React.createElement(View, {
					tag = "size-full-full padding-x-medium",
					layout = {
						FillDirection = Enum.FillDirection.Horizontal,
						Padding = UDim.new(0, v37.Size.Size_50),
						SortOrder = Enum.SortOrder.LayoutOrder
					}
				}, v72)
			})
		}),
		VideoControls = React.createElement(View, {
			LayoutOrder = 3,
			tag = "row flex-x-between align-x-center align-y-center gap-small size-full-0 auto-y"
		}, {
			PlaybackToggle = React.createElement(IconButton, {
				LayoutOrder = 1,
				icon = if not v41 then PlayLarge else PauseLarge,
				onActivated = v66,
				size = Foundation.Enums.InputSize.Medium
			}),
			DurationDisplay = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-xy text-label-medium content-default",
				Text = v71
			}),
			MuteToggle = React.createElement(IconButton, {
				LayoutOrder = 3,
				icon = if not v42 then Speaker else SpeakerSlash,
				onActivated = v67,
				size = Foundation.Enums.InputSize.Medium
			})
		})
	})
end
