local scriptParent = script.Parent
local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local Device = require(Foundation.Enums.Device)
local StyleSheetContext = require(scriptParent.StyleSheetContext)
local TagsContext = require(scriptParent.TagsContext)
local TextSizeOffsetContext = require(scriptParent.TextSizeOffsetContext)
local Theme = require(Foundation.Enums.Theme)
local Tokens = require(scriptParent.Tokens)
local TokensContext = require(scriptParent.TokensContext)
local VariantsContext = require(scriptParent.VariantsContext)
local getTextSizeOffset = require(Foundation.Utility.getTextSizeOffset)
local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local withDefaults = require(Foundation.Utility.withDefaults)
local getTokens = Tokens.getTokens
local useRegistryStyleSheet = require(scriptParent.useRegistryStyleSheet)
local t1 = {
	scale = 1,
	theme = Theme.Dark,
	device = Device.Desktop
}

local function StyleProvider(t2: {[any]: any}) -- line: 49
	-- upvalues: withDefaults (copy), t1 (copy), VariantsContext (copy), React (copy), getTokens (copy), usePreferences (copy), getTextSizeOffset (copy), useRegistryStyleSheet (copy), TokensContext (copy), TextSizeOffsetContext (copy), TagsContext (copy), StyleSheetContext (copy)
	local v21 = withDefaults({
		theme = t2.theme,
		device = t2.device,
		scale = t2.scale
	}, t1)
	local v22 = VariantsContext.useVariantsState()
	local v23 = React.useMemo(function() -- line: 58
		-- upvalues: getTokens (copy), v21 (copy), t2 (copy)
		return getTokens(v21.theme, v21.device, v21.scale, t2.tokenOverrides)
	end, {
		v21.device,
		v21.theme,
		v21.scale,
		t2.tokenOverrides
	})
	local preferredTextSize = usePreferences().preferredTextSize
	local v25 = React.useMemo(function() -- line: 65
		-- upvalues: getTextSizeOffset (copy)
		return getTextSizeOffset() or 0
	end, { preferredTextSize })
	local v26, v27 = useRegistryStyleSheet(v21.theme, v21.device, v21.scale, t2.tokenOverrides)

	return React.createElement(TokensContext.Provider, {
		value = v23
	}, {
		TextSizeOffsetContext = React.createElement(TextSizeOffsetContext.Provider, {
			value = v25
		}, {
			VariantsContext = React.createElement(VariantsContext.Provider, {
				value = v22
			}, {
				TagsContext = React.createElement(TagsContext.Provider, {
					value = v27
				}, React.createElement(StyleSheetContext.Provider, {
					value = v26
				}, t2.children)),
				StyleSheet = React.createElement("StyleLink", {
					StyleSheet = v26
				})
			})
		})
	})
end

return StyleProvider
