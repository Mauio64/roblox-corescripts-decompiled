local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Components = Foundation.Components
local HintText = require(Components.HintText)
local InputLabel = require(Components.InputLabel)
require(Components.Types)
local View = require(Components.View)

local useScaledValue = require(Foundation.Utility.useScaledValue)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local Constants = require(Foundation.Constants)

local InputLabelSize = require(Foundation.Enums.InputLabelSize)

local v = { size = InputLabelSize.Small, testId = "--foundation-input-field" }

local function InputField(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useScaledValue(Constants.DEFAULT_INPUT_FIELD_WIDTH_PIXELS)
	local ref2 = React.useRef(nil)

	local onActivated = React.useCallback(function()
		if ref2.current and not ref2.current.getIsFocused() then
			ref2.current.focus()
		end
	end, {})

	React.useImperativeHandle(v2.textBoxRef, function()
		if ref2.current then
			return {
				focus = ref2.current.focus,
				releaseFocus = ref2.current.releaseFocus,
				getIsFocused = ref2.current.getIsFocused,
				getCursorPosition = ref2.current.getCursorPosition,
				getSelectionStart = ref2.current.getSelectionStart,
				setCursorPosition = ref2.current.setCursorPosition,
				setSelectionStart = ref2.current.setSelectionStart
			}
		end

		return nil
	end, {})

	local createElement = React.createElement
	local size

	if v2.width then
		size = UDim2.new(v2.width, UDim.new(0, 0))
	else
		size = UDim2.fromOffset(v3, 0)
	end

	local v4 = withCommonProps(v2, { Size = size, tag = "col gap-small auto-y", ref = ref })
	local label

	if #v2.label > 0 then
		label = React.createElement(InputLabel, {
			Text = v2.label,
			size = v2.size,
			isRequired = v2.isRequired,
			isDisabled = v2.isDisabled,
			onActivated = onActivated,
			LayoutOrder = 1,
			testId = `{v2.testId}--label`
		})
	end

	local v5 = {
		Label = label,
		InputWrapper = React.createElement(
			View,
			{ tag = "size-full-0 auto-y", LayoutOrder = 2, testId = `{v2.testId}--input-wrapper` },
			{ Input = v2.input(ref2) }
		),
		Hint = 0
	}
	local hint

	if v2.hint then
		hint = React.createElement(HintText, {
			text = v2.hint,
			hasError = v2.hasError,
			isDisabled = v2.isDisabled,
			LayoutOrder = 3,
			testId = `{v2.testId}--hint`
		})
	end

	v5.Hint = hint
	return createElement(View, v4, v5)
end

return React.memo(React.forwardRef(InputField))
