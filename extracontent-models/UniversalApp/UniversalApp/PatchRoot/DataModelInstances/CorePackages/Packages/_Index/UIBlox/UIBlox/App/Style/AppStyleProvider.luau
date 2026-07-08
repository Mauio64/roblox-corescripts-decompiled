local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local getTextSizeOffset = require(ParentParent.Utility.getTextSizeOffset)
local ParentParentParent = ParentParent.Parent
local Cryo = require(ParentParentParent.Cryo)
local React = require(ParentParentParent.React)
local Roact = require(ParentParentParent.Roact)
local v8 = ParentParent:FindFirstAncestor("Packages") or ParentParent:FindFirstAncestor("CorePackages")
local v9 = not not v8 and (not not v8:FindFirstChild("Dev") and (not not v8.Dev:FindFirstChild("JestGlobals") and pcall(require, v8.Dev.JestGlobals)))
local Foundation = require(ParentParentParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local useTokens = Foundation.Hooks.useTokens
local Object = require(ParentParentParent.LuauPolyfill).Object
local getThemeFromName = require(scriptParent.Themes.getThemeFromName)
local getFontFromName = require(scriptParent.Fonts.getFontFromName)
local Constants = require(scriptParent.Constants)

require(script.Parent.StyleTypes)

local Tokens = require(script.Parent.Tokens)
local StyleContext = require(ParentParent.Core.Style.StyleContext)
local Logger = require(ParentParent.Logger)
local getTokens = Tokens.getTokens
local validateTokens = Tokens.validateTokens
local getFoundationTokens = Tokens.getFoundationTokens
local Mappers = Tokens.Mappers
local foundationSurfaceTokensDiffer = require(script.Parent.foundationSurfaceTokensDiffer)
local t1 = {
	dark = Foundation.Enums.Theme.Dark,
	light = Foundation.Enums.Theme.Light
}
local t2 = {
	themeName = Constants.DefaultThemeName,
	fontName = Constants.DefaultFontName,
	deviceType = Constants.DefaultDeviceType,
	settings = Constants.DefaultSettings
}

local function AppStyleProvider(t3: {[any]: any}) -- line: 84
	-- upvalues: Object (copy), t2 (copy), React (copy), getTokens (copy), getThemeFromName (copy), useTokens (copy), getFoundationTokens (copy), Cryo (copy), Mappers (copy), validateTokens (copy), getFontFromName (copy), Constants (copy), getTextSizeOffset (copy), StyleContext (copy), foundationSurfaceTokensDiffer (copy), Roact (copy), v9 (copy), Logger (copy), FoundationProvider (copy), t1 (copy)
	local v29 = Object.assign({}, t2, t3.style)
	local v30, v31 = React.useState(v29.themeName)
	local v32 = v29.settings and v29.settings.scale
	local v33 = getTokens(v29.deviceType, v30, v32)
	local v34, v35 = React.useState(0)
	local v36 = getThemeFromName(v30)
	local v37 = useTokens()
	local v38 = v37.Config ~= nil
	local v39 = getFoundationTokens(v29.deviceType, v30)
	local v40 = if not v38 then v39 else Cryo.Dictionary.join(v39, v37)
	local v41 = Mappers.mapColorTokensToFoundation(v33, v40)
	local v42 = Mappers.mapThemeToFoundation(v36, if not v38 then v39 else v37)

	assert(validateTokens(v41), "Invalid tokens!")

	local v43 = Mappers.addFoundationFlatKeys(v41, if not v38 then v39 else v37)
	local t4 = {
		Font = getFontFromName(v29.fontName, v43),
		Theme = v42,
		Tokens = v43,
		Settings = if not v29.settings then Constants.DefaultSettings else {
			PreferredTransparency = v29.settings.preferredTransparency,
			ReducedMotion = v29.settings.reducedMotion,
			PreferredTextSize = v29.settings.preferredTextSize,
			Scale = v29.settings.scale
		}
	}
	local v45 = React.useRef(false)

	React.useEffect(function() -- line: 128
		-- upvalues: v45 (copy), v31 (copy), v29 (copy)
		v45.current = true
		v31(v29.themeName)

		return function() -- line: 131
			-- upvalues: v45 (copy)
			v45.current = false
		end
	end, {
		v45,
		v29.themeName,
		v31
	})
	React.useEffect(function() -- line: 136
		-- upvalues: getTextSizeOffset (copy), v43 (copy), v35 (copy)
		local v49, v50 = getTextSizeOffset(v43.Semantic.Typography.Body.Font)

		if v49 then
			v35(v50)
		end
	end, { v29.settings.preferredTextSize })

	local v46 = React.useCallback(function(_, p2) -- line: 143
		-- upvalues: v45 (copy), v31 (copy)
		if v45.current then
			v31(p2)
		end
	end, {
		v45,
		v31
	})
	local v47 = React.useMemo(function() -- line: 149
		-- upvalues: v30 (copy), Constants (copy)
		if v30:lower() == Constants.ThemeName.Dark:lower() then
			return Constants.ThemeName.Dark
		end

		if v30:lower() == Constants.ThemeName.Light:lower() then
			return Constants.ThemeName.Light
		end

		return Constants.DefaultThemeName
	end, { v30 })
	local v48 = React.createElement(StyleContext.Provider, {
		value = {
			style = t4,
			updateTheme = v46,
			derivedValues = {
				textSizeOffset = v34
			},
			styleMetadata = {
				ThemeName = v47,
				HasSurfaceOverrides = not not v38 and foundationSurfaceTokensDiffer(v39, v37)
			}
		}
	}, Roact.oneChild(t3.children))

	if not v38 then
		if not v9 and _G.__DEV__ then
			Logger:warning(debug.traceback("FoundationProvider not found. Please ensure that the FoundationProvider is present in the component tree."))
		end

		return React.createElement(FoundationProvider, {
			theme = t1[v30:lower()],
			device = v29.deviceType,
			preferences = v29.settings
		}, v48)
	end

	return v48
end

return AppStyleProvider
