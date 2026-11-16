local parent = script:FindFirstAncestor("StreamNotifications").Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagStreamNotificationUXSettingsHeader = SharedFlags.FFlagStreamNotificationUXSettingsHeader
local GetFStringNotificationsStreamNotificationUXLayer = SharedFlags.GetFStringNotificationsStreamNotificationUXLayer
local NotificationsCommon = require(parent.NotificationsCommon)
local ixpHelper = NotificationsCommon.ixpHelper

local defineFastString = game:DefineFastString("StreamNotificationUXSettingsGearVariant", "enableStreamSettingsGear")

local function getLayerVariables() -- 2 equivalent calls inferred from this helper
	return ixpHelper.getIxpLayerData(GetFStringNotificationsStreamNotificationUXLayer())
end

local function getIsUserInTreatment(): boolean
	local layerVariables = getLayerVariables() -- inferred equivalent call

	if layerVariables and layerVariables[defineFastString] ~= nil then
		return layerVariables[defineFastString] == true
	end

	return false
end

return {
	getSettingsGearEnabled = function()
		local v = FFlagStreamNotificationUXSettingsHeader

		if not v then
			return v
		end

		local layerVariables = getLayerVariables() -- inferred equivalent call

		if layerVariables and layerVariables[defineFastString] ~= nil then
			return layerVariables[defineFastString] == true
		end

		v = false
		return false
	end
}
