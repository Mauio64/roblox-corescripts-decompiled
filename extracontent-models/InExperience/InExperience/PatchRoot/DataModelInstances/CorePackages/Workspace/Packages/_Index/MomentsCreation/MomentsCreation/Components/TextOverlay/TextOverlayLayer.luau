local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local GuiService = game:GetService("GuiService")
local TextService = game:GetService("TextService")

local engineFeature = game:GetEngineFeature("UIDragDetectorFixEventPositionEnabled")

local Button = Foundation.Button
local View = Foundation.View

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

local OverlayDisplay = MomentsCommon.Components.OverlayDisplay
local TextOverlay = MomentsCommon.Components.TextOverlay
local TextOverlayDisplay = MomentsCommon.Components.TextOverlayDisplay
local getScale = MomentsCommon.Utils.getScale

local GetFFlagMomentsStickerButton = MomentsCommon.Flags.GetFFlagMomentsStickerButton
local GetFFlagEnableMomentTextGeneration = MomentsCommon.Flags.GetFFlagEnableMomentTextGeneration
local FFlagMomentsTextOverlayV2Redesign = MomentsCommon.Flags.FFlagMomentsTextOverlayV2Redesign
local EventNames = MomentsCommon.Analytics.EventNames
local fireAnalyticsEvent = require(MomentsCreation.Analytics.fireAnalyticsEvent)
local makeCreationEventFields = require(MomentsCreation.Analytics.makeCreationEventFields)

local CreationFlowState = require(MomentsCreation.Enums.CreationFlowState)
local Constants = require(MomentsCreation.Constants)
require(MomentsCreation.Types.CreationFlowTypes)
require(parent.MomentsTypes)
local TextOverlayTrashZone = require(MomentsCreation.Components.TextOverlay.TextOverlayTrashZone)
local useOnScreenKeyboardHeight = require(MomentsCreation.Hooks.useOnScreenKeyboardHeight)
local useOnScreenKeyboardTop = require(MomentsCreation.Hooks.useOnScreenKeyboardTop)
local useCreationFlowStrings = require(MomentsCreation.Hooks.useCreationFlowStrings)
local GetFFlagMomentsGenerateTextInTextOverlay = require(MomentsCreation.Flags.GetFFlagMomentsGenerateTextInTextOverlay)
local makeDefaultTextOverlayEdit = require(MomentsCreation.Utils.makeDefaultTextOverlayEdit)
local makeTextOverlayEditsForEditor = require(MomentsCreation.Utils.makeTextOverlayEditsForEditor)
local fitTextOverlayFontSize = require(MomentsCreation.Utils.fitTextOverlayFontSize)
local computeEditorChipLayout = require(MomentsCreation.Utils.computeEditorChipLayout)
local isPointOverTrashTarget = require(MomentsCreation.Utils.isPointOverTrashTarget)
local playDragToDeleteHaptic = require(MomentsCreation.Utils.playDragToDeleteHaptic)
local FFlagMomentsTextOverlayChipGrowAboveKeyboard = MomentsCommon.Flags.FFlagMomentsTextOverlayChipGrowAboveKeyboard

local FFlagMomentsTextOverlayToolbarWhileTyping = require(MomentsCreation.Flags.FFlagMomentsTextOverlayToolbarWhileTyping)
local FFlagMomentsTextOverlayEdgeClipFix = MomentsCommon.Flags.FFlagMomentsTextOverlayEdgeClipFix
local FFlagMomentsTextOverlayChipGrowWidth = require(MomentsCreation.Flags.FFlagMomentsTextOverlayChipGrowWidth)
local FFlagMomentsTextOverlayModalTextFix = require(MomentsCreation.Flags.FFlagMomentsTextOverlayModalTextFix)

local FFlagMomentsTextOverlayDragToDeleteRefinement = require(MomentsCreation.Flags.FFlagMomentsTextOverlayDragToDeleteRefinement)
local FFlagMomentsTextOverlayTopNav = require(MomentsCreation.Flags.FFlagMomentsTextOverlayTopNav)
local VerticalFontSizeSlider = require(MomentsCreation.Components.TextOverlay.VerticalFontSizeSlider)
local TextOverlayToolbar = require(MomentsCreation.Components.TextOverlay.TextOverlayToolbar)
local EditorTopNav = require(MomentsCreation.Components.EditorTopNav)

