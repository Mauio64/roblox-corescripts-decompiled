local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local BuilderIcons = require(FoundationParent.BuilderIcons)
local React = require(FoundationParent.React)
local Components = Foundation.Components
local Icon = require(Components.Icon)
local InternalTextInput = require(Components.InternalTextInput)

require(Components.Types)

local View = require(Components.View)
local Constants = require(Foundation.Constants)
local Translator = require(Foundation.Utility.Localization.Translator)
local useScaledValue = require(Foundation.Utility.useScaledValue)
local useTextInputVariants = require(Foundation.Components.TextInput.useTextInputVariants)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local InputSize = require(Foundation.Enums.InputSize)
local InputVariant = require(Foundation.Enums.InputVariant)
local Radius = require(Foundation.Enums.Radius)
local SearchInputShape = require(Foundation.Enums.SearchInputShape)
local t1 = {
	[SearchInputShape.Pill] = Radius.Circle,
	[SearchInputShape.Box] = Radius.None
}
local t2 = {
	hasClearButton = true,
	testId = "--foundation-search-input",
	size = InputSize.Medium,
	variant = InputVariant.Standard,
	shape = SearchInputShape.Pill
}

local function SearchInput(p1, p2) -- line: 75
	-- upvalues: withDefaults (copy), t2 (copy), useTokens (copy), useTextInputVariants (copy), useScaledValue (copy), Constants (copy), React (copy), View (copy), withCommonProps (copy), InternalTextInput (copy), t1 (copy), Translator (copy), Icon (copy), BuilderIcons (copy)
	local v25 = withDefaults(p1, t2)
	local v26 = useTokens()
	local v27 = useTextInputVariants(v26, v25.size, v25.variant)
	local v28 = useScaledValue(Constants.DEFAULT_INPUT_FIELD_WIDTH_PIXELS)
	local v29 = React.useMemo(function() -- line: 83
		-- upvalues: v27 (copy), v26 (copy)
		return UDim2.fromOffset(0, (v27.container.minHeight - v26.Stroke.Standard) / 2)
	end, {
		v27.container.minHeight,
		v26.Stroke.Standard
	})

	return React.createElement(View, withCommonProps(v25, {
		tag = "auto-y",
		Size = if not v25.width then UDim2.new(UDim.new(0, v28), UDim.new(0, 0)) else UDim2.new(v25.width, UDim.new(0, 0))
	}), {
		Input = React.createElement(InternalTextInput, {
			ref = p2,
			hasError = v25.hasError,
			isDisabled = v25.isDisabled,
			hasClearButton = v25.hasClearButton,
			text = v25.text,
			size = v25.size,
			radius = t1[v25.shape],
			variant = v25.variant,
			horizontalPadding = {
				left = v27.container.horizontalPadding,
				right = v27.container.horizontalPadding
			},
			onChanged = v25.onChanged,
			onFocus = v25.onFocusGained,
			onFocusLost = v25.onFocusLost,
			placeholder = if not v25.placeholder then Translator:FormatByKey("CommonUI.Controls.Action.Search") else v25.placeholder,
			leadingElement = React.createElement(View, {
				tag = "anchor-center-left auto-xy",
				Position = v29
			}, {
				Icon = React.createElement(Icon, {
					name = BuilderIcons.Icon.MagnifyingGlass,
					size = v25.size,
					testId = `{ v25.testId }--search-icon`
				})
			}),
			testId = `{ v25.testId }--input`
		})
	})
end

return React.memo(React.forwardRef(SearchInput))
