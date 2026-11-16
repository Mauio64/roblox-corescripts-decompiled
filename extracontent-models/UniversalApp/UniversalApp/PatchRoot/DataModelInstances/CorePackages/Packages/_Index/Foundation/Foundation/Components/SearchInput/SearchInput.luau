local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local BuilderIcons = require(parent.BuilderIcons)
local React = require(parent.React)

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

local v = { [SearchInputShape.Pill] = Radius.Circle, [SearchInputShape.Box] = Radius.None }

local v2 = {
	size = InputSize.Medium,
	variant = InputVariant.Standard,
	shape = SearchInputShape.Pill,
	hasClearButton = true,
	testId = "--foundation-search-input"
}

local function SearchInput(p, ref)
	local v3 = withDefaults(p, v2)
	local v4 = useTokens()
	local v5 = useTextInputVariants(v4, v3.size, v3.variant)
	local v6 = useScaledValue(Constants.DEFAULT_INPUT_FIELD_WIDTH_PIXELS)

	local position = React.useMemo(function()
		return UDim2.fromOffset(0, (v5.container.minHeight - v4.Stroke.Standard) / 2)
	end, { v5.container.minHeight, v4.Stroke.Standard })

	local createElement = React.createElement
	local size

	if v3.width then
		size = UDim2.new(v3.width, UDim.new(0, 0))
	else
		size = UDim2.new(UDim.new(0, v6), UDim.new(0, 0))
	end

	local v7 = withCommonProps(v3, { Size = size, tag = "auto-y" })

	local createElement2 = React.createElement
	local v8 = {
		ref = ref,
		hasError = v3.hasError,
		isDisabled = v3.isDisabled,
		hasClearButton = v3.hasClearButton,
		text = v3.text,
		size = v3.size,
		radius = v[v3.shape],
		variant = v3.variant,
		horizontalPadding = {
			left = v5.container.horizontalPadding,
			right = v5.container.horizontalPadding
		},
		onChanged = v3.onChanged,
		onFocus = v3.onFocusGained,
		onFocusLost = v3.onFocusLost,
		placeholder = 0,
		leadingElement = 0,
		testId = 0
	}
	local placeholder

	if v3.placeholder then
		placeholder = v3.placeholder
	else
		placeholder = Translator:FormatByKey("CommonUI.Controls.Action.Search")
	end

	v8.placeholder = placeholder

	v8.leadingElement = React.createElement(View, {
		Position = position,
		tag = "anchor-center-left auto-xy"
	}, {
		Icon = React.createElement(Icon, {
			name = BuilderIcons.Icon.MagnifyingGlass,
			size = v3.size,
			testId = `{v3.testId}--search-icon`
		})
	})

	v8.testId = `{v3.testId}--input`
	return createElement(View, v7, {
		Input = createElement2(InternalTextInput, v8)
	})
end

return React.memo(React.forwardRef(SearchInput))
