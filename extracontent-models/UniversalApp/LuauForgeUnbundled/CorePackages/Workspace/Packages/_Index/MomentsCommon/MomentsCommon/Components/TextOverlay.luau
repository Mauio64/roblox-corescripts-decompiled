local TextService = game:GetService("TextService")

local FFlagMomentsTextOverlayFixedContrast = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsTextOverlayFixedContrast")

local FFlagMomentsTextOverlayChipGrowAboveKeyboard = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsTextOverlayChipGrowAboveKeyboard")
local FFlagMomentsTextOverlayEdgeClipFix = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsTextOverlayEdgeClipFix")
local FFlagMomentsTextOverlayV2Redesign = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/FFlagMomentsTextOverlayV2Redesign")
local GetFFlagMomentsStickerButton = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Flags/GetFFlagMomentsStickerButton")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/React")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/Responsive")
local view = Foundation.View

local useCallback = React.useCallback
local useState = React.useState

require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsTypes")
local TextOverlaySelectionControls = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Components/TextOverlaySelectionControls")
local insertNewlineAtCursor = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/MomentsCommon/Utils/insertNewlineAtCursor")

local v5 = { [Enum.Font.LuckiestGuy] = 0.12 }

local v6 = { [Enum.Font.Bangers] = 0.08 }

local color = Color3.fromHex("FFFFFF")

local function composeScale(p2, value)
	if value == nil then
		return p2
	end

	if typeof(value) == "number" then
		return p2 * value
	end

	return value:map(function(p3)
		return p2 * p3
	end)
end

