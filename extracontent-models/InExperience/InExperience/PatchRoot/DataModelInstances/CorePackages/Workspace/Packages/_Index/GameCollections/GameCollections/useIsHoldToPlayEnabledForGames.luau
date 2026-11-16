local parent = script:FindFirstAncestor("GameCollections").Parent

local RoactAppExperiment = require(parent.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment
local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useUiModeInfo = RobloxAppHooks.useUiModeInfo
local RobloxAppEnums = require(parent.RobloxAppEnums)
local UiMode = RobloxAppEnums.UiMode
local Responsive = require(parent.Responsive)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppResponsiveEnginePreferredInput = SharedFlags.FFlagLuaAppResponsiveEnginePreferredInput

local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy

local function useIsHoldToPlayEnabledForGames()
	local v = useUserExperiment({ AppUserLayers.PlatformExcellenceQualityImprovementConsoles }, function(p)
		return (p[AppUserLayers.PlatformExcellenceQualityImprovementConsoles] or {}).enableHoldToPlay
	end)

	local v2 = Responsive.useLastInput()

	local v3 = useUiModeInfo()

	local v4 = useAppPolicy(function(p)
		return p.getStickyShortcutBarEnabled()
	end)
	local v5

	if FFlagLuaAppResponsiveEnginePreferredInput then
		v5 = Responsive.usePreferredInput()
	end

	if not v then
		return v
	end

	local v6

	if FFlagLuaAppResponsiveEnginePreferredInput then
		v6 = v5 == Responsive.Input.Directional
	else
		v6 = v2 == Responsive.Input.Directional
	end

	return v6 and (v3.uiMode == UiMode.TenFoot or v4)
end

return useIsHoldToPlayEnabledForGames
