local useUserExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RoactAppExperiment").useUserExperiment
local appUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/ExperimentLayers").AppUserLayers
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RobloxAppEnums").UiMode
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Responsive")

local fFlagLuaAppResponsiveEnginePreferredInput = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/SharedFlags").FFlagLuaAppResponsiveEnginePreferredInput

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/UniversalAppPolicy").useAppPolicy

local function useIsHoldToPlayEnabledForGames()
	local v5 = useUserExperiment(
		{ appUserLayers.PlatformExcellenceQualityImprovementConsoles },
		function(p2)
			return (p2[appUserLayers.PlatformExcellenceQualityImprovementConsoles] or {}).enableHoldToPlay
		end
	)

	local v6 = Responsive.useLastInput()

	local v7 = useUiModeInfo()

	local v8 = useAppPolicy(function(p2)
		return p2.getStickyShortcutBarEnabled()
	end)

	local v9 = if fFlagLuaAppResponsiveEnginePreferredInput then Responsive.usePreferredInput() else nil

	if not v5 then
		return v5
	end

	v5 = (if fFlagLuaAppResponsiveEnginePreferredInput then v9 == Responsive.Input.Directional else v6 == Responsive.Input.Directional)
		and (v7.uiMode == uiMode.TenFoot or v8)

	return v5
end

return useIsHoldToPlayEnabledForGames
