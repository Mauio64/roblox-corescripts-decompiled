local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local VideoService = game:GetService("VideoService")
local BuilderIcons = require(MomentsCreationFlowParent.BuilderIcons)
local Foundation = require(MomentsCreationFlowParent.Foundation)
local MomentsCommon = require(MomentsCreationFlowParent.MomentsCommon)
local React = require(MomentsCreationFlowParent.React)
local Button = Foundation.Button
local IconButton = Foundation.IconButton
local FoundationText = Foundation.Text
local View = Foundation.View
local PlayLarge = BuilderIcons.Icon.PlayLarge
local PauseLarge = BuilderIcons.Icon.PauseLarge
local Speaker = BuilderIcons.Icon.Speaker
local SpeakerSlash = BuilderIcons.Icon.SpeakerSlash
local DragHandle = require(MomentsCreationFlow.Components.DragHandle)
local TrimTooltip = require(MomentsCreationFlow.Components.TrimTooltip)
local useCallback = React.useCallback
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useTokens = Foundation.Hooks.useTokens
local useTrimDragController = require(MomentsCreationFlow.Hooks.useTrimDragController)
local CreationFlowContext = require(MomentsCreationFlow.Context.CreationFlowContext)
local getContentFromCapture = require(MomentsCreationFlow.Utils.getContentFromCapture)
local DragHandle2 = require(MomentsCreationFlow.Enums.DragHandle)
local CreationFlowLocalization = require(MomentsCreationFlow.Enums.CreationFlowLocalization)

