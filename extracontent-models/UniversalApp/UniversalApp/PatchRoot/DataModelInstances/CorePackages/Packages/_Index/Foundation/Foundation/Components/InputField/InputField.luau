local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
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
local t1 = {
	testId = "--foundation-input-field",
	size = InputLabelSize.Small
}

local function InputField(p1, p2) -- line: 45
	-- upvalues: withDefaults (copy), t1 (copy), useScaledValue (copy), Constants (copy), React (copy), View (copy), withCommonProps (copy), InputLabel (copy), HintText (copy)
	local v17 = withDefaults(p1, t1)
	local v18 = useScaledValue(Constants.DEFAULT_INPUT_FIELD_WIDTH_PIXELS)
	local v19 = React.useRef(nil)
	local v20 = React.useCallback(function() -- line: 50
		-- upvalues: v19 (copy)
		if v19.current and not v19.current.getIsFocused() then
			v19.current.focus()
		end
	end, {})

	React.useImperativeHandle(v17.textBoxRef, function() -- line: 56
		-- upvalues: v19 (copy)
		if not v19.current then
			return nil
		end

		return {
			focus = v19.current.focus,
			releaseFocus = v19.current.releaseFocus,
			getIsFocused = v19.current.getIsFocused,
			getCursorPosition = v19.current.getCursorPosition,
			getSelectionStart = v19.current.getSelectionStart,
			setCursorPosition = v19.current.setCursorPosition,
			setSelectionStart = v19.current.setSelectionStart
		}
	end, {})

	return React.createElement(View, withCommonProps(v17, {
		tag = "col gap-small auto-y",
		Size = if v17.width then UDim2.new(v17.width, UDim.new(0, 0)) else UDim2.fromOffset(v18, 0),
		ref = p2
	}), {
		Label = if not (#v17.label > 0) then nil else React.createElement(InputLabel, {
			LayoutOrder = 1,
			Text = v17.label,
			size = v17.size,
			isRequired = v17.isRequired,
			isDisabled = v17.isDisabled,
			onActivated = v20,
			testId = `{ v17.testId }--label`
		}),
		InputWrapper = React.createElement(View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 2,
			testId = `{ v17.testId }--input-wrapper`
		}, {
			Input = v17.input(v19)
		}),
		Hint = if not v17.hint then nil else React.createElement(HintText, {
			LayoutOrder = 3,
			text = v17.hint,
			hasError = v17.hasError,
			isDisabled = v17.isDisabled,
			testId = `{ v17.testId }--hint`
		})
	})
end

return React.memo(React.forwardRef(InputField))
