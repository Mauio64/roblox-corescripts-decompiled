local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/BuilderIcons")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Dash")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Foundation")
local MomentsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/MomentsCommon")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/React")
local ReactOtter = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/ReactOtter")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/SignalsReact")

local GuiService = game:GetService("GuiService")
local TextService = game:GetService("TextService")

local engineFeature = game:GetEngineFeature("UIDragDetectorFixEventPositionEnabled")

local button = Foundation.Button
local view = Foundation.View

local useAnimatedBinding = ReactOtter.useAnimatedBinding
local useBinding = React.useBinding
local useCallback = React.useCallback
local useEffect = React.useEffect
local useMemo = React.useMemo
local useRef = React.useRef
local useSignalState = SignalsReact.useSignalState
local useTokens = Foundation.Hooks.useTokens
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useIsMultiTouchActive = MomentsCommon.Hooks.useIsMultiTouchActive

local overlayDisplay = MomentsCommon.Components.OverlayDisplay
local textOverlay = MomentsCommon.Components.TextOverlay
local textOverlayDisplay = MomentsCommon.Components.TextOverlayDisplay
local getScale = MomentsCommon.Utils.getScale

local getFFlagMomentsStickerButton = MomentsCommon.Flags.GetFFlagMomentsStickerButton
local getFFlagEnableMomentTextGeneration = MomentsCommon.Flags.GetFFlagEnableMomentTextGeneration
local fFlagMomentsTextOverlayV2Redesign = MomentsCommon.Flags.FFlagMomentsTextOverlayV2Redesign
local eventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/fireAnalyticsEvent")
local makeCreationEventFields = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Analytics/makeCreationEventFields")

local CreationFlowState = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Enums/CreationFlowState")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/CreationFlowTypes")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsTypes")
local TextOverlayTrashZone = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/TextOverlay/TextOverlayTrashZone")
local useOnScreenKeyboardHeight = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useOnScreenKeyboardHeight")
local useOnScreenKeyboardTop = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useOnScreenKeyboardTop")
local useCreationFlowStrings = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Hooks/useCreationFlowStrings")
local GetFFlagMomentsGenerateTextInTextOverlay = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsGenerateTextInTextOverlay")
local makeDefaultTextOverlayEdit = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/makeDefaultTextOverlayEdit")
local makeTextOverlayEditsForEditor = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/makeTextOverlayEditsForEditor")
local fitTextOverlayFontSize = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/fitTextOverlayFontSize")
local computeEditorChipLayout = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/computeEditorChipLayout")
local isPointOverTrashTarget = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/isPointOverTrashTarget")
local playDragToDeleteHaptic = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Utils/playDragToDeleteHaptic")
local fFlagMomentsTextOverlayChipGrowAboveKeyboard = MomentsCommon.Flags.FFlagMomentsTextOverlayChipGrowAboveKeyboard

local FFlagMomentsTextOverlayToolbarWhileTyping = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTextOverlayToolbarWhileTyping")
local fFlagMomentsTextOverlayEdgeClipFix = MomentsCommon.Flags.FFlagMomentsTextOverlayEdgeClipFix
local FFlagMomentsTextOverlayChipGrowWidth = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTextOverlayChipGrowWidth")
local FFlagMomentsTextOverlayModalTextFix = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTextOverlayModalTextFix")

local FFlagMomentsTextOverlayDragToDeleteRefinement = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTextOverlayDragToDeleteRefinement")
local FFlagMomentsTextOverlayTopNav = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/FFlagMomentsTextOverlayTopNav")
local module29 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/TextOverlay/VerticalFontSizeSlider")
local module30 = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/TextOverlay/TextOverlayToolbar")
local EditorTopNav = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Components/EditorTopNav")

local v5 = { dampingRatio = 0.85, frequency = 12 }

local numberSequence = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(1, 0.2)
})

local function resolveKeyboardTop(p2, p3, p4)
	return p2 or p3 - p4
end

