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
local Flags = require(Foundation.Utility.Flags)
local InputLabelSize = require(Foundation.Enums.InputLabelSize)
local t1 = {
	testId = "--foundation-input-field",
	size = InputLabelSize.Small
}

local function InputField(p1, p2) -- line: 46
	-- upvalues: withDefaults (copy), t1 (copy), useScaledValue (copy), Constants (copy), React (copy), Flags (copy), View (copy), withCommonProps (copy), InputLabel (copy), HintText (copy)
	local v18 = withDefaults(p1, t1)
	local v19 = useScaledValue(Constants.DEFAULT_INPUT_FIELD_WIDTH_PIXELS)
	local v20 = React.useRef(nil)
	local v21 = React.useCallback(function() -- line: 51
		-- upvalues: v20 (copy)
		if v20.current and not v20.current.getIsFocused() then
			v20.current.focus()
		end
	end, {})
	local v22 = if not Flags.FoundationTextInputsBetaUpdate then React.useCallback(function(p3) -- line: 59
		-- upvalues: v20 (copy)
		if v20.current then
			v20.current.setHover(p3)
		end
	end, {}) else nil

	React.useImperativeHandle(v18.textBoxRef, function() -- line: 65
		-- upvalues: v20 (copy)
		if not v20.current then
			return nil
		end

		return {
			focus = v20.current.focus,
			releaseFocus = v20.current.releaseFocus,
			getIsFocused = v20.current.getIsFocused,
			getCursorPosition = v20.current.getCursorPosition,
			getSelectionStart = v20.current.getSelectionStart,
			setCursorPosition = v20.current.setCursorPosition,
			setSelectionStart = v20.current.setSelectionStart
		}
	end, {})

	return React.createElement(View, withCommonProps(v18, {
		tag = "col gap-small auto-y",
		Size = if v18.width then UDim2.new(v18.width, UDim.new(0, 0)) else UDim2.fromOffset(v19, 0),
		ref = p2
	}), {
		Label = if not (#v18.label > 0) then nil else React.createElement(InputLabel, {
			LayoutOrder = 1,
			Text = v18.label,
			size = v18.size,
			isRequired = v18.isRequired,
			isDisabled = v18.isDisabled,
			onActivated = v21,
			onHover = if not Flags.FoundationTextInputsBetaUpdate then v22 else nil,
			testId = `{ v18.testId }--label`
		}),
		InputWrapper = React.createElement(View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 2,
			testId = `{ v18.testId }--input-wrapper`
		}, {
			Input = v18.input(v20)
		}),
		Hint = if not v18.hint then nil else React.createElement(HintText, {
			LayoutOrder = 3,
			text = v18.hint,
			hasError = v18.hasError,
			isDisabled = v18.isDisabled,
			testId = `{ v18.testId }--hint`
		})
	})
end

return React.memo(React.forwardRef(InputField))
