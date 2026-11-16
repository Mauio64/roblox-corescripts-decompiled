local CorePackages = game:GetService("CorePackages")
local IxpServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper)
local IXPServiceWrapper = IxpServiceWrapper.IXPServiceWrapper
local defineFastFlag = game:DefineFastFlag("FriendshipNotifsUseSendrEnabledForAll", false)
local defineFastFlag2 = game:DefineFastFlag("FriendshipNotifsUseSendrExperiment_v2", false)
local defineFastString = game:DefineFastString("FriendshipNotifsUseSendrLayerName", "Notification.Toast")
local defineFastString2 = game:DefineFastString("FriendshipNotifsUseSendrLayerValue", "EnableNotificationViaSENDR")

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
