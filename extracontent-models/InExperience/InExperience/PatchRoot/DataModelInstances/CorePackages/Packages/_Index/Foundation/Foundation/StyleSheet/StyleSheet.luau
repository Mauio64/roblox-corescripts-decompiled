local parent = script.Parent
local Foundation = script:FindFirstAncestor("Foundation")
local parent2 = Foundation.Parent
local React = require(parent2.React)
require(Foundation.Providers.Style.Tokens)
require(parent.Rules.Types)
local createStyleSheetRules = require(parent.createStyleSheetRules)
local getOverrideAttributes = require(parent.getOverrideAttributes)
local useGeneratedRules = require(Foundation.Utility.useGeneratedRules)

require(Foundation.Enums.ColorMode)
require(Foundation.Enums.Device)
require(Foundation.Enums.ThemeName)

local function StyleSheet(props)
	local state, setState = React.useState(nil)
	local ref = React.useRef({})

	React.useLayoutEffect(function()
		if props.setStyleSheetRef and props.setStyleSheetRef.current then
			props.setStyleSheetRef.current(state)
		end
	end, { state })

	local v = useGeneratedRules(props.themeName, props.colorMode, props.device)

	local v2 = React.useMemo(function()
		return getOverrideAttributes(props.themeName, props.colorMode, props.device, props.tokenOverrides)
	end, { props.themeName, props.colorMode, props.device, props.tokenOverrides })

	local v3 = React.useMemo(function()
		if state then
			return createStyleSheetRules(v, props.tags, state, ref.current, props.scale, v2)
		end

		return nil
	end, { state, v, props.tags, props.scale, v2 })

	return React.createElement(React.Fragment, nil, {
		FoundationStyleSheet = React.createElement("StyleSheet", { ref = setState }, v3),
		FoundationStyleLink = React.createElement("StyleLink", { StyleSheet = state })
	})
end

return React.memo(StyleSheet)
