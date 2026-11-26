local CorePackages = game:GetService("CorePackages")

local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local fFlagUseSignalsForAuthenticationStatus = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForAuthenticationStatus
local getAuthenticationStatusStore

if fFlagUseSignalsForAuthenticationStatus then
	getAuthenticationStatusStore = require("@luauforge/bundled/ggh").GetAuthenticationStatusStore
else
	getAuthenticationStatusStore = nil
end

local module2 = require("@luauforge/bundled/ipe")
local module3 = require("@luauforge/bundled/ipt")
local module4 = require("@luauforge/bundled/iqa")
local module5 = require("@luauforge/bundled/ggj")
local module6 = require("@luauforge/bundled/iqb")
local axPrefetchMarketplaceIXP = require("@luauforge/bundled/gZJ").AXPrefetchMarketplaceIXP

local module7 = require("@luauforge/bundled/iqc")
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial
local useStore = RoactUtils.Hooks.RoactRodux.useStore

local module8 = require("@luauforge/bundled/iqg")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXDebugPanel = AvatarExperienceFlags.FFlagAXDebugPanel
local fFlagAXUnifiedEventPageContext = AvatarExperienceFlags.FFlagAXUnifiedEventPageContext
local fFlagAXBackgroundsCycloramaVR = AvatarExperienceFlags.FFlagAXBackgroundsCycloramaVR
local fFlagAXDebugMobileRbxlContentProbe = AvatarExperienceFlags.FFlagAXDebugMobileRbxlContentProbe
local fFlagAXBringingItBack = AvatarExperienceFlags.FFlagAXBringingItBack

local v5 = if fFlagAXBringingItBack then require("@luauforge/bundled/fBO") else nil

local v6 = if fFlagAXBringingItBack then require("@luauforge/bundled/fBQ") else nil

local function AvatarExperienceMountedAtStartup(p2)
	local v7 = useIsSpatial()
	local v8

	if fFlagAXBringingItBack then
		v8 = useSignalState(v5(false).getColorThemeKey) == v6.Classic
	end

	local shouldStart = p2.shouldStart
	local v9 = useStore()
	local v10 = p2.authStatus == module5.LOGGED_IN or shouldStart

	if axPrefetchMarketplaceIXP.isEnabled() then
		module7()
	end

	if fFlagAXUnifiedEventPageContext then
		React.useEffect(function()
			module8(v9)
		end, { v9 })
	end

	if fFlagAXDebugPanel then
		React.useEffect(function()
			return (require("@luauforge/bundled/iqh").register())
		end, {})
	end

	if fFlagAXDebugMobileRbxlContentProbe then
		React.useEffect(function()
			require("@luauforge/bundled/iqj").run()
		end, {})
	end

	local createElement = React.createElement
	local fragment = React.Fragment
	local v12 = {
		ItemSelectionManager = React.createElement(module4),
		AvatarSceneManager = 0,
		AvatarExperienceInitialization = 0,
		AvatarExperienceIXPDiagnostics = 0
	}
	local v13

	if v10 then
		local createElement2 = React.createElement
		local v15 = {
			store = v9,
			shouldStart = shouldStart,
			shouldManageBackground = not v7 or fFlagAXBackgroundsCycloramaVR,
			isSpatial = v7,
			isClassicTheme = nil,
			renderSky = nil
		}

		if not fFlagAXBringingItBack then
			v8 = nil
		end

		v15.isClassicTheme = v8
		v15.renderSky = shouldStart
		v13 = createElement2(module3, v15)
	end

	v12.AvatarSceneManager = v13

	local v14 = if v10 then React.createElement(module2) else nil
	v12.AvatarExperienceInitialization = v14

	v12.AvatarExperienceIXPDiagnostics = React.createElement(module6)
	return createElement(fragment, {}, v12)
end

local function mapStateToProps(p2, p3)
	return { authStatus = p2.AuthenticationStatus.status }
end

if fFlagUseSignalsForAuthenticationStatus then
	return (React.memo(function(p2)
		local v7 = useSignalState(getAuthenticationStatusStore(false).getStatus)
		return React.createElement(
			AvatarExperienceMountedAtStartup,
			Cryo.Dictionary.union(p2, { authStatus = v7 })
		)
	end))
end

return RoactRodux.connect(mapStateToProps, nil)(AvatarExperienceMountedAtStartup)
