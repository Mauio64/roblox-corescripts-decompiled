local module = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/open3DFullView")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/close3DFullView")

local AnalyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/AnalyticsService")

local reportAvatarEventCounterV1 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/reportAvatarEventCounterV1")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Constants")

local v6 = nil
return {
	get = function(p2)
		if v6 then
			return v6
		end

		local v7 = AnalyticsService
		local v8 = {
			open3DFullView = function(p3)
				module(v7.EventStream, p3)
			end,
			close3DFullView = function(p3)
				module2(v7.EventStream, p3)
			end,
			toggleCameraInEditorAndShop = function(p3, p4)
				v7.EventStream:sendTelemetryEvent(
					"CameraInEditorAndCatalogButton",
					"CameraInEditorAndCatalogButton_Toggle",
					{
						actionName = p3 and "Button Enabled" or "Button Disabled",
						pageName = p4
					}
				)

				local v10 = if p3 then Constants.AVATAR_EVENT_COUNTER_NAME.AXCameraEnabled else Constants.AVATAR_EVENT_COUNTER_NAME.AXCameraDisabled
				reportAvatarEventCounterV1(v10)
			end
		}

		v6 = v8
		return v8
	end
}
