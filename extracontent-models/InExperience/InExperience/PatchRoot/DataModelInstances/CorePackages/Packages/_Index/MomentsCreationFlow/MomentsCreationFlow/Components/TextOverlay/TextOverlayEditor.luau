local MomentsCreationFlow = script:FindFirstAncestor("MomentsCreationFlow")
local MomentsCreationFlowParent = MomentsCreationFlow.Parent
local TextService = game:GetService("TextService")
local Dash = require(MomentsCreationFlowParent.Dash)
local Foundation = require(MomentsCreationFlowParent.Foundation)
local MomentsCommon = require(MomentsCreationFlowParent.MomentsCommon)
local React = require(MomentsCreationFlowParent.React)
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

local function TextOverlayEditor(t1: {[any]: any}) -- line: 41
	-- upvalues: useDeviceInsets (copy), useTokens (copy), useRef (copy), useBinding (copy), useState (copy), useOnScreenKeyboardHeight (copy), useCallback (copy), Dash (copy), useEffectOnce (copy), React (copy), TextService (copy), View (copy), Foundation (copy), Slider (copy), Knob (copy), TextOverlay (copy)
	local v22 = useDeviceInsets()
	local v23 = useTokens()
	local v24 = useRef(nil)
	local v25, v26 = useBinding(UDim2.fromOffset(0, 0))
	local v27, v28 = useState(Vector2.new(0, 0))
	local v29 = useOnScreenKeyboardHeight()
	local v30 = t1.textOverlayEdits and t1.textOverlayEdits[1]
	local v31 = useCallback(function() -- line: 51
		-- upvalues: v24 (copy)
		if v24.current then
			v24.current:CaptureFocus()
		end
	end, {})
	local v32 = useCallback(function(p1) -- line: 57
		-- upvalues: t1 (copy), Dash (copy), v30 (copy)
		local v36 = utf8.len(p1.Text)

		if v36 ~= nil and v36 >= 100 then
			local v37 = utf8.offset(p1.Text, 101)

			p1.Text = string.sub(p1.Text, 1, v37 - 1)
		end

		t1.onTextOverlayUpdated({ Dash.joinDeep(v30, {
			text = p1.Text
		}) })
	end, {
		v30,
		t1.onTextOverlayUpdated
	})
	local v33 = useCallback(function(n1: number) -- line: 69
		-- upvalues: t1 (copy), Dash (copy), v30 (copy)
		if not t1.textOverlayEdits then
			return
		end

		local v39 = Dash.joinDeep(v30, {
			textOverlayStyle = {
				fontSize = n1
			}
		})

		t1.onTextOverlayUpdated({ v39 })
	end, {
		t1.onTextOverlayUpdated,
		v30
	})
	local v34 = useCallback(function(p2) -- line: 82
		-- upvalues: v28 (copy)
		v28(p2.AbsoluteSize)
	end, {})

	useEffectOnce(function() -- line: 86
		-- upvalues: v31 (copy)
		v31()
	end, v24.current ~= nil and t1.textOverlayEdits ~= nil)
	React.useEffect(function() -- line: 90
		-- upvalues: v30 (copy), v29 (copy), v26 (copy), TextService (copy), v27 (copy)
		if not v30 then
			return
		end

		if v29 == 0 then
			v26(UDim2.fromOffset(0, 0))

			return
		end

		local TextSize = TextService:GetTextSize("W", v30.textOverlayStyle.fontSize, v30.textOverlayStyle.font, Vector2.new(v27.X, v27.Y))

		v26(UDim2.fromOffset(math.min(TextSize.X * 30, v27.X / 2), (math.min(TextSize.Y * 5, v27.Y / 2))))
	end, {
		v27,
		v30,
		v29
	})

	if not t1.textOverlayEdits then
		return nil
	end

	return React.createElement(View, {
		tag = "bg-over-media-0 size-full",
		onAbsoluteSizeChanged = v34,
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		ZIndex = t1.zIndex or 1
	}, {
		Controls = if v29 ~= 0 then nil else React.createElement(View, {
			tag = "auto-y anchor-bottom-center col gap-large position-bottom-center size-full-0"
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v23.Padding.XLarge),
				PaddingBottom = UDim.new(0, v23.Padding.XLarge),
				PaddingLeft = UDim.new(0, (math.max(v22.left, v23.Padding.XLarge))),
				PaddingRight = UDim.new(0, (math.max(v22.right, v23.Padding.XLarge)))
			}),
			FontSizeSlider = React.createElement(Slider, {
				LayoutOrder = 2,
				knob = React.createElement(Knob, {
					size = Foundation.Enums.InputSize.Large
				}),
				knobVisibility = Foundation.Enums.Visibility.Always,
				onValueChanged = v33,
				size = Foundation.Enums.InputSize.XSmall,
				range = NumberRange.new(10, 32),
				value = t1.textOverlayEdits[1].textOverlayStyle.fontSize,
				variant = Foundation.Enums.SliderVariant.Standard
			})
		}),
		TextOverlay = React.createElement(TextOverlay, {
			editable = true,
			onActivated = v31,
			size = v25,
			textOverlayEdit = Dash.joinDeep(v30, {
				rotation = 0,
				scale = 1,
				position = UDim2.fromScale(0.5, 0.5)
			}),
			onTextChanged = v32,
			textBoxRef = v24
		})
	})
end

return TextOverlayEditor
