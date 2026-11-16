local parent = script.Parent
local parent2 = parent.Parent.Parent
local getTextSizeOffset = require(parent2.Utility.getTextSizeOffset)

local parent3 = parent2.Parent
local Cryo = require(parent3.Cryo)
local React = require(parent3.React)
local Roact = require(parent3.Roact)

local Foundation = require(parent3.Foundation)
local FoundationProvider = Foundation.FoundationProvider

local useTokens = Foundation.Hooks.useTokens
local LuauPolyfill = require(parent3.LuauPolyfill)
local Object = LuauPolyfill.Object

local getThemeFromName = require(parent.Themes.getThemeFromName)
local getFontFromName = require(parent.Fonts.getFontFromName)
local Constants = require(parent.Constants)
require(script.Parent.StyleTypes)
local Tokens = require(script.Parent.Tokens)
local StyleContext = require(parent2.Core.Style.StyleContext)
local Logger = require(parent2.Logger)

local getTokens = Tokens.getTokens
local getFoundationTokens = Tokens.getFoundationTokens
local Mappers = Tokens.Mappers
local foundationSurfaceTokensDiffer = require(script.Parent.foundationSurfaceTokensDiffer)

local v = { ["dark"] = Foundation.Enums.Theme.Dark, light = Foundation.Enums.Theme.Light }

local v2 = {
	themeName = Constants.DefaultThemeName,
	fontName = Constants.DefaultFontName,
	deviceType = Constants.DefaultDeviceType,
	settings = Constants.DefaultSettings
}

local function AppStyleProvider(p)
	local v3 = Object.assign({}, v2, p.style)
	local state, setState = React.useState(v3.themeName)
	local scale = v3.settings and v3.settings.scale
	local tokens = getTokens(v3.deviceType, state, scale)
	local state2, setState2 = React.useState(0)
	local themeFromName = getThemeFromName(state)
	local v4 = useTokens()
	local v5 = v4.Config ~= nil

	local foundationTokens = getFoundationTokens(v3.deviceType, state)
	local v6

	if v5 then
		v6 = Cryo.Dictionary.join(foundationTokens, v4)
	else
		v6 = foundationTokens
	end

	local mapColorTokensToFoundation = Mappers.mapColorTokensToFoundation(tokens, v6)

	local mapThemeToFoundation = Mappers.mapThemeToFoundation
	local v7 = if v5 then v4 else foundationTokens
	local theme = mapThemeToFoundation(themeFromName, v7)

	local addFoundationFlatKeys = Mappers.addFoundationFlatKeys
	local v8 = if v5 then v4 else foundationTokens
	local tokens2 = addFoundationFlatKeys(mapColorTokensToFoundation, v8)

	local style = {
		Font = getFontFromName(v3.fontName, tokens2),
		Theme = theme,
		Tokens = tokens2,
		Settings = 0
	}
	local settings

	if v3.settings then
		settings = {
			PreferredTransparency = v3.settings.preferredTransparency,
			ReducedMotion = v3.settings.reducedMotion,
			PreferredTextSize = v3.settings.preferredTextSize,
			Scale = v3.settings.scale
		}
	else
		settings = Constants.DefaultSettings
	end

	style.Settings = settings

	local ref = React.useRef(false)
	React.useEffect(function()
		ref.current = true
		setState(v3.themeName)
		return function()
			ref.current = false
		end
	end, { ref, v3.themeName, setState })

	React.useEffect(function()
		local textSizeOffset, v9 = getTextSizeOffset(tokens2.Typography.BodyLarge.Font)

		if textSizeOffset then
			setState2(v9)
		end
	end, { v3.settings.preferredTextSize })

	local updateTheme = React.useCallback(function(_, p2)
		if ref.current then
			setState(p2)
		end
	end, { ref, setState })

	local themeName = React.useMemo(function()
		if state:lower() == Constants.ThemeName.Dark:lower() then
			return Constants.ThemeName.Dark
		end

		if state:lower() == Constants.ThemeName.Light:lower() then
			return Constants.ThemeName.Light
		end

		return Constants.DefaultThemeName
	end, { state })

	local createElement = React.createElement
	local provider = StyleContext.Provider
	local hasSurfaceOverrides

	if v5 then
		hasSurfaceOverrides = foundationSurfaceTokensDiffer(foundationTokens, v4)
	else
		hasSurfaceOverrides = false
	end

	local element = createElement(provider, {
		value = {
			style = style,
			updateTheme = updateTheme,
			derivedValues = { textSizeOffset = state2 },
			styleMetadata = { ThemeName = themeName, HasSurfaceOverrides = hasSurfaceOverrides }
		}
	}, Roact.oneChild(p.children))

	if v5 then
		return element
	end

	if _G.ENVIRONMENT ~= "PRODUCTION" and (_G.ENVIRONMENT == "DEVELOPMENT" or _G.__DEV__) then
		local parent4 = script.Parent.Parent.Parent
		local packages = parent4:FindFirstAncestor("Packages") or parent4:FindFirstAncestor("CorePackages")
		local v9

		if packages and packages:FindFirstChild("Dev") and packages.Dev:FindFirstChild("JestGlobals") then
			v9 = pcall(require, packages.Dev.JestGlobals)
		else
			v9 = false
		end

		if not v9 then
			Logger:warning(debug.traceback("FoundationProvider not found. Please ensure that the FoundationProvider is present in the component tree."))
		end
	end

	return React.createElement(
		FoundationProvider,
		{ theme = v[state:lower()], device = v3.deviceType, preferences = v3.settings },
		element
	)
end

return AppStyleProvider
