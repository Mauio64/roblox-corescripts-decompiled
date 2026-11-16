local fFlagStreamNotificationUXDropdown = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/SharedFlags").FFlagStreamNotificationUXDropdown
local ixpHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/NotificationsCommon").ixpHelper
local constants = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/constants")

local defineFastString = game:DefineFastString(
	"StreamNotificationUXExposureLayer",
	"Notifications.StreamNotificationUXExposure"
)

local defineFastString2 = game:DefineFastString(
	"StreamNotificationUXDropdownVariant",
	"enableStreamDropdown"
)

local function getIsLargeScreen()
	local currentCamera = workspace.CurrentCamera
	local isLargeScreen = not (currentCamera == nil)
		and currentCamera.ViewportSize.X >= constants.Modal.WidthLimit
	return isLargeScreen
end

local function getIsUserInTreatment(): boolean
	local ixpLayerData = ixpHelper.getIxpLayerData(defineFastString)

	if ixpLayerData and ixpLayerData[defineFastString2] ~= nil then
		return ixpLayerData[defineFastString2] == true
	end

	return false
end

return {
	getDropdownEnabled = function()
		local v5 = fFlagStreamNotificationUXDropdown

		if not v5 then
			return v5
		end

		local currentCamera = workspace.CurrentCamera
		v5 = not (currentCamera == nil) and currentCamera.ViewportSize.X >= constants.Modal.WidthLimit

		if not v5 then
			return v5
		end

		local ixpLayerData = ixpHelper.getIxpLayerData(defineFastString)

		if ixpLayerData and ixpLayerData[defineFastString2] ~= nil then
			return ixpLayerData[defineFastString2] == true
		end

		v5 = false
		return false
	end,
	logExposure = function()
		if fFlagStreamNotificationUXDropdown then
			local currentCamera = workspace.CurrentCamera
			local v5 = not (currentCamera == nil)
				and currentCamera.ViewportSize.X >= constants.Modal.WidthLimit

			if v5 then
				local ixpLayerData = ixpHelper.getIxpLayerData(defineFastString)

				if ixpLayerData and ixpLayerData[defineFastString2] ~= nil then
					ixpHelper.logUserLayerExposure(defineFastString)
				end
			end
		end
	end
}