local function TextOverlay(props)
	local v7 = if GetFFlagMomentsStickerButton() then props.overlayEdit or props.textOverlayEdit else props.textOverlayEdit

	local contrast = if FFlagMomentsTextOverlayFixedContrast then Foundation.Hooks.useTokens().DarkMode.System.Contrast else nil
	local state, setState, v8, v9

	if FFlagMomentsTextOverlayV2Redesign then
		state, setState = useState(false)

		v8 = Responsive.usePreferredInput()

		v9 = React.useBinding(0)
	else
		setState = nil
	end

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v10 = useCallback(function(p2, current)
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

	local v11 = useCallback(function(p2, p3)
		if props.onDragContinue then
			props.onDragContinue(p3)
		end
	end, { props.onDragContinue })

	local v12 = useCallback(function(p2, p3)
		if ref2.current == p3 and props.onActivated then
			props.onActivated()
		end

		if props.onDragEnd then
			props.onDragEnd()
		end

		if setState and props.selected == true then
			setState(false)
		end
	end, { props.onActivated, props.onDragEnd, props.selected })

	local v13 = React.useMemo(function()
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
			[React.Event.DragStart] = v10,
			[React.Event.DragContinue] = v11,
			[React.Event.DragEnd] = v12
		})
	end, { props.boundingUI, props.draggable, props.referenceUI, v10, v11, v12 })

	local v14 = props.size
	local v15

	if FFlagMomentsTextOverlayV2Redesign and props.editable == true then
		v15 = React.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(300, 1e999)
		})
	end

	local v16 = if FFlagMomentsTextOverlayV2Redesign then v5[v7.textOverlayStyle.font] else nil

	local v17 = not v16 and 0 or math.ceil(v7.textOverlayStyle.fontSize * v16)

	local v18 = if props.fitToContent == nil then props.size == nil else props.fitToContent

	local v19 = 0
	local v20

	if FFlagMomentsTextOverlayV2Redesign and v18 then
		local v21 = v6[v7.textOverlayStyle.font] or 0.03

		v20 = math.ceil(v7.textOverlayStyle.fontSize * v21)

		if FFlagMomentsTextOverlayEdgeClipFix then
			v19 = math.ceil(TextService:GetTextSize(
				" ",
				v7.textOverlayStyle.fontSize,
				v7.textOverlayStyle.font,
				Vector2.new(1000000, 1000000)
			).X)
		end

		local v22 = 276 - v20 - v19 * 2
		local textSize = TextService:GetTextSize(
			v7.text,
			v7.textOverlayStyle.fontSize,
			v7.textOverlayStyle.font,
			Vector2.new(v22, 1000000)
		)

		v14 = UDim2.fromOffset(math.ceil(textSize.X) + v20 + v19 * 2, math.ceil(textSize.Y) + v17)
		v15 = nil
	else
		v20 = 0
	end

	local v21 = v20 + v19
	local v22

	if v16 or v21 > 0 then
		local createElement = React.createElement
		local v25 = if v19 > 0 then UDim.new(0, v19) else nil
		local v26 = if v16 then UDim.new(0, v17) else nil
		local v27 = if v21 > 0 then UDim.new(0, v21) else nil
		v22 = createElement("UIPadding", {
			PaddingLeft = v25,
			PaddingTop = v26,
			PaddingRight = v27
		})
	end

	local v23 = FFlagMomentsTextOverlayV2Redesign and FFlagMomentsTextOverlayChipGrowAboveKeyboard

	if v23 then
		v23 = props.editable == true and v8 == Responsive.Input.Touch
	end

	local v24 = useCallback(function(instance)
		local text = instance.Text
		task.defer(function()
			if instance.Parent == nil or instance.Text ~= text then
				return
			end

			local v25, v26 = insertNewlineAtCursor(instance.Text, instance.CursorPosition)
			instance.Text = v25
			instance.CursorPosition = v26
		end)
	end, {})

	local createElement = React.createElement
	local v26 = {}
	v26.AutomaticSize = Enum.AutomaticSize.XY
	v26.BackgroundTransparency = 1
	v26.ClearTextOnFocus = false
	v26.ClipsDescendants = true
	v26.Font = v7.textOverlayStyle.font
	v26.Interactable = props.editable == true

	v26.MultiLine = FFlagMomentsTextOverlayV2Redesign and props.editable == true
	v26.ManualFocusRelease = v23 and true or nil
	v26.ShouldEmitReturnEvents = v23 and true or nil
	local returnPressedFromOnScreenKeyboard = React.Event.ReturnPressedFromOnScreenKeyboard

	if not v23 then
		v24 = nil
	end

	v26[returnPressedFromOnScreenKeyboard] = v24

	v26.Text = v7.text
	v26.TextColor3 = v7.textOverlayStyle.fontColor
	v26.TextSize = v7.textOverlayStyle.fontSize
	v26.TextXAlignment = v7.textOverlayStyle.textXAlignment
	v26.TextYAlignment = Enum.TextYAlignment.Center
	v26.TextWrapped = true
	v26.Selectable = props.editable == true
	v26.Size = v14
	local v27 = if props.textVisible == false then false else nil
	v26.Visible = v27
	v26.ZIndex = v7.zIndex
	v26.ref = props.textBoxRef
	v26[React.Change.Text] = props.onTextChanged
	local element = createElement("TextBox", v26, {
		WrapWidth = v15,
		FontQuirkPadding = v22
	})

	local v28 = {
		ref = props.containerRef,
		onActivated = props.onActivated,
		onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
		Position = v7.position,
		Rotation = v7.rotation,
		scale = 0,
		stateLayer = 0,
		ZIndex = 0
	}
	local scale = v7.scale
	local additionalScale = props.additionalScale
	local v29

	if additionalScale == nil then
		v29 = scale
	elseif typeof(additionalScale) == "number" then
		v29 = scale * additionalScale
	else
		v29 = additionalScale:map(function(p2)
			return scale * p2
		end)
	end

	v28.scale = v29
	v28.stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None }
	v28.ZIndex = v7.zIndex

	local vector2 = Vector2.new(300, 1e999)

	if FFlagMomentsTextOverlayV2Redesign and props.selected == true then
		local v30 = v8 == Responsive.Input.Pointer and not state

		local v31 = {
			GroupTransparency = v9,
			scale = v28.scale,
			sizeConstraint = { MaxSize = vector2 },
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			tag = "auto-xy padding-medium radius-medium bg-contrast"
		}

		if FFlagMomentsTextOverlayFixedContrast then
			v31.backgroundStyle = contrast
			v31.tag = "auto-xy padding-medium radius-medium"
		end

		local element2 = React.createElement(view, v31, { TextInput = element })

		local element3 = React.createElement(view, {
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
				Transparency = v30 and 0.45 or 1
			},
			tag = "auto-xy radius-medium",
			ZIndex = 1
		}, { Chip = element2 })

		v28.scale = nil
		v28.tag = "position-center-center anchor-center-center auto-xy"
		return React.createElement(view, v28, {
			UIDragDetector = v13,
			Selection = element3,
			SelectionControls = React.createElement(TextOverlaySelectionControls, {
				borderGap = 4,
				containerRef = props.containerRef,
				onRotationChanged = props.onRotationChanged,
				onScaleChanged = props.onScaleChanged,
				rotation = v7.rotation,
				scale = v7.scale,
				visible = v30
			})
		})
	elseif FFlagMomentsTextOverlayV2Redesign then
		local v30 = {
			GroupTransparency = v9,
			scale = v28.scale,
			sizeConstraint = { MaxSize = vector2 },
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			tag = "auto-xy padding-medium radius-medium bg-contrast"
		}

		if FFlagMomentsTextOverlayFixedContrast then
			v30.backgroundStyle = contrast
			v30.tag = "auto-xy padding-medium radius-medium"
		end

		local element2 = React.createElement(view, v30, { TextInput = element })

		v28.scale = nil
		v28.tag = "position-center-center anchor-center-center auto-xy"
		return React.createElement(view, v28, {
			UIDragDetector = v13,
			Chip = element2
		})
	else
		v28.tag = "position-center-center anchor-center-center auto-xy padding-medium radius-medium bg-contrast"
		v28.sizeConstraint = { MaxSize = vector2 }

		if FFlagMomentsTextOverlayFixedContrast then
			v28.backgroundStyle = contrast
			v28.tag = "position-center-center anchor-center-center auto-xy padding-medium radius-medium"
		end

		return React.createElement(view, v28, {
			UIDragDetector = v13,
			TextInput = element
		})
	end
end

return TextOverlay
