local Modules = game:GetService("CoreGui").RobloxGui.Modules
local PromiseUtilities = require(Modules.LuaApp.PromiseUtilities)
local ApiFetchAccountSettingsEmail = require(Modules.LuaApp.Thunks.ApiFetchAccountSettingsEmail)
local ApiFetchPasswordStatus = require(Modules.LuaApp.Thunks.ApiFetchPasswordStatus)
local ApiFetchFriendRequestsCount = require(Modules.LuaApp.Thunks.ApiFetchFriendRequestsCount)
local ApiFetchUnreadMessageCount = require(Modules.LuaApp.Thunks.ApiFetchUnreadMessageCount)
local ApiFetchUnreadNotificationCount = require(Modules.LuaApp.Thunks.ApiFetchUnreadNotificationCount)
local FFlagEnablePasswordStatusRemoval = require(Modules.LuaApp.Flags.FFlagEnablePasswordStatusRemoval)

return function(p1) -- line: 13
	-- upvalues: ApiFetchAccountSettingsEmail (copy), FFlagEnablePasswordStatusRemoval (copy), ApiFetchPasswordStatus (copy), ApiFetchFriendRequestsCount (copy), ApiFetchUnreadMessageCount (copy), ApiFetchUnreadNotificationCount (copy), PromiseUtilities (copy)
	return function(p2) -- line: 14
		-- upvalues: ApiFetchAccountSettingsEmail (copy), p1 (copy), FFlagEnablePasswordStatusRemoval (copy), ApiFetchPasswordStatus (copy), ApiFetchFriendRequestsCount (copy), ApiFetchUnreadMessageCount (copy), ApiFetchUnreadNotificationCount (copy), PromiseUtilities (copy)
		local t1 = {}

		table.insert(t1, p2:dispatch(ApiFetchAccountSettingsEmail(p1)))

		if not FFlagEnablePasswordStatusRemoval then
			table.insert(t1, p2:dispatch(ApiFetchPasswordStatus(p1)))
		end

		table.insert(t1, p2:dispatch(ApiFetchFriendRequestsCount(p1)))
		table.insert(t1, p2:dispatch(ApiFetchUnreadMessageCount(p1)))
		table.insert(t1, p2:dispatch(ApiFetchUnreadNotificationCount(p1)))

		return PromiseUtilities.Batch(t1):andThen(function(p3) -- line: 25
			-- upvalues: PromiseUtilities (copy), t1 (copy)
			local failureCount = PromiseUtilities.CountResults(p3).failureCount

			if failureCount ~= 0 then
				warn(string.format("%d of %d notification count fetching failed!", failureCount, #t1))
			end
		end)
	end
end