local v = { dampingRatio = 0.85, frequency = 12 }

local numberSequence = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0.2) })

local function resolveKeyboardTop(p: number?, y: number, p2: number) -- 1 equivalent call inferred from this helper
	return p or y - p2
end

local v2 = FFlagMomentsTextOverlayV2Redesign
	and FFlagMomentsTextOverlayChipGrowAboveKeyboard
	and FFlagMomentsTextOverlayToolbarWhileTyping

local function useToolbarWhileTyping(p, p2)
	local v3, state, v4

	if
		FFlagMomentsTextOverlayV2Redesign
		and FFlagMomentsTextOverlayChipGrowAboveKeyboard
		and FFlagMomentsTextOverlayToolbarWhileTyping
	then
		v3 = useOnScreenKeyboardTop()
		local setState
		state, setState = React.useState(0)
		v4 = useCallback(function(p3)
			setState(p3.AbsoluteSize.Y)
		end, {})
		local textOverlayStyle

		if p ~= nil then
			textOverlayStyle = p.textOverlayStyle
		end

		local current3

		if textOverlayStyle == nil then
			current3 = nil
		else
			current3 = `{tostring(textOverlayStyle.font)}|{tostring(textOverlayStyle.fontColor)}|{tostring(textOverlayStyle.textXAlignment)}`
		end

		local v5 = useRef(current3)
		useEffect(function()
			local current = v5.current
			v5.current = current3

			if current == nil or current3 == nil or current == current3 then
				return
			end

			local current2 = p2.current

			if current2 ~= nil and current2:IsFocused() then
				current2:ReleaseFocus()
			end
		end, { current3 })
	else
		state = 0
	end

	return state, v4, v3
end

local function GenerateTextButton(p)
	local controller = p.controller
	local v3 = useTokens()
	local v4 = useCreationFlowStrings()
	local isLoading = useSignalState(controller.getIsGenerating)

	local onActivated = useCallback(function()
		controller.beginTool("generateText")
	end, { controller })

	return React.createElement(View, {
		tag = "position-bottom-right anchor-bottom-right auto-xy",
		ZIndex = 10,
		padding = { bottom = UDim.new(0, v3.Padding.Large), right = UDim.new(0, v3.Padding.Large) }
	}, {
		Button = React.createElement(Button, {
			fillBehavior = Foundation.Enums.FillBehavior.Fit,
			icon = BuilderIcons.Icon.TagSparkle,
			text = v4.GenerateTextCta,
			variant = Foundation.Enums.ButtonVariant.Emphasis,
			onActivated = onActivated,
			isLoading = isLoading,
			size = Foundation.Enums.InputSize.Medium
		})
	})
end

