local UserGameSettings = UserSettings():GetService("UserGameSettings")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/SignalsReact")
local useDeviceType = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/RobloxAppHooks").useDeviceType
local AppearanceContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Style/AppearanceContext")
local SceneOverridesRegistry = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Style/SceneOverridesRegistry")
local appStyleProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/UIBlox").App.Style.AppStyleProvider
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Foundation")
local foundationProvider = Foundation.FoundationProvider
local colorMode = Foundation.Enums.ColorMode
local themeName = Foundation.Enums.ThemeName
local getUIScale = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Display").GetDisplayStore(false).getUIScale

local engineFeature = game:DefineFastFlag("LuaAppEnableWindowsHandheldTokenScale", false)
	and game:GetEngineFeature("EnableDisplaySize")
local defineFastFlag = game:DefineFastFlag("DebugLuaAppEnableTokenScale", false)

local v5 = engineFeature or defineFastFlag
local fFlagAppNavBarPerItemThemeOverride = require("@game/CorePackages/Workspace/Packages/_Workspace/Style/SharedFlags").FFlagAppNavBarPerItemThemeOverride

local v6 = if fFlagAppNavBarPerItemThemeOverride then require("@game/CorePackages/Workspace/Packages/_Workspace/Style/Style/UiModeBrandThemeContext") else nil

local defineFastFlag2 = game:DefineFastFlag("AppClassicThemeGreenButtonColors", false)

local v7 = {
	["Color.ActionEmphasis.Background.Color3"] = Color3.fromHex("#137F1F"),
	["Color.ActionSoftEmphasis.Background.Color3"] = Color3.fromHex("#137F1F"),
	["Color.ActionSoftEmphasis.Foreground.Color3"] = Color3.fromHex("#E2F8E3")
}

local v8 = {
	["Color.ActionEmphasis.Background.Color3"] = Color3.fromHex("#12891D"),
	["Color.ActionEmphasis.Foreground.Color3"] = Color3.fromHex("#FFFFFF"),
	["Color.ActionSoftEmphasis.Background.Color3"] = Color3.fromHex("#12891D"),
	["Color.ActionSoftEmphasis.Foreground.Color3"] = Color3.fromHex("#022708")
}

local v9 = { ["dark"] = colorMode.Dark, light = colorMode.Light }

local function useTokenScale()
	return (SignalsReact.useSignalState(getUIScale))
end

local function UiModeStyleProvider(p2)
	local v10 = useDeviceType()
	local v11 = if v5 then SignalsReact.useSignalState(getUIScale) else nil

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

	local style = p2.style
	local v12 = React.useMemo(function()
		local join = Cryo.Dictionary.join
		local v13 = {
			deviceType = style.deviceType or v10
		}

		local v16 = if v5 then Cryo.Dictionary.join(state, { scale = v11 }) else state
		return join(v13, style, { settings = v16 })
	end, { style, v10, state, v11 })

	local v13 = v12.foundationThemeName ~= nil
	local v14

	if defineFastFlag2 and v12.foundationThemeName == themeName.Classic then
		v14 = if v9[v12.themeName:lower()] == colorMode.Light then v8 else v7
	end

	return React.createElement(foundationProvider, {
		device = v12.deviceType,
		colorMode = v9[v12.themeName:lower()],
		themeName = v12.foundationThemeName,
		preferences = v12.settings,
		tokenOverrides = v14
	}, React.createElement(
		SceneOverridesRegistry,
		{ isActive = v13 },
		React.createElement(appStyleProvider, { style = v12 }, p2.children)
	))
end

local function ThemeProvider(props)
	local state, setState = React.useState(props.style.themeName)

	if fFlagAppNavBarPerItemThemeOverride and props.syncThemeFromProps then
		state = props.style.themeName
	end

	local clone = table.clone(props)

	local join = Cryo.Dictionary.join
	local style = clone.style

	local v11 = if props.foundationThemeName then props.foundationThemeName else Cryo.None
	clone.style = join(style, { themeName = state, foundationThemeName = v11 })

	local element = React.createElement(AppearanceContext.Provider, {
		value = { theme = state, setTheme = setState }
	}, React.createElement(UiModeStyleProvider, clone))

	if fFlagAppNavBarPerItemThemeOverride then
		return React.createElement(v6.Provider, {
			value = { foundationThemeName = props.foundationThemeName }
		}, element)
	end

	return element
end

return ThemeProvider
