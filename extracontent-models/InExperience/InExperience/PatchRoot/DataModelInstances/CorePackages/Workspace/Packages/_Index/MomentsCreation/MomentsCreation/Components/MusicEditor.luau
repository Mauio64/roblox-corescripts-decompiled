local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local Button = Foundation.Button
local Loading = Foundation.Loading
local View = Foundation.View

local EditorTopNav = require(MomentsCreation.Components.EditorTopNav)
local GradientBackdrop = MomentsCommon.Components.GradientBackdrop
local MusicPreviewItem = require(MomentsCreation.Components.MusicPreviewItem)
local Waveform = require(MomentsCreation.Components.Waveform)

local useCallback = React.useCallback
local useContext = React.useContext
local useEffect = React.useEffect
local useMemo = React.useMemo
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useToggleState = MomentsCommon.Hooks.useToggleState
local useTokens = Foundation.Hooks.useTokens
local useSignalBinding = SignalsReact.useSignalBinding

local useMusicEditorController = require(MomentsCreation.Hooks.useMusicEditorController)
local useMusicInfo = require(MomentsCreation.Hooks.useMusicInfo)

local Constants = require(MomentsCreation.Constants)
local DockedEditorContext = require(MomentsCreation.Contexts.DockedEditorContext)
local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)
local FFlagMomentsCreationMusicEditorRedesign = require(MomentsCreation.Flags.FFlagMomentsCreationMusicEditorRedesign)
local FFlagMomentsCreationStartAudioOnLoad = require(MomentsCreation.Flags.FFlagMomentsCreationStartAudioOnLoad)
require(MomentsCreation.Types.CreationFlowTypes)
require(parent.MomentsTypes)

local SegmentSelectorWidth = Constants.AudioWaveform.SegmentSelectorWidth

local udim = UDim2.new(0, 48, 1, 0)