return function(t1: {[any]: any}) -- line: 50
	-- upvalues: useDeviceInsets (copy), useTokens (copy), React (copy), CreationFlowContext (copy), getContentFromCapture (copy), VideoService (copy), useCallback (copy), useTrimDragController (copy), View (copy), Button (copy), Foundation (copy), CreationFlowLocalization (copy), TrimTooltip (copy), DragHandle (copy), DragHandle2 (copy), IconButton (copy), PauseLarge (copy), PlayLarge (copy), FoundationText (copy), SpeakerSlash (copy), Speaker (copy)
	local v27 = useDeviceInsets()
	local v28 = useTokens()
	local v29 = React.useContext(CreationFlowContext)
	local v30 = React.useRef(false)
	local v31 = React.useRef(false)
	local v32, v33 = React.useState(nil)
	local v34 = React.useRef(nil)
	local v35 = getContentFromCapture(t1.selectedCapture)
	local v36, v37 = React.useState({})

	React.useEffect(function() -- line: 63
		-- upvalues: v34 (copy), VideoService (copy), v35 (copy), t1 (copy), v37 (copy)
		task.spawn(function() -- line: 64
			-- upvalues: v34 (copy), VideoService (copy), v35 (copy), t1 (copy), v37 (copy)
			local ok, result = pcall(function() -- line: 65
				-- upvalues: v34 (copy), VideoService (copy), v35 (copy)
				v34.current = VideoService:CreateVideoSamplerAsync(v35)
			end)

			if ok then
				local t2 = {}

				for i = 0, math.floor(t1.playbackController.timeline.timeLength) - 1 do
					table.insert(t2, i)
				end

				v37(v34.current:GetSamplesAtTimesAsync(t2))

				return
			end

			warn("Failed to create VideoSampler:", result)
		end)
	end, { t1.selectedCapture })

	local v38 = useCallback(function(p1) -- line: 82
		-- upvalues: v30 (copy), t1 (copy), v31 (copy), v33 (copy)
		v30.current = t1.playbackController.playback.isPlaying
		v31.current = t1.playbackController.volume.isMuted
		t1.playbackController.volume.mute()
		t1.playbackController.playback.pause()
		v33(p1)
	end, {
		t1.playbackController.playback.isPlaying,
		t1.playbackController.volume.isMuted
	})
	local v39 = useCallback(function() -- line: 90
		-- upvalues: v30 (copy), t1 (copy), v31 (copy), v33 (copy)
		if v30.current then
			t1.playbackController.playback.play()
		end

		if not v31.current then
			t1.playbackController.volume.unmute()
		end

		v30.current = false
		v31.current = false
		v33(nil)
	end, {})
	local v40 = useCallback(function(n1: number?, n2: number?) -- line: 102
		-- upvalues: t1 (copy)
		local v59 = n1 or (t1.trimEdit and t1.trimEdit.startTime or 0)
		local v60 = n2 or (t1.trimEdit and t1.trimEdit.endTime or t1.playbackController.timeline.timeLength)
		local v61 = math.clamp(v59, 0, t1.playbackController.timeline.timeLength)
		local v62 = math.clamp(v60, 0, t1.playbackController.timeline.timeLength)

		t1.onTrimUpdate({
			startTime = v61,
			endTime = v62
		})
		t1.playbackController.timeline.seek(0)
	end, {
		t1.onTrimUpdate,
		t1.trimEdit,
		t1.playbackController.timeline.timeLength
	})
	local v41 = useCallback(function(n3: number) -- line: 123
		-- upvalues: t1 (copy)
		t1.playbackController.timeline.seek(n3 * t1.playbackController.timeline.duration)
	end, {
		t1.playbackController.timeline.seek,
		t1.playbackController.timeline.duration
	})
	local v42 = useTrimDragController(true, v39, v38, v40, v41, t1.trimEdit, t1.playbackController.timeline.timeLength)
	local dragContainerRef = v42.dragContainerRef
	local leftHandleRef = v42.leftHandleRef
	local rightHandleRef = v42.rightHandleRef
	local scrubberDisplayRef = v42.scrubberDisplayRef
	local scrubberRef = v42.scrubberRef
	local segmentRef = v42.segmentRef
	local leftHandlePosition = v42.leftHandlePosition
	local rightHandlePosition = v42.rightHandlePosition
	local v51 = useCallback(function() -- line: 146
		-- upvalues: t1 (copy)
		if t1.onTrimDiscard then
			t1.onTrimDiscard()
		end
	end, { t1.onTrimDiscard })
	local v52 = useCallback(function() -- line: 152
		-- upvalues: t1 (copy)
		if t1.onTrimSave then
			t1.onTrimSave()
		end
	end, { t1.onTrimSave })
	local v53 = useCallback(function() -- line: 158
		-- upvalues: t1 (copy)
		t1.playbackController.playback.toggle()
	end, { t1.playbackController })
	local v54 = useCallback(function() -- line: 162
		-- upvalues: t1 (copy)
		t1.playbackController.volume.toggle()
	end, { t1.playbackController })
	local v55 = React.useMemo(function() -- line: 166
		-- upvalues: t1 (copy), React (copy), View (copy), v36 (copy)
		local t3 = {}

		for i = 1, math.floor(t1.playbackController.timeline.timeLength) do
			t3[i] = React.createElement(View, {
				tag = "size-full-full bg-system-neutral shrink"
			}, {
				content = React.createElement("ImageLabel", {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ImageContent = v36[i] and v36[i].Image,
					ScaleType = Enum.ScaleType.Crop
				})
			})
		end

		return t3
	end, {
		t1.playbackController.timeline.timeLength,
		v36
	})

	return React.createElement(View, {
		tag = "align-x-center auto-y align-y-bottom anchor-bottom-center col gap-large position-bottom-center size-full-0",
		LayoutOrder = t1.layoutOrder
	}, {
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v28.Padding.Small),
			PaddingBottom = UDim.new(0, (math.max(v27.bottom, v28.Padding.Small))),
			PaddingLeft = UDim.new(0, (math.max(v27.left, v28.Padding.XLarge))),
			PaddingRight = UDim.new(0, (math.max(v27.right, v28.Padding.XLarge)))
		}),
		Nav = React.createElement(View, {
			LayoutOrder = 1,
			tag = "align-x-center align-y-center auto-y gap-small row size-full-0 flex-x-between"
		}, {
			BackButton = React.createElement(Button, {
				LayoutOrder = 1,
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				text = v29.getLocalization(CreationFlowLocalization.GeneralCtaBack),
				variant = Foundation.Enums.ButtonVariant.Text,
				onActivated = v51,
				size = Foundation.Enums.InputSize.Medium
			}),
			DoneButton = React.createElement(Button, {
				LayoutOrder = 2,
				fillBehavior = Foundation.Enums.FillBehavior.Fit,
				text = v29.getLocalization(CreationFlowLocalization.GeneralCtaDone),
				variant = Foundation.Enums.ButtonVariant.Text,
				onActivated = v52,
				size = Foundation.Enums.InputSize.Medium
			})
		}),
		Trimmer = React.createElement(View, {
			LayoutOrder = 2,
			tag = "padding-x-small size-full-1000",
			ZIndex = 2
		}, {
			PaddedContainer = React.createElement(View, {
				tag = "padding-x-medium size-full-full",
				ZIndex = 2,
				ref = dragContainerRef
			}, {
				TrimmerBar = React.createElement(View, {
					tag = "size-full"
				}, {
					TrimTooltip = React.createElement(TrimTooltip, {
						activeHandle = v32,
						leftHandlePosition = leftHandlePosition,
						rightHandlePosition = rightHandlePosition,
						timeLength = t1.playbackController.timeline.timeLength
					}),
					LeftHandle = React.createElement(DragHandle, {
						anchorPoint = Vector2.new(1, 0.5),
						position = leftHandlePosition:map(function(p2) -- line: 239
							return UDim2.fromScale(p2, 0.5)
						end),
						dragDetectorRef = leftHandleRef
					}),
					RightHandle = React.createElement(DragHandle, {
						isFlipped = true,
						anchorPoint = Vector2.new(0, 0.5),
						position = rightHandlePosition:map(function(p3) -- line: 248
							return UDim2.fromScale(p3, 0.5)
						end),
						dragDetectorRef = rightHandleRef
					}),
					Outline = React.createElement(View, {
						tag = "anchor-center-left",
						ZIndex = 2,
						Position = leftHandlePosition:map(function(p4) -- line: 255
							return UDim2.fromScale(p4, 0.5)
						end),
						Size = React.joinBindings({
							leftHandlePosition = leftHandlePosition,
							rightHandlePosition = rightHandlePosition
						}):map(function(p5) -- line: 261
							local leftHandlePosition2 = p5.leftHandlePosition
							local rightHandlePosition2 = p5.rightHandlePosition

							return UDim2.fromScale(rightHandlePosition2 - leftHandlePosition2, 1)
						end)
					}, {
						OutlineStroke = React.createElement("UIStroke", {
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Color = v28.Color.System.Contrast.Color3,
							Transparency = v28.Color.System.Contrast.Transparency,
							Thickness = v28.Stroke.Thicker
						}),
						Scrubber = if not not v32 and v32 ~= DragHandle2.Scrubber then nil else React.createElement(View, {
							tag = "anchor-center-center bg-system-contrast size-100-1400 radius-circle",
							ref = scrubberDisplayRef,
							Position = UDim2.fromScale(t1.playbackController.timeline.elapsed / t1.playbackController.timeline.duration, 0.5)
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
						tag = "anchor-center-left position-center-left",
						ZIndex = 0,
						backgroundStyle = v28.Color.Extended.Black.Black_50,
						Size = leftHandlePosition:map(function(p6) -- line: 303
							return UDim2.fromScale(p6, 1)
						end)
					}),
					ShadowBlockRight = React.createElement(View, {
						tag = "anchor-center-right position-center-right",
						ZIndex = 0,
						backgroundStyle = v28.Color.Extended.Black.Black_50,
						Size = rightHandlePosition:map(function(p7) -- line: 312
							return UDim2.fromScale(1 - p7, 1)
						end)
					})
				})
			}),
			Timeline = React.createElement(View, {
				tag = "bg-surface-100 radius-medium size-full-full",
				ZIndex = 1
			}, {
				OutlineStroke = React.createElement("UIStroke", {
					ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					Color = v28.Color.Surface.Surface_100.Color3,
					Transparency = v28.Color.Surface.Surface_100.Transparency,
					Thickness = v28.Stroke.Thicker
				}),
				TimelineBar = React.createElement(View, {
					tag = "padding-x-medium size-full-full row",
					layout = {
						Padding = UDim.new(0, v28.Size.Size_50)
					}
				}, v55)
			})
		}),
		VideoControls = React.createElement(View, {
			LayoutOrder = 3,
			tag = "align-x-center align-y-center auto-y gap-small row size-full-0 flex-x-between"
		}, {
			PlaybackToggle = React.createElement(IconButton, {
				LayoutOrder = 1,
				icon = t1.playbackController.playback.isPlaying and PauseLarge or PlayLarge,
				onActivated = v53,
				size = Foundation.Enums.InputSize.Medium
			}),
			DurationDisplay = React.createElement(FoundationText, {
				LayoutOrder = 2,
				tag = "auto-xy text-label-medium content-default",
				Text = `{ string.format("%.1f", (math.max(0, t1.playbackController.timeline.elapsed))) } / { string.format("%.1f", t1.playbackController.timeline.duration) }`
			}),
			MuteToggle = React.createElement(IconButton, {
				LayoutOrder = 3,
				icon = t1.playbackController.volume.isMuted and SpeakerSlash or Speaker,
				onActivated = v54,
				size = Foundation.Enums.InputSize.Medium
			})
		})
	})
end
