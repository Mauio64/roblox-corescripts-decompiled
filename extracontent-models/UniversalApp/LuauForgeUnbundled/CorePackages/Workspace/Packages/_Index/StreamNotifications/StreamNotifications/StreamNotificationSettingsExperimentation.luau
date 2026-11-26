local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/SharedFlags")
local fFlagStreamNotificationUXSettingsHeader = SharedFlags.FFlagStreamNotificationUXSettingsHeader
local getFStringNotificationsStreamNotificationUXLayer = SharedFlags.GetFStringNotificationsStreamNotificationUXLayer
local ixpHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/NotificationsCommon").ixpHelper

local defineFastString = game:DefineFastString(
	"StreamNotificationUXSettingsGearVariant",
	"enableStreamSettingsGear"
)

local function getLayerVariables()
	return ixpHelper.getIxpLayerData(getFStringNotificationsStreamNotificationUXLayer())
end

local function getIsUserInTreatment(): boolean
	local ixpLayerData = ixpHelper.getIxpLayerData(getFStringNotificationsStreamNotificationUXLayer())

	if ixpLayerData and ixpLayerData[defineFastString] ~= nil then
		return ixpLayerData[defineFastString] == true
	end

	return false
end

return {
	getSettingsGearEnabled = function()
		local v5 = fFlagStreamNotificationUXSettingsHeader

		if not v5 then
			return v5
		end

		local ixpLayerData = ixpHelper.getIxpLayerData(getFStringNotificationsStreamNotificationUXLayer())

		if ixpLayerData and ixpLayerData[defineFastString] ~= nil then
			return ixpLayerData[defineFastString] == true
		end

		v5 = false
		return false
	end
}