local function TextOverlayLayer(props)
	local controller = props.controller

	local v3 = useSignalState(controller.getStep)
	local itemSize = useSignalState(props.ctx.getItemSize)
	local itemResolution = useSignalState(props.ctx.getItemResolution)
	local textOverlays = useSignalState(controller.getComposedEdits).textOverlays
	local scale = getScale(itemSize, itemResolution, Enum.ScaleType.Crop)

	local v4 = useSignalState((useMemo(function()
		return Signals.createComputed(function(p)
			local activeSession = controller.getActiveSession(p)

			if activeSession == nil then
				return nil
			end

			return (activeSession.getDraft(p))
		end)
	end, { controller })))

	local v5 = v3 == CreationFlowState.TextOverlay
	local v6 = v4 and v4[1]

	local textBoxRef = useRef(nil)
	local ref = useRef(nil)
	local v7, v8 = useBinding(UDim2.fromOffset(0, 0))
	local keyboardHeight = useOnScreenKeyboardHeight()

	local v9 = v2
	local v10, onAbsoluteSizeChanged, keyboardTop = useToolbarWhileTyping(v6, textBoxRef)
	local v11

	if FFlagMomentsTextOverlayModalTextFix then
		v11 = useSignalState(controller.getActiveModal)
	end

	local v12 = FFlagMomentsTextOverlayModalTextFix and v11 ~= nil
	local scale2

	if FFlagMomentsTextOverlayModalTextFix then
		scale2 = not (FFlagMomentsTextOverlayV2Redesign and scale > 0) and 1 or 1 / scale
	end

	local v13

	if FFlagMomentsTextOverlayV2Redesign then
		v13 = useMemo(function()
			if v6 == nil then
				return Constants.TextOverlay.DefaultFontSize
			end

			local fontSize = v6.textOverlayStyle.fontSize

			if keyboardHeight > 0 then
				return Constants.TextOverlay.DefaultFontSize
			end

			local v14 = math.min(300, itemSize.X * 0.9)

			if FFlagMomentsTextOverlayEdgeClipFix then
				local x = TextService:GetTextSize(
					" ",
					fontSize,
					v6.textOverlayStyle.font,
					Vector2.new(1000000, 1000000)
				).X
				v14 = math.min(276 - (math.ceil(fontSize * 0.08) + math.ceil(x) * 2), itemSize.X * 0.9)
			end

			local v15 = itemSize.Y * 0.8
			return fitTextOverlayFontSize(
				v6.text,
				v6.textOverlayStyle.font,
				fontSize,
				v14,
				v15,
				Constants.TextOverlay.MinFontSize
			)
		end, { v6, keyboardHeight, itemSize })
	elseif v6 == nil then
		v13 = Constants.TextOverlay.DefaultFontSize
	else
		v13 = v6.textOverlayStyle.fontSize
	end

	local onActivated = useCallback(function()
		if textBoxRef.current then
			textBoxRef.current:CaptureFocus()
		end
	end, {})

	local onActivated2 = useCallback(function()
		if textBoxRef.current then
			textBoxRef.current:ReleaseFocus()
		end
	end, {})

	local onTextChanged = useCallback(function(p)
		local activeSession = controller.getActiveSession(false)

		if activeSession == nil then
			return
		end

		local draft = activeSession.getDraft(false)
		local v14 = draft and draft[1]

		if v14 == nil then
			return
		end

		local v15 = utf8.len(p.Text)

		if v15 ~= nil and v15 >= 100 then
			local v16 = utf8.offset(p.Text, 101)

			if GetFFlagMomentsStickerButton() then
				if v16 then
					p.Text = string.sub(p.Text, 1, v16 - 1)
				end
			else
				p.Text = string.sub(p.Text, 1, v16 - 1)
			end
		end

		activeSession.update({ Dash.joinDeep(v14, { text = p.Text }) })
	end, { controller })

	local v14 = useCallback(function()
		if GetFFlagEnableMomentTextGeneration() and controller.getIsGenerating(false) then
			controller.onDisabledToolActivated("text")
		else
			controller.beginTool("text")
		end
	end, { controller })

	local v15 = useCallback(function(p)
		controller.updateCommittedEdit("text", p)
	end, { controller })

	local v16 = nil
	local v17 = nil
	local v18 = nil
	local v19 = nil
	local v20

	if FFlagMomentsTextOverlayV2Redesign then
		v18 = useRef(false)
		v19 = useRef(false)
		v20 = useRef(false)

		v16 = useCallback(function(scale3: number)
			local textOverlays2 = controller.getComposedEdits(false).textOverlays
			local v21 = textOverlays2 and textOverlays2[1]

			if v21 == nil then
				return
			end

			controller.updateCommittedEdit("text", { Dash.joinDeep(v21, { scale = scale3 }) })

			if not v18.current then
				v18.current = true
				fireAnalyticsEvent(
					EventNames.EditingFlowTextOverlayRescaleUsed,
					makeCreationEventFields.makeTextOverlayEventFields()
				)
			end
		end, { controller })

		v17 = useCallback(function(rotation: number)
			local textOverlays2 = controller.getComposedEdits(false).textOverlays
			local v21 = textOverlays2 and textOverlays2[1]

			if v21 == nil then
				return
			end

			controller.updateCommittedEdit("text", { Dash.joinDeep(v21, { rotation = rotation }) })

			if not v19.current then
				v19.current = true
				fireAnalyticsEvent(
					EventNames.EditingFlowTextOverlayRotateUsed,
					makeCreationEventFields.makeTextOverlayEventFields()
				)
			end
		end, { controller })
	else
		v20 = nil
	end

	local v21

	if FFlagMomentsTextOverlayV2Redesign then
		v21 = useDeviceInsets()
	else
		v21 = nil
	end

	local v22 = FFlagMomentsTextOverlayTopNav
	local v23, onBack, onSave

	if FFlagMomentsTextOverlayTopNav then
		v23 = useTokens()
		onBack = useCallback(function()
			controller.discardActiveTool()
		end, { controller })
		onSave = useCallback(function()
			controller.commitActiveTool()
		end, { controller })
	end

	local ref2 = useRef(nil)
	local circleRef, v24, textOverlayDragHereToDelete

	if FFlagMomentsTextOverlayDragToDeleteRefinement then
		circleRef = useRef(nil)
		v24 = useRef(nil)
		textOverlayDragHereToDelete = useCreationFlowStrings().TextOverlayDragHereToDelete
	else
		circleRef = nil
		v24 = nil
	end

	local v25 = useRef(false)

	local visible, v26 = useBinding(false)
	local highlightScale, v27 = useAnimatedBinding(1)
	local visualScale, v28 = useAnimatedBinding(1)
	local v29

	if FFlagMomentsTextOverlayV2Redesign then
		v29 = useIsMultiTouchActive(v3 == CreationFlowState.Preview)
	else
		v29 = false
	end

	local v30 = useCallback(function(vector2: Vector2)
		local current = ref2.current

		if current == nil then
			return false
		end

		local v30 = Vector2.zero

		if FFlagMomentsTextOverlayV2Redesign and not engineFeature and v21 ~= nil then
			v30 = GuiService:GetGuiInset() + Vector2.new(v21.left, v21.top)
		end

		local v31 = FFlagMomentsTextOverlayV2Redesign and 24 or 0

		if not (FFlagMomentsTextOverlayV2Redesign and FFlagMomentsTextOverlayDragToDeleteRefinement) then
			return isPointOverTrashTarget(vector2, v30, current.AbsolutePosition, current.AbsoluteSize, v31)
		end

		local current2

		if circleRef then
			current2 = circleRef.current
		end

		if current2 == nil or v24 == nil then
			return false
		end

		local v32 = vector2 - v30
		local radius = current2.AbsoluteSize.X / 2
		local center = current2.AbsolutePosition + current2.AbsoluteSize / 2

		if not v25.current and math.abs(highlightScale:getValue() - 1) < 0.01 then
			v24.current = { center = center, radius = radius }
		end

		local current3 = v24.current or {
			center = center,
			radius = radius / math.max(highlightScale:getValue(), 1)
		}

		if v25.current then
			return (v32 - current3.center).Magnitude <= current3.radius * 1.15 + 8
				or (v32 - center).Magnitude <= radius + 8
		end

		return (v32 - current3.center).Magnitude <= current3.radius
	end, { v21, highlightScale })

	local v31 = useCallback(function()
		if not FFlagMomentsTextOverlayV2Redesign then
			return
		end

		if props.ctx.setIsOverlayDragging then
			props.ctx.setIsOverlayDragging(true)
		end

		v25.current = false
		v27(ReactOtter.instant(1))
		v28(ReactOtter.instant(1))
		v26(true)

		if not v20.current then
			v20.current = true
			fireAnalyticsEvent(
				EventNames.EditingFlowTextOverlayRepositionUsed,
				makeCreationEventFields.makeTextOverlayEventFields()
			)
		end
	end, { props.ctx, v27, v28, v26 })

	local v32 = useCallback(function(vector2: Vector2)
		if not FFlagMomentsTextOverlayV2Redesign then
			return
		end

		local current = v30(vector2)

		if current == v25.current then
			return
		end

		v25.current = current

		if FFlagMomentsTextOverlayDragToDeleteRefinement and current then
			playDragToDeleteHaptic()
		end

		v27((ReactOtter.spring(current and 1.15 or 1, v)))

		v28((ReactOtter.spring(current and 0.45 or 1, v)))
	end, { v30, v27, v28 })

	local v52 = useCallback(function(p)
		if not FFlagMomentsTextOverlayV2Redesign then
			v15(p)
			return
		end

		if props.ctx.setIsOverlayDragging then
			props.ctx.setIsOverlayDragging(false)
		end

		local current = v25.current
		v25.current = false
		v26(false)
		v27(ReactOtter.instant(1))

		if current then
			fireAnalyticsEvent(
				EventNames.EditingFlowTextOverlayDeletedViaTrash,
				makeCreationEventFields.makeTextOverlayEventFields()
			)

			controller.updateCommittedEdit("text", nil)
		else
			v28(ReactOtter.instant(1))

			v15(p)
		end
	end, { props.ctx, controller, v15, v26, v27, v28 })

	useEffect(function()
		if not FFlagMomentsTextOverlayV2Redesign then
			return
		end

		if textOverlays == nil or #textOverlays == 0 then
			v28(ReactOtter.instant(1))
		end
	end, { textOverlays })

	if FFlagMomentsTextOverlayV2Redesign then
		useEffect(function()
			if not (FFlagMomentsTextOverlayV2Redesign and v29) then
				return
			end

			v25.current = false
			v26(false)
			v27(ReactOtter.instant(1))
			v28(ReactOtter.instant(1))

			if props.ctx.setIsOverlayDragging then
				props.ctx.setIsOverlayDragging(false)
			end
		end, { v29, props.ctx, v26, v27, v28 })
	end

	useEffect(function()
		if not v5 then
			return
		end

		local activeSession = controller.getActiveSession(false)

		if activeSession == nil or activeSession.getDraft(false) ~= nil then
			return
		end

		activeSession.update(makeTextOverlayEditsForEditor(textOverlays, makeDefaultTextOverlayEdit(), scale))
	end, { v5, textOverlays, controller, scale })

	local v53 = useRef(false)
	useEffect(function()
		if v5 then
			if v53.current or textBoxRef.current == nil or v6 == nil then
				return
			end

			onActivated()
			v53.current = true
		else
			v53.current = false

			if textBoxRef.current then
				textBoxRef.current:ReleaseFocus()
			end
		end
	end, { v5, v6, onActivated })

	if FFlagMomentsTextOverlayModalTextFix then
		local v54 = useRef(false)
		useEffect(function()
			local current = textBoxRef.current

			if v12 then
				if current ~= nil and current:IsFocused() then
					v54.current = true
					current:ReleaseFocus()
				end
			elseif v54.current then
				v54.current = false

				if v5 then
					onActivated()
				end
			end
		end, { v12, v5, onActivated })
	end

	useEffect(function()
		if
			not v5
			or v6 == nil
			or FFlagMomentsTextOverlayV2Redesign and FFlagMomentsTextOverlayChipGrowAboveKeyboard
		then
			return
		end

		if keyboardHeight == 0 then
			v8(UDim2.fromOffset(0, 0))
			return
		end

		local textSize = TextService:GetTextSize(
			"W",
			v13,
			v6.textOverlayStyle.font,
			Vector2.new(itemSize.X, itemSize.Y)
		)
		v8(UDim2.fromOffset(math.min(textSize.X * 30, itemSize.X / 2), (math.min(textSize.Y * 5, itemSize.Y / 2))))
	end, { v5, v6, v13, keyboardHeight, itemSize })
	local v54 = not FFlagMomentsTextOverlayV2Redesign or keyboardHeight == 0

	if v5 then
		if v6 == nil then
			return nil
		end

		local position = UDim2.fromScale(0.5, 0.5)
		local fontSize = v13
		local v57 = FFlagMomentsTextOverlayV2Redesign
			and FFlagMomentsTextOverlayChipGrowAboveKeyboard
			and keyboardHeight > 0
		local v58, size

		if v57 then
			local currentCamera = workspace.CurrentCamera
			local y

			if currentCamera then
				y = currentCamera.ViewportSize.Y
			else
				y = itemSize.Y
			end

			local layerTopY = not ref.current and 0 or ref.current.AbsolutePosition.Y
			v58 = resolveKeyboardTop(keyboardTop, y, keyboardHeight) - layerTopY -- inferred equivalent call

			local v61 = computeEditorChipLayout({
				text = v6.text,
				font = v6.textOverlayStyle.font,
				itemWidth = itemSize.X,
				maxChipWidth = 300,
				viewportHeight = y,
				keyboardHeight = keyboardHeight,
				keyboardTop = keyboardTop,
				layerTopY = layerTopY,
				keyboardGap = not (v9 and v10 > 0) and 48 or v10 + 16 + 12,
				topMargin = not v22 and 48 or layerTopY + v21.top + v23.Padding.Medium + v23.Size.Size_1000,
				chipPadding = 12,
				growWidthWithText = FFlagMomentsTextOverlayChipGrowWidth,
				overhangFraction = 0.08
			})

			fontSize = v61.fontSize
			size = v61.size
			position = v61.position
		end

		local createElement = React.createElement

		if not (FFlagMomentsTextOverlayV2Redesign and FFlagMomentsTextOverlayChipGrowAboveKeyboard) then
			onActivated2 = nil
		end

		local v60 = {
			onActivated = onActivated2,
			ref = ref,
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			tag = "size-full bg-over-media-0",
			ZIndex = props.zIndex or 1
		}

		local createElement2 = React.createElement
		local additionalScale

		if FFlagMomentsTextOverlayV2Redesign then
			additionalScale = scale
		end

		local v62 = {
			additionalScale = additionalScale,
			editable = true,
			fitToContent = keyboardHeight == 0,
			onActivated = onActivated,
			size = nil,
			textOverlayEdit = 0,
			onTextChanged = 0,
			textBoxRef = 0,
			textVisible = 0
		}

		if not v57 then
			size = v7
		end

		v62.size = size
		v62.textOverlayEdit = Dash.joinDeep(v6, {
			position = position,
			rotation = 0,
			scale = scale2,
			textOverlayStyle = { fontSize = fontSize }
		})

		v62.onTextChanged = onTextChanged
		v62.textBoxRef = textBoxRef
		v62.textVisible = not v12 and nil
		local v61 = {
			TextOverlay = createElement2(TextOverlay, v62),
			GenerateText = 0,
			VerticalFontSizeSlider = 0,
			BottomScrim = 0,
			TopNav = 0,
			TextOverlayToolbar = 0
		}
		local generateText

		if GetFFlagMomentsGenerateTextInTextOverlay() and controller.getCanGenerateText(false) then
			generateText = React.createElement(GenerateTextButton, { controller = controller })
		end

		v61.GenerateText = generateText
		local verticalFontSizeSlider

		if FFlagMomentsTextOverlayV2Redesign and v54 then
			verticalFontSizeSlider = React.createElement(VerticalFontSizeSlider, {
				controller = controller,
				mediaHeight = itemSize.Y
			})
		end

		v61.VerticalFontSizeSlider = verticalFontSizeSlider
		local bottomScrim

		if FFlagMomentsTextOverlayV2Redesign then
			bottomScrim = React.createElement(View, {
				ZIndex = 5,
				tag = "position-bottom-center anchor-bottom-center",
				Size = UDim2.new(1, 0, 0, 200),
				backgroundStyle = { Color3 = Color3.new(0, 0, 0) }
			}, {
				UIGradient = React.createElement("UIGradient", {
					Rotation = 90,
					Transparency = numberSequence
				})
			})
		end

		v61.BottomScrim = bottomScrim
		local topNav

		if v22 then
			topNav = React.createElement(EditorTopNav, {
				onBack = onBack,
				onSave = onSave,
				backTestId = "--moments-creation-view-textoverlay-back",
				saveTestId = "--moments-creation-button-textoverlay-save",
				zIndex = 5
			})
		end

		v61.TopNav = topNav
		local textOverlayToolbar

		if v9 then
			local createElement3 = React.createElement
			local size2

			if v58 == nil then
				size2 = UDim2.fromScale(1, 1)
			else
				size2 = UDim2.new(1, 0, 0, v58 - 16)
			end

			textOverlayToolbar = createElement3(
				View,
				{ Size = size2, tag = "position-top-left anchor-top-left", ZIndex = 10 },
				{
					Toolbar = React.createElement(TextOverlayToolbar, {
						controller = controller,
						isKeyboardVisible = false,
						onAbsoluteSizeChanged = onAbsoluteSizeChanged
					})
				}
			)
		elseif FFlagMomentsTextOverlayV2Redesign then
			textOverlayToolbar = React.createElement(TextOverlayToolbar, {
				controller = controller,
				isKeyboardVisible = keyboardHeight > 0
			})
		end

		v61.TextOverlayToolbar = textOverlayToolbar
		return createElement(View, v60, v61)
	else
		if textOverlays == nil or #textOverlays == 0 then
			return nil
		end

		local v55 = v3 == CreationFlowState.Preview
		local draggable = v55 and not v29
		local v57 = FFlagMomentsTextOverlayV2Redesign and v55

		local selected = FFlagMomentsTextOverlayV2Redesign and v55
		local v59 = FFlagMomentsTextOverlayV2Redesign and FFlagMomentsTextOverlayDragToDeleteRefinement
		local overlay

		if GetFFlagMomentsStickerButton() then
			local createElement = React.createElement
			local v61 = {
				clampToBoundsEnabled = not v59,
				unboundedDragEnabled = v59 and true or nil,
				draggable = draggable,
				editable = false,
				itemResolution = itemResolution,
				itemSize = itemSize,
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

			if not v55 then
				v14 = nil
			end

			v61.onOverlayActivated = v14

			if not v55 then
				v31 = nil
			end

			v61.onOverlayDragBegin = v31

			if not v57 then
				v32 = nil
			end

			v61.onOverlayDragContinue = v32

			if not v55 then
				v52 = nil
			end

			v61.onOverlayDragEnd = v52

			if not selected then
				v17 = nil
			end

			v61.onOverlayRotationChanged = v17

			if not selected then
				v16 = nil
			end

			v61.onOverlayScaleChanged = v16
			v61.overlayEdits = textOverlays
			v61.overlayComponent = TextOverlay
			v61.selected = selected

			if not v57 then
				visualScale = nil
			end

			v61.visualScale = visualScale
			v61.zIndex = props.zIndex
			overlay = createElement(OverlayDisplay, v61)
		else
			local createElement = React.createElement
			local v61 = {
				clampToBoundsEnabled = not v59,
				unboundedDragEnabled = v59 and true or nil,
				draggable = draggable,
				editable = false,
				itemResolution = itemResolution,
				itemSize = itemSize,
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

			if not v55 then
				v14 = nil
			end

			v61.onTextOverlayActivated = v14

			if not v55 then
				v31 = nil
			end

			v61.onTextOverlayDragBegin = v31

			if not v57 then
				v32 = nil
			end

			v61.onTextOverlayDragContinue = v32

			if not v55 then
				v52 = nil
			end

			v61.onTextOverlayDragEnd = v52

			if not selected then
				v17 = nil
			end

			v61.onTextOverlayRotationChanged = v17

			if not selected then
				v16 = nil
			end

			v61.onTextOverlayScaleChanged = v16
			v61.selected = selected
			v61.textOverlayEdits = textOverlays

			if not v57 then
				visualScale = nil
			end

			v61.visualScale = visualScale
			v61.zIndex = props.zIndex
			overlay = createElement(TextOverlayDisplay, v61)
		end

		if v57 then
			return React.createElement(View, {
				tag = "size-full",
				ZIndex = props.zIndex or 1
			}, {
				Overlay = overlay,
				TrashZone = React.createElement(TextOverlayTrashZone, {
					circleRef = circleRef,
					highlightScale = highlightScale,
					label = textOverlayDragHereToDelete,
					ref = ref2,
					visible = visible,
					ZIndex = (props.zIndex or 1) + 10
				})
			})
		end

		return overlay
	end
end

return TextOverlayLayer
