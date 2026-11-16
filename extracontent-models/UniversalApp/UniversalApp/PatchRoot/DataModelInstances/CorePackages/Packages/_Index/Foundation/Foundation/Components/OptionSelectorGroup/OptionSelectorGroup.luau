local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local Orientation = require(Foundation.Enums.Orientation)

local OptionSelectorGroupSize = require(Foundation.Enums.OptionSelectorGroupSize)

require(Foundation.Enums.FillBehavior)

local InputLabel = require(Foundation.Components.InputLabel)
require(Foundation.Components.Types)
local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local OptionSelectorGroupContext = require(script.Parent.OptionSelectorGroupContext)
local useOptionSelectorGroupVariants = require(script.Parent.useOptionSelectorGroupVariants)

local v = {
	orientation = Orientation.Vertical,
	size = OptionSelectorGroupSize.Medium,
	Selectable = true,
	testId = "--foundation-option-selector-group"
}

local function OptionSelectorGroupInner(props)
	local props2 = props.props
	local v2 = useOptionSelectorGroupVariants(
		useTokens(),
		props2.size or OptionSelectorGroupSize.Medium,
		props2.orientation
	)

	local v3 = React.useMemo(function()
		return {
			value = props.value,
			onValueChanged = props.onValueChanged,
			orientation = props2.orientation,
			Selectable = props2.Selectable,
			testId = props2.testId,
			size = props.sizeOverride,
			fillBehavior = props.fillBehaviorOverride
		}
	end, {
		props.value,
		props.onValueChanged,
		props2.orientation,
		props2.Selectable,
		props2.testId,
		props.sizeOverride,
		props.fillBehaviorOverride
	})

	local createElement = React.createElement

	local v4 = withCommonProps(props2, { tag = v2.container.tag, ref = props.ref })
	local legend

	if props2.legend ~= nil then
		legend = React.createElement(InputLabel, {
			Text = props2.legend,
			size = v2.legend.size,
			LayoutOrder = 1,
			testId = `{props2.testId}--legend`
		})
	end

	return createElement(View, v4, {
		Legend = legend,
		List = React.createElement(View, {
			tag = v2.list.tag,
			LayoutOrder = 2,
			testId = `{props2.testId}--list`
		}, {
			OptionSelectorGroupContext = React.createElement(
				OptionSelectorGroupContext.Provider,
				{ value = v3 },
				props2.children
			)
		})
	})
end

local function OptionSelectorGroup(p, ref)
	local props = withDefaults(p, v)
	local state, setState = React.useState(props.value)

	React.useEffect(function()
		if props.value ~= nil then
			setState(props.value)
		end
	end, { props.value })

	local onValueChanged = React.useCallback(function(p2: string)
		setState(p2)
		props.onValueChanged(p2)
	end, { setState, props.onValueChanged })
	return (React.createElement(OptionSelectorGroupInner, {
		props = props,
		sizeOverride = p.size,
		fillBehaviorOverride = p.fillBehavior,
		value = state,
		onValueChanged = onValueChanged,
		ref = ref
	}))
end

return React.memo(React.forwardRef(OptionSelectorGroup))
