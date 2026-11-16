local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local UserInputService = game:GetService("UserInputService")

local React = require(parent.React)
local RoactAppExperiment = require(parent.RoactAppExperiment)
local useBrowserTrackerExperiment = RoactAppExperiment.useBrowserTrackerExperiment
local RoactAppExperiment2 = require(parent.RoactAppExperiment)
local useIXPService = RoactAppExperiment2.useIXPService
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local RobloxAppEnums = require(parent.RobloxAppEnums)
local UiMode = RobloxAppEnums.UiMode
local PioneerUtils = require(parent.PioneerUtils)
local isPioneerLaunch = PioneerUtils.isPioneerLaunch
local ExperimentLayers = require(parent.ExperimentLayers)
local AppBtidLayers = ExperimentLayers.AppBtidLayers
local FFlagGoogleAppleSsoDesktop = require(AuthCommon.Flags.FFlagGoogleAppleSsoDesktop)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableAccountSwitchSsoLogin = SharedFlags.FFlagEnableAccountSwitchSsoLogin

local defineFastInt = game:DefineFastInt("DebugAuthEntryVariantOverride", -1)

local UniversalAppAuthEntryLayer = AppBtidLayers.UniversalAppAuthEntryLayer

local authEntryVariant = { Control = 0, Foundation = 1, FoundationSso = 2 }

local function resolveAuthEntryVariant(p, flag: boolean, defineFastInt2: number?) -- 1 equivalent call inferred from this helper
	if defineFastInt2 ~= nil and defineFastInt2 >= 0 then
		p = defineFastInt2
	end

	if flag and (p == authEntryVariant.Foundation or p == authEntryVariant.FoundationSso) then
		return p
	end

	return authEntryVariant.Control
end

local function isPlatformInPopulation(p) -- 1 equivalent call inferred from this helper
	if p == Enum.Platform.Windows or p == Enum.Platform.OSX then
		return FFlagGoogleAppleSsoDesktop
	end

	return p == Enum.Platform.IOS or p == Enum.Platform.Android
end

return {
	AuthEntryVariant = authEntryVariant,
	resolveAuthEntryVariant = resolveAuthEntryVariant,
	useAuthEntryVariant = function(p, flag: boolean?)
		local v = useIXPService()
		local v2 = useBrowserTrackerExperiment({ UniversalAppAuthEntryLayer }, function(p2)
			return (p2[UniversalAppAuthEntryLayer] or {}).authEntryVariant
		end, false)

		local v3 = v:GetBrowserTrackerStatusForLayer(UniversalAppAuthEntryLayer) == Enum.IXPLoadingStatus.Initialized
		local v4 = useAppPolicy(function(p2)
			return p2.getExcludeExternalIdentityLogin() or p2.getUseVNGUserAgreementPopup()
		end)

		local uiMode = useUiModeInfo().uiMode
		local ref = React.useRef(false)
		local v5 = not FFlagEnableAccountSwitchSsoLogin or flag ~= false
		local v6 = isPlatformInPopulation(p or UserInputService:GetPlatform()) -- inferred equivalent call

		if v6 then
			if uiMode == UiMode.TenFoot or uiMode == UiMode.VR then
				v6 = false
			else
				v6 = not (v4 or isPioneerLaunch())
			end
		end

		React.useEffect(function()
			if v5 and v6 and v3 and not ref.current then
				ref.current = true
				v:LogBrowserTrackerLayerExposure(UniversalAppAuthEntryLayer)
			end
		end, { v, v6, v3, v5 })
		return resolveAuthEntryVariant(v2, v6, defineFastInt) -- inferred equivalent call
	end
}
