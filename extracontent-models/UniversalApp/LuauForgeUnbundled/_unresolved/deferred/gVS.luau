local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local analyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AnalyticsService
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local module = require("@luauforge/bundled/fuH")

local v6 = memoize(function(p2)
	return {
		avatarAARefineNavigationTap = function(p3, p4, p5)
			p2.EventStream:sendTelemetryEvent(p3, "avatarRefineNavigationTap", {
				category = p5,
				uid = p4,
				navTab = "Accessory"
			})
		end,
		avatarLCRefineNavigationTap = function(p3, p4, p5)
			p2.EventStream:sendTelemetryEvent(p3, "avatarRefineNavigationTap", {
				category = p5,
				uid = p4,
				navTab = "Clothing"
			})
		end,
		avatarLayeredMakeupNavigationTap = function(p3, p4, p5)
			p2.EventStream:sendTelemetryEvent(p3, "avatarRefineNavigationTap", {
				category = p5,
				uid = p4,
				navTab = "Makeup"
			})
		end,
		avatarRefineAccessoryResetConfirm = function(p3, p4, p5, p6)
			local v7 = {
				uid = p4,
				refineSessionId = RbxAnalyticsService:GetSessionId(),
				assetId = p6
			}

			p2.EventStream:sendTelemetryEvent(p3, "avatarRefineAccessoryResetConfirm", v7)
		end,
		avatarRefineAccessoryStart = function(p3, p4, p5, p6)
			local v7 = {
				uid = p4,
				refineSessionId = RbxAnalyticsService:GetSessionId(),
				assetId = p6
			}

			p2.EventStream:sendTelemetryEvent(p3, "avatarRefineAccessoryStart", v7)
		end,
		avatarRefineAccessoryAdjustTap = function(p3)
			return function(p4, p5, p6, p7)
				p2.EventStream:sendTelemetryEvent(p4, "avatarRefineAccessoryAdjustTap", {
					uid = p5,
					assetId = p7,
					adjustTab = p3
				})
			end
		end,
		avatarRefineAccessoryApply = function(p3)
			return function(p4, p5, p6, p7)
				local v7 = {
					assetId = p7,
					uid = p5,
					move_x = p3[module.PositionX],
					move_y = p3[module.PositionY],
					move_z = p3[module.PositionZ],
					rotation_x = p3[module.RotationX],
					rotation_y = p3[module.RotationY],
					rotation_z = p3[module.RotationZ],
					scale = p3[module.Scale]
				}

				p2.EventStream:sendTelemetryEvent(p4, "avatarRefineAccessoryApply", v7)
			end
		end
	}
end)
return {
	get = function(p2)
		return v6(analyticsService)
	end
}
