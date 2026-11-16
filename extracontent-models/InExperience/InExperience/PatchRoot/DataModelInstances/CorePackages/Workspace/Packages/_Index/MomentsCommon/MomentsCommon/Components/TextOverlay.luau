local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local parent = MomentsCommon.Parent

local TextService = game:GetService("TextService")

local FFlagMomentsTextOverlayFixedContrast = require(MomentsCommon.Flags.FFlagMomentsTextOverlayFixedContrast)

local FFlagMomentsTextOverlayChipGrowAboveKeyboard = require(MomentsCommon.Flags.FFlagMomentsTextOverlayChipGrowAboveKeyboard)
local FFlagMomentsTextOverlayEdgeClipFix = require(MomentsCommon.Flags.FFlagMomentsTextOverlayEdgeClipFix)
local FFlagMomentsTextOverlayV2Redesign = require(MomentsCommon.Flags.FFlagMomentsTextOverlayV2Redesign)
local GetFFlagMomentsStickerButton = require(MomentsCommon.Flags.GetFFlagMomentsStickerButton)
local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Responsive = require(parent.Responsive)
local View = Foundation.View

local useCallback = React.useCallback
local useState = React.useState

require(parent.MomentsTypes)
local TextOverlaySelectionControls = require(MomentsCommon.Components.TextOverlaySelectionControls)
local insertNewlineAtCursor = require(MomentsCommon.Utils.insertNewlineAtCursor)

local v = { [Enum.Font.LuckiestGuy] = 0.12 }

local v2 = { [Enum.Font.Bangers] = 0.08 }

local color = Color3.fromHex("FFFFFF")

local function composeScale(scale: number, additionalScale) -- 1 equivalent call inferred from this helper
	if additionalScale == nil then
		return scale
	end

	if typeof(additionalScale) == "number" then
		return scale * additionalScale
	end

	return additionalScale:map(function(p: number)
		return scale * p
	end)
end