local v6 = fFlagMomentsTextOverlayV2Redesign and fFlagMomentsTextOverlayChipGrowAboveKeyboard and FFlagMomentsTextOverlayToolbarWhileTyping

local function useToolbarWhileTyping(p2, p3)
	local v7, state, v8

	if fFlagMomentsTextOverlayV2Redesign and fFlagMomentsTextOverlayChipGrowAboveKeyboard and FFlagMomentsTextOverlayToolbarWhileTyping then
		v7 = useOnScreenKeyboardTop()
		local setState
		state, setState = React.useState(0)
		v8 = useCallback(function(p4)
			setState(p4.AbsoluteSize.Y)
		end, {})

		local textOverlayStyle = if p2 ~= nil then p2.textOverlayStyle else nil
		local v10

		if textOverlayStyle == nil then
			v10 = nil
		else
			v10 = `{tostring(textOverlayStyle.font)}|{tostring(textOverlayStyle.fontColor)}|{tostring(textOverlayStyle.textXAlignment)}`
		end

		local v11 = useRef(v10)
		useEffect(function()
			local current = v11.current
			v11.current = v10

			if current == nil or v10 == nil or current == v10 then
				return
			end

			local current2 = p3.current

			if current2 ~= nil and current2:IsFocused() then
				current2:ReleaseFocus()
			end
		end, { v10 })
	else
		state = 0
	end

	return state, v8, v7
end

local function GenerateTextButton(p2)
	local controller = p2.controller
	local v7 = useTokens()
	local v8 = useCreationFlowStrings()
	local v9 = useSignalState(controller.getIsGenerating)

	local v10 = useCallback(function()
		controller.beginTool("generateText")
	end, { controller })

	return React.createElement(view, {
		tag = "position-bottom-right anchor-bottom-right auto-xy",
		ZIndex = 10,
		padding = {
			bottom = UDim.new(0, v7.Padding.Large),
			right = UDim.new(0, v7.Padding.Large)
		}
	}, {
		Button = React.createElement(button, {
			fillBehavior = Foundation.Enums.FillBehavior.Fit,
			icon = BuilderIcons.Icon.TagSparkle,
			text = v8.GenerateTextCta,
			variant = Foundation.Enums.ButtonVariant.Emphasis,
			onActivated = v10,
			isLoading = v9,
			size = Foundation.Enums.InputSize.Medium
		})
	})
end

