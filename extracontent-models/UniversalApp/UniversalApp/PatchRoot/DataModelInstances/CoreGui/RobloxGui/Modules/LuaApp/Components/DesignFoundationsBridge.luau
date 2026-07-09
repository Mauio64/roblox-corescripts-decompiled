local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Theme = Foundation.Enums.Theme
local getTokens = Foundation.Utility.getTokens
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AccountTypeThemeOverrides = require(Modules.LuaApp.Themes.AccountTypeThemeOverrides)
local FFlagEnableRobloxPlusThemeSetting = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableRobloxPlusThemeSetting
local v11 = if not FFlagEnableRobloxPlusThemeSetting then nil else require(Modules.LuaApp.Themes.RobloxPlusThemeOverrides)
local v12 = if not FFlagEnableRobloxPlusThemeSetting then nil else require(Modules.LuaApp.Themes.RobloxPlusTheme)
local v13 = if not FFlagEnableRobloxPlusThemeSetting then nil else require(Modules.LuaApp.Themes.Stores.GetRobloxPlusThemeStore)
local v14 = if not FFlagEnableRobloxPlusThemeSetting then nil else require(Modules.LuaApp.Hooks.useShowRobloxPlusThemeSetting)

local function getEngineFeatureSafe(s1: string) -- line: 82
	local ok, result = pcall(function() -- line: 86
		-- upvalues: s1 (copy)
		return game:GetEngineFeature(s1)
	end)

	return ok and result == true
end

local t1 = {
	"Color.Common.NavigationBar",
	"Color.Surface.Surface_0",
	"Color.Surface.Surface_100",
	"Color.Content.Default",
	"Color.Content.Muted",
	"Color.ActionEmphasis.Background",
	"Color.ActionEmphasis.Foreground"
}

local function getTokenAtPath(p1, s2: string) -- line: 106
	for _, v33 in string.split(s2, ".") do
		if p1 == nil or type(p1) ~= "table" then
			return nil
		end

		p1 = p1[v33]
	end

	return p1
end
local function isColorToken(p2) -- line: 117
	return type(p2) == "table" and typeof(p2.Color3) == "Color3"
end
local function isHexColorValue(p3) -- line: 121
	return type(p3) == "string" and p3:match("^#?%x%x%x%x%x%x$") ~= nil
end
local function resolveColor3FromOverride(p4, p5) -- line: 125
	-- upvalues: getTokenAtPath (copy)
	if typeof(p5) == "Color3" then
		return p5
	end

	if type(p5) == "string" and p5:match("^#?%x%x%x%x%x%x$") ~= nil then
		return Color3.fromHex(p5)
	end

	if type(p5) == "string" then
		local v38 = getTokenAtPath(p4, p5)

		if typeof(v38) == "Color3" then
			return v38
		end

		if type(v38) == "table" and typeof(v38.Color3) == "Color3" then
			return v38.Color3
		end
	end

	return nil
end
local function resolveTransparencyFromOverride(p6, p7, t2: {[any]: any}?) -- line: 144
	-- upvalues: getTokenAtPath (copy)
	if type(p7) == "number" then
		return p7
	end

	if type(p7) == "string" then
		local v42 = getTokenAtPath(p6, p7)

		if type(v42) == "number" then
			return v42
		end

		if type(v42) == "table" and typeof(v42.Color3) == "Color3" then
			return v42.Transparency
		end
	end

	if t2 then
		return t2.Transparency
	end

	return nil
end
local function resolveForTheme(p8, p9, s3: string) -- line: 172
	-- upvalues: getTokens (copy), getTokenAtPath (copy), resolveColor3FromOverride (copy)
	local v46 = getTokens(p8)
	local v47 = getTokenAtPath(v46, s3)
	local v48 = if not (type(v47) == "table" and typeof(v47.Color3) == "Color3") then nil else v47
	local v49 = p9 and p9[s3]
	local v50 = p9 and p9[s3 .. ".Color3"]
	local v51 = p9 and p9[s3 .. ".Transparency"]
	local g54 = nil
	local g55 = nil

	if v49 and (type(v49) == "string" and (type(v49) ~= "string" or v49:match("^#?%x%x%x%x%x%x$") == nil)) then
		local v52 = getTokenAtPath(v46, v49)

		if type(v52) == "table" and typeof(v52.Color3) == "Color3" then
			return v52
		end
	end

	local v53 = resolveColor3FromOverride(v46, v50)

	repeat
		if g54 or not v53 then
			g54 = false

			if v48 then
				return v48
			end

			return nil
		end

		if type(v51) == "number" then
			g55 = true
		end

		repeat
			if g55 or (g55 or type(v51) == "string") then
				if not g55 then
					if not g55 then
						v51 = getTokenAtPath(v46, v51)

						if type(v51) == "number" then
							g55 = true
						end
					end
				end

				if g55 or (g55 or (g55 or type(v51) == "table" and typeof(v51.Color3) == "Color3")) then
					if not g55 then
						if not g55 then
							if not g55 then
								v51 = v51.Transparency
							end
						end
					end

					g55 = false

					if v51 ~= nil then
						return {
							Color3 = v53,
							Transparency = v51
						}
					end

					g54 = true
				end
			end

			if g54 then
				break
			end

			v51 = if not v48 then nil else v48.Transparency
			g55 = true
		until not g55
	until not g54
