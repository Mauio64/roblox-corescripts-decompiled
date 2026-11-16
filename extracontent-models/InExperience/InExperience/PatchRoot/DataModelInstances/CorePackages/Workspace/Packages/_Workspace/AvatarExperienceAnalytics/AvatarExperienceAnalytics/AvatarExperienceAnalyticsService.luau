local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")

local open3DFullView = require(AvatarExperienceAnalytics.open3DFullView)
local close3DFullView = require(AvatarExperienceAnalytics.close3DFullView)

local AnalyticsService = require(AvatarExperienceAnalytics.AnalyticsService)

local reportAvatarEventCounterV1 = require(AvatarExperienceAnalytics.reportAvatarEventCounterV1)
local Constants = require(AvatarExperienceAnalytics.Constants)

local v = nil
return {
	get = function(_)
		if v then
			return v
		end

		local v2 = AnalyticsService
		local v3 = {
			open3DFullView = function(p)
				open3DFullView(v2.EventStream, p)
			end,
			close3DFullView = function(p)
				close3DFullView(v2.EventStream, p)
			end,
			toggleCameraInEditorAndShop = function(p, pageName)
				v2.EventStream:sendTelemetryEvent(
					"CameraInEditorAndCatalogButton",
					"CameraInEditorAndCatalogButton_Toggle",
					{
						actionName = p and "Button Enabled" or "Button Disabled",
						pageName = pageName
					}
				)
				local v3

				if p then
					v3 = Constants.AVATAR_EVENT_COUNTER_NAME.AXCameraEnabled
				else
					v3 = Constants.AVATAR_EVENT_COUNTER_NAME.AXCameraDisabled
				end

				reportAvatarEventCounterV1(v3)
			end
		}

		v = v3
		return v3
	end
}
