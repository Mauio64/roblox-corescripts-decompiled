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
local FFlagFixUiModeStyleProviderTreeShapeRace = require(StyleParent.SharedFlags).FFlagFixUiModeStyleProviderTreeShapeRace
local v19 = v15 or v16
local t1 = {
	dark = Theme.Dark,
	light = Theme.Light
}

local function useTokenScale() -- line: 52
	-- upvalues: SignalsReact (copy), getUIScale (copy)
	return (SignalsReact.useSignalState(getUIScale))
end
local function UiModeStyleProvider(t2: {[any]: any}) -- line: 57
	-- upvalues: useDeviceType (copy), v19 (copy), SignalsReact (copy), getUIScale (copy), React (copy), UserGameSettings (copy), Cryo (copy), FFlagFixUiModeStyleProviderTreeShapeRace (copy), FoundationProvider (copy), t1 (copy), FFlagEnableCoreContentTheme (copy), SceneOverridesRegistry (copy), AppStyleProvider (copy)
	local v25 = useDeviceType()
	local u26 = nil

	if v19 then
		u26 = SignalsReact.useSignalState(getUIScale)
	end

	local v27, v28 = React.useState({
		preferredTransparency = UserGameSettings.PreferredTransparency,
		reducedMotion = UserGameSettings.ReducedMotion,
		preferredTextSize = UserGameSettings.PreferredTextSize
	})

	React.useEffect(function() -- line: 71
		-- upvalues: v28 (copy), UserGameSettings (copy)
		local function updateSettings() -- line: 72
			-- upvalues: v28 (copy), UserGameSettings (copy)
			v28({
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
	local v30 = React.useMemo(function() -- line: 94
		-- upvalues: Cryo (copy), style (copy), v25 (copy), v19 (copy), v27 (copy), u26 (ref)
		return Cryo.Dictionary.join({
			deviceType = style.deviceType or v25
		}, style, {
			settings = if not v19 then v27 else Cryo.Dictionary.join(v27, {
				scale = u26
			})
		})
	end, {
		style,
		v25,
		v27,
		u26
	})
	local v31 = if not FFlagFixUiModeStyleProviderTreeShapeRace then nil else v30.tokenOverrides ~= nil

	return React.createElement(FoundationProvider, {
		device = v30.deviceType,
		theme = t1[v30.themeName:lower()],
		preferences = v30.settings,
		tokenOverrides = if not FFlagEnableCoreContentTheme then nil else v30.tokenOverrides
	}, if not if not FFlagFixUiModeStyleProviderTreeShapeRace then FFlagEnableCoreContentTheme and v30.tokenOverrides ~= nil else FFlagEnableCoreContentTheme or v30.tokenOverrides ~= nil then React.createElement(AppStyleProvider, {
		style = v30
	}, t2.children) else React.createElement(SceneOverridesRegistry, if not FFlagFixUiModeStyleProviderTreeShapeRace then nil else {
		isActive = v31
	}, React.createElement(AppStyleProvider, {
		style = v30
	}, t2.children)))
end
local function ThemeProvider(t3: {[any]: any}) -- line: 138
	-- upvalues: React (copy), FFlagEnableCoreContentTheme (copy), t1 (copy), Cryo (copy), ThemeContext (copy), UiModeStyleProvider (copy)
	local v33, v34 = React.useState(t3.style.themeName)
	local v35 = table.clone(t3)
	local v36 = if not FFlagEnableCoreContentTheme then nil else t3.style.tokenOverrides

	if FFlagEnableCoreContentTheme and t3.tokenOverridesByTheme then
		local v37 = t1[v33:lower()]

		v36 = t3.tokenOverridesByTheme[v37] or v36
	end

	v35.style = Cryo.Dictionary.join(v35.style, {
		themeName = v33,
		tokenOverrides = if not FFlagEnableCoreContentTheme then nil else v36 or Cryo.None
	})

	return React.createElement(ThemeContext.Provider, {
		value = {
			theme = v33,
			setTheme = v34
		}
	}, React.createElement(UiModeStyleProvider, v35))
end

return ThemeProvider
