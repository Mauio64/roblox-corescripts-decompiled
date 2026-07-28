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
local t1 = {
	dark = Theme.Dark,
	light = Theme.Light
}

local function useTokenScale() -- line: 50
	-- upvalues: SignalsReact (copy), getUIScale (copy)
	return (SignalsReact.useSignalState(getUIScale))
end
local function UiModeStyleProvider(t2: {[any]: any}) -- line: 55
	-- upvalues: useDeviceType (copy), v17 (copy), SignalsReact (copy), getUIScale (copy), React (copy), UserGameSettings (copy), Cryo (copy), FoundationProvider (copy), t1 (copy), SceneOverridesRegistry (copy), AppStyleProvider (copy)
	local v23 = useDeviceType()
	local u24 = nil

	if v17 then
		u24 = SignalsReact.useSignalState(getUIScale)
	end

	local v25, v26 = React.useState({
		preferredTransparency = UserGameSettings.PreferredTransparency,
		reducedMotion = UserGameSettings.ReducedMotion,
		preferredTextSize = UserGameSettings.PreferredTextSize
	})

	React.useEffect(function() -- line: 69
		-- upvalues: v26 (copy), UserGameSettings (copy)
		local function updateSettings() -- line: 70
			-- upvalues: v26 (copy), UserGameSettings (copy)
			v26({
				preferredTransparency = UserGameSettings.PreferredTransparency,
				reducedMotion = UserGameSettings.ReducedMotion,
				preferredTextSize = UserGameSettings.PreferredTextSize
			})
		end

		local connection = UserGameSettings:GetPropertyChangedSignal("PreferredTransparency"):Connect(updateSettings)
		local connection2 = UserGameSettings:GetPropertyChangedSignal("ReducedMotion"):Connect(updateSettings)
		local connection3 = UserGameSettings:GetPropertyChangedSignal("PreferredTextSize"):Connect(updateSettings)

		return function() -- line: 84
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, {})

	local style = t2.style
	local v28 = React.useMemo(function() -- line: 92
		-- upvalues: Cryo (copy), style (copy), v23 (copy), v17 (copy), v25 (copy), u24 (ref)
		return Cryo.Dictionary.join({
			deviceType = style.deviceType or v23
		}, style, {
			settings = if not v17 then v25 else Cryo.Dictionary.join(v25, {
				scale = u24
			})
		})
	end, {
		style,
		v23,
		v25,
		u24
	})
	local v29 = v28.tokenOverrides ~= nil

	return React.createElement(FoundationProvider, {
		device = v28.deviceType,
		theme = t1[v28.themeName:lower()],
		preferences = v28.settings,
		tokenOverrides = v28.tokenOverrides
	}, React.createElement(SceneOverridesRegistry, {
		isActive = v29
	}, React.createElement(AppStyleProvider, {
		style = v28
	}, t2.children)))
end
local function ThemeProvider(t3: {[any]: any}) -- line: 130
	-- upvalues: React (copy), t1 (copy), Cryo (copy), ThemeContext (copy), UiModeStyleProvider (copy)
	local v31, v32 = React.useState(t3.style.themeName)
	local v33 = table.clone(t3)
	local tokenOverrides = t3.style.tokenOverrides

	if t3.tokenOverridesByTheme then
		local v35 = t1[v31:lower()]

		tokenOverrides = t3.tokenOverridesByTheme[v35] or tokenOverrides
	end

	v33.style = Cryo.Dictionary.join(v33.style, {
		themeName = v31,
		tokenOverrides = tokenOverrides or Cryo.None
	})

	return React.createElement(ThemeContext.Provider, {
		value = {
			theme = v31,
			setTheme = v32
		}
	}, React.createElement(UiModeStyleProvider, v33))
end

return ThemeProvider