local function TextOverlay(props)
	local v3

	if GetFFlagMomentsStickerButton() then
		v3 = props.overlayEdit or props.textOverlayEdit
	else
		v3 = props.textOverlayEdit
	end

	local contrast

	if FFlagMomentsTextOverlayFixedContrast then
		contrast = Foundation.Hooks.useTokens().DarkMode.System.Contrast
	end

	local state, setState, v4, groupTransparency

	if FFlagMomentsTextOverlayV2Redesign then
		state, setState = useState(false)

		v4 = Responsive.usePreferredInput()

		groupTransparency = React.useBinding(0)
	else
		setState = nil
	end

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v5 = useCallback(function(_, current: Vector2)
		if props.containerRef and props.containerRef.current then
			ref2.current = current
		end

		if setState and props.selected == true then
			setState(true)
		end

		if props.onDragBegin then
			props.onDragBegin()
		end
	end, { props.containerRef, props.onDragBegin, props.selected })

	local v6 = useCallback(function(_, vector2: Vector2)
		if props.onDragContinue then
			props.onDragContinue(vector2)
		end
	end, { props.onDragContinue })

	local v7 = useCallback(function(_, vector2: Vector2)
		if ref2.current == vector2 and props.onActivated then
			props.onActivated()
		end

		if props.onDragEnd then
			props.onDragEnd()
		end

		if setState and props.selected == true then
			setState(false)
		end
	end, { props.onActivated, props.onDragEnd, props.selected })

	local uiDragDetector = React.useMemo(function()
		if not props.draggable then
			return nil
		end

		return React.createElement("UIDragDetector", {
			BoundingBehavior = Enum.UIDragDetectorBoundingBehavior.EntireObject,
			BoundingUI = props.boundingUI,
			DragStyle = Enum.UIDragDetectorDragStyle.TranslatePlane,
			ref = ref,
			ReferenceUIInstance = props.referenceUI or props.boundingUI,
			ResponseStyle = Enum.UIDragDetectorResponseStyle.Scale,
			[React.Event.DragStart] = v5,
			[React.Event.DragContinue] = v6,
			[React.Event.DragEnd] = v7
		})
	end, { props.boundingUI, props.draggable, props.referenceUI, v5, v6, v7 })

	local size = props.size
	local wrapWidth

	if FFlagMomentsTextOverlayV2Redesign and props.editable == true then
		wrapWidth = React.createElement("UISizeConstraint", { MaxSize = Vector2.new(300, 1e999) })
	end

	local v8

	if FFlagMomentsTextOverlayV2Redesign then
		v8 = v[v3.textOverlayStyle.font]
	end

	local v9 = not v8 and 0 or math.ceil(v3.textOverlayStyle.fontSize * v8)
	local v10

	if props.fitToContent == nil then
		v10 = props.size == nil
	else
		v10 = props.fitToContent
	end

	local v11 = 0
	local v12

	if FFlagMomentsTextOverlayV2Redesign and v10 then
		local v13 = v2[v3.textOverlayStyle.font] or 0.03

		v12 = math.ceil(v3.textOverlayStyle.fontSize * v13)

		if FFlagMomentsTextOverlayEdgeClipFix then
			v11 = math.ceil(TextService:GetTextSize(
				" ",
				v3.textOverlayStyle.fontSize,
				v3.textOverlayStyle.font,
				Vector2.new(1000000, 1000000)
			).X)
		end

		local v14 = 276 - v12 - v11 * 2
		local textSize = TextService:GetTextSize(
			v3.text,
			v3.textOverlayStyle.fontSize,
			v3.textOverlayStyle.font,
			Vector2.new(v14, 1000000)
		)

		size = UDim2.fromOffset(math.ceil(textSize.X) + v12 + v11 * 2, math.ceil(textSize.Y) + v9)
		wrapWidth = nil
	else
		v12 = 0
	end

	local v13 = v12 + v11
	local fontQuirkPadding

	if v8 or v13 > 0 then
		local createElement = React.createElement
		local paddingLeft

		if v11 > 0 then
			paddingLeft = UDim.new(0, v11)
		end

		local paddingTop

		if v8 then
			paddingTop = UDim.new(0, v9)
		end

		local paddingRight

		if v13 > 0 then
			paddingRight = UDim.new(0, v13)
		end

		fontQuirkPadding = createElement("UIPadding", {
			PaddingLeft = paddingLeft,
			PaddingTop = paddingTop,
			PaddingRight = paddingRight
		})
	end

	local v14 = FFlagMomentsTextOverlayV2Redesign and FFlagMomentsTextOverlayChipGrowAboveKeyboard

	if v14 then
		if props.editable == true then
			v14 = v4 == Responsive.Input.Touch
		else
			v14 = false
		end
	end

	local v15 = useCallback(function(instance)
		local text = instance.Text
		task.defer(function()
			if instance.Parent == nil or instance.Text ~= text then
				return
			end

			local text2, cursorPosition = insertNewlineAtCursor(instance.Text, instance.CursorPosition)
			instance.Text = text2
			instance.CursorPosition = cursorPosition
		end)
	end, {})

	local createElement = React.createElement
	local v16 = {}
	v16.AutomaticSize = Enum.AutomaticSize.XY
	v16.BackgroundTransparency = 1
	v16.ClearTextOnFocus = false
	v16.ClipsDescendants = true
	v16.Font = v3.textOverlayStyle.font
	v16.Interactable = props.editable == true

	v16.MultiLine = FFlagMomentsTextOverlayV2Redesign and props.editable == true
	v16.ManualFocusRelease = v14 and true or nil
	v16.ShouldEmitReturnEvents = v14 and true or nil
	local returnPressedFromOnScreenKeyboard = React.Event.ReturnPressedFromOnScreenKeyboard

	if not v14 then
		v15 = nil
	end

	v16[returnPressedFromOnScreenKeyboard] = v15

	v16.Text = v3.text
	v16.TextColor3 = v3.textOverlayStyle.fontColor
	v16.TextSize = v3.textOverlayStyle.fontSize
	v16.TextXAlignment = v3.textOverlayStyle.textXAlignment
	v16.TextYAlignment = Enum.TextYAlignment.Center
	v16.TextWrapped = true
	v16.Selectable = props.editable == true
	v16.Size = size
	v16.Visible = props.textVisible ~= false and nil
	v16.ZIndex = v3.zIndex
	v16.ref = props.textBoxRef
	v16[React.Change.Text] = props.onTextChanged
	local element = createElement("TextBox", v16, {
		WrapWidth = wrapWidth,
		FontQuirkPadding = fontQuirkPadding
	})

	local v17 = {
		ref = props.containerRef,
		onActivated = props.onActivated,
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
		Position = v3.position,
		Rotation = v3.rotation,
		scale = composeScale(v3.scale, props.additionalScale), -- inferred equivalent call
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		ZIndex = v3.zIndex
	}

	local vector2 = Vector2.new(300, 1e999)

	if FFlagMomentsTextOverlayV2Redesign and props.selected == true then
		local visible

		if v4 == Responsive.Input.Pointer then
			visible = not state
		else
			visible = false
		end

		local v18 = {
			GroupTransparency = groupTransparency,
			scale = v17.scale,
			sizeConstraint = { MaxSize = vector2 },
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			tag = "auto-xy padding-medium radius-medium bg-contrast"
		}

		if FFlagMomentsTextOverlayFixedContrast then
			v18.backgroundStyle = contrast
			v18.tag = "auto-xy padding-medium radius-medium"
		end

		local element2 = React.createElement(View, v18, { TextInput = element })

		local element3 = React.createElement(View, {
			padding = {
				bottom = UDim.new(0, 4),
				left = UDim.new(0, 4),
				right = UDim.new(0, 4),
				top = UDim.new(0, 4)
			},
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			stroke = {
				Color = color,
				Thickness = 1.5,
				Transparency = visible and 0.45 or 1
			},
			tag = "auto-xy radius-medium",
			ZIndex = 1
		}, { Chip = element2 })

		v17.scale = nil
		v17.tag = "position-center-center anchor-center-center auto-xy"
		return React.createElement(View, v17, {
			UIDragDetector = uiDragDetector,
			Selection = element3,
			SelectionControls = React.createElement(TextOverlaySelectionControls, {
				borderGap = 4,
				containerRef = props.containerRef,
				onRotationChanged = props.onRotationChanged,
				onScaleChanged = props.onScaleChanged,
				rotation = v3.rotation,
				scale = v3.scale,
				visible = visible
			})
		})
	elseif FFlagMomentsTextOverlayV2Redesign then
		local v18 = {
			GroupTransparency = groupTransparency,
			scale = v17.scale,
			sizeConstraint = { MaxSize = vector2 },
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			tag = "auto-xy padding-medium radius-medium bg-contrast"
		}

		if FFlagMomentsTextOverlayFixedContrast then
			v18.backgroundStyle = contrast
			v18.tag = "auto-xy padding-medium radius-medium"
		end

		local element2 = React.createElement(View, v18, { TextInput = element })

		v17.scale = nil
		v17.tag = "position-center-center anchor-center-center auto-xy"
		return React.createElement(View, v17, { UIDragDetector = uiDragDetector, Chip = element2 })
	else
		v17.tag = "position-center-center anchor-center-center auto-xy padding-medium radius-medium bg-contrast"
		v17.sizeConstraint = { MaxSize = vector2 }

		if FFlagMomentsTextOverlayFixedContrast then
			v17.backgroundStyle = contrast
			v17.tag = "position-center-center anchor-center-center auto-xy padding-medium radius-medium"
		end

		return React.createElement(View, v17, {
			UIDragDetector = uiDragDetector,
			TextInput = element
		})
	end
end

return TextOverlay
