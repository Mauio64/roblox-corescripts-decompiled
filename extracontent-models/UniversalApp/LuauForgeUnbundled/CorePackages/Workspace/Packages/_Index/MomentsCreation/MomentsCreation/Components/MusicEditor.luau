local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SignalsReact")

local button = Foundation.Button
local loading = Foundation.Loading
local view = Foundation.View

local EditorTopNav = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/EditorTopNav")
local gradientBackdrop = MomentsCommon.Components.GradientBackdrop
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/MusicPreviewItem")
local Waveform = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/Waveform")

local useCallback = React.useCallback
local useContext = React.useContext
local useEffect = React.useEffect
local useMemo = React.useMemo
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useToggleState = MomentsCommon.Hooks.useToggleState
local useTokens = Foundation.Hooks.useTokens
local useSignalBinding = SignalsReact.useSignalBinding

local useMusicEditorController = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useMusicEditorController")
local useMusicInfo = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useMusicInfo")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants")
local DockedEditorContext = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Contexts/DockedEditorContext")
local useCreationFlowStrings = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useCreationFlowStrings")
local FFlagMomentsCreationMusicEditorRedesign = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCreationMusicEditorRedesign")
local FFlagMomentsCreationStartAudioOnLoad = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsCreationStartAudioOnLoad")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")

local segmentSelectorWidth = Constants.AudioWaveform.SegmentSelectorWidth

local udim = UDim2.new(0, 48, 1, 0)

