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
local FFlagEnableCoreContentTheme = require(StyleParent.SharedFlags).FFlagEnableCoreContentTheme
local v18 = v15 or v16
local t1 = {
	dark = Theme.Dark,
	light = Theme.Light
}

local function useTokenScale() -- line: 51
	-- upvalues: SignalsReact (copy), getUIScale (copy)
	return (SignalsReact.useSignalState(getUIScale))
end
local function UiModeStyleProvider(t2: {[any]: any}) -- line: 56
	-- upvalues: useDeviceType (copy), v18 (copy), SignalsReact (copy), getUIScale (copy), React (copy), UserGameSettings (copy), Cryo (copy), FoundationProvider (copy), t1 (copy), FFlagEnableCoreContentTheme (copy), SceneOverridesRegistry (copy), AppStyleProvider (copy)
	local v24 = useDeviceType()
	local u25 = nil

	if v18 then
		u25 = SignalsReact.useSignalState(getUIScale)
	end

	local v26, v27 = React.useState({
		preferredTransparency = UserGameSettings.PreferredTransparency,
		reducedMotion = UserGameSettings.ReducedMotion,
		preferredTextSize = UserGameSettings.PreferredTextSize
	})

	React.useEffect(function() -- line: 70
		-- upvalues: v27 (copy), UserGameSettings (copy)
		local function updateSettings() -- line: 71
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

		return function() -- line: 85
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, {})

	local style = t2.style
	local v29 = React.useMemo(function() -- line: 93
		-- upvalues: Cryo (copy), style (copy), v24 (copy), v18 (copy), v26 (copy), u25 (ref)
		return Cryo.Dictionary.join({
			deviceType = style.deviceType or v24
		}, style, {
			settings = if not v18 then v26 else Cryo.Dictionary.join(v26, {
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
		tokenOverrides = if not FFlagEnableCoreContentTheme then nil else v29.tokenOverrides
	}, if not FFlagEnableCoreContentTheme and v29.tokenOverrides == nil then React.createElement(AppStyleProvider, {
		style = v29
	}, t2.children) else React.createElement(SceneOverridesRegistry, {
		isActive = v30
	}, React.createElement(AppStyleProvider, {
		style = v29
	}, t2.children)))
end
local function ThemeProvider(t3: {[any]: any}) -- line: 133
	-- upvalues: React (copy), FFlagEnableCoreContentTheme (copy), t1 (copy), Cryo (copy), ThemeContext (copy), UiModeStyleProvider (copy)
	local v32, v33 = React.useState(t3.style.themeName)
	local v34 = table.clone(t3)
	local v35 = if not FFlagEnableCoreContentTheme then nil else t3.style.tokenOverrides

	if FFlagEnableCoreContentTheme and t3.tokenOverridesByTheme then
		local v36 = t1[v32:lower()]

		v35 = t3.tokenOverridesByTheme[v36] or v35
	end

	v34.style = Cryo.Dictionary.join(v34.style, {
		themeName = v32,
		tokenOverrides = if not FFlagEnableCoreContentTheme then nil else v35 or Cryo.None
	})

	return React.createElement(ThemeContext.Provider, {
		value = {
			theme = v32,
			setTheme = v33
		}
	}, React.createElement(UiModeStyleProvider, v34))
end

return ThemeProvider