end
local function resolveOverrideSource(s4: string?, s5: string, b1: boolean) -- line: 202
	-- upvalues: FFlagEnableRobloxPlusThemeSetting (copy), v12 (copy), v11 (copy), AccountTypeThemeOverrides (copy)
	if FFlagEnableRobloxPlusThemeSetting and (b1 and s5 ~= v12.Default) then
		local v59 = v11[s5]

		if v59 then
			return v59
		end
	end

	if s4 ~= nil then
		return AccountTypeThemeOverrides[s4]
	end

	return nil
end
local function buildColorTokens(s6: string?, s7: string, b2: boolean) -- line: 225
	-- upvalues: FFlagEnableRobloxPlusThemeSetting (copy), v12 (copy), v11 (copy), AccountTypeThemeOverrides (copy), Theme (copy), t1 (copy), resolveForTheme (copy)
	local v63 = FFlagEnableRobloxPlusThemeSetting and (not not b2 and (s7 ~= v12.Default and v11[s7])) or if s6 == nil then nil else AccountTypeThemeOverrides[s6]

	if v63 == nil then
		return nil
	end

	local v64 = v63[Theme.Dark]
	local v65 = v63[Theme.Light]
	local t3 = {}

	for _, v68 in t1 do
		local v69 = resolveForTheme(Theme.Dark, v64, v68)
		local v70 = resolveForTheme(Theme.Light, v65, v68)

		if v69 and v70 then
			t3[string.gsub(v68, "^Color%.", "")] = {
				dark = v69,
				light = v70
			}
		end
	end

	return t3
end
local function getDesignFoundationsService() -- line: 252
	local ok, result = pcall(function() -- line: 253
		return game:GetService("DesignFoundationsService")
	end)

	if not ok or result == nil then
		return nil
	end

	return result
end
local function DesignFoundationsBridge(t4: {[any]: any}) -- line: 272
	-- upvalues: getEngineFeatureSafe (copy), getDesignFoundationsService (copy), useAppPolicy (copy), FFlagEnableRobloxPlusThemeSetting (copy), v13 (copy), useSignalState (copy), v14 (copy), React (copy), buildColorTokens (copy)
	local v74 = t4.getEngineFeature or getEngineFeatureSafe
	local v75 = t4.getService or getDesignFoundationsService
	local v76 = v74("DesignFoundationsServiceEnabled")
	local v77 = useAppPolicy(function(p10) -- line: 278
		local getAccountType = p10.getAccountType

		if getAccountType then
			return (getAccountType())
		end

		return nil
	end)
	local s8 = "Default"
	local u79 = false

	if FFlagEnableRobloxPlusThemeSetting then
		local v80 = v13(false)

		s8 = useSignalState(v80.getColorThemeKey)
		u79 = v14()
	end

	React.useEffect(function() -- line: 295
		-- upvalues: v76 (copy), v75 (copy), buildColorTokens (copy), v77 (copy), s8 (ref), u79 (ref)
		if not v76 then
			return
		end

		local v83 = v75()

		if not v83 then
			warn("[DesignFoundationsBridge] DesignFoundationsService not available")

			return
		end

		local v84 = buildColorTokens(v77, s8, u79)

		if v84 and next(v84) ~= nil then
			local t5 = {
				colorTokens = v84
			}
			local ok, result = pcall(function() -- line: 319
				-- upvalues: v83 (copy), t5 (copy)
				v83:SetTokens(t5)
			end)

			if not ok then
				warn("[DesignFoundationsBridge] SetTokens failed:", result)

				return
			end
		else
			local ok, result = pcall(function() -- line: 326
				-- upvalues: v83 (copy)
				v83:ClearTokens()
			end)

			if not ok then
				warn("[DesignFoundationsBridge] ClearTokens failed:", result)
			end
		end
	end, {
		v77,
		v76,
		v75,
		s8,
		u79
	})

	return React.createElement(React.Fragment, nil, t4.children)
end

return DesignFoundationsBridge
