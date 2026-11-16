local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local parent = MomentsCreationFlow.Parent

local TextService = game:GetService("TextService")

local Dash = require(parent.Dash)
local Foundation = require(parent.Foundation)
local MomentsCommon = require(parent.MomentsCommon)
local React = require(parent.React)

local useBinding = React.useBinding
local useCallback = React.useCallback
local useDeviceInsets = MomentsCommon.Hooks.useDeviceInsets
local useEffectOnce = require(MomentsCreationFlow.Hooks.useEffectOnce)
local useOnScreenKeyboardHeight = require(MomentsCreationFlow.Hooks.useOnScreenKeyboardHeight)
local useRef = React.useRef
local useState = React.useState
local useTokens = Foundation.Hooks.useTokens

local Knob = Foundation.Knob
local Slider = Foundation.Slider
local View = Foundation.View

local TextOverlay = MomentsCommon.TextOverlay

local function TextOverlayEditor(props)
	local v = useDeviceInsets()
	local v2 = useTokens()
	local textBoxRef = useRef(nil)
	local size, v3 = useBinding(UDim2.fromOffset(0, 0))
	local state, setState = useState(Vector2.new(0, 0))
	local v4 = useOnScreenKeyboardHeight()

	local v5 = props.textOverlayEdits and props.textOverlayEdits[1]

	local onActivated = useCallback(function()
		if textBoxRef.current then
			textBoxRef.current:CaptureFocus()
		end
	end, {})

	local onTextChanged = useCallback(function(p)
		local v6 = utf8.len(p.Text)

		if v6 ~= nil and v6 >= 100 then
			local v7 = utf8.offset(p.Text, 101)
			p.Text = string.sub(p.Text, 1, v7 - 1)
		end

		props.onTextOverlayUpdated({ Dash.joinDeep(v5, { text = p.Text }) })
	end, { v5, props.onTextOverlayUpdated })

	local onValueChanged = useCallback(function(fontSize: number)
		if not props.textOverlayEdits then
			return
		end

		local v6 = { (Dash.joinDeep(v5, {
				textOverlayStyle = { fontSize = fontSize }
			})) }
		props.onTextOverlayUpdated(v6)
	end, { props.onTextOverlayUpdated, v5 })

	local onAbsoluteSizeChanged = useCallback(function(p)
		setState(p.AbsoluteSize)
	end, {})

	local function fn()
		onActivated()
	end

	useEffectOnce(fn, textBoxRef.current ~= nil and props.textOverlayEdits ~= nil)

	React.useEffect(function()
		if not v5 then
			return
		end

		if v4 == 0 then
			v3(UDim2.fromOffset(0, 0))
			return
		end

		local textSize = TextService:GetTextSize(
			"W",
			v5.textOverlayStyle.fontSize,
			v5.textOverlayStyle.font,
			Vector2.new(state.X, state.Y)
		)

		v3(UDim2.fromOffset(math.min(textSize.X * 30, state.X / 2), (math.min(textSize.Y * 5, state.Y / 2))))
	end, { state, v5, v4 })

	if not props.textOverlayEdits then
		return nil
	end

	local createElement = React.createElement
	local v6 = {
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		tag = "bg-over-media-0 size-full",
		ZIndex = props.zIndex or 1
	}
	local controls

	if v4 == 0 then
		controls = React.createElement(
			View,
			{ tag = "auto-y anchor-bottom-center col gap-large position-bottom-center size-full-0" },
			{
				Padding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, v2.Padding.XLarge),
					PaddingBottom = UDim.new(0, v2.Padding.XLarge),
					PaddingLeft = UDim.new(0, (math.max(v.left, v2.Padding.XLarge))),
					PaddingRight = UDim.new(0, (math.max(v.right, v2.Padding.XLarge)))
				}),
				FontSizeSlider = React.createElement(Slider, {
					knob = React.createElement(Knob, { size = Foundation.Enums.InputSize.Large }),
					knobVisibility = Foundation.Enums.Visibility.Always,
					LayoutOrder = 2,
					onValueChanged = onValueChanged,
					size = Foundation.Enums.InputSize.XSmall,
					range = NumberRange.new(10, 32),
					value = props.textOverlayEdits[1].textOverlayStyle.fontSize,
					variant = Foundation.Enums.SliderVariant.Standard
				})
			}
		)
	end

	return createElement(View, v6, {
		Controls = controls,
		TextOverlay = React.createElement(TextOverlay, {
			editable = true,
			onActivated = onActivated,
			size = size,
			textOverlayEdit = Dash.joinDeep(v5, {
				position = UDim2.fromScale(0.5, 0.5),
				rotation = 0,
				scale = 1
			}),
			onTextChanged = onTextChanged,
			textBoxRef = textBoxRef
		})
	})
end

return TextOverlayEditor
