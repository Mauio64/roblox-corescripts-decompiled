local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

local Foundation = require(CorePackages.Packages.Foundation)
local colorMode = Foundation.Enums.ColorMode
local themeName = Foundation.Enums.ThemeName
local getTokens = Foundation.Utility.getTokens

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local fFlagMomentsRespectAccountTheme = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagMomentsRespectAccountTheme

local module = require("@luauforge/bundled/fBQ")

local module2 = require("@luauforge/bundled/fBO")
local module3 = require("@luauforge/bundled/fHg")
local module4 = require("@luauforge/bundled/fHp")
local module5 = require("@luauforge/bundled/fBM")

local function getEngineFeatureSafe(p2)
	local success, result = pcall(function()
		return game:GetEngineFeature(p2)
	end)

	return success and result == true
end

local v5 = {
	"Color.Common.NavigationBar",
	"Color.Surface.Surface_0",
	"Color.Surface.Surface_100",
	"Color.Content.Default",
	"Color.Content.Muted",
	"Color.ActionEmphasis.Background",
	"Color.ActionEmphasis.Foreground"
}

local function getTokenAtPath(tokens, value)
	for k, v6 in string.split(value, ".") do
		if tokens == nil or type(tokens) ~= "table" then
			return nil
		end

		tokens = tokens[v6]
	end

	return tokens
end

local function isColorToken(p2): boolean
	return type(p2) == "table" and typeof(p2.Color3) == "Color3"
end

local function resolveForTheme(p2, p3, p4)
	local tokenAtPath = getTokenAtPath(getTokens(p2, nil, nil, nil, p4), p3)
	local v6 = type(tokenAtPath) == "table" and typeof(tokenAtPath.Color3) == "Color3"

	if v6 then
		return tokenAtPath
	end

	return nil
end

local function resolveFoundationThemeName(p2, p3, p4)
	if p4 and p3 ~= module.Default then
		return p3
	end

	if p2 == nil then
		return nil
	end

	return themeName[p2]
end

local function buildColorTokens(p2, p3, p4)
	if not p4 or p3 == module.Default then
		p3 = if p2 ~= nil then themeName[p2] else nil
	end

	if p3 == nil then
		return nil
	end

	local result = {}

	for k, v6 in v5 do
		local tokenAtPath = getTokenAtPath(getTokens(colorMode.Dark, nil, nil, nil, p3), v6)
		local v7 = type(tokenAtPath) == "table" and typeof(tokenAtPath.Color3) == "Color3"

		if not v7 then
			tokenAtPath = nil
		end

		local tokenAtPath2 = getTokenAtPath(getTokens(colorMode.Light, nil, nil, nil, p3), v6)
		local v8 = type(tokenAtPath2) == "table" and typeof(tokenAtPath2.Color3) == "Color3"

		if not v8 then
			tokenAtPath2 = nil
		end

		if tokenAtPath and tokenAtPath2 then
			result[string.gsub(v6, "^Color%.", "")] = {
				dark = tokenAtPath,
				light = tokenAtPath2
			}
		end
	end

	return result
end

local function getDesignFoundationsService()
	local success, result = pcall(function()
		return game:GetService("DesignFoundationsService")
	end)

	if success and result ~= nil then
		return result
	end

	return nil
end

local function DesignFoundationsBridge(props)
	local getEngineFeature = props.getEngineFeature or getEngineFeatureSafe
	local getService = props.getService or getDesignFoundationsService

	local engineFeature = getEngineFeature("DesignFoundationsServiceEnabled")

	local v6 = useAppPolicy(function(p2)
		local getAccountType = p2.getAccountType

		if getAccountType then
			return (getAccountType())
		end

		return nil
	end)

	local v7 = module2(false)

	local v8 = useSignalState(v7.getColorThemeKey)

	local v9 = module3()
	local v10 = v9.isRobloxPlusUpsellEligible and v9.hasRobloxPlusSubscription

	if fFlagMomentsRespectAccountTheme and useSignalState(v7.getSuppressAccountTheme) then
		v8 = module.Default
	end

	if module5 then
		v10 = v10
			or module4.getThemeAccess(v8, v9.hasRobloxPlusSubscription, not v9.canSeeExclusiveThemes) == module4.ThemeAccess.Device
	end

	React.useEffect(function()
		if not engineFeature then
			return
		end

		local service = getService()

		if not service then
			warn("[DesignFoundationsBridge] DesignFoundationsService not available")
			return
		end

		local colorTokens = buildColorTokens(v6, v8, v10)

		if colorTokens and next(colorTokens) ~= nil then
			local v11 = { colorTokens = colorTokens }

			local success, result = pcall(function()
				service:SetTokens(v11)
			end)

			if not success then
				warn("[DesignFoundationsBridge] SetTokens failed:", result)
			end
		else
			local success, result = pcall(function()
				service:ClearTokens()
			end)

			if not success then
				warn("[DesignFoundationsBridge] ClearTokens failed:", result)
			end
		end
	end, { v6, engineFeature, getService, v8, v10 })

	return React.createElement(React.Fragment, nil, props.children)
end

return DesignFoundationsBridge
