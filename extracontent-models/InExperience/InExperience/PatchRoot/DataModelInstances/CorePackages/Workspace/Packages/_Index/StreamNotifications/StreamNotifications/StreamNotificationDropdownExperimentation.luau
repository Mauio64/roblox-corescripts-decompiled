local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local StreamNotificationsParent = StreamNotifications.Parent
local FFlagStreamNotificationUXDropdown = require(StreamNotificationsParent.SharedFlags).FFlagStreamNotificationUXDropdown
local ixpHelper = require(StreamNotificationsParent.NotificationsCommon).ixpHelper
local constants = require(StreamNotifications.constants)
local v6 = game:DefineFastString("StreamNotificationUXExposureLayer", "Notifications.StreamNotificationUXExposure")
local v7 = game:DefineFastString("StreamNotificationUXDropdownVariant", "enableStreamDropdown")

local function getIsLargeScreen() -- line: 20
	-- upvalues: constants (copy)
	local CurrentCamera = workspace.CurrentCamera

	return CurrentCamera ~= nil and CurrentCamera.ViewportSize.X >= constants.Modal.WidthLimit
end
local function getIsUserInTreatment() -- line: 25
	-- upvalues: ixpHelper (copy), v6 (copy), v7 (copy)
	local v11 = ixpHelper.getIxpLayerData(v6)

	if v11 and v11[v7] ~= nil then
		return v11[v7] == true
	end

	return false
end

return {
	getDropdownEnabled = function() -- line: 36
		-- upvalues: FFlagStreamNotificationUXDropdown (copy), constants (copy), ixpHelper (copy), v6 (copy), v7 (copy)
		local v12 = FFlagStreamNotificationUXDropdown

		if v12 then
			local CurrentCamera = workspace.CurrentCamera

			v12 = CurrentCamera ~= nil and CurrentCamera.ViewportSize.X >= constants.Modal.WidthLimit

			if v12 then
				local v14 = ixpHelper.getIxpLayerData(v6)

				if v14 and v14[v7] ~= nil then
					return v14[v7] == true
				end

				v12 = false
			end
		end

		return v12
	end,
	logExposure = function() -- line: 43
		-- upvalues: FFlagStreamNotificationUXDropdown (copy), constants (copy), ixpHelper (copy), v6 (copy), v7 (copy)
		if FFlagStreamNotificationUXDropdown then
			local CurrentCamera = workspace.CurrentCamera

			if CurrentCamera ~= nil and CurrentCamera.ViewportSize.X >= constants.Modal.WidthLimit then
				local v16 = ixpHelper.getIxpLayerData(v6)

				if v16 and v16[v7] ~= nil then
					ixpHelper.logUserLayerExposure(v6)
				end
			end
		end
	end
}
