local CorePackages = game:GetService("CorePackages")
local IxpServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper
local defineFastFlag = game:DefineFastFlag("ClientToastNotificationsRedirect4", false)
local defineFastFlag2 = game:DefineFastFlag("EnableClientToastNotificationsRedirectExperiment", false)
local defineFastString = game:DefineFastString("ClientToastNotificationsRedirectLayerName", "Notification.Toast")
local defineFastString2 = game:DefineFastString("ClientToastNotificationsRedirectLayerValue", "NotificationRedirect")

local v = false
local success = nil
local result = nil

return function()
	if defineFastFlag2 and not v then
		success, result = pcall(function()
			v = true
			return IXPServiceWrapper:GetLayerData(defineFastString)
		end)
	end

	return defineFastFlag or success and result and result[defineFastString2]
end
