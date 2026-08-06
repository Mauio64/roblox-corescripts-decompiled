local Style = script:FindFirstAncestor("Style")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local StyleParent = Style.Parent
local Cryo = require(StyleParent.Cryo)
local React = require(StyleParent.React)
local SignalsReact = require(StyleParent.SignalsReact)
local useDeviceType = require(StyleParent.RobloxAppHooks).useDeviceType
local ThemeContext = require(script.Parent.ThemeContext)
local SceneOverridesRegistry = require(script.Parent.SceneOverridesRegistry)
local AppStyleProvider = require(StyleParent.UIBlox).App.Style.AppStyleProvider
local Foundation = require(StyleParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Theme = Foundation.Enums.Theme
local getUIScale = require(StyleParent.Display).GetDisplayStore(false).getUIScale
local v15 = game:DefineFastFlag("LuaAppEnableWindowsHandheldTokenScale", false) and game:GetEngineFeature("EnableDisplaySize")
local v16 = game:DefineFastFlag("DebugLuaAppEnableTokenScale", false)
local v17 = v15 or v16
local FFlagAppNavBarPerItemThemeOverride = require(StyleParent.SharedFlags).FFlagAppNavBarPerItemThemeOverride
local t1 = {
	dark = Theme.Dark,
	light = Theme.Light
}

local function useTokenScale() -- line: 52
	-- upvalues: SignalsReact (copy), getUIScale (copy)
	return (SignalsReact.useSignalState(getUIScale))
end
local function UiModeStyleProvider(t2: {[any]: any}) -- line: 57
	-- upvalues: useDeviceType (copy), v17 (copy), SignalsReact (copy), getUIScale (copy), React (copy), UserGameSettings (copy), Cryo (copy), FoundationProvider (copy), t1 (copy), SceneOverridesRegistry (copy), AppStyleProvider (copy)
	local v24 = useDeviceType()
	local u25 = nil

	if v17 then
		u25 = SignalsReact.useSignalState(getUIScale)
	end

	local v26, v27 = React.useState({
		preferredTransparency = UserGameSettings.PreferredTransparency,
		reducedMotion = UserGameSettings.ReducedMotion,
		preferredTextSize = UserGameSettings.PreferredTextSize
	})

	React.useEffect(function() -- line: 71
		-- upvalues: v27 (copy), UserGameSettings (copy)
		local function updateSettings() -- line: 72
			-- upvalues: v27 (copy), UserGameSettings (copy)
			v27({
				preferredTransparency = UserGameSettings.PreferredTransparency,
				reducedMotion = UserGameSettings.ReducedMotion,
				preferredTextSize = UserGameSettings.PreferredTextSize
			})
		end

		local connection = UserGameSettings:GetPropertyChangedSignal("PreferredTransparency"):Connect(updateSettings)
		local connection2 = UserGameSettings:GetPropertyChangedSignal("ReducedMotion"):Connect(updateSettings)
		local connection3 = UserGameSettings:GetPropertyChangedSignal("PreferredTextSize"):Connect(updateSettings)

		return function() -- line: 86
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, {})

	local style = t2.style
	local v29 = React.useMemo(function() -- line: 94
		-- upvalues: Cryo (copy), style (copy), v24 (copy), v17 (copy), v26 (copy), u25 (ref)
		return Cryo.Dictionary.join({
			deviceType = style.deviceType or v24
		}, style, {
			settings = if not v17 then v26 else Cryo.Dictionary.join(v26, {
				scale = u25
			})
		})
	end, {
		style,
		v24,
		v26,
		u25
	})
	local v30 = v29.tokenOverrides ~= nil

	return React.createElement(FoundationProvider, {
		device = v29.deviceType,
		theme = t1[v29.themeName:lower()],
		preferences = v29.settings,
		tokenOverrides = v29.tokenOverrides
	}, React.createElement(SceneOverridesRegistry, {
		isActive = v30
	}, React.createElement(AppStyleProvider, {
		style = v29
	}, t2.children)))
end
local function ThemeProvider(t3: {[any]: any}) -- line: 132
	-- upvalues: React (copy), FFlagAppNavBarPerItemThemeOverride (copy), t1 (copy), Cryo (copy), ThemeContext (copy), UiModeStyleProvider (copy)
	local v32, v33 = React.useState(t3.style.themeName)
	local v34 = if not FFlagAppNavBarPerItemThemeOverride or not t3.syncThemeFromProps then v32 else t3.style.themeName
	local v35 = table.clone(t3)
	local tokenOverrides = t3.style.tokenOverrides

	if t3.tokenOverridesByTheme then
		local v37 = t1[v34:lower()]

		tokenOverrides = t3.tokenOverridesByTheme[v37] or tokenOverrides
	end

	v35.style = Cryo.Dictionary.join(v35.style, {
		themeName = v34,
		tokenOverrides = tokenOverrides or Cryo.None
	})

	local v38 = React.createElement(ThemeContext.Provider, {
		value = {
			theme = v34,
			setTheme = v33
		}
	}, React.createElement(UiModeStyleProvider, v35))

	if FFlagAppNavBarPerItemThemeOverride then
		local UiModeTokenOverridesContext = require(script.Parent.UiModeTokenOverridesContext)

		return React.createElement(UiModeTokenOverridesContext.Provider, {
			value = t3.tokenOverridesByTheme or {}
		}, v38)
	end

	return v38
end

return ThemeProvider
