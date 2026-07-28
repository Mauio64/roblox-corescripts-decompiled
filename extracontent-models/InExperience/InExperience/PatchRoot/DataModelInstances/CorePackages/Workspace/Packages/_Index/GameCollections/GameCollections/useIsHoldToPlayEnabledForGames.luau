local Parent = script:FindFirstAncestor("GameCollections").Parent
local useUserExperiment = require(Parent.RoactAppExperiment).useUserExperiment
local AppUserLayers = require(Parent.ExperimentLayers).AppUserLayers
local useUiModeInfo = require(Parent.RobloxAppHooks).useUiModeInfo
local UiMode = require(Parent.RobloxAppEnums).UiMode
local Responsive = require(Parent.Responsive)
local FFlagLuaAppEnableStickyShortcutBar = require(Parent.SharedFlags).FFlagLuaAppEnableStickyShortcutBar
local FFlagLuaAppResponsiveEnginePreferredInput = require(Parent.SharedFlags).FFlagLuaAppResponsiveEnginePreferredInput
local FFlagGuacStickyShortcutBarEnabled = require(Parent.SharedFlags).FFlagGuacStickyShortcutBarEnabled
local v10 = if not FFlagLuaAppEnableStickyShortcutBar then nil else require(Parent.AppShortcutBar).Hooks.useIsStickyShortcutBarEnabled
local v11 = if not FFlagGuacStickyShortcutBarEnabled then nil else require(Parent.UniversalAppPolicy).useAppPolicy

local function useIsHoldToPlayEnabledForGames() -- line: 21
	-- upvalues: useUserExperiment (copy), AppUserLayers (copy), Responsive (copy), useUiModeInfo (copy), FFlagGuacStickyShortcutBarEnabled (copy), v11 (copy), FFlagLuaAppEnableStickyShortcutBar (copy), v10 (copy), FFlagLuaAppResponsiveEnginePreferredInput (copy), UiMode (copy)
	local v13 = useUserExperiment({ AppUserLayers.PlatformExcellenceQualityImprovementConsoles }, function(p1) -- line: 24
		-- upvalues: AppUserLayers (copy)
		return (p1[AppUserLayers.PlatformExcellenceQualityImprovementConsoles] or {}).enableHoldToPlay
	end)
	local v14 = Responsive.useLastInput()
	local v15 = useUiModeInfo()
	local v16 = if not FFlagGuacStickyShortcutBarEnabled then if not FFlagLuaAppEnableStickyShortcutBar then nil else v10() else v11(function(p2) -- line: 36
		return p2.getStickyShortcutBarEnabled()
	end)
	local v17 = if not FFlagLuaAppResponsiveEnginePreferredInput then nil else Responsive.usePreferredInput()

	if v13 then
		v13 = if not FFlagLuaAppResponsiveEnginePreferredInput then v14 == Responsive.Input.Directional else v17 == Responsive.Input.Directional

		if v13 then
			v13 = true

			if v15.uiMode ~= UiMode.TenFoot then
				if FFlagLuaAppEnableStickyShortcutBar or FFlagGuacStickyShortcutBarEnabled then
					return v16
				end

				v13 = false
			end
		end
	end

	return v13
end

return useIsHoldToPlayEnabledForGames
