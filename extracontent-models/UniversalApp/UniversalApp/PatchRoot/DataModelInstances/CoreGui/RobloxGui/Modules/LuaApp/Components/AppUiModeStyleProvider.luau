local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local UiModeStyleProvider = require(CorePackages.Workspace.Packages.Style).UiModeStyleProvider

require(CorePackages.Packages.Foundation)

local Cryo = require(CorePackages.Packages.Cryo)
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local AccountTypeThemeOverrides = require(script.Parent.Parent.Themes.AccountTypeThemeOverrides)
local FFlagEnableCoreContentTheme = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableCoreContentTheme
local FFlagEnableCoreContentThemeUseGuacForTokenOverrides = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableCoreContentThemeUseGuacForTokenOverrides
local FFlagUseDefaultThemeForLoggedOutUsers = require(CorePackages.Workspace.Packages.SharedFlags).FFlagUseDefaultThemeForLoggedOutUsers
local FFlagEnableRobloxPlusThemeSetting = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableRobloxPlusThemeSetting
local v15 = if not FFlagEnableRobloxPlusThemeSetting then nil else require(script.Parent.Parent.Themes.RobloxPlusThemeOverrides)
local v16 = if not FFlagEnableRobloxPlusThemeSetting then nil else require(script.Parent.Parent.Themes.RobloxPlusTheme)
local v17 = if not FFlagEnableRobloxPlusThemeSetting then nil else require(script.Parent.Parent.Themes.Stores.GetRobloxPlusThemeStore)
local v18 = if not FFlagEnableRobloxPlusThemeSetting then nil else require(script.Parent.Parent.Hooks.useShowRobloxPlusThemeSetting)
local v19 = game:DefineFastFlag("KidsThemeBlueColorsIxpEnabled", false)
local v20 = game:DefineFastString("KidsThemeBlueColorsIxpLayer", "UniversalApp.KidsTheme")

local function isHexColorValue(s1: string) -- line: 56
	return s1:match("^#?%x%x%x%x%x%x$") ~= nil
end
local function convertHexLeafValuesToColor3(p1) -- line: 60
	-- upvalues: convertHexLeafValuesToColor3 (copy)
	if type(p1) == "string" and p1:match("^#?%x%x%x%x%x%x$") ~= nil then
		return Color3.fromHex(p1)
	end

	if type(p1) == "table" then
		for v26, v27 in p1 do
			p1[v26] = convertHexLeafValuesToColor3(v27)
		end
	end

	return p1
end
local function useCoreContentThemeOverridesByTheme() -- line: 72
	-- upvalues: useAppPolicy (copy), FFlagUseDefaultThemeForLoggedOutUsers (copy), FFlagEnableCoreContentThemeUseGuacForTokenOverrides (copy), convertHexLeafValuesToColor3 (copy), FFlagEnableRobloxPlusThemeSetting (copy), v17 (copy), useSignalState (copy), v18 (copy), v19 (copy), React (copy), IXPServiceWrapper (copy), v20 (copy), v16 (copy), v15 (copy), AccountTypeThemeOverrides (copy)
	local v28, v29 = useAppPolicy(function(p2) -- line: 73
		-- upvalues: FFlagUseDefaultThemeForLoggedOutUsers (copy), FFlagEnableCoreContentThemeUseGuacForTokenOverrides (copy), convertHexLeafValuesToColor3 (copy)
		if FFlagUseDefaultThemeForLoggedOutUsers and (not game.Players.LocalPlayer or game.Players.LocalPlayer.UserId <= 0) then
			return "Roblox", nil
		end

		local getAccountType = p2.getAccountType
		local v38 = if not getAccountType then nil else getAccountType()
		local v39 = nil

		if FFlagEnableCoreContentThemeUseGuacForTokenOverrides then
			local getCoreContentTheme = p2.getCoreContentTheme
			local v41 = if not getCoreContentTheme then nil else getCoreContentTheme()

			if v41 then
				return v38, (convertHexLeafValuesToColor3(v41))
			end

			v39 = nil
		end

		return v38, v39
	end)
	local s2 = "Default"
	local v31 = false

	if FFlagEnableRobloxPlusThemeSetting then
		local v32 = v17(false)

		s2 = useSignalState(v32.getColorThemeKey)
		v31 = v18()
	end

	if v19 and FFlagEnableCoreContentThemeUseGuacForTokenOverrides then
		React.useEffect(function() -- line: 107
			-- upvalues: v28 (copy), IXPServiceWrapper (copy), v20 (copy)
			if v28 == "Kids" then
				IXPServiceWrapper:LogFlagLinkedUserLayerExposure(v20)
			end
		end, { v28 })
	end

	if FFlagEnableRobloxPlusThemeSetting and v31 and s2 ~= v16.Default then
		local v33 = v15[s2]

		if v33 then
			return v33
		end
	end

	if v29 then
		return v29
	end

	if v28 and AccountTypeThemeOverrides[v28] then
		return AccountTypeThemeOverrides[v28]
	end

	return nil
end

return function(p3) -- line: 134
	-- upvalues: FFlagEnableCoreContentTheme (copy), useCoreContentThemeOverridesByTheme (copy), Cryo (copy), ReactRoblox (copy), React (copy), UiModeStyleProvider (copy), CoreGui (copy)
	local t1 = nil

	if FFlagEnableCoreContentTheme then
		t1 = {
			tokenOverridesByTheme = useCoreContentThemeOverridesByTheme() or Cryo.None
		}
	end

	return ReactRoblox.createPortal({ React.createElement(UiModeStyleProvider, if not t1 then p3 else Cryo.Dictionary.join(p3, t1)) }, CoreGui)
end
