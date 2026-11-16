local parent = script.Parent
local Foundation = script:FindFirstAncestor("Foundation")
local parent2 = Foundation.Parent
local React = require(parent2.React)

local ColorMode = require(Foundation.Enums.ColorMode)
local Device = require(Foundation.Enums.Device)
local StyleSheetContext = require(parent.StyleSheetContext)
local TagsContext = require(parent.TagsContext)
local TextSizeOffsetContext = require(parent.TextSizeOffsetContext)
local ThemeName = require(Foundation.Enums.ThemeName)
local Tokens = require(parent.Tokens)
local TokensContext = require(parent.TokensContext)
local VariantsContext = require(parent.VariantsContext)
local getTextSizeOffset = require(Foundation.Utility.getTextSizeOffset)
local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local withDefaults = require(Foundation.Utility.withDefaults)

local getTokens = Tokens.getTokens

local useRegistryStyleSheet = require(parent.useRegistryStyleSheet)

local v = {
	themeName = ThemeName.Default,
	colorMode = ColorMode.Dark,
	device = Device.Desktop,
	scale = 1
}

local function StyleProvider(props)
	local v2 = withDefaults({
		themeName = props.themeName,
		colorMode = props.colorMode or props.theme,
		device = props.device,
		scale = props.scale
	}, v)

	local v3 = VariantsContext.useVariantsState()

	local v4 = React.useMemo(function()
		return getTokens(v2.colorMode, v2.device, v2.scale, props.tokenOverrides, v2.themeName)
	end, { v2.colorMode, v2.device, v2.scale, props.tokenOverrides, v2.themeName })

	local v5 = { usePreferences().preferredTextSize }
	local v6 = React.useMemo(function()
		return getTextSizeOffset() or 0
	end, v5)

	local styleSheet, v7 = useRegistryStyleSheet(v2.themeName, v2.colorMode, v2.device, v2.scale, props.tokenOverrides)

	return React.createElement(TokensContext.Provider, { value = v4 }, {
		TextSizeOffsetContext = React.createElement(TextSizeOffsetContext.Provider, { value = v6 }, {
			VariantsContext = React.createElement(VariantsContext.Provider, { value = v3 }, {
				TagsContext = React.createElement(
					TagsContext.Provider,
					{ value = v7 },
					React.createElement(StyleSheetContext.Provider, { value = styleSheet }, props.children)
				),
				StyleSheet = React.createElement("StyleLink", { StyleSheet = styleSheet })
			})
		})
	})
end

return StyleProvider
