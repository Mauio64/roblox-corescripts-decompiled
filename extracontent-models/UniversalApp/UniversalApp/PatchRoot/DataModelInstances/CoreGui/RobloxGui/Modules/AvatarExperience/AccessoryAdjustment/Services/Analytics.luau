local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Modules = CoreGui.RobloxGui.Modules
local AnalyticsService = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).AnalyticsService
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local AdjustmentSliderType = require(Modules.AvatarExperience.AccessoryAdjustment.Enum.AdjustmentSliderType)
local FFlagAXCustomizeMakeupSupport = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCustomizeMakeupSupport
local t1 = {}
local v10 = memoize(function(p1) -- line: 14
	-- upvalues: FFlagAXCustomizeMakeupSupport (copy), RbxAnalyticsService (copy), AdjustmentSliderType (copy)
	local t4 = {
		avatarAARefineNavigationTap = function(p2, p3, p4) -- line: 17
			-- upvalues: p1 (copy)
			local t2 = {
				navTab = "Accessory",
				category = p4,
				uid = p3
			}

			p1.EventStream:sendTelemetryEvent(p2, "avatarRefineNavigationTap", t2)
		end,
		avatarLCRefineNavigationTap = function(p5, p6, p7) -- line: 28
			-- upvalues: p1 (copy)
			local t3 = {
				navTab = "Clothing",
				category = p7,
				uid = p6
			}

			p1.EventStream:sendTelemetryEvent(p5, "avatarRefineNavigationTap", t3)
		end
	}

	if FFlagAXCustomizeMakeupSupport then
		function t4.avatarLayeredMakeupNavigationTap(p8, p9, p10) -- line: 40
			-- upvalues: p1 (copy)
			local t5 = {
				navTab = "Makeup",
				category = p10,
				uid = p9
			}

			p1.EventStream:sendTelemetryEvent(p8, "avatarRefineNavigationTap", t5)
		end
	end

	function t4.avatarRefineAccessoryResetConfirm(p11, p12, _, s1: string?) -- line: 52
		-- upvalues: RbxAnalyticsService (copy), p1 (copy)
		local t6 = {
			uid = p12,
			refineSessionId = RbxAnalyticsService:GetSessionId(),
			assetId = s1
		}

		p1.EventStream:sendTelemetryEvent(p11, "avatarRefineAccessoryResetConfirm", t6)
	end
	function t4.avatarRefineAccessoryStart(p14, p15, _, s2: string?) -- line: 63
		-- upvalues: RbxAnalyticsService (copy), p1 (copy)
		local t7 = {
			uid = p15,
			refineSessionId = RbxAnalyticsService:GetSessionId(),
			assetId = s2
		}

		p1.EventStream:sendTelemetryEvent(p14, "avatarRefineAccessoryStart", t7)
	end
	function t4.avatarRefineAccessoryAdjustTap(s3: string) -- line: 74
		-- upvalues: p1 (copy)
		return function(p17, p18, _, s4: string?) -- line: 75
			-- upvalues: s3 (copy), p1 (copy)
			local t8 = {
				uid = p18,
				assetId = s4,
				adjustTab = s3
			}

			p1.EventStream:sendTelemetryEvent(p17, "avatarRefineAccessoryAdjustTap", t8)
		end
	end
	function t4.avatarRefineAccessoryApply(p20) -- line: 87
		-- upvalues: AdjustmentSliderType (copy), p1 (copy)
		return function(p21, p22, _, s5: string?) -- line: 88
			-- upvalues: p20 (copy), AdjustmentSliderType (copy), p1 (copy)
			local t9 = {
				assetId = s5,
				uid = p22,
				move_x = p20[AdjustmentSliderType.PositionX],
				move_y = p20[AdjustmentSliderType.PositionY],
				move_z = p20[AdjustmentSliderType.PositionZ],
				rotation_x = p20[AdjustmentSliderType.RotationX],
				rotation_y = p20[AdjustmentSliderType.RotationY],
				rotation_z = p20[AdjustmentSliderType.RotationZ],
				scale = p20[AdjustmentSliderType.Scale]
			}

			p1.EventStream:sendTelemetryEvent(p21, "avatarRefineAccessoryApply", t9)
		end
	end

	return t4
end)

function t1.get(_) -- line: 111
	-- upvalues: AnalyticsService (copy), v10 (copy)
	local v14 = AnalyticsService

	return v10(v14)
end

return t1
