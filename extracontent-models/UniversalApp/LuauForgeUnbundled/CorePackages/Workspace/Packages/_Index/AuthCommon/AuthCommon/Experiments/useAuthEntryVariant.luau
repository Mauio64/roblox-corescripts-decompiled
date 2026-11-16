local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/React")
local useBrowserTrackerExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactAppExperiment").useBrowserTrackerExperiment
local useIXPService = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactAppExperiment").useIXPService
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UniversalAppPolicy").useAppPolicy
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppEnums").UiMode
local isPioneerLaunch = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/PioneerUtils").isPioneerLaunch
local appBtidLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/ExperimentLayers").AppBtidLayers
local FFlagGoogleAppleSsoDesktop = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Flags/FFlagGoogleAppleSsoDesktop")
local fFlagEnableAccountSwitchSsoLogin = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagEnableAccountSwitchSsoLogin

local defineFastInt = game:DefineFastInt("DebugAuthEntryVariantOverride", -1)

local universalAppAuthEntryLayer = appBtidLayers.UniversalAppAuthEntryLayer

local v5 = { Control = 0, Foundation = 1, FoundationSso = 2 }

local function isPlatformInPopulation(p2)
	if p2 == Enum.Platform.Windows or p2 == Enum.Platform.OSX then
		return FFlagGoogleAppleSsoDesktop
	end

	return p2 == Enum.Platform.IOS or p2 == Enum.Platform.Android
end

return {
	AuthEntryVariant = v5,
	resolveAuthEntryVariant = function(p2, p3, p4)
		if p4 ~= nil and p4 >= 0 then
			p2 = p4
		end

		if p3 and (p2 == v5.Foundation or p2 == v5.FoundationSso) then
			return p2
		end

		return v5.Control
	end,
	useAuthEntryVariant = function(p2, p3)
		local v6 = useIXPService()
		local v7 = useBrowserTrackerExperiment({ universalAppAuthEntryLayer }, function(p4)
			return (p4[universalAppAuthEntryLayer] or {}).authEntryVariant
		end, false)

		local v8 = v6:GetBrowserTrackerStatusForLayer(universalAppAuthEntryLayer) == Enum.IXPLoadingStatus.Initialized
		local v9 = useAppPolicy(function(p4)
			return p4.getExcludeExternalIdentityLogin() or p4.getUseVNGUserAgreementPopup()
		end)

		local uiMode2 = useUiModeInfo().uiMode
		local ref = React.useRef(false)
		local v10 = not fFlagEnableAccountSwitchSsoLogin or p3 ~= false
		local v11 = p2 or UserInputService:GetPlatform()
		local v12

		if v11 == Enum.Platform.Windows or v11 == Enum.Platform.OSX then
			v12 = FFlagGoogleAppleSsoDesktop
		else
			v12 = v11 == Enum.Platform.IOS or v11 == Enum.Platform.Android
		end

		if v12 then
			v12 = not (uiMode2 == uiMode.TenFoot or uiMode2 == uiMode.VR) and not (v9 or isPioneerLaunch())
		end

		React.useEffect(function()
			if v10 and v12 and v8 and not ref.current then
				ref.current = true
				v6:LogBrowserTrackerLayerExposure(universalAppAuthEntryLayer)
			end
		end, { v6, v12, v8, v10 })

		local v13 = defineFastInt

		if v13 ~= nil and v13 >= 0 then
			v7 = v13
		end

		if v12 and (v7 == v5.Foundation or v7 == v5.FoundationSso) then
			return v7
		end

		return v5.Control
	end
}
