local Style = script:FindFirstAncestor("Style")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local parent = Style.Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useDeviceType = RobloxAppHooks.useDeviceType
local AppearanceContext = require(script.Parent.AppearanceContext)
local SceneOverridesRegistry = require(script.Parent.SceneOverridesRegistry)
local UIBlox = require(parent.UIBlox)
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
local Foundation = require(parent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local ColorMode = Foundation.Enums.ColorMode
local ThemeName = Foundation.Enums.ThemeName
local Display = require(parent.Display)
local getUIScale = Display.GetDisplayStore(false).getUIScale

local engineFeature = game:DefineFastFlag("LuaAppEnableWindowsHandheldTokenScale", false)
	and game:GetEngineFeature("EnableDisplaySize")
local defineFastFlag = game:DefineFastFlag("DebugLuaAppEnableTokenScale", false)

local v = engineFeature or defineFastFlag
local SharedFlags = require(parent.SharedFlags)
local FFlagAppNavBarPerItemThemeOverride = SharedFlags.FFlagAppNavBarPerItemThemeOverride
local UiModeBrandThemeContext

if FFlagAppNavBarPerItemThemeOverride then
	UiModeBrandThemeContext = require(script.Parent.UiModeBrandThemeContext)
else
	UiModeBrandThemeContext = nil
end

local FFlagAppClassicThemeGreenButtonColors = require(script.Parent.FFlagAppClassicThemeGreenButtonColors)

local v2 = {
	["Color.ActionEmphasis.Background.Color3"] = Color3.fromHex("#137F1F"),
	["Color.ActionSoftEmphasis.Background.Color3"] = Color3.fromHex("#137F1F"),
	["Color.ActionSoftEmphasis.Foreground.Color3"] = Color3.fromHex("#E2F8E3")
}

local v3 = {
	["Color.ActionEmphasis.Background.Color3"] = Color3.fromHex("#12891D"),
	["Color.ActionEmphasis.Foreground.Color3"] = Color3.fromHex("#FFFFFF"),
	["Color.ActionSoftEmphasis.Background.Color3"] = Color3.fromHex("#12891D"),
	["Color.ActionSoftEmphasis.Foreground.Color3"] = Color3.fromHex("#022708")
}

local v4 = { ["dark"] = ColorMode.Dark, light = ColorMode.Light }

local function useTokenScale() -- 1 equivalent call inferred from this helper
	return (SignalsReact.useSignalState(getUIScale))
end

local function UiModeStyleProvider(p)
	local v5 = useDeviceType()
	local scale

	if v then
		scale = useTokenScale() -- inferred equivalent call
	else
		scale = nil
	end

	local state, setState = React.useState({
		preferredTransparency = UserGameSettings.PreferredTransparency,
		reducedMotion = UserGameSettings.ReducedMotion,
		preferredTextSize = UserGameSettings.PreferredTextSize
	})

	React.useEffect(function()
		local function updateSettings()
			setState({
				preferredTransparency = UserGameSettings.PreferredTransparency,
				reducedMotion = UserGameSettings.ReducedMotion,
				preferredTextSize = UserGameSettings.PreferredTextSize
			})
		end
		local preferredTransparencyChangedConnection = UserGameSettings:GetPropertyChangedSignal("PreferredTransparency"):Connect(updateSettings)
		local reducedMotionChangedConnection = UserGameSettings:GetPropertyChangedSignal("ReducedMotion"):Connect(updateSettings)
		local preferredTextSizeChangedConnection = UserGameSettings:GetPropertyChangedSignal("PreferredTextSize"):Connect(updateSettings)

		return function()
			preferredTransparencyChangedConnection:Disconnect()
			reducedMotionChangedConnection:Disconnect()
			preferredTextSizeChangedConnection:Disconnect()
		end
	end, {})

	local style = p.style
	local style2 = React.useMemo(function()
		local join = Cryo.Dictionary.join
		local v6 = {
			deviceType = style.deviceType or v5
		}
		local settings

		if v then
			settings = Cryo.Dictionary.join(state, { scale = scale })
		else
			settings = state
		end

		return join(v6, style, { settings = settings })
	end, { style, v5, state, scale })

	local isActive = style2.foundationThemeName ~= nil
	local tokenOverrides

	if FFlagAppClassicThemeGreenButtonColors and style2.foundationThemeName == ThemeName.Classic then
		if v4[style2.themeName:lower()] == ColorMode.Light then
			tokenOverrides = v3
		else
			tokenOverrides = v2
		end
	end

	return React.createElement(FoundationProvider, {
		device = style2.deviceType,
		colorMode = v4[style2.themeName:lower()],
		themeName = style2.foundationThemeName,
		preferences = style2.settings,
		tokenOverrides = tokenOverrides
	}, React.createElement(
		SceneOverridesRegistry,
		{ isActive = isActive },
		React.createElement(AppStyleProvider, { style = style2 }, p.children)
	))
end

local function ThemeProvider(props)
	local state, setState = React.useState(props.style.themeName)

	if FFlagAppNavBarPerItemThemeOverride and props.syncThemeFromProps then
		state = props.style.themeName
	end

	local clone = table.clone(props)

	local join = Cryo.Dictionary.join
	local style = clone.style
	local foundationThemeName

	if props.foundationThemeName then
		foundationThemeName = props.foundationThemeName
	else
		foundationThemeName = Cryo.None
	end

	clone.style = join(style, { themeName = state, foundationThemeName = foundationThemeName })

	local element = React.createElement(AppearanceContext.Provider, {
		value = { theme = state, setTheme = setState }
	}, React.createElement(UiModeStyleProvider, clone))

	if FFlagAppNavBarPerItemThemeOverride then
		return React.createElement(UiModeBrandThemeContext.Provider, {
			value = { foundationThemeName = props.foundationThemeName }
		}, element)
	end

	return element
end

return ThemeProvider
