local scriptParent = script.Parent
local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local React = require(FoundationParent.React)
local Device = require(Foundation.Enums.Device)
local Flags = require(Foundation.Utility.Flags)
local StyleSheet = require(Foundation.StyleSheet)
local StyleSheetContext = require(scriptParent.StyleSheetContext)
local TagsContext = require(scriptParent.TagsContext)
local TextSizeOffsetContext = require(scriptParent.TextSizeOffsetContext)
local Theme = require(Foundation.Enums.Theme)
local Tokens = require(scriptParent.Tokens)
local TokensContext = require(scriptParent.TokensContext)
local VariantsContext = require(scriptParent.VariantsContext)
local getTextSizeOffset = require(Foundation.Utility.getTextSizeOffset)
local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local useTagsState = require(scriptParent.useTagsState)
local withDefaults = require(Foundation.Utility.withDefaults)
local getTokens = Tokens.getTokens
local v21 = if not Flags.FoundationUseStyleSheetRegistry then nil else require(scriptParent.useRegistryStyleSheet)
local t1 = {
	scale = 1,
	theme = Theme.Dark,
	device = Device.Desktop
}

function StyleSheetContextWrapper(t2: {[any]: any}) -- line: 55
	-- upvalues: React (copy), StyleSheetContext (copy), Dash (copy)
	local v25, v26 = React.useState(nil)

	if t2.setStyleSheetRef and v26 ~= t2.setStyleSheetRef.current then
		t2.setStyleSheetRef.current = v26
	end

	return React.createElement(StyleSheetContext.Provider, {
		value = v25 or Dash.None
	}, t2.children)
end

local function StyleProvider(t3: {[any]: any}) -- line: 69
	-- upvalues: withDefaults (copy), t1 (copy), Flags (copy), React (copy), useTagsState (copy), VariantsContext (copy), getTokens (copy), usePreferences (copy), getTextSizeOffset (copy), v21 (copy), TokensContext (copy), TextSizeOffsetContext (copy), TagsContext (copy), StyleSheetContext (copy), StyleSheet (copy)
	local v28 = withDefaults({
		theme = t3.theme,
		device = t3.device,
		scale = t3.scale
	}, t1)
	local v29 = if Flags.FoundationUseStyleSheetRegistry then nil else React.useRef(nil)
	local v30 = nil
	local v31 = nil

	if not Flags.FoundationUseStyleSheetRegistry then
		v30, v31 = useTagsState()
	end

	local v32 = VariantsContext.useVariantsState()
	local v33 = React.useMemo(function() -- line: 86
		-- upvalues: getTokens (copy), v28 (copy), t3 (copy)
		return getTokens(v28.theme, v28.device, v28.scale, t3.tokenOverrides)
	end, {
		v28.device,
		v28.theme,
		v28.scale,
		t3.tokenOverrides
	})
	local preferredTextSize = usePreferences().preferredTextSize
	local v35 = React.useMemo(function() -- line: 93
		-- upvalues: getTextSizeOffset (copy)
		return getTextSizeOffset() or 0
	end, { preferredTextSize })
	local v36 = nil
	local v37 = nil

	if Flags.FoundationUseStyleSheetRegistry then
		v36, v37 = v21(v28.theme, v28.device, v28.scale, t3.tokenOverrides)
	end

	return React.createElement(TokensContext.Provider, {
		value = v33
	}, {
		TextSizeOffsetContext = React.createElement(TextSizeOffsetContext.Provider, {
			value = v35
		}, {
			VariantsContext = React.createElement(VariantsContext.Provider, {
				value = v32
			}, {
				TagsContext = React.createElement(TagsContext.Provider, {
					value = if not Flags.FoundationUseStyleSheetRegistry then v31 else v37
				}, if not Flags.FoundationUseStyleSheetRegistry then React.createElement(StyleSheetContextWrapper, {
					setStyleSheetRef = v29
				}, t3.children) else React.createElement(StyleSheetContext.Provider, {
					value = v36
				}, t3.children)),
				StyleSheet = if not Flags.FoundationUseStyleSheetRegistry then React.createElement(StyleSheet, {
					theme = v28.theme,
					device = v28.device,
					scale = v28.scale,
					tags = v30,
					derives = t3.derives,
					setStyleSheetRef = v29,
					tokenOverrides = t3.tokenOverrides
				}) else React.createElement("StyleLink", {
					StyleSheet = v36
				})
			})
		})
	})
end

return StyleProvider