local function TextOverlayLayer(props)
	local controller = props.controller

	local v7 = useSignalState(controller.getStep)
	local v8 = useSignalState(props.ctx.getItemSize)
	local v9 = useSignalState(props.ctx.getItemResolution)
	local textOverlays = useSignalState(controller.getComposedEdits).textOverlays
	local scale = getScale(v8, v9, Enum.ScaleType.Crop)

	local v11 = useSignalState((useMemo(function()
		return Signals.createComputed(function(p2)
			local activeSession = controller.getActiveSession(p2)

			if activeSession == nil then
				return nil
			end

			return (activeSession.getDraft(p2))
		end)
	end, { controller })))

	local v12 = v7 == CreationFlowState.TextOverlay
	local v13 = v11 and v11[1]

	local v14 = useRef(nil)
	local v15 = useRef(nil)
	local v16, v17 = useBinding(UDim2.fromOffset(0, 0))
	local v18 = useOnScreenKeyboardHeight()

	local v19 = v6
	local v20, v21, v22 = useToolbarWhileTyping(v13, v14)

	local v23 = if FFlagMomentsTextOverlayModalTextFix then useSignalState(controller.getActiveModal) else nil
	local v24 = FFlagMomentsTextOverlayModalTextFix and v23 ~= nil
	local v25

	if FFlagMomentsTextOverlayModalTextFix then
		v25 = not (fFlagMomentsTextOverlayV2Redesign and scale > 0) and 1 or 1 / scale
	end

	local v26

	if fFlagMomentsTextOverlayV2Redesign then
		v26 = useMemo(function()
			if v13 == nil then
				return Constants.TextOverlay.DefaultFontSize
			end

			local fontSize = v13.textOverlayStyle.fontSize

			if v18 > 0 then
				return Constants.TextOverlay.DefaultFontSize
			end

			local v27 = math.min(300, v8.X * 0.9)

			if fFlagMomentsTextOverlayEdgeClipFix then
				local x = TextService:GetTextSize(
					" ",
					fontSize,
					v13.textOverlayStyle.font,
					Vector2.new(1000000, 1000000)
				).X
				v27 = math.min(276 - (math.ceil(fontSize * 0.08) + math.ceil(x) * 2), v8.X * 0.9)
			end

			local v28 = v8.Y * 0.8
			return fitTextOverlayFontSize(
				v13.text,
				v13.textOverlayStyle.font,
				fontSize,
				v27,
				v28,
				Constants.TextOverlay.MinFontSize
			)
		end, { v13, v18, v8 })
	else
		v26 = if v13 == nil then Constants.TextOverlay.DefaultFontSize else v13.textOverlayStyle.fontSize
	end

	local v27 = useCallback(function()
		if v14.current then
			v14.current:CaptureFocus()
		end
	end, {})

	local v28 = useCallback(function()
		if v14.current then
			v14.current:ReleaseFocus()
		end
	end, {})

	local v29 = useCallback(function(p2)
		local activeSession = controller.getActiveSession(false)

		if activeSession == nil then
			return
		end

		local draft = activeSession.getDraft(false)
		local v30 = draft and draft[1]

		if v30 == nil then
			return
		end

		local v31 = utf8.len(p2.Text)

		if v31 ~= nil and v31 >= 100 then
			local v32 = utf8.offset(p2.Text, 101)

			if getFFlagMomentsStickerButton() then
				if v32 then
					p2.Text = string.sub(p2.Text, 1, v32 - 1)
				end
			else
				p2.Text = string.sub(p2.Text, 1, v32 - 1)
			end
		end

		activeSession.update({ Dash.joinDeep(v30, { text = p2.Text }) })
	end, { controller })

	local v30 = useCallback(function()
		if getFFlagEnableMomentTextGeneration() and controller.getIsGenerating(false) then
			controller.onDisabledToolActivated("text")
		else
			controller.beginTool("text")
		end
	end, { controller })

	local v31 = useCallback(function(p2)
		controller.updateCommittedEdit("text", p2)
	end, { controller })

	local v32 = nil
	local v33 = nil
	local v34 = nil
	local v35 = nil
	local v36

	if fFlagMomentsTextOverlayV2Redesign then
		v34 = useRef(false)
		v35 = useRef(false)
		v36 = useRef(false)

		v32 = useCallback(function(p2)
			local textOverlays2 = controller.getComposedEdits(false).textOverlays
			local v37 = textOverlays2 and textOverlays2[1]

			if v37 == nil then
				return
			end

			controller.updateCommittedEdit("text", { Dash.joinDeep(v37, {
					scale = p2
				}) })

			if not v34.current then
				v34.current = true
				fireAnalyticsEvent(eventNames.EditingFlowTextOverlayRescaleUsed, makeCreationEventFields.makeTextOverlayEventFields())
			end
		end, { controller })

		v33 = useCallback(function(p2)
			local textOverlays2 = controller.getComposedEdits(false).textOverlays
			local v37 = textOverlays2 and textOverlays2[1]

			if v37 == nil then
				return
			end

			controller.updateCommittedEdit("text", { Dash.joinDeep(v37, {
					rotation = p2
				}) })

			if not v35.current then
				v35.current = true
				fireAnalyticsEvent(eventNames.EditingFlowTextOverlayRotateUsed, makeCreationEventFields.makeTextOverlayEventFields())
			end
		end, { controller })
	else
		v36 = nil
	end

	local v37 = if fFlagMomentsTextOverlayV2Redesign then useDeviceInsets() else nil

	local v38 = FFlagMomentsTextOverlayTopNav
	local v39, v40, v41

	if FFlagMomentsTextOverlayTopNav then
		v39 = useTokens()
		v40 = useCallback(function()
			controller.discardActiveTool()
		end, { controller })
		v41 = useCallback(function()
			controller.commitActiveTool()
		end, { controller })
	end

	local v42 = useRef(nil)
	local v43, v44, textOverlayDragHereToDelete

	if FFlagMomentsTextOverlayDragToDeleteRefinement then
		v43 = useRef(nil)
		v44 = useRef(nil)
		textOverlayDragHereToDelete = useCreationFlowStrings().TextOverlayDragHereToDelete
	else
		v43 = nil
		v44 = nil
	end

	local v45 = useRef(false)

	local v46, v47 = useBinding(false)
	local v48, v49 = useAnimatedBinding(1)
	local v50, v51 = useAnimatedBinding(1)
	local v52

	if fFlagMomentsTextOverlayV2Redesign then
		v52 = useIsMultiTouchActive(v7 == CreationFlowState.Preview)
	else
		v52 = false
	end

	local v53 = useCallback(function(p2)
		local current = v42.current

		if current == nil then
			return false
		end

		local v54 = Vector2.zero

		if fFlagMomentsTextOverlayV2Redesign and not engineFeature and v37 ~= nil then
			v54 = GuiService:GetGuiInset() + Vector2.new(v37.left, v37.top)
		end

		local v56 = fFlagMomentsTextOverlayV2Redesign and 24 or 0

		if not (fFlagMomentsTextOverlayV2Redesign and FFlagMomentsTextOverlayDragToDeleteRefinement) then
			return isPointOverTrashTarget(p2, v54, current.AbsolutePosition, current.AbsoluteSize, v56)
		end

		local current2 = if v43 then v43.current else nil

		if current2 == nil or v44 == nil then
			return false
		end

		local v57 = p2 - v54
		local v58 = current2.AbsoluteSize.X / 2
		local v59 = current2.AbsolutePosition + current2.AbsoluteSize / 2

		if not v45.current and math.abs(v48:getValue() - 1) < 0.01 then
			v44.current = { center = v59, radius = v58 }
		end

		local current3 = v44.current or {
			center = v59,
			radius = v58 / math.max(v48:getValue(), 1)
		}

		if v45.current then
			return (v57 - current3.center).Magnitude <= current3.radius * 1.15 + 8
				or (v57 - v59).Magnitude <= v58 + 8
		end

		return (v57 - current3.center).Magnitude <= current3.radius
	end, { v37, v48 })

	local v54 = useCallback(function()
		if not fFlagMomentsTextOverlayV2Redesign then
			return
		end

		if props.ctx.setIsOverlayDragging then
			props.ctx.setIsOverlayDragging(true)
		end

		v45.current = false
		v49(ReactOtter.instant(1))
		v51(ReactOtter.instant(1))
		v47(true)

		if not v36.current then
			v36.current = true
			fireAnalyticsEvent(eventNames.EditingFlowTextOverlayRepositionUsed, makeCreationEventFields.makeTextOverlayEventFields())
		end
	end, { props.ctx, v49, v51, v47 })

	local v55 = useCallback(function(p2)
		if not fFlagMomentsTextOverlayV2Redesign then
			return
		end

		local v56 = v53(p2)

		if v56 == v45.current then
			return
		end

		v45.current = v56

		if FFlagMomentsTextOverlayDragToDeleteRefinement and v56 then
			playDragToDeleteHaptic()
		end

		v49(ReactOtter.spring(v56 and 1.15 or 1, v5))

		v51(ReactOtter.spring(v56 and 0.45 or 1, v5))
	end, { v53, v49, v51 })

	local v56 = useCallback(function(p2)
		if not fFlagMomentsTextOverlayV2Redesign then
			v31(p2)
			return
		end

		if props.ctx.setIsOverlayDragging then
			props.ctx.setIsOverlayDragging(false)
		end

		local current = v45.current
		v45.current = false
		v47(false)
		v49(ReactOtter.instant(1))

		if current then
			fireAnalyticsEvent(eventNames.EditingFlowTextOverlayDeletedViaTrash, makeCreationEventFields.makeTextOverlayEventFields())

			controller.updateCommittedEdit("text", nil)
		else
			v51(ReactOtter.instant(1))

			v31(p2)
		end
	end, { props.ctx, controller, v31, v47, v49, v51 })

	useEffect(function()
		if not fFlagMomentsTextOverlayV2Redesign then
			return
		end

		if textOverlays == nil or #textOverlays == 0 then
			v51(ReactOtter.instant(1))
		end
	end, { textOverlays })

	if fFlagMomentsTextOverlayV2Redesign then
		useEffect(function()
			if not (fFlagMomentsTextOverlayV2Redesign and v52) then
				return
			end

			v45.current = false
			v47(false)
			v49(ReactOtter.instant(1))
			v51(ReactOtter.instant(1))

			if props.ctx.setIsOverlayDragging then
				props.ctx.setIsOverlayDragging(false)
			end
		end, { v52, props.ctx, v47, v49, v51 })
	end

	useEffect(function()
		if not v12 then
			return
		end

		local activeSession = controller.getActiveSession(false)

		if activeSession == nil or activeSession.getDraft(false) ~= nil then
			return
		end

		activeSession.update(makeTextOverlayEditsForEditor(textOverlays, makeDefaultTextOverlayEdit(), scale))
	end, { v12, textOverlays, controller, scale })

	local v57 = useRef(false)
	useEffect(function()
		if v12 then
			if v57.current or v14.current == nil or v13 == nil then
				return
			end

			v27()
			v57.current = true
		else
			v57.current = false

			if v14.current then
				v14.current:ReleaseFocus()
			end
		end
	end, { v12, v13, v27 })

	if FFlagMomentsTextOverlayModalTextFix then
		local v58 = useRef(false)
		useEffect(function()
			local current = v14.current

			if v24 then
				if current ~= nil and current:IsFocused() then
					v58.current = true
					current:ReleaseFocus()
				end
			elseif v58.current then
				v58.current = false

				if v12 then
					v27()
				end
			end
		end, { v24, v12, v27 })
	end

	useEffect(function()
		if
			not v12
			or v13 == nil
			or fFlagMomentsTextOverlayV2Redesign and fFlagMomentsTextOverlayChipGrowAboveKeyboard
		then
			return
		end

		if v18 == 0 then
			v17(UDim2.fromOffset(0, 0))
			return
		end

		local textSize = TextService:GetTextSize(
			"W",
			v26,
			v13.textOverlayStyle.font,
			Vector2.new(v8.X, v8.Y)
		)
		v17(UDim2.fromOffset(math.min(textSize.X * 30, v8.X / 2), (math.min(textSize.Y * 5, v8.Y / 2))))
	end, { v12, v13, v26, v18, v8 })
	local v58 = not fFlagMomentsTextOverlayV2Redesign or v18 == 0

	if v12 then
		if v13 == nil then
			return nil
		end

		local v59 = UDim2.fromScale(0.5, 0.5)
		local v60 = v26
		local v61 = fFlagMomentsTextOverlayV2Redesign
			and fFlagMomentsTextOverlayChipGrowAboveKeyboard
			and v18 > 0
		local v62, v63

		if v61 then
			local currentCamera = workspace.CurrentCamera
			local y = if currentCamera then currentCamera.ViewportSize.Y else v8.Y
			local v64 = not v15.current and 0 or v15.current.AbsolutePosition.Y
			v62 = (v22 or y - v18) - v64

			local v65 = computeEditorChipLayout({
				text = v13.text,
				font = v13.textOverlayStyle.font,
				itemWidth = v8.X,
				maxChipWidth = 300,
				viewportHeight = y,
				keyboardHeight = v18,
				keyboardTop = v22,
				layerTopY = v64,
				keyboardGap = not (v19 and v20 > 0) and 48 or 16 + v20 + 12,
				topMargin = not v38 and 48 or v64 + v37.top + v39.Padding.Medium + v39.Size.Size_1000,
				chipPadding = 12,
				growWidthWithText = FFlagMomentsTextOverlayChipGrowWidth,
				overhangFraction = 0.08
			})

			v60 = v65.fontSize
			v63 = v65.size
			v59 = v65.position
		end

		local createElement = React.createElement

		if not (fFlagMomentsTextOverlayV2Redesign and fFlagMomentsTextOverlayChipGrowAboveKeyboard) then
			v28 = nil
		end

		local v65 = {
			onActivated = v28,
			ref = v15,
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			tag = "size-full bg-over-media-0",
			ZIndex = props.zIndex or 1
		}

		local createElement2 = React.createElement

		local v68 = {
			additionalScale = if fFlagMomentsTextOverlayV2Redesign then scale else nil,
			editable = true,
			fitToContent = v18 == 0,
			onActivated = v27,
			size = nil,
			textOverlayEdit = 0,
			onTextChanged = 0,
			textBoxRef = 0,
			textVisible = 0
		}

		if not v61 then
			v63 = v16
		end

		v68.size = v63
		v68.textOverlayEdit = Dash.joinDeep(v13, {
			position = v59,
			rotation = 0,
			scale = v25,
			textOverlayStyle = { fontSize = v60 }
		})

		v68.onTextChanged = v29
		v68.textBoxRef = v14
		v68.textVisible = if v24 then false else nil
		local v66 = {
			TextOverlay = createElement2(textOverlay, v68),
			GenerateText = 0,
			VerticalFontSizeSlider = 0,
			BottomScrim = 0,
			TopNav = 0,
			TextOverlayToolbar = 0
		}

		local v71 = if GetFFlagMomentsGenerateTextInTextOverlay() and controller.getCanGenerateText(false) then React.createElement(GenerateTextButton, {
			controller = controller
		}) else nil
		v66.GenerateText = v71

		local v72 = if fFlagMomentsTextOverlayV2Redesign and v58 then React.createElement(module29, {
			controller = controller,
			mediaHeight = v8.Y
		}) else nil
		v66.VerticalFontSizeSlider = v72

		local v73 = if fFlagMomentsTextOverlayV2Redesign then React.createElement(view, {
			ZIndex = 5,
			tag = "position-bottom-center anchor-bottom-center",
			Size = UDim2.new(1, 0, 0, 200),
			backgroundStyle = { Color3 = Color3.new(0, 0, 0) }
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = numberSequence
			})
		}) else nil
		v66.BottomScrim = v73

		local v74 = if v38 then React.createElement(EditorTopNav, {
			onBack = v40,
			onSave = v41,
			backTestId = "--moments-creation-view-textoverlay-back",
			saveTestId = "--moments-creation-button-textoverlay-save",
			zIndex = 5
		}) else nil
		v66.TopNav = v74
		local v75

		if v19 then
			local createElement3 = React.createElement

			local v78 = if v62 == nil then UDim2.fromScale(1, 1) else UDim2.new(1, 0, 0, v62 - 16)
			v75 = createElement3(
				view,
				{ Size = v78, tag = "position-top-left anchor-top-left", ZIndex = 10 },
				{
					Toolbar = React.createElement(module30, {
						controller = controller,
						isKeyboardVisible = false,
						onAbsoluteSizeChanged = v21
					})
				}
			)
		elseif fFlagMomentsTextOverlayV2Redesign then
			v75 = React.createElement(module30, {
				controller = controller,
				isKeyboardVisible = v18 > 0
			})
		end

		v66.TextOverlayToolbar = v75
		return createElement(view, v65, v66)
	else
		if textOverlays == nil or #textOverlays == 0 then
			return nil
		end

		local v59 = v7 == CreationFlowState.Preview
		local v60 = v59 and not v52
		local v61 = fFlagMomentsTextOverlayV2Redesign and v59

		local v62 = fFlagMomentsTextOverlayV2Redesign and v59
		local v63 = fFlagMomentsTextOverlayV2Redesign and FFlagMomentsTextOverlayDragToDeleteRefinement
		local v64

		if getFFlagMomentsStickerButton() then
			local createElement = React.createElement
			local v66 = {
				clampToBoundsEnabled = not v63,
				unboundedDragEnabled = v63 and true or nil,
				draggable = v60,
				editable = false,
				itemResolution = v9,
				itemSize = v8,
				scaleType = Enum.ScaleType.Crop,
				onOverlayActivated = 0,
				onOverlayDragBegin = 0,
				onOverlayDragContinue = 0,
				onOverlayDragEnd = 0,
				onOverlayRotationChanged = 0,
				onOverlayScaleChanged = 0,
				overlayEdits = 0,
				overlayComponent = 0,
				selected = 0,
				visualScale = 0,
				zIndex = 0
			}

			if not v59 then
				v30 = nil
			end

			v66.onOverlayActivated = v30

			if not v59 then
				v54 = nil
			end

			v66.onOverlayDragBegin = v54

			if not v61 then
				v55 = nil
			end

			v66.onOverlayDragContinue = v55

			if not v59 then
				v56 = nil
			end

			v66.onOverlayDragEnd = v56

			if not v62 then
				v33 = nil
			end

			v66.onOverlayRotationChanged = v33

			if not v62 then
				v32 = nil
			end

			v66.onOverlayScaleChanged = v32
			v66.overlayEdits = textOverlays
			v66.overlayComponent = textOverlay
			v66.selected = v62

			if not v61 then
				v50 = nil
			end

			v66.visualScale = v50
			v66.zIndex = props.zIndex
			v64 = createElement(overlayDisplay, v66)
		else
			local createElement = React.createElement
			local v66 = {
				clampToBoundsEnabled = not v63,
				unboundedDragEnabled = v63 and true or nil,
				draggable = v60,
				editable = false,
				itemResolution = v9,
				itemSize = v8,
				scaleType = Enum.ScaleType.Crop,
				onTextOverlayActivated = 0,
				onTextOverlayDragBegin = 0,
				onTextOverlayDragContinue = 0,
				onTextOverlayDragEnd = 0,
				onTextOverlayRotationChanged = 0,
				onTextOverlayScaleChanged = 0,
				selected = 0,
				textOverlayEdits = 0,
				visualScale = 0,
				zIndex = 0
			}

			if not v59 then
				v30 = nil
			end

			v66.onTextOverlayActivated = v30

			if not v59 then
				v54 = nil
			end

			v66.onTextOverlayDragBegin = v54

			if not v61 then
				v55 = nil
			end

			v66.onTextOverlayDragContinue = v55

			if not v59 then
				v56 = nil
			end

			v66.onTextOverlayDragEnd = v56

			if not v62 then
				v33 = nil
			end

			v66.onTextOverlayRotationChanged = v33

			if not v62 then
				v32 = nil
			end

			v66.onTextOverlayScaleChanged = v32
			v66.selected = v62
			v66.textOverlayEdits = textOverlays

			if not v61 then
				v50 = nil
			end

			v66.visualScale = v50
			v66.zIndex = props.zIndex
			v64 = createElement(textOverlayDisplay, v66)
		end

		if v61 then
			return React.createElement(view, {
				tag = "size-full",
				ZIndex = props.zIndex or 1
			}, {
				Overlay = v64,
				TrashZone = React.createElement(TextOverlayTrashZone, {
					circleRef = v43,
					highlightScale = v48,
					label = textOverlayDragHereToDelete,
					ref = v42,
					visible = v46,
					ZIndex = (props.zIndex or 1) + 10
				})
			})
		end

		return v64
	end
end

return TextOverlayLayer