local function MusicEditor(props)
	local playback = props.controller.preview.playback
	local v5 = useTokens()
	local v6 = useDeviceInsets()
	local v7 = useCreationFlowStrings()

	local v8 = useToggleState(false)
	local v9 = useToggleState(false)
	local ref = React.useRef(nil)

	local v10 = useMusicInfo(props.musicEdit.assetId)
	local v11 = (v10 == nil or v10.Duration == nil) and 0 or v10.Duration

	local state, setState = React.useState(playback.getDuration(false))
	useEffect(function()
		return Signals.createEffect(function(p2)
			setState(playback.getDuration(p2))
		end)
	end, { playback })

	local v12 = useCallback(function()
		playback.setMuted(true)
		playback.seek(0)
		playback.pause()
		v9.enable()
	end, { playback, v9.enable })

	local v13 = useCallback(function()
		playback.setMuted(false)
		playback.play()
		v9.disable()
	end, { playback, v9.disable })

	local v14 = useCallback(function()
		if FFlagMomentsCreationStartAudioOnLoad and ref.current ~= props.musicEdit.assetId then
			ref.current = props.musicEdit.assetId
			playback.seek(0)
		end

		playback.setMuted(false)
		playback.play()
		v8.enable()
	end, { playback, props.musicEdit.assetId, v8.enable })

	useEffect(function()
		v8.disable()
	end, { props.musicEdit.assetId, v8.disable })

	local v15 = useMusicEditorController(v8.enabled, v13, v12, props.onStartTimeChanged, props.musicEdit, v11)
	local v16

	if FFlagMomentsCreationMusicEditorRedesign then
		local v17 = useContext(DockedEditorContext)

		v16 = useCallback(function(p2)
			v17.setDockedEditorHeight(p2.AbsoluteSize.Y)
		end, { v17 })

		useEffect(function()
			return function()
				v17.setDockedEditorHeight(0)
			end
		end, { v17 })
	end

	local waveformRef = v15.waveformRef
	local waveformPosition = v15.waveformPosition
	local waveformDisplayRef = v15.waveformDisplayRef

	local v18 = useSignalBinding((useMemo(function()
		return Signals.createComputed(function(p2)
			local duration = playback.getDuration(p2)

			if duration <= 0 then
				return 0
			end

			return (math.clamp(playback.getPosition(p2) / duration, 0, 1))
		end)
	end, { playback })))
	local color3

	if FFlagMomentsCreationMusicEditorRedesign then
		color3 = v5.Color.Surface.Surface_0.Color3
	else
		color3 = v5.Color.Surface.Surface_100.Color3
	end

	local createElement = React.createElement

	local v21 = {
		Timeline = React.createElement(view, {
			tag = "size-full-full clip",
			ZIndex = 1
		}, {
			DragDetector = React.createElement("UIDragDetector", {
				CursorIcon = "",
				DragStyle = Enum.UIDragDetectorDragStyle.TranslateLine,
				ref = waveformRef,
				ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomOffset
			}),
			LeftGradientBackdrop = React.createElement(gradientBackdrop, {
				color3 = color3,
				rotation = 0,
				size = udim,
				startingTransparency = 0,
				zIndex = 2
			}),
			RightGradientBackdrop = React.createElement(gradientBackdrop, {
				anchorPoint = Vector2.new(1, 0),
				color3 = color3,
				position = UDim2.fromScale(1, 0),
				rotation = 180,
				size = udim,
				startingTransparency = 0,
				zIndex = 2
			}),
			WaveformContainer = React.createElement(
				view,
				{
					tag = "position-center-center anchor-center-center radius-medium",
					Size = UDim2.new(0, segmentSelectorWidth, 1, 0)
				},
				{
					WaveformDisplay = React.createElement(Waveform, {
						audioAssetId = props.musicEdit.assetId,
						position = waveformPosition:map(function(p2)
							return UDim2.fromScale(p2, 0.5)
						end),
						onWaveformReady = v14,
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
	local v23 = {
		tag = "position-center-center anchor-center-center radius-medium",
		Size = UDim2.new(0, segmentSelectorWidth, 1, -v5.Size.Size_100),
		ZIndex = 2,
		stroke = {
			Color = v5.Color.System.Contrast.Color3,
			Transparency = v5.Color.System.Contrast.Transparency,
			Thickness = v5.Stroke.Thick
		}
	}
	local v25

	if v8.enabled and not v9.enabled then
		v25 = React.createElement(view, {
			tag = "anchor-center-center size-100-1900 radius-circle bg-system-contrast",
			Position = v18:map(function(p2)
				return UDim2.fromScale(p2, 0.5)
			end)
		})
	end

	local v26 = if not v8.enabled then React.createElement(loading, {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		size = Foundation.Enums.IconSize.Medium
	}) else nil
	v21.SegmentOutline = createElement2(view, v23, {
		Scrubber = v25,
		LoadingIndicator = v26
	})
	local element = createElement(view, { LayoutOrder = 2, tag = "size-full-1600" }, v21)

	local element2 = React.createElement(view, {
		tag = "size-full-0 auto-y",
		LayoutOrder = 3,
		padding = FFlagMomentsCreationMusicEditorRedesign and {
			left = UDim.new(0, v5.Padding.Large),
			right = UDim.new(0, v5.Padding.Large)
		} or nil
	}, {
		MusicPreviewItem = React.createElement(module7, {
			layoutOrder = 1,
			musicAssetId = props.musicEdit.assetId,
			isPreviewing = false
		})
	})

	if FFlagMomentsCreationMusicEditorRedesign then
		return React.createElement(view, { tag = "size-full", ZIndex = 5 }, {
			TopNav = React.createElement(EditorTopNav, {
				onBack = props.onBack,
				onSave = props.onDone,
				backTestId = "--moments-creation-view-musiceditor-back",
				saveTestId = "--moments-creation-button-musiceditor-save"
			}),
			DockedPanel = React.createElement(view, {
				tag = "col align-x-center align-y-top gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y radius-large bg-surface-0",
				onAbsoluteSizeChanged = v16,
				padding = {
					top = UDim.new(0, v5.Padding.XLarge),
					bottom = UDim.new(0, (math.max(v6.bottom, v5.Padding.Small))),
					left = UDim.new(0, v6.left),
					right = UDim.new(0, v6.right)
				}
			}, { SegmentSelector = element, MusicPreviewItemWrapper = element2 })
		})
	end

	return React.createElement(view, {
		tag = "col align-x-center align-y-top gap-large position-bottom-center anchor-bottom-center size-full-0 auto-y radius-medium bg-surface-100",
		ZIndex = 5,
		padding = {
			top = UDim.new(0, v5.Padding.Small),
			bottom = UDim.new(0, (math.max(v6.bottom, v5.Padding.Small))),
			left = UDim.new(0, (math.max(v6.left, v5.Padding.Large))),
			right = UDim.new(0, (math.max(v6.right, v5.Padding.Large)))
		}
	}, {
		Nav = React.createElement(
			view,
			{
				LayoutOrder = 1,
				tag = "row flex-x-between align-x-center align-y-center gap-small size-full-0 auto-y"
			},
			{
				BackButton = React.createElement(button, {
					ZIndex = 6,
					fillBehavior = Foundation.Enums.FillBehavior.Fit,
					LayoutOrder = 1,
					text = v7.GeneralCtaBack,
					variant = Foundation.Enums.ButtonVariant.Text,
					onActivated = props.onBack,
					size = Foundation.Enums.InputSize.Medium
				}),
				DoneButton = React.createElement(button, {
					ZIndex = 6,
					fillBehavior = Foundation.Enums.FillBehavior.Fit,
					LayoutOrder = 2,
					text = v7.GeneralCtaDone,
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
