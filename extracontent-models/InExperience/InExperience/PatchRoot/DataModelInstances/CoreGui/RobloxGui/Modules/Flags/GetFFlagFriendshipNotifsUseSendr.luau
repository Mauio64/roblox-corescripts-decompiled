local CorePackages = game:GetService("CorePackages")
local IXPServiceWrapper = require(CorePackages.Workspace.Packages.IxpServiceWrapper).IXPServiceWrapper
local v3 = game:DefineFastFlag("FriendshipNotifsUseSendrEnabledForAll", false)
local v4 = game:DefineFastFlag("FriendshipNotifsUseSendrExperiment_v2", false)
local v5 = game:DefineFastString("FriendshipNotifsUseSendrLayerName", "Notification.Toast")
local v6 = game:DefineFastString("FriendshipNotifsUseSendrLayerValue", "EnableNotificationViaSENDR")
local u7 = false
local u8 = nil
local u9 = nil

return function() -- line: 12
	-- upvalues: v4 (copy), u7 (ref), u8 (ref), u9 (ref), IXPServiceWrapper (copy), v5 (copy), v3 (copy), v6 (copy)
	if v4 and not u7 then
		local ok, result = pcall(function() -- line: 14
			-- upvalues: u7 (ref), IXPServiceWrapper (copy), v5 (copy)
			u7 = true

			return IXPServiceWrapper:GetLayerData(v5)
		end)

		u8 = ok
		u9 = result
	end

	return v3 or u8 and (u9 and u9[v6])
end
