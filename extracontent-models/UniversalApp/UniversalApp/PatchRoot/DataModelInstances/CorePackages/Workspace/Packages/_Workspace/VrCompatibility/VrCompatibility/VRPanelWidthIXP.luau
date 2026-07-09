local ParentParent = script.Parent.Parent
local SharedFlags = require(ParentParent.SharedFlags)
local GetFFlagVRPanelWidthIXPEnabled = SharedFlags.GetFFlagVRPanelWidthIXPEnabled
local AppUserLayers = require(ParentParent.ExperimentLayers).AppUserLayers
local IxpUtils = require(ParentParent.IxpUtils)

game:DefineFastInt("VrAvatarPanelsSpreadMultiplierPercentageOverride", 96)
game:DefineFastInt("SystemBarHeightMultiplierPercentageOverride", 80)
game:DefineFastString("VrAvatarPanelsDistanceOffsetOverride", "-1.8")

local v6 = SharedFlags.GetFFlagVRPanelWidthIXPLocalOverrideEnabled()
local v7 = SharedFlags.GetFIntVrAppPanelCurvatureOverride()
local v8 = SharedFlags.GetFIntVrAppPanelWidthMultiplierPercentageOverride()
local FastInt = game:GetFastInt("VrAvatarPanelsSpreadMultiplierPercentageOverride")
local FastInt2 = game:GetFastInt("SystemBarHeightMultiplierPercentageOverride")
local FastString = game:GetFastString("VrAvatarPanelsDistanceOffsetOverride")
local v12 = SharedFlags.GetFStringVrSystemBarXOffSetOverride()
local v13 = SharedFlags.GetFStringVrSystemBarYOffSetOverride()
local v14 = SharedFlags.GetFStringVrSystemBarZOffSetOverride()

return IxpUtils.defineIXPTest({
	name = "PlatformExcellence.QualityImprovement.App.VR.AppPanelWidth",
	recordExposure = false,
	layer = AppUserLayers.PlatformExcellenceQualityImprovementVR,
	getDependentFlagsEnabled = function() -- line: 37
		return true
	end,
	getEnabledFlag = function() -- line: 41
		-- upvalues: GetFFlagVRPanelWidthIXPEnabled (copy)
		return GetFFlagVRPanelWidthIXPEnabled()
	end,
	getEnabledForAllFlag = function() -- line: 45
		return false
	end,
	variables = {
		VrAppPanelWidthMultiplier = function(p1, _) -- line: 51
			-- upvalues: v6 (copy), v8 (copy)
			if v6 then
				return v8 / 100
			end

			local num = tonumber(p1.vr_app_panel_width_multiplier_percentage)

			if num then
				return num / 100
			end

			return nil
		end,
		VrAppPanelCurvature = function(p3, _) -- line: 60
			-- upvalues: v6 (copy), v7 (copy)
			if v6 then
				return v7
			end

			return tonumber(p3.vr_app_panel_curvature) or nil
		end,
		VrAvatarPanelsSpreadMultiplier = function(p5, _) -- line: 67
			-- upvalues: v6 (copy), FastInt (copy)
			if v6 then
				return FastInt / 100
			end

			local num = tonumber(p5.vr_avatar_panels_spread_multiplier_percentage)

			if num then
				return num / 100
			end

			return nil
		end,
		VrAvatarPanelsDistanceOffset = function(p7, _) -- line: 77
			-- upvalues: v6 (copy), FastString (copy)
			if v6 then
				return (tonumber(FastString))
			end

			return tonumber(p7.vr_avatar_panels_distance_offset) or nil
		end,
		VrSystemBarXOffSet = function(p9, _) -- line: 84
			-- upvalues: v6 (copy), v12 (copy)
			if v6 then
				return (tonumber(v12))
			end

			return tonumber(p9.vr_system_bar_x_offset) or nil
		end,
		VrSystemBarYOffSet = function(p11, _) -- line: 91
			-- upvalues: v6 (copy), v13 (copy)
			if v6 then
				return (tonumber(v13))
			end

			return tonumber(p11.vr_system_bar_y_offset) or nil
		end,
		VrSystemBarZOffSet = function(p13, _) -- line: 98
			-- upvalues: v6 (copy), v14 (copy)
			if v6 then
				return (tonumber(v14))
			end

			return tonumber(p13.vr_system_bar_z_offset) or nil
		end,
		SystemBarHeightMultiplier = function(p15, _) -- line: 105
			-- upvalues: v6 (copy), FastInt2 (copy)
			if v6 then
				return FastInt2 / 100
			end

			local num = tonumber(p15.system_bar_height_percentage)

			if num then
				return num / 100
			end

			return nil
		end
	}
})
