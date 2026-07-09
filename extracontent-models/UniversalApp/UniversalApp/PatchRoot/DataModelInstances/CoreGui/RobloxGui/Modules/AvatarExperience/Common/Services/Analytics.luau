local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local open3DFullView = require(Modules.AvatarExperience.Common.Analytics.open3DFullView)
local close3DFullView = require(Modules.AvatarExperience.Common.Analytics.close3DFullView)
local AnalyticsService = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).AnalyticsService
local reportAvatarEventCounterV1 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).reportAvatarEventCounterV1
local Constants = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Constants
local t1 = {}
local u10 = nil

function t1.get(_) -- line: 21
	-- upvalues: u10 (ref), AnalyticsService (copy), open3DFullView (copy), close3DFullView (copy), reportAvatarEventCounterV1 (copy), Constants (copy)
	if u10 then
		return u10
	end

	local v12 = AnalyticsService
	local t2 = {
		open3DFullView = function(p2) -- line: 30
			-- upvalues: open3DFullView (copy), v12 (copy)
			open3DFullView(v12.EventStream, p2)
		end,
		close3DFullView = function(p3) -- line: 34
			-- upvalues: close3DFullView (copy), v12 (copy)
			close3DFullView(v12.EventStream, p3)
		end,
		toggleCameraInEditorAndShop = function(p4, p5) -- line: 39
			-- upvalues: v12 (copy), reportAvatarEventCounterV1 (copy), Constants (copy)
			local v18 = not p4 and "Button Disabled" or "Button Enabled"

			v12.EventStream:sendTelemetryEvent("CameraInEditorAndCatalogButton", "CameraInEditorAndCatalogButton_Toggle", {
				actionName = v18,
				pageName = p5
			})
			reportAvatarEventCounterV1(if not p4 then Constants.AVATAR_EVENT_COUNTER_NAME.AXCameraDisabled else Constants.AVATAR_EVENT_COUNTER_NAME.AXCameraEnabled)
		end
	}

	u10 = t2

	return t2
end

return t1
