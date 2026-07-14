local Parent = script:FindFirstAncestor("StreamNotifications").Parent
local SharedFlags = require(Parent.SharedFlags)
local FFlagStreamNotificationUXSettingsHeader = SharedFlags.FFlagStreamNotificationUXSettingsHeader
local GetFStringNotificationsStreamNotificationUXLayer = SharedFlags.GetFStringNotificationsStreamNotificationUXLayer
local ixpHelper = require(Parent.NotificationsCommon).ixpHelper
local v6 = game:DefineFastString("StreamNotificationUXSettingsGearVariant", "enableStreamSettingsGear")

local function getLayerVariables() -- line: 17
	-- upvalues: ixpHelper (copy), GetFStringNotificationsStreamNotificationUXLayer (copy)
	return ixpHelper.getIxpLayerData(GetFStringNotificationsStreamNotificationUXLayer())
end
local function getIsUserInTreatment() -- line: 21
	-- upvalues: ixpHelper (copy), GetFStringNotificationsStreamNotificationUXLayer (copy), v6 (copy)
	local v9 = ixpHelper.getIxpLayerData(GetFStringNotificationsStreamNotificationUXLayer())

	if v9 and v9[v6] ~= nil then
		return v9[v6] == true
	end

	return false
end

return {
	getSettingsGearEnabled = function() -- line: 31
		-- upvalues: FFlagStreamNotificationUXSettingsHeader (copy), ixpHelper (copy), GetFStringNotificationsStreamNotificationUXLayer (copy), v6 (copy)
		local v10 = FFlagStreamNotificationUXSettingsHeader

		if v10 then
			local v11 = ixpHelper.getIxpLayerData(GetFStringNotificationsStreamNotificationUXLayer())

			if v11 and v11[v6] ~= nil then
				return v11[v6] == true
			end

			v10 = false
		end

		return v10
	end
}