local function MusicEditor(props)
	local playback = props.controller.preview.playback
	local v = useTokens()
	local v2 = useDeviceInsets()
	local v3 = useCreationFlowStrings()

	local v4 = useToggleState(false)
	local v5 = useToggleState(false)
	local ref = React.useRef(nil)

	local v6 = useMusicInfo(props.musicEdit.assetId)
	local v7 = (v6 == nil or v6.Duration == nil) and 0 or v6.Duration

	local state, setState = React.useState(playback.getDuration(false))
	useEffect(function()
		return Signals.createEffect(function(p)
			setState(playback.getDuration(p))
		end)
	end, { playback })

	local v8 = useCallback(function()
		playback.setMuted(true)
		playback.seek(0)
		playback.pause()
		v5.enable()
	end, { playback, v5.enable })

	local v9 = useCallback(function()
		playback.setMuted(false)
		playback.play()
		v5.disable()
	end, { playback, v5.disable })

	local onWaveformReady = useCallback(function()
		if FFlagMomentsCreationStartAudioOnLoad and ref.current ~= props.musicEdit.assetId then
			ref.current = props.musicEdit.assetId
			playback.seek(0)
		end

		playback.setMuted(false)
		playback.play()
		v4.enable()
	end, { playback, props.musicEdit.assetId, v4.enable })

	useEffect(function()
		v4.disable()
	end, { props.musicEdit.assetId, v4.disable })

	local v10 = useMusicEditorController(v4.enabled, v9, v8, props.onStartTimeChanged, props.musicEdit, v7)
	local onAbsoluteSizeChanged

	if FFlagMomentsCreationMusicEditorRedesign then
		local v11 = useContext(DockedEditorContext)

		onAbsoluteSizeChanged = useCallback(function(p)
			v11.setDockedEditorHeight(p.AbsoluteSize.Y)
		end, { v11 })

		useEffect(function()
			return function()
				v11.setDockedEditorHeight(0)
			end
		end, { v11 })
	end

	local waveformRef = v10.waveformRef
	local waveformPosition = v10.waveformPosition
	local waveformDisplayRef = v10.waveformDisplayRef

	local v11 = useSignalBinding((useMemo(function()
		return Signals.createComputed(function(p)
			local duration = playback.getDuration(p)

			if duration <= 0 then
				return 0
			end

			return (math.clamp(playback.getPosition(p) / duration, 0, 1))
		end)
	end, { playback })))
	local color3

	if FFlagMomentsCreationMusicEditorRedesign then
		color3 = v.Color.Surface.Surface_0.Color3
	else
		color3 = v.Color.Surface.Surface_100.Color3
	end

	local createElement = React.createElement

	local v12 = {
		Timeline = React.createElement(View, { tag = "size-full-full clip", ZIndex = 1 }, {
			DragDetector = React.createElement("UIDragDetector", {
				CursorIcon = "",
				DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
				ref = waveformRef,
				ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomOffset
			}),
			LeftGradientBackdrop = React.createElement(GradientBackdrop, {
				color3 = color3,
				rotation = 0,
				size = udim,
				startingTransparency = 0,
				zIndex = 2
			}),
			RightGradientBackdrop = React.createElement(GradientBackdrop, {
				anchorPoint = Vector2.new(1, 0),
				color3 = color3,
				position = UDim2.fromScale(1, 0),
				rotation = 180,
				size = udim,
				startingTransparency = 0,
				zIndex = 2
			}),
			WaveformContainer = React.createElement(
				View,
				{
					tag = "position-center-center anchor-center-center radius-medium",
					Size = UDim2.new(0, SegmentSelectorWidth, 1, 0)
				},
				{
					WaveformDisplay = React.createElement(Waveform, {
						audioAssetId = props.musicEdit.assetId,
						position = waveformPosition:map(function(p)
							return UDim2.fromScale(p, 0.5)
						end),
						onWaveformReady = onWaveformReady,
						ref = waveformDisplayRef,
						videoDuration = state,
						zIndex = 1
					})
				}
			)
		}),
		SegmentOutline = 0
	}

	local createElement2 = React.createElement
	local v13 = {
		tag = "position-center-center anchor-center-center radius-medium",
		Size = UDim2.new(0, SegmentSelectorWidth, 1, -v.Size.Size_100),
		ZIndex = 2,
		stroke = {
			Color = v.Color.System.Contrast.Color3,
			Transparency = v.Color.System.Contrast.Transparency,
			Thickness = v.Stroke.Thick
		}
	}
	local scrubber

	if v4.enabled and not v5.enabled then
		scrubber = React.createElement(View, {
			tag = "anchor-center-center size-100-1900 radius-circle bg-system-contrast",
			Position = v11:map(function(p)
				return UDim2.fromScale(p, 0.5)
			end)
		})
	end

	local loadingIndicator

	if not v4.enabled then
		loadingIndicator = React.createElement(Loading, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			size = Foundation.Enums.IconSize.Medium
		})
	end

	v12.SegmentOutline = createElement2(View, v13, {
		Scrubber = scrubber,
		LoadingIndicator = loadingIndicator
	})
	local element = createElement(View, { LayoutOrder = 2, tag = "size-full-1600" }, v12)

	local element2 = React.createElement(View, {
		tag = "size-full-0 auto-y",
		LayoutOrder = 3,
		padding = FFlagMomentsCreationMusicEditorRedesign and {
			left = UDim.new(0, v.Padding.Large),
			right = UDim.new(0, v.Padding.Large)
		} or nil
	}, {
		MusicPreviewItem = React.createElement(MusicPreviewItem, {
			layoutOrder = 1,
			musicAssetId = props.musicEdit.assetId,
			isPreviewing = false
		})
	})

	if FFlagMomentsCreationMusicEditorRedesign then
		return React.createElement(View, { tag = "size-full", ZIndex = 5 }, {
			TopNav = React.createElement(EditorTopNav, {
				onBack = props.onBack,
				onSave = props.onDone,
				backTestId = "--moments-creation-view-musiceditor-back",
				saveTestId = "--moments-creation-button-musiceditor-save"
			}),
			DockedPanel = React.createElement(View, {
				tag = "col align-x-center align-y-top gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y radius-large bg-surface-0",
				onAbsoluteSizeChanged = onAbsoluteSizeChanged,
				padding = {
					top = UDim.new(0, v.Padding.XLarge),
					bottom = UDim.new(0, (math.max(v2.bottom, v.Padding.Small))),
					left = UDim.new(0, v2.left),
					right = UDim.new(0, v2.right)
				}
			}, { SegmentSelector = element, MusicPreviewItemWrapper = element2 })
		})
	end

	return React.createElement(View, {
		tag = "col align-x-center align-y-top gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y radius-medium bg-surface-100",
		ZIndex = 5,
		padding = {
			top = UDim.new(0, v.Padding.Small),
			bottom = UDim.new(0, (math.max(v2.bottom, v.Padding.Small))),
			left = UDim.new(0, (math.max(v2.left, v.Padding.Large))),
			right = UDim.new(0, (math.max(v2.right, v.Padding.Large)))
		}
	}, {
		Nav = React.createElement(
			View,
			{
				LayoutOrder = 1,
				tag = "row flex-x-between align-x-center align-y-center gap-small size-full-0 auto-y"
			},
			{
				BackButton = React.createElement(Button, {
					ZIndex = 6,
					fillBehavior = Foundation.Enums.FillBehavior.Fit,
					LayoutOrder = 1,
					text = v3.GeneralCtaBack,
					variant = Foundation.Enums.ButtonVariant.Text,
					onActivated = props.onBack,
					size = Foundation.Enums.InputSize.Medium
				}),
				DoneButton = React.createElement(Button, {
					ZIndex = 6,
					fillBehavior = Foundation.Enums.FillBehavior.Fit,
					LayoutOrder = 2,
					text = v3.GeneralCtaDone,
					variant = Foundation.Enums.ButtonVariant.Text,
					onActivated = props.onDone,
					size = Foundation.Enums.InputSize.Medium
				})
			}
		),
		SegmentSelector = element,
		MusicPreviewItemWrapper = element2
	})
end

return MusicEditor
